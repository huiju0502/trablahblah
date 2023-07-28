<%@page import="javax.sql.RowSetListener"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	// 세션유효값 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
		return;
	}
	
	String localName = request.getParameter("localName");

	// db연결
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
			local_name localName,
			createdate,
			updatedate
		FROM local
		WHERE local_name = ?
	*/
	String sql = "SELECT local_name localName, createdate,updatedate FROM local WHERE local_name = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	rs = stmt.executeQuery();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateLocal</title>
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
	<h1>지역명 수정</h1>
	<br>
<!-- 수정 폼 -->
<form action="<%=request.getContextPath() %>/homepage/updateLocalAction.jsp" method="post">
	<table class="table text-center">
		<tr>
			<td class="table-primary">LOCAL NAME</td>
			<td><input type="text" name="localName" value="<%=localName %>" readonly="readonly"></td>
		</tr>
		<tr>
			<td class="table-primary">UPDATED LOCAL NAME</td>
			<td><input type="text" name="newLocalName"></td>
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