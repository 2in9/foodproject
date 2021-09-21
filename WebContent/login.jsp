<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>
<link rel="stylesheet" href="./css/login.css">
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
</head>
<body>
<%
    String clientId = "lZ_q_G3VUDdUaqqUW5y4";//애플리케이션 클라이언트 아이디값";
    String redirectURI = URLEncoder.encode("http://175.200.235.98:7777/foodproject1/login_naver.do", "UTF-8");
    SecureRandom random = new SecureRandom();
    String state = new BigInteger(130, random).toString();
    String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code";
    apiURL += "&client_id=" + clientId;
    apiURL += "&redirect_uri=" + redirectURI;
    apiURL += "&state=" + state;
    session.setAttribute("state", state);
%>
  
<div class="wrapper fadeInDown">
  <div id="formContent">
    <!-- Tabs Titles -->

    <!-- Icon -->
    <div class="fadeIn first">
      <h2 style="color:#00BFFF">Login</h2>
    </div>

    <!-- Login Form -->
    <form action="./login_ok.do">
      <input type="text" id="id" class="fadeIn second" name="login" placeholder="I D">
      <input type="password" id="password" class="fadeIn third" name="login" placeholder="Password">
      <input type="submit" class="fadeIn fourth" value="Log In">
    </form>
    <a href="<%=apiURL%>"><img class="fadeIn fourth" height="50" src="http://static.nid.naver.com/oauth/small_g_in.PNG"/></a>

    <!-- Remind Passowrd -->
    <div id="formFooter">
      <a class="underlineHover" href="./signin.jsp" style="margin-bottom:5px">sign in</a><br>
      <a class="underlineHover" href="#">Forgot Password?</a>
    </div>
  </div>
</div>

</body>
</html>