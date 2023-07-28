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
// db 연결 
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
		local_name localName, createdate, updatedate
	FROM local
*/
String sql = "SELECT local_name localName, createdate, updatedate FROM local";
stmt = conn.prepareStatement(sql);
rs = stmt.executeQuery();
ArrayList<Local> localList = new ArrayList<Local>();
while(rs.next()) {
	Local l = new Local();
	l.setLocalName(rs.getString("localName"));
	l.setCreatedate(rs.getString("createdate"));
	l.setUpdatedate(rs.getString("updatedate"));
	localList.add(l);
}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertLocal</title>
</head>
<body>
<div class="container-md mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<h1>지역 추가</h1>
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
		
<form action="<%=request.getContextPath() %>/homepage/insertLocalAction.jsp" method="post">
	<table class="table text-center">
		<tr class="table-primary">
			<td>LOCAL NAME</td>
			<td>CREATE DATE</td>
			<td>UPDATE DATE</td>
			<td>수정</td>
			<td>삭제</td>
		<tr>
		<%
			for(Local l : localList) {
		
		%>
		<tr>
			<td><%=l.getLocalName()%></td>
			<td><%=l.getCreatedate() %></td>
			<td><%=l.getUpdatedate() %></td>
			<td><a href="<%=request.getContextPath()%>/homepage/updateLocalForm.jsp?localName=<%=l.getLocalName()%>">수정</a></td>
			<td><a href="<%=request.getContextPath()%>/homepage/deleteLocalForm.jsp?localName=<%=l.getLocalName()%>">삭제</a></td>
		</tr>
		<%
			}
		%>
		
		<tr class="table-primary">
			<td colspan="5"><input type="text" name="localName"></td>
		</tr>
	</table>
	<div class="text-center">
		<button type="submit" class="btn btn-secondary">추가</button>
	</div>
</form>
	<div>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</div>
</body>
</html>