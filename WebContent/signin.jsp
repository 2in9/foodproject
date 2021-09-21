<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.util.Calendar" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
<link rel="stylesheet" href="./css/login.css">
<link href="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
<script src="//maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>

<script type="text/javascript">

var pattern1 = /[0-9]/;
var pattern2 = /[a-zA-Z]/;
var pattern3 = /[~!@\#$%<>^&*]/;
var id_check = false;
var	pw_check = false;

function idCheck() {
	
	id_check = false;
	
	TagReset("id_ck");
	
	var id = document.getElementById('id').value;
	
	var xmlhttp = new XMLHttpRequest();
	
	var method = 'POST';
	
	var url = "./foodproject1/idCheck.do";

	xmlhttp.open('POST', url, true);
	xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlhttp.onload = () => {
		var ckId = xmlhttp.response;
		var check = document.createElement("a");
		var text = '';
		
		var msg = '';
		if(!pattern1.test(id)||!pattern2.test(id)||id.length<5){
			msg = "사용할 수 없는 아이디입니다.";
		} else if(ckId == 'true'){
			msg = "사용 가능한 아이디 입니다.";
			id_check = true;
		} else{
			msg = "중복된 아이디가 있습니다.";
		}
		text = document.createTextNode(msg);
		check.appendChild(text);
		
		document.getElementById('id_ck').appendChild(check);
	}
	
	xmlhttp.send("id="+id);
}

function PwCheck(){
	
	pw_check = false;
	
	TagReset("pw_ck")
	
	var pw = document.getElementById('password').value;
	var pw_ck = document.getElementById('password_ck').value;
	var id = document.getElementById('id').value;
	
	var check = document.createElement("a");
	check.setAttribute("style", "float:right;margin:0 20px;")
	
	var msg='';
	if(pw.length==0){
		msg = "비밀번호를 입력해주세요.";
	} else if(pw != pw_ck){
		msg = "비밀번호가 일치하지 않습니다.";
	} else if(!pattern1.test(pw)||!pattern2.test(pw)||!pattern3.test(pw)||pw.length<10){
		msg = "영문, 숫자, 특수문자 10자리 이상으로 구성하여야 합니다.";
	} else if(pw.indexOf(id) > -1 && id!='') {
        msg = "비밀번호는 ID를 포함할 수 없습니다.";
    } else {
    	msg = "비밀번호가 일치합니다."
    	pw_check = true;
    }
	
	var text = document.createTextNode(msg);
	
	check.appendChild(text);
	
	document.getElementById('pw_ck').appendChild(check);
	
}

function setDate() {	
	var year = document.getElementById('year');
	year = year.options[year.selectedIndex].value;
	
	var month = document.getElementById('month');
	month = month.options[month.selectedIndex].value;
	
	var day = document.getElementById('day');
	day.options.length = 1
	
	var day=31;
	if(	month=='2'	||
		month=='3'	||
		month=='6'	||
		month=='9'	||
		month=='11' ){
		
		var day=30;
		if(month=='2'){
			day=28;
			if(0==Number(year)%4){
				day=29;
			}
		}
	}
	
	var text = '';
	for(var i=1; i<=day; i++){
		var option = document.createElement("option");
		option.setAttribute('value', i);
		text = document.createTextNode(i);
		option.appendChild(text);
		
		document.getElementById('day').appendChild(option);
	}
}

function formCheck() {
	
	var name = document.getElementById('name').value;
	var addr = document.getElementById('addr').value;
	var year = document.getElementById('year');
	year = year.options[year.selectedIndex].value;
	var month = document.getElementById('month');
	month = month.options[month.selectedIndex].value;
	var day = document.getElementById('day');
	day = day.options[day.selectedIndex].value;
	var gender = document.getElementById('gender').value;
	
	if(	name.length		== 0||
		addr.length		== 0||
		year			== "선택"||
		month			== "선택"||
		day				== "선택"||
		gender			== "선택"){
		
		alert("항목을 모두 채워주세요.");
		
		return false;
	}
	
	if(id_check == false || pw_check == false){
		var msg='';
		if(id_check==pw_check){
			msg = "아이디와 비밀번호를 확인해주세요."
		} else if(id_check == false) {
			msg = "아이디 중복확인을 해야합니다.";
		} else {
			msg = "비밀번호 형식이 맞지 않습니다.";
		}
		
		alert(msg);
		
		return false;
	}
	
}

function TagReset(id) {
	
	var tag = document.getElementById(id);	
	while ( tag.hasChildNodes() ) {				
		tag.removeChild( tag.firstChild );
	}
}
</script>
</head>
<body>  
<div class="wrapper fadeInDown">
  	<div id="formContent">

		<div class="fadeIn first">
     		<h2 style="color:#00BFFF">Sign in</h2>
    	</div>
		<form onsubmit="return formCheck()" action="./signin_ok.do" method="GET" >
		   	<input type="text" id="name" name="name" class="fadeIn second" placeholder="Name">
		   	<input type="text" id="id" name="id" class="fadeIn second" placeholder="I D(영문, 숫자 포함  5글자 이상)" onkeyup="PwCheck()">
		   	<div style="float:left;">
		   		<input style="margin-left:35px;padding:10px 30px;" type="button" class="fadeIn fourth" value="중복 확인" onclick="idCheck()">
		   	</div>
		   	<div style="margin-top:15px;font-size:15px;float:left;" id="id_ck"></div>
		   	
		   	<input type="password" id="password" name="pw" class="fadeIn third" onkeyup="PwCheck()" placeholder="Password(영문, 특수문자 , 숫자 포함 10글자 이상)">
		   	<input type="password" id="password_ck" class="fadeIn third" onkeyup="PwCheck()" placeholder="Password 확인">
		   	<div style="font-size:15px;" id="pw_ck" class="fadeIn third">
		   		<a style="float:right;margin:0 20px;">비밀번호를 입력해주세요.</a>
		   	</div>
		   	
		   	<div style="height:25px;width:30px;color:#fff"></div>
		   	
		   	<input type="text" id="addr" name="addr" class="fadeIn third" value="" placeholder="주소"><br>
		   	
		   	<!-- 생년월일-->
		   	<div class="fadeIn third" style="float:left;margin-left:33px;font-size:14px;">
		    	<%
		    	Calendar cal = Calendar.getInstance();
		    	%>
		    	생년월일 : 
		    	<select id="year" name="year">
		    		<option selected>선택</option>
					<%for(int i=0; i<130; i++){ %>
					<option value="<%=cal.get(Calendar.YEAR)-i%>">
						<%=cal.get(Calendar.YEAR)-i%>
					</option>
					<%} %>
				</select> 년&nbsp;
				<select id="month" name="month" onchange="setDate();"> 
					<option selected>선택</option>
					<%for(int i=12; i>=1; i--){ %>
					<option value="<%=i%>">
						<%=i%>
					</option>
					<%} %>
				</select> 월&nbsp;
				<select id="day" name="day">
					<option selected>선택</option>
					<%for(int i=1; i<=31; i++){ %>
					<option value="<%=i%>">
						<%=i%>
					</option>
					<%} %>
				</select> 일
			</div><br>
			
			<div class="fadeIn third" style="float:left;margin-left:33px;font-size:14px;">
		    	성별 : 
		    	<select id="gender" name="gender">
					<option selected>선택</option>
					<option value='m'>남자</option>
					<option value='w'>여자</option>
				</select>
			</div><br>
		   	
		   	<input type="submit" class="fadeIn fourth" value="sign In" style="float:left;margin-left:33px;">
	  	</form>
  	</div>
</div>

</body>
</html>