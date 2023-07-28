<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import="java.net.*" %>
<%
// 인코딩
request.setCharacterEncoding("UTF-8");

//세션 유효성 검사
if(session.getAttribute("loginMemberId") == null) {
	response.sendRedirect(request.getContextPath()+"/home.jsp");
	return;
}
String memberId = (String)session.getAttribute("loginMemberId");

// 입력값 유효성 검사
String msg = null;
if(request.getParameter("localName") == null
	||request.getParameter("localName").equals("")) {
	msg = URLEncoder.encode("지역 이름을 입력해주세요", "utf-8");
	response.sendRedirect(request.getContextPath()+"/homepage/insertLocalForm.jsp?msg=" + msg);
return;	
}
String localName = request.getParameter("localName");

// db연결
String driver = "org.mariadb.jdbc.Driver";
String dburl = "jdbc:mariadb://127.0.0.1:3306/userboard";
String dbuser = "root";
String dbpw = "java1234";

Class.forName(driver);
Connection conn = null;
conn = DriverManager.getConnection(dburl, dbuser, dbpw);

// 지역명 중복검사
String cntLocal = "SELECT count(*) FROM local WHERE local_name = ?";
PreparedStatement cntLocalStmt = conn.prepareStatement(cntLocal);
cntLocalStmt.setString(1, localName);
System.out.println(cntLocalStmt + " <- insertLocalAction cntLocalStmt");
ResultSet cntRs = cntLocalStmt.executeQuery();

int cnt = 0;
if(cntRs.next()) {
	cnt = cntRs.getInt("count(*)");
}
if(cnt > 0) {
	msg = URLEncoder.encode("이미 존재하는 지역명입니다", "utf-8");
	response.sendRedirect(request.getContextPath() + "/homepage/insertLocalForm.jsp?msg=" + msg);
	return;
}

/*
	INSERT INTO local(
		local_name,
		createdate,
		updatedate)
	VALUES (?, now(), now());
*/

String insertLocalSql = "INSERT INTO local(local_name, createdate, updatedate) VALUES (?, now(), now())";
PreparedStatement insertLocalStmt = conn.prepareStatement(insertLocalSql);
insertLocalStmt.setString(1, localName);

int row = insertLocalStmt.executeUpdate();

if(row == 1){
	response.sendRedirect(request.getContextPath() + "/homepage/insertLocalForm.jsp");
	System.out.println("insertLocal success"); // 지역입력성공
}else{
	System.out.println("insertLocal failed"); // 지역입력실패
}


%>