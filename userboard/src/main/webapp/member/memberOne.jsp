<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="vo.*" %>

<%
	// 1. 컨트롤러 계층
	// 세션유효값 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");

	// 2. 모델 계층 
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
		SELECT member_id memberId, createdate, updatedate
		FROM member 
		WHERE member_id = ?
	*/
	String sql = "SELECT member_id memberId, createdate, updatedate FROM member  WHERE member_id = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setString(1, memberId);
	System.out.println(stmt + " <--memberOne stmt");
	rs = stmt.executeQuery();
	Member member = null;
	if(rs.next()) {
		member = new Member();
		member.setMemberId(rs.getString("memberId"));
		member.setCreatedate(rs.getString("createdate"));
		member.setUpdatedate(rs.getString("updatedate"));
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>myPage</title>
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
	<h1>마이 페이지</h1>
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

<!-- member one 결과셋 -->
<form action="<%=request.getContextPath() %>/member/updateMemberAction.jsp" method="post">
	<table class="table text-center">
		<tr>
			<td class="table-primary">ID</td>
			<td><input type="text" name="memberId" value="<%=memberId %>" readonly="readonly"></td>
		</tr>
		<tr>
			<td class="table-primary">PASSWORD</td>
			<td><input type="password" name="memberPw"></td>
		</tr>
		<tr>
			<td class="table-primary">NEW PASSWORD</td>
			<td><input type="password" name="newPw1"></td>
		</tr>
		<tr>
			<td class="table-primary">NEW PASSWORD</td>
			<td><input type="password" name="newPw2"></td>
		</tr>
		<tr>
			<td class="table-primary">CREATE DATE</td>
			<td><%=member.getCreatedate() %></td>
		</tr>
		<tr>
			<td class="table-primary">UPDATE DATE</td>
			<td><%=member.getUpdatedate() %></td>
		</tr>	
	</table>

	<div class="text-center">
		<button type="submit" class="btn btn-primary">비밀번호 변경</button>
		<a href="<%=request.getContextPath()%>/member/deleteMemberForm.jsp"><button type="button" class="btn btn-primary">회원 탈퇴</button></a>
	</div>
	</form>
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>

</div>

</body>
</html>