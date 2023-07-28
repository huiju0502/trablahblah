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
String memberId = (String)session.getAttribute("loginMemberId");

//요청값 유효성 검사
if(request.getParameter("boardNo") == null
||request.getParameter("localName") == null
|| request.getParameter("boardTitle") == null
|| request.getParameter("boardContent") == null
|| request.getParameter("boardNo").equals("")
|| request.getParameter("localName").equals("")
|| request.getParameter("boardTitle").equals("")
|| request.getParameter("boardContent").equals("")) {

response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp?boardNo=" + request.getParameter("boardNo"));
return;	
}

int boardNo = Integer.parseInt(request.getParameter("boardNo"));
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
PreparedStatement stmt = null;
ResultSet rs = null;
conn = DriverManager.getConnection(dburl, dbuser, dbpw);

/* 
UPDATE board
SET local_name = ?, board_title = ?, board_content = ?, updatedate = now()
WHERE board_no = ?
*/
String sql = "UPDATE board SET local_name = ?, board_title = ?, board_content = ?, updatedate = now() WHERE board_no = ?";
stmt =conn.prepareStatement(sql);
stmt.setString(1, localName);
stmt.setString(2, boardTitle);
stmt.setString(3, boardContent);
stmt.setInt(4, boardNo);
System.out.println(stmt);

int row = stmt.executeUpdate();
System.out.println(stmt +"<--- updateMemberAction stmt");

if(row == 1){
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + request.getParameter("boardNo"));
	System.out.println("updateBoard success");
}else{
	response.sendRedirect(request.getContextPath() + "/board/boardOne.jsp?boardNo=" + request.getParameter("boardNo"));
	System.out.println("updateBoard failed");
}
%>