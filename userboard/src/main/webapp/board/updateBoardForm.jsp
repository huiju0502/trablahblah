<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	// 세션유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	// 
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
	//db연결
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);

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
	
	/*
	SELECT local_name localName
	FROM local
	*/
	String sql = "SELECT local_name localName FROM local";
	stmt = conn.prepareStatement(sql);
	rs = stmt.executeQuery();
	ArrayList<Local> localList = new ArrayList<Local>();
	while(rs.next()) {
		Local l = new Local();
		l.setLocalName(rs.getString("localName"));
		localList.add(l);
	}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateBoard</title>
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
	<h1>게시글 수정</h1>
	<br>
<!-- 수정 폼 -->
<form action="<%=request.getContextPath() %>/board/updateBoardAction.jsp" method="post">
	<table class="table text-center">
			<tr>
				<td class="table-primary">NO</td>
				<td><input type="number" name="boardNo" value="<%=board.getBoardNo() %>" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="table-primary">LOCAL NAME</td>
				<td>
				
				<select name ="localName">
					<option>::선택::</option>
					<%
						for(Local l : localList) {
							
					%>
					
					<option value="<%=l.localName%>" <%if(board.getLocalName().equals(l.localName)) { %> selected<% } %>><%=l.localName %></option>
					<%
						}
					%>
				</select>
				
				
				
				
				</td>
			</tr>
			<tr>
				<td class="table-primary">TITLE</td>
				<td><input type="text" name="boardTitle" value="<%=board.getBoardTitle()%>"></td>
			</tr>
			<tr>
				<td class="table-primary">CONTENT</td>
				<td><textarea rows="2" cols="80" name="boardContent"><%=board.getBoardContent() %></textarea></td>
			</tr>
			<tr>
				<td class="table-primary">ID</td>
				<td><%=memberId %></td>
			</tr>
		</table>
			<div class="text-center">
				<button type="submit" class="btn btn-secondary">수정</button>
			</div>
</form>
	<div>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</div>

</body>
</html>