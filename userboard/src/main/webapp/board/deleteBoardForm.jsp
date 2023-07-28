<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
// 세션 유효성 검사
if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
	return;
}
// 요청값 유효성 검사
String memberId = (String)session.getAttribute("loginMemberId");

int boardNo = Integer.parseInt(request.getParameter("boardNo"));
System.out.println(boardNo + " <-- deleteBoardForm param boardNo");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>deleteBoard</title>
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
	
	<h1>게시글 삭제</h1>
	
<!-- board 삭제폼 -->
<form action="<%=request.getContextPath() %>/board/deleteBoardAction.jsp" method="post">
	<table class="table text-center">
		<tr>
			<td class="table-primary">NO</td>
			<td><input type="text" name="boardNo" value="<%=boardNo%>" readonly="readonly"></td>
		</tr>
		<tr>
			<td class="table-primary">ID</td>
			<td><input type="password" name="memberId"></td>
		</tr>
	</table>
	<div class="text-center">
		<button type="submit" class="btn btn-secondary">삭제</button>
	</div>

</form>
	<div>
		<jsp:include page="/inc/copyright.jsp"></jsp:include>
	</div>
</div>

</body>
</html>