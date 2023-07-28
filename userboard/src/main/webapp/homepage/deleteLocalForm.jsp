<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>
<%
	//세션유효값 검사
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
		SELECT count(*)
		FROM board 
		WHERE local_name = ?
	*/
	String sql = "SELECT count(*) FROM board WHERE local_name = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, localName);
	rs = stmt.executeQuery();
	
	int cnt = 0;
	if(rs.next()) {
		cnt = rs.getInt("count(*)");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteLocal</title>
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
	
<!-- 삭제 폼 -->
<%
	if(cnt == 0) {
		
%>
		<h1>지역 삭제</h1>
		<br>
		<%	// 삭제 실패시 오류메세지 
			if(request.getParameter("msg") != null) {
				
		%>
  			<div class="alert alert-secondary alert-dismissible">
   				 <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    			<strong><%=request.getParameter("msg")%></strong>
 			</div>
		<%
		}
		%>
		<form action="<%=request.getContextPath() %>/homepage/deleteLocalAction.jsp" method="post">
			<table class="table text-center">
				<tr>
					<td class="table-primary">LOCAL NAME</td>
					<td><input type="text" name="localName" value="<%=localName %>" readonly="readonly"></td>
				</tr>
				<tr>
					<td class="table-primary">삭제하려면 지역이름을 입력하세요</td>
					<td><input type="text" name="deleteCk"></td>
				</tr>
			</table>
			
			<div class="text-center">
				<button type="submit" class="btn btn-secondary">삭제</button>
			</div>
		</form>	
	
<%
	} else { 
%>
		<div class="alert alert-danger">
	    <strong>삭제 실패!</strong> 게시글이 존재해 카테고리를 삭제할수 없습니다!
	 	</div>
<%	
	}
%>
	<br>
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
		
	
</div>

</body>
</html>