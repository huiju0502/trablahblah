<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.net.*" %>
<%@ page import = "vo.*" %>
<%

	//인코딩
	request.setCharacterEncoding("UTF-8");

	// 세션 유효성 검사 -> 요청값 유효성 검사
	if(session.getAttribute("loginMemberId") != null) {
		response.sendRedirect(request.getContextPath()+"/homepage/home.jsp");
		return;
	}
	
	// 요청값 유효성 검사
	String memberId = request.getParameter("memberId");
	String memberPw = request.getParameter("memberPw");
	
	// 디버깅
	System.out.println(memberId + " <-- id");
	System.out.println(memberPw + " <-- pw");
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
		SELECT member_id memberId 
		FROM member 
		WHERE member_id = ? AND member_pw = PASSWORD(?)
	*/
	String sql = "SELECT member_id memberId FROM member WHERE member_id = ? AND member_pw = PASSWORD(?)";
	stmt =conn.prepareStatement(sql);
	stmt.setString(1, paramMember.memberId);
	stmt.setString(2, paramMember.memberPw);
	System.out.println(stmt);
	rs = stmt.executeQuery();
	
	String msg = null;
	if(rs.next()) { //로그인 성공
		// 세션에 로그인 정보(memberId) 저장
		session.setAttribute("loginMemberId", rs.getString("memberId"));
		System.out.println("로그인 성공 세션정보 : " + session.getAttribute("loginMemberId"));
		msg = URLEncoder.encode("로그인 성공!", "utf-8");
	    response.sendRedirect(request.getContextPath()+"/homepage/home.jsp?msg=" + msg);
	} else { // 로그인 실패
	      System.out.println("로그인 실패");
	      msg = URLEncoder.encode("로그인에 실패! 다시 시도해주세요.", "utf-8");
	      response.sendRedirect(request.getContextPath()+"/homepage/home.jsp?msg=" + msg);
	}
%>