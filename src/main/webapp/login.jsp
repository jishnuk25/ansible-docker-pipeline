<%@ page import="java.sql.*"%>

<%
 String userName = request.getParameter("userName"); 
 
 String password = request.getParameter("password"); 
 
 Class.forName ("org.postgresql.Driver");
 Connection con = DriverManager.getConnection("jdbc:postgresql://postgres:5432/mydb", "Admin", "Admin@777");
 Statement st = con.createStatement(); 
 ResultSet rs; 
 rs = st.executeQuery("select * from user_data where username='" + userName + "' and password='" + password + "'");
	if (rs.next()) 
		{ 
			session.setAttribute("userid", userName); 
			response.sendRedirect("success.jsp"); 
		} 
	else 
		{ 
			out.println("Invalid password <a href='index.jsp'>try again</a>"); 
} 
%>
