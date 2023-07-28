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
//요청값 유효성 검사
if(request.getParameter("boardNo") == null
|| request.getParameter("memberId") == null
|| request.getParameter("boardNo").equals("")
|| request.getParameter("memberId").equals("")) {

response.sendRedirect(request.getContextPath()+"/board/boardOne.jsp");
return;	
}

int boardNo = Integer.parseInt(request.getParameter("boardNo"));
String memberId =(String)session.getAttribute("loginMemberId");

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
DELETE
FROM board
WHERE board_no = ? and member_id = ?
*/
String sql = "DELETE FROM board WHERE board_no = ? and member_id = ?";
stmt =conn.prepareStatement(sql);
stmt.setInt(1, boardNo);
stmt.setString(2, memberId);
System.out.println(stmt);
int row = stmt.executeUpdate();
System.out.println(stmt +"<--- deleteMemberAction stmt");

if(row == 1){
	System.out.println("삭제완료");
	response.sendRedirect(request.getContextPath() +"/homepage/home.jsp");
} else{
	System.out.println("삭제실패");
	response.sendRedirect(request.getContextPath() +"/board/deleteBoardForm.jsp?boardNo=" + request.getParameter("boardNo"));
}
System.out.println(row +"<--- deleteMemberAction row");

%>