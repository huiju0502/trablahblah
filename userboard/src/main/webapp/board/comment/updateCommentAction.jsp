<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	//인코딩
	request.setCharacterEncoding("UTF-8");

	//세션 유효성 검사
	if(session.getAttribute("loginMemberId") == null) {
		response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
		return;
	}
	// String memberId = (String)session.getAttribute("loginMemberId");
	//요청값 유효성 검사
	if(request.getParameter("commentNo") == null
	||request.getParameter("commentContent") == null
	|| request.getParameter("commentNo").equals("")
	|| request.getParameter("commentContent").equals("")) {
	
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + request.getParameter("boardNo"));
	return;	
	}
	
	int boardNo = Integer.parseInt(request.getParameter("boardNo"));
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
	UPDATE comment
	SET comment_content = ?, updatedate = now()
	WHERE comment_no = ?
	*/
	String sql = "UPDATE comment SET comment_content = ?, updatedate = now() WHERE comment_no = ?";
	stmt =conn.prepareStatement(sql);
	stmt.setString(1, commentContent);
	stmt.setInt(2, commentNo);
	System.out.println(stmt);

	int row = stmt.executeUpdate();
	System.out.println(stmt +"<--- updateCommentAction stmt");

	if(row == 1){
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + request.getParameter("boardNo"));
		System.out.println("updateComment success");
	}else{
		response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + request.getParameter("boardNo"));
		System.out.println("updateComment failed");
	}

%>