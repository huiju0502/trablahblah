<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	// 1. 요청분석(컨트롤러 계층)
	// 1) session JSP내장(기본)객체

	// 2) request / response JSP내장(기본) 객체
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	int rowPerPage = 10;
	if(request.getParameter("rowPerPage") != null) {
		rowPerPage = Integer.parseInt(request.getParameter("rowPerPage"));
	}
	int startRow = (currentPage-1)*rowPerPage;
	System.out.println(startRow + " <--home startRow");
	
	int lastPage = 0;
	
	String localName = "전체";
	if(request.getParameter("localName") != null){
		localName = request.getParameter("localName");
	}
	
	System.out.println(localName + " <--home localName");
	
	// 2. 모델 계층
	String driver = "org.mariadb.jdbc.Driver";
	String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
	String dbuser = "root";
	String dbpw = "java1234";
	Class.forName(driver);
	Connection conn = null;
	
	// 2-1) 서브메뉴 결과셋(모델)
	PreparedStatement subMenuStmt = null;
	ResultSet subMenuRs = null;
	conn = DriverManager.getConnection(dburl, dbuser, dbpw);
		
	/* 서브메뉴
		SELECT '전체' localName, COUNT(local_name) cnt FROM board
		UNION ALL 
		SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name
	*/
	String subMenuSql = "SELECT '전체' localName, COUNT(local_name) cnt FROM board UNION ALL SELECT local_name, COUNT(local_name) FROM board GROUP BY local_name";
	subMenuStmt = conn.prepareStatement(subMenuSql);
	subMenuRs = subMenuStmt.executeQuery();
	
	ArrayList<HashMap<String, Object>> subMenuList 
		= new ArrayList<HashMap<String, Object>>();
	while(subMenuRs.next()) {
	HashMap<String, Object> m = new HashMap<String, Object>();
	m.put("localName", subMenuRs.getString("localName"));
	m.put("cnt", subMenuRs.getInt("cnt"));
	subMenuList.add(m);
	}
	
	// 2-2)게시판 목록 결과셋(모델)
	PreparedStatement boardStmt = null;
	ResultSet boardRs = null;
	/*
		SELECT 
			board_no boardNo, 
			local_name localName, 
			board_title boardTitle, 
			member_id memberId,
			createdate
		FROM board
		WHERE local_name = ?
		ORDER BY createdate DESC
		LIMIT ?, ?
	*/
	String boardSql = "";
	if(localName.equals("전체")) {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, member_id memberId, createdate FROM board ORDER BY createdate DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setInt(1, startRow);
		boardStmt.setInt(2, rowPerPage);
	} else {
		boardSql = "SELECT board_no boardNo, local_name localName, board_title boardTitle, member_id memberId, createdate FROM board WHERE local_name = ? ORDER BY createdate DESC LIMIT ?, ?";
		boardStmt = conn.prepareStatement(boardSql);
		boardStmt.setString(1, localName);
		boardStmt.setInt(2, startRow);
		boardStmt.setInt(3, rowPerPage);
	}
	boardRs = boardStmt.executeQuery(); // DB쿼리 결과셋 모델
	ArrayList<Board> boardList = new ArrayList<Board>();// 애플케이션에서 사용할 모델(사이즈 0)
	// boardRs --> boardList
	while(boardRs.next()) {
		Board b = new Board();
		b.setBoardNo(boardRs.getInt("boardNo"));
		b.setLocalName(boardRs.getString("localName"));
		b.setBoardTitle(boardRs.getString("boardTitle"));
		b.setMemberId(boardRs.getString("memberId"));
		b.setCreatedate(boardRs.getString("createdate"));
		boardList.add(b);
	}
	// 2-3) 마지막 페이지수 구하기
	// SELECT count(*) boardRow FROM board; 사용해서 '전체' 행 수 구하기
		if(localName.equals("전체")) {
			PreparedStatement stmt = conn.prepareStatement("SELECT count(*) boardRow from board");
			ResultSet rs = stmt.executeQuery();
			int totalRow = 0;
			if(rs.next()) {
				totalRow = rs.getInt("boardRow");
			}
			// 2) 전체행수를 페이지당 출력할 행의 수로 나눠서 마지막 페이지 구하기
			lastPage = totalRow / rowPerPage;
			// 3) 나머지가 생기면 전체페이지수 + 1
			if(totalRow % rowPerPage != 0) {
				lastPage = lastPage + 1;
			}
		} else { // SELECT count(*) boardRow FROM board WHERE rocal_name = ?; 사용해서 지역별 행 수 구하기
			PreparedStatement stmt = conn.prepareStatement("SELECT count(*) boardRow from board WHERE local_name = ?");
			stmt.setString(1, localName);
			ResultSet rs = stmt.executeQuery();
			int totalRow = 0;
			if(rs.next()) {
				totalRow = rs.getInt("boardRow");
			}
			// 2) 전체행수를 페이지당 출력할 행의 수로 나눠서 마지막 페이지 구하기
			lastPage = totalRow / rowPerPage;
			// 3) 나머지가 생기면 전체페이지수 + 1
			if(totalRow % rowPerPage != 0) {
				lastPage = lastPage + 1;
			}
		}
	
		// 페이지 네비게이션 페이징
		int pagePerPage = 10;
		int minPage = (((currentPage-1) / pagePerPage) * pagePerPage) + 1;
		int maxPage = minPage + (pagePerPage - 1);
		if(maxPage > lastPage) {
			maxPage = lastPage;
		}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<link href="<%=request.getContextPath()%>/image/trablahblahFavicon.png" rel="icon">
</head>
<body>
<div class="container-md mt-3">
<!-- 메인메뉴 -->
<%
	//request.getRequestDispatcher("/inc/mainmenu.jsp").include(request, response);
	// 이코드를 액션 태그로 변경하면 아래와 같다
%>
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	
	<div class="container-fluid p-5 text-white text-center" style="background-color: #9CB9FF;">
	
	  <img src="<%=request.getContextPath()%>/image/trablahblah.png" height="200px">
	  <p>Resize this responsive page to see the effect!</p> 
	</div>
<br>
	<div>
		<%	// 로그인 실패시 오류메세지 
			if(request.getParameter("msg") != null) {
				
		%>
  			<div class="alert alert-secondary alert-dismissible">
   				 <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    			<strong><%=request.getParameter("msg")%></strong>
 			</div>
		<%
		}
		%>
	<!-- 로그인 폼 -->
		<%
			// 로그인 상태가 아닐떄 로그인폼 나타남
			if(session.getAttribute("loginMemberId") == null) {
		%>
			<form action="<%=request.getContextPath()%>/member/loginAction.jsp" method="post">
				<table class="table text-center">
					<tr>
						<td class="table-primary">ID</td>
						<td><input type="text" name="memberId"></td>
					</tr>
					<tr>
						<td class="table-primary">PASSWORD</td>
						<td><input type="password" name="memberPw"></td>
					</tr>
					<tr>
						<td colspan="2"><button type="submit" class="btn btn-secondary">LOG IN</button></td>
					</tr>
				</table>
			</form>
		<%		
				}	
		%>
		
	</div>
	<br>
	<!-- insertBoard버튼 -->
	<div>
	<%
		if(session.getAttribute("loginMemberId") != null) { // 로그인 했을때만 글쓰기 버튼 보임
	%>
					<a href="<%=request.getContextPath()%>/board/insertBoardForm.jsp"><button type="button" class="btn btn-secondary btn-lg">NEW</button></a>
			<%
				}
			%>
		
	</div>
	<br>
	
	<div class="row">
	<!-- 서브메뉴(세로) subMenuList모델을 출력 -->
		<div class="col-sm-2">
			<ul class="list-group">
				<%
					if(session.getAttribute("loginMemberId") != null) { // 로그인 했을때만 관리 버튼 보임
				%>
					<li class="list-group-item"><a href="<%=request.getContextPath()%>/homepage/insertLocalForm.jsp">카테고리 관리</a></li>	
				<%
					}
					for(HashMap<String, Object> m : subMenuList) {
				%>
						
						<li class="list-group-item">
							<a href="<%=request.getContextPath()%>/homepage/home.jsp?localName=<%=(String)m.get("localName")%>">
							<%=(String)m.get("localName")%>(<%=(Integer)m.get("cnt")%>)</a>
						</li>
				<%		
					}
				%>
				
			</ul>
		</div>
		
		<div class="col-sm-10">
			<!-- boardList -->
			<div>
			
				<table class="table text-center">
					<tr class="table-primary">
						<td>LOCAL</td>
						<td>TITLE</td>
						<td>ID</td>
						<td>CREATEDATE</td>
					</tr>
					<%
						for(Board b : boardList) {
					%>
					<tr>
						<td><%=b.getLocalName() %></td>
						<td>
							<a href="<%=request.getContextPath()%>/board/boardOne.jsp?boardNo=<%=b.getBoardNo()%>">
										<%=b.getBoardTitle()%>
							</a>
						</td>
						<td><%=b.getMemberId() %></td>
						<td><%=b.getCreatedate()%></td>
						
					</tr>	
				<%
						}
				%>
				</table>
			</div>
			<div class="text-center">
			<%
					if(minPage > 1) {
					%>
						<a href="<%=request.getContextPath() %>/homepage/home.jsp?localName=<%=localName%>&currentPage=<%=minPage-pagePerPage%>"><button type="button" class="btn btn-outline-secondary">이전</button></a>
					<%
					}
					
					for(int i = minPage; i<=maxPage; i=i+1) {
						if(i == currentPage) {
					%>
							<a><span><%=i%></span></a>&nbsp;
					<%			
						} else {		
					%>
							<a href="<%=request.getContextPath() %>/homepage/home.jsp?localName=<%=localName%>&currentPage=<%=i%>"><%=i%></a>&nbsp;	
					<%	
						}
					}
					
					if(maxPage != lastPage) {
					%>
						<!--  maxPage + 1 -->
						<a href="<%=request.getContextPath() %>/homepage/home.jsp?localName=<%=localName%>&currentPage=<%=minPage+pagePerPage%>"><button type="button" class="btn btn-outline-secondary">다음</button></a>
					<%
					}
			   		%>
			
			</div>
		</div>
	<div>
		<!-- include 페이지 : Copyright &copy; 구디아카데미 -->
	<%
		//request.getRequestDispatcher("/inc/copyright.jsp").include(request, response);
		// 이코드를 액션 태그로 변경하면 아래와 같다
	%>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</div>

</div>	
</body>
</html>