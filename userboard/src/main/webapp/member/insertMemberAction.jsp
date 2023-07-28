<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<%@ page import="vo.*" %>
<%
//인코딩
request.setCharacterEncoding("UTF-8");

// 세션 유효성 검사 -> 요청값 유효성 검사
if(session.getAttribute("loginMemberId") != null) {
	response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
	return;
}

// 요청값 유효성 검사
if(request.getParameter("memberId") == null
|| request.getParameter("memberPw") == null
|| request.getParameter("memberId").equals("")
|| request.getParameter("memberPw").equals("")) {

response.sendRedirect(request.getContextPath()+"/member/insertMemberForm.jsp");
return;	
}

String memberId = request.getParameter("memberId");
String memberPw = request.getParameter("memberPw");

// 요청값 객체에 묶어 저장 
Member paramMember = new Member();
paramMember.memberId = memberId;
paramMember.memberPw = memberPw;

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
INSERT INTO member(
		member_id, member_pw, createdate, updatedate)
		VALUES(?,PASSWORD(?),now(),now())
*/
String sql = "INSERT INTO member(member_id, member_pw, createdate, updatedate) VALUES(?,PASSWORD(?),now(),now())";
stmt =conn.prepareStatement(sql);
stmt.setString(1, paramMember.memberId);
stmt.setString(2, paramMember.memberPw);
System.out.println(stmt);
int row = stmt.executeUpdate();

if(row==1) {
	System.out.println("회원가입 성공");
} else {
	System.out.println("회원가입 실패");
}
response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
%>
</body>
</html>