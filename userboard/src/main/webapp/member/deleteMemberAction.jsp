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
if(request.getParameter("memberId") == null
|| request.getParameter("memberPw") == null
|| request.getParameter("memberId").equals("")
|| request.getParameter("memberPw").equals("")) {

response.sendRedirect(request.getContextPath()+"/member/memberOne.jsp");
return;	
}

String memberId =(String)session.getAttribute("loginMemberId");
String memberPw = request.getParameter("memberPw");

System.out.println(memberId + " <-- updateMemberAction param memberId");
System.out.println(memberPw + " <-- updateMemberAction param memberPw");

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
FROM member
WHERE member_id = ? and member_pw = PASSWORD(?)
*/
String sql = "DELETE FROM member WHERE member_id = ? and member_pw = PASSWORD(?)";
stmt =conn.prepareStatement(sql);
stmt.setString(1, memberId);
stmt.setString(2, memberPw);
System.out.println(stmt);
int row = stmt.executeUpdate();
System.out.println(stmt +"<--- deleteMemberAction stmt");

if(row == 1){
	System.out.println("탈퇴완료");
	response.sendRedirect(request.getContextPath() +"/member/logoutAction.jsp");
} else{
	System.out.println("변경실패");
	response.sendRedirect(request.getContextPath() +"/member/deleteMemberForm.jsp");
}
System.out.println(row +"<--- deleteMemberAction row");

%>