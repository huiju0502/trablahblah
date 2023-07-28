<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%
//인코딩
request.setCharacterEncoding("UTF-8");

//세션 유효성 검사
if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
}
//요청값 유효성 검사
if(request.getParameter("localName") == null
	|| request.getParameter("deleteCk") == null
	|| request.getParameter("localName").equals("")
	|| request.getParameter("deleteCk").equals("")) {
	
	response.sendRedirect(request.getContextPath()+"/homepage/insertLocalForm.jsp");
	return;	
	}

String localName = request.getParameter("localName");
String deleteCk = request.getParameter("deleteCk");

System.out.println(localName + " <-- updateLocalAction param localName");
System.out.println(deleteCk+ " <-- updateLocalAction param newLocalName");

// 확인용 문구가 틀리면 
if(!deleteCk.equals(localName)) {
	response.sendRedirect(request.getContextPath() +"/homepage/deleteLocalForm.jsp");
  return;
} 
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
FROM local
WHERE local_name = ?
*/
String sql = "DELETE FROM local WHERE local_name = ?";
stmt =conn.prepareStatement(sql);
stmt.setString(1, deleteCk);
System.out.println(stmt);
int row = stmt.executeUpdate();
System.out.println(stmt +"<--- deleteMemberAction stmt");

String msg = null;
if(row == 1){
	System.out.println("삭제 완료");
	msg = URLEncoder.encode("삭제 성공!", "utf-8");
	response.sendRedirect(request.getContextPath() +"/homepage/insertLocalForm.jsp?msg=" + msg);
} else{
	System.out.println("삭제 실패");
	msg = URLEncoder.encode("삭제 실패! 확인용 문구를 정확히 입력해주세요", "utf-8");
	response.sendRedirect(request.getContextPath() +"/homepage/insertLocalForm.jsp?msg=" + msg);
} 
System.out.println(row +"<--- deleteLocalAction row");


%>