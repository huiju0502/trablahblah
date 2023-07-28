<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
		return;
	}
	//요청값 유효성 검사
	String memberId = (String)session.getAttribute("loginMemberId");
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
<title>insertBoard</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<form action="<%=request.getContextPath()%>/board/insertBoardAction.jsp" method="post">
		<h1>게시글 작성</h1>
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
		<table class="table text-center">
			<tr>
				<td class="table-primary">지역</td>
				<td>
				<select name ="localName">
					<option value="">::선택::</option>
					<%
						for(Local l : localList) {
					%>
					<option value="<%=l.localName%>"><%=l.localName %></option>
					<%
						}
					%>
				</select>
				</td>
			</tr>
			<tr>
				<td class="table-primary">제목</td>
				<td><input type="text" name="boardTitle"></td>
			</tr>
			<tr>
				<td class="table-primary">내용</td>
				<td><textarea rows="2" cols="80" name="boardContent"></textarea></td>
			</tr>
			<tr>
				<td class="table-primary">작성자</td>
				<td><%=memberId %></td>
			</tr>
			
		</table>
			<div class="text-center">
				<button type="submit" class="btn btn-secondary">작성</button>
			</div>
	</form>
	
	<div>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</div>

</body>
</html>