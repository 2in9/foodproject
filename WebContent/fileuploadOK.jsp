<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String path = application.getRealPath("/files/");
	int FileSize = 1024 * 1024 * 5;
	String fileName = "";
	String realFileName = "";
	String encoding = "UTF-8";
	try{
		MultipartRequest multi = new MultipartRequest(request, path, FileSize, encoding, new DefaultFileRenamePolicy());
		
		fileName = multi.getOriginalFileName("file");
		realFileName = multi.getFilesystemName("file");
	}catch (Exception e) {
		e.printStackTrace();
	}
%>
</body>
</html>