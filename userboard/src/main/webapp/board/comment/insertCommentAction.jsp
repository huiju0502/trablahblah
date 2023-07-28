<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*" %>
<%
//인코딩
request.setCharacterEncoding("UTF-8");

//세션 유효성 검사
if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
	return;
}

// 입력값 유효성 검사
int boardNo = Integer.parseInt(request.getParameter("boardNo"));
String commentContent = request.getParameter("commentContent");
String memberId =(String)session.getAttribute("loginMemberId");


if(request.getParameter("boardNo") == null
	|| request.getParameter("memberId") == null 
	|| request.getParameter("boardNo").equals("")
	|| request.getParameter("memberId").equals("")) {
	response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
	return;	
	}

String msg = null;
if(request.getParameter("commentContent") == null
	||request.getParameter("commentContent").equals("")) {
	msg = URLEncoder.encode("댓글내용을 입력해주세요", "utf-8");
	response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + boardNo +"&msg=" + msg);
	return;	
	}
// db연결
String driver = "org.mariadb.jdbc.Driver";
String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
String dbuser = "root";
String dbpw = "java1234";

Class.forName(driver);
Connection conn = null;
conn = DriverManager.getConnection(dburl, dbuser, dbpw);

/*
	INSERT INTO comment(
		board_no,
		comment_content,
		member_id,
		createdate,
		updatedate)
	VALUES (?, ?, ?, now(), now());
*/
PreparedStatement insertCommentStmt = null;
String insertCommentSql = "INSERT INTO comment(board_no, comment_content, member_id, createdate, updatedate) VALUES (?, ?, ?, now(), now())";
insertCommentStmt = conn.prepareStatement(insertCommentSql);
insertCommentStmt.setInt(1, boardNo);
insertCommentStmt.setString(2, commentContent);
insertCommentStmt.setString(3, memberId);

int row = insertCommentStmt.executeUpdate();

if(row == 1){
	System.out.println("insertComment success"); // 댓글입력성공
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
}else{
	System.out.println("insertComment failed"); // 댓글입력실패
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + boardNo);
}

%>