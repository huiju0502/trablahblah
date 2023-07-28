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
<div class="container mt-3">
	<div>
		<jsp:include page="/inc/mainmenu.jsp"></jsp:include>
	</div>
	<br>
	<form action="<%=request.getContextPath()%>/member/insertMemberAction.jsp" method="post">
		<h1>회원가입</h1>
		<table class="table text-center">
			<tr>
				<td class="table-primary">ID</td>
				<td><input type="text" name="memberId"></td>
			</tr>
			<tr>
				<td class="table-primary">PASSWORD</td>
				<td><input type="password" name="memberPw"></td>
			</tr>
		</table>
			<div class="text-center">
		<button type="submit" class="btn btn-secondary">가입</button>
		</div>
	</form>
	
	<div>
	<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</div>
</body>
</html>