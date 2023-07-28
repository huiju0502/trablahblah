<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
		<!-- 
			로그인 전 : 회원가입
			로그인 후 : 회원정보 / 로그아웃 (로그인정보 세션 : loginMemberId)
		-->
	<div class="btn-group">
  <a href="<%=request.getContextPath() %>/homepage/home.jsp"><button type="button" class="btn btn-outline-secondary">HOME</button></a>
  
  <%
			if(session.getAttribute("loginMemberId") == null) { //로그인 전
		%>
			<a href="<%=request.getContextPath() %>/member/insertMemberForm.jsp"><button type="button" class="btn btn-outline-secondary">SIGN IN</button></a>
		<%		
			} else { //로그인 후
		%>
			<a href="<%=request.getContextPath() %>/member/memberOne.jsp"><button type="button" class="btn btn-outline-secondary">MY PAGE</button></a>
			<a href="<%=request.getContextPath() %>/member/logoutAction.jsp"><button type="button" class="btn btn-outline-secondary">LOG OUT</button></a>
		<%
			}
		%>
</div>
</body>
</html>



