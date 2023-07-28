<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
//인코딩
request.setCharacterEncoding("UTF-8");

//세션 유효성 검사
if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
	return;
}
//요청값 유효성 검사
if(request.getParameter("localName") == null
	|| request.getParameter("newLocalName") == null
	|| request.getParameter("localName").equals("")
	|| request.getParameter("newLocalName").equals("")) {
	String msg = URLEncoder.encode("수정 실패! 수정할 이름을 입력해주세요.", "utf-8");
	response.sendRedirect(request.getContextPath() +"/homepage/insertLocalForm.jsp?msg=" + msg);
	return;	
}

String localName = request.getParameter("localName");
String newLocalName = request.getParameter("newLocalName");

System.out.println(localName + " <-- updateLocalAction param localName");
System.out.println(newLocalName + " <-- updateLocalAction param newLocalName");

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
UPDATE local
SET local_name = ?, updatedate = now()
WHERE local_name = ?
*/
String sql = "UPDATE local SET local_name = ?, updatedate = now() WHERE local_name = ?";
stmt =conn.prepareStatement(sql);
stmt.setString(1, newLocalName);
stmt.setString(2, localName);
System.out.println(stmt);

int row = stmt.executeUpdate();
System.out.println(stmt +"<--- updateMemberAction stmt");

String msg = null;
if(row == 1){
	System.out.println("수정 완료");
	msg = URLEncoder.encode("수정 성공!", "utf-8");
	response.sendRedirect(request.getContextPath() +"/homepage/insertLocalForm.jsp?msg=" + msg);
} 
System.out.println(row +"<--- updateLocalAction row");
%>