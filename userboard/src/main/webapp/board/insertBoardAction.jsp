<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*" %>
<%
//인코딩
request.setCharacterEncoding("UTF-8");

//세션 유효성 검사
if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
}
String memberId = (String)session.getAttribute("loginMemberId");

//요청값 유효성 검사
String msg = null;
if(request.getParameter("localName") == null
	||request.getParameter("localName").equals("")) {
	msg = URLEncoder.encode("지역 이름을 입력해주세요", "utf-8");
	response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg=" + msg);
	return;
} 
if(request.getParameter("boardTitle") == null
	||request.getParameter("boardTitle").equals("")) {
	msg = URLEncoder.encode("제목을 입력해주세요", "utf-8");
	response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg=" + msg);
	return;
} 

if (request.getParameter("boardContent") == null
	||request.getParameter("boardContent").equals("")) {
	msg = URLEncoder.encode("내용을 입력해주세요", "utf-8");
	response.sendRedirect(request.getContextPath()+"/board/insertBoardForm.jsp?msg=" + msg);
	return;
}

System.out.println(request.getParameter("localName"));

String localName = request.getParameter("localName");
String boardTitle = request.getParameter("boardTitle");
String boardContent = request.getParameter("boardContent");

//db연결
String driver = "org.mariadb.jdbc.Driver";
String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
String dbuser = "root";
String dbpw = "java1234";

Class.forName(driver);
Connection conn = null;
conn = DriverManager.getConnection(dburl, dbuser, dbpw);
/*
INSERT INTO board(
	local_name,
	board_title,
	board_content,
	member_id,
	createdate,
	updatedate)
VALUES (?, ?, ?, ?, now(), now());
*/

String sql = "INSERT INTO board(local_name, board_title, board_content, member_id, createdate, updatedate) VALUES (?, ?, ?, ?, now(), now());";
PreparedStatement stmt = conn.prepareStatement(sql);
stmt.setString(1, localName);
stmt.setString(2, boardTitle);
stmt.setString(3, boardContent);
stmt.setString(4, memberId);

int row = stmt.executeUpdate();

if(row == 1){
	response.sendRedirect(request.getContextPath() + "/homepage/home.jsp");
	System.out.println("inserBoard success"); // 게시글 입력성공
}else{
	System.out.println("insertBoard failed"); // 게시글 입력실패
}



%>
