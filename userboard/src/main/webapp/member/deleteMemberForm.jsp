<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>
    
<%
//세션 유효성 검사
if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
	return;
}
String memberId = (String)session.getAttribute("loginMemberId");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteMember</title>
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
	
	<h1>회원 탈퇴</h1>
	
<!-- 회원탈퇴 폼 -->
<form action="<%=request.getContextPath() %>/member/deleteMemberAction.jsp" method="post">
	<table class="table text-center">
		<tr>
			<td class="table-primary">ID</td>
			<td><input type="text" name="memberId" value="<%=memberId%>" readonly="readonly"></td>
		</tr>
		<tr>
			<td class="table-primary">PASSWORD</td>
			<td><input type="password" name="memberPw"></td>
		</tr>
	</table>
	<div class="text-center">
		<button type="submit" class="btn btn-primary">탈퇴</button>
	</div>
</form>
	
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>

</div>

</body>
</html>