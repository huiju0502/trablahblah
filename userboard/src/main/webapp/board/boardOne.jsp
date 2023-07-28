<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 1. 컨트롤러 계층
	//세션 유효성 검사
	
	if(request.getParameter("boardNo") == null
	|| request.getParameter("boardNo").equals("")) {
	
	response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
	return;	
	}

	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	
	
	String loginMemberId = (String)session.getAttribute("loginMemberId");
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 5;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	int startRow = (currentPage-1)*rowPerPage;
	System.out.println(startRow + " <--boardOne startRow");
	
	// 2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	
	Class.forName(driver);
	Connection conn = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
	
	// 2-1) board one 결과셋
	/*
		SELECT 
			board_no boardNo, 
			local_name localName, 
			board_title boardTitle, 
			board_content boardContent, 
			member_id memberId, 
			createdate, 
			updatedate
		FROM board
		WHERE board_no = ?;
	*/
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	String boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, board_content boardContent, member_id memberId, createdate, updatedate FROM board WHERE board_no = ?";
	boardStmt = conn.prepareStatement(boardSql);
	boardStmt.setInt(1, boardNo);
	System.out.println(boardStmt + " <--boardStmt");
	boardRs = boardStmt.executeQuery(); 
	Board board = null;
	if(boardRs.next()) {
		board = new Board();
		board.setBoardNo(boardRs.getInt("boardNo"));
		board.setLocalName(boardRs.getString("localName"));
		board.setBoardTitle(boardRs.getString("boardTitle"));
		board.setBoardContent(boardRs.getString("boardContent"));
		board.setMemberId(boardRs.getString("memberId"));
		board.setCreatedate(boardRs.getString("createdate"));
		board.setUpdatedate(boardRs.getString("updatedate"));
	}
	
	// 2-2) comment list 결과셋
	/*
		SELECT 
			comment_no commentNo, 
			board_no boardNo, 
			comment_content commentContent, 
			member_id memberId, 
			createdate, 
			updatedate
		FROM comment
		WHERE board_no = ?
		ORDER BY createdate desc
		LIMIT ?, ?;
	*/
	PreparedStatement commentListStmt = null;
	ResultSet commentListRs = null;
	String commentListSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE board_no = ? ORDER BY createdate desc LIMIT ?, ?";
	commentListStmt = conn.prepareStatement(commentListSql);
	commentListStmt.setInt(1, boardNo);
	commentListStmt.setInt(2, startRow);
	commentListStmt.setInt(3, rowPerPage);
	System.out.println(commentListStmt + " <--commentListStmt");
	commentListRs = commentListStmt.executeQuery(); 
	
	ArrayList<Comment> commentList = new ArrayList<Comment>();
	while(commentListRs.next()) {
		Comment c = new Comment();
		c.setCommentNo(commentListRs.getInt("commentNo"));
		c.setBoardNo(commentListRs.getInt("boardNo"));
		c.setCommentContent(commentListRs.getString("commentContent"));
		c.setMemberId(commentListRs.getString("memberId"));
		c.setCreatedate(commentListRs.getString("createdate"));
		c.setUpdatedate(commentListRs.getString("updatedate"));
		commentList.add(c);
	}
	
	// 2-3) 마지막 페이지수 구하기
	// 1) SELECT count(*) commentRow FROM comment WHERE boar_no = ?;사용해서 전체 행 수 구하기	
	PreparedStatement stmt = conn.prepareStatement("SELECT count(*) commentRow FROM comment WHERE board_no = ?");
	stmt.setInt(1, boardNo);
	ResultSet rs = stmt.executeQuery();
	int totalRow = 0;
	if(rs.next()) {
		totalRow = rs.getInt("commentRow");
	}
	// 2) 전체행수를 페이지당 출력할 행의 수로 나눠서 마지막 페이지 구하기
	int lastPage = totalRow / rowPerPage;
	// 3) 나머지가 생기면 전체페이지수 + 1
	if(totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
	// 3. 뷰 계층
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>boardOne</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container-md mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	
<!--  3-1) board one 결과셋 -->
	<table class="table text-center">
		<tr>
			<td class="table-primary">NO</td>
			<td><%=board.getBoardNo() %></td>
		</tr>
		<tr>
			<td class="table-primary">LOCAL NAME</td>
			<td><%=board.getLocalName() %></td>
		</tr>
		<tr>
			<td class="table-primary">TITLE</td>
			<td><%=board.getBoardTitle() %></td>
		</tr>
		<tr>
			<td class="table-primary">CONTENT</td>
			<td><%=board.getBoardContent() %></td>
		</tr>
		<tr>
			<td class="table-primary">ID</td>
			<td><%=board.getMemberId() %></td>
		</tr>
		<tr>
			<td class="table-primary">CREATE DATE</td>
			<td><%=board.getCreatedate() %></td>
		</tr>
		<tr>
			<td class="table-primary">UPDATE DATE</td>
			<td><%=board.getUpdatedate() %></td>
		</tr>
	</table>

	
	

<%
	// 로그인 사용자만 댓글 허용
	if(session.getAttribute("loginMemberId") != null) {
		// 현재 로그인 사용자의 아이디
		loginMemberId = (String)session.getAttribute("loginMemberId");
			// 로그인 사용자에게만 게시글 수정, 삭제 버튼 보임
			if(loginMemberId.equals(board.getMemberId())) {
			%>	
				<div class="text-center">
					<a href="<%=request.getContextPath() %>/board/updateBoardForm.jsp?boardNo=<%=board.getBoardNo()%>"><button type="button" class="btn btn-secondary">수정</button></a>
					<a href="<%=request.getContextPath() %>/board/deleteBoardForm.jsp?boardNo=<%=board.getBoardNo()%>"><button type="button" class="btn btn-secondary">삭제</button></a>
				</div>
				<br>
			<%
			}
			%>
		<br>
	
	<%
		if(request.getParameter("msg") != null) {
	%>
			<div class="alert alert-secondary alert-dismissible">
   				 <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    			<strong><%=request.getParameter("msg")%></strong>
 			</div>
	<%
		}
	%>

<!--  3-2) comment 입력 : 세션유무에 따른 분기 -->		
		<form action="<%=request.getContextPath() %>/board/comment/insertCommentAction.jsp" method="post">
			<input type="hidden" name="boardNo" value="<%=board.getBoardNo() %>">
			<input type="hidden" name="memberId" value="<%=loginMemberId %>">
			<table class="table text-center">
				<tr>
					<th>COMMENT CONTENT</th>
					<td>
						<textarea rows="2" cols="80" name="commentContent"></textarea>
					</td>
					<td><button type="submit" class="btn btn-outline-secondary">댓글입력</button></td>
				</tr>	
			</table>
	</form>
<%
	}
%>

<!--  3-3) comment list 결과셋 -->
	<table class="table text-center">
		<tr class="table-primary">
			<th>COMMENT CONTENT</th>
			<th>MEMBER ID</th>
			<th>CREATE DATE</th>
			<th>UPDATE DATE</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			for(Comment c : commentList) {
		%>
		<tr>
			<td><%=c.getCommentContent() %></td>
			<td><%=c.getMemberId() %></td>
			<td><%=c.getCreatedate() %></td>
			<td><%=c.getUpdatedate() %></td>
		<%
	// 댓글 작성자에게만 수정, 삭제 버튼 보임
	if(session.getAttribute("loginMemberId") != null) {
		// 현재 로그인 사용자의 아이디
		loginMemberId = (String)session.getAttribute("loginMemberId");
		if(loginMemberId.equals(c.getMemberId())) {
		%>	
			<td><a href="<%=request.getContextPath() %>/board/comment/updateCommentForm.jsp?boardNo=<%=c.getBoardNo() %>&commentNo=<%=c.getCommentNo()%>"><button type="submit" class="btn btn-secondary">수정</button></a></td>
			<td><a href="<%=request.getContextPath() %>/board/comment/deleteCommentForm.jsp?boardNo=<%=c.getBoardNo() %>&commentNo=<%=c.getCommentNo()%>"><button type="submit" class="btn btn-secondary">삭제</button></a></td>
		<%
		}
		%>
		
		<%
	}
			}
		%>
	
	</table>
	
<!--  3-4) 페이징 -->
<div class="table text-center">
<%
	if(currentPage > 1) {
%>
	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage-1%>"><button type="button" class="btn btn-outline-secondary">이전</button></a>
<%
	}
%>
	<%=currentPage %>
<%
	if(currentPage < lastPage) {
%>
	<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=boardNo%>&currentPage=<%=currentPage+1%>"><button type="button" class="btn btn-outline-secondary">다음</button></a>
<%
	}	
%>
</div>

	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</div>
</body>
</html>