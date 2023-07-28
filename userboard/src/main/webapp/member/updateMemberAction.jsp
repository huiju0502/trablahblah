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
// 요청값 유효성 검사
if(request.getParameter("memberId") == null
|| request.getParameter("memberPw") == null
|| request.getParameter("newPw1") == null
|| request.getParameter("newPw2") == null
|| request.getParameter("memberId").equals("")
|| request.getParameter("memberPw").equals("")
|| request.getParameter("newPw1").equals("")
|| request.getParameter("newPw2").equals("")) {

response.sendRedirect(request.getContextPath()+"/member/memberOne.jsp");
return;	
}

String memberId = request.getParameter("memberId");
String memberPw = request.getParameter("memberPw");
String newPw1 = request.getParameter("newPw1");
String newPw2 = request.getParameter("newPw2");

System.out.println(memberId + " <-- updateMemberAction param memberId");
System.out.println(memberPw + " <-- updateMemberAction param memberPw");
System.out.println(newPw1 + " <-- updateMemberAction param newPw1");
System.out.println(newPw2 + " <-- updateMemberAction param newPw2");





// db연결
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
UPDATE member
SET member_pw = PASSWORD(?), updatedate = now()
WHERE member_id = ? and member_pw = PASSWORD(?)		
*/
String sql = "UPDATE member SET member_pw = PASSWORD(?), updatedate = now() WHERE member_id = ? and member_pw = PASSWORD(?)	";
stmt =conn.prepareStatement(sql);
stmt.setString(1, newPw1);
stmt.setString(2, memberId);
stmt.setString(3, memberPw);
System.out.println(stmt);
int row = stmt.executeUpdate();
System.out.println(stmt +"<--- updateMemberAction stmt");

//새로운 비밀번호 일치 하지않으면 오류 메세지
String msg = null;
if(!newPw1.equals(newPw2)) {
	msg = URLEncoder.encode("새로운 비밀번호가 서로 일치하지않습니다", "utf-8");
	response.sendRedirect(request.getContextPath() +"/member/memberOne.jsp?msg=" + msg);
return;
} 

if(row == 1){
		System.out.println("변경완료");
		response.sendRedirect(request.getContextPath() +"/homepage/home.jsp");
} else{
		System.out.println("변경실패");
		response.sendRedirect(request.getContextPath() +"/member/memberOne.jsp");
}


System.out.println(row +"<--- updateMemberAction row");
%>
