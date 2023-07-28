<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*" %>
<%@ page import = "vo.*" %>
<%
	//세션유효값 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
		return;
	}
	String memberId = (String)session.getAttribute("loginMemberId");
	
	int commentNo = Integer.parseInt(request.getParameter("commentNo"));
	String commentContent = request.getParameter("commentContent");
	
	

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
	SELECT 
		comment_no commentNo, 
		board_no boardNo, 
		comment_content commentContent, 
		member_id memberId, 
		createdate, 
		updatedate
	FROM comment
	WHERE comment_no = ?
	*/
	PreparedStatement commentStmt = null;
	ResultSet commentRs = null;
	String commentSql = "SELECT comment_no commentNo, board_no boardNo, comment_content commentContent, member_id memberId, createdate, updatedate FROM comment WHERE comment_no = ?";
	commentStmt = conn.prepareStatement(commentSql);
	commentStmt.setInt(1, commentNo);
	System.out.println(commentStmt + " <--commentstmt");
	commentRs = commentStmt.executeQuery();
	
	Comment c = null;
	if(commentRs.next()) {
		c = new Comment();
		c.setCommentNo(commentRs.getInt("commentNo"));
		c.setBoardNo(commentRs.getInt("boardNo"));
		c.setCommentContent(commentRs.getString("commentContent"));
		c.setMemberId(commentRs.getString("memberId"));
		c.setCreatedate(commentRs.getString("createdate"));
		c.setUpdatedate(commentRs.getString("updatedate"));
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>updateComment</title>
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
	<h1>댓글 수정</h1>
	<br>
<!-- 수정폼 -->
<form action="<%=request.getContextPath() %>/board/comment/updateCommentAction.jsp" method="post">
	<input type="hidden" name="commentNo" value="<%=c.getCommentNo() %>">
	<input type="hidden" name="boardNo" value="<%=c.getBoardNo() %>">
	<table class="table text-center">
		<tr>
			<td class="table-primary">내용</td>
			<td>
				<textarea rows="2" cols="80" name="commentContent"><%=c.getCommentContent() %></textarea>
			</td>
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