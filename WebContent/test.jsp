<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>

<link rel="stylesheet" href="./css/w3school.css">
<link rel="stylesheet" href="./css/my.css">

<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=1">

<script type="text/javascript">

function getgugun(dosi){
	
	var gugun = document.getElementById('gugun');
	
	var xmlhttp = new XMLHttpRequest();
	var method = 'GET';
	var url = './foodproject1/getGugun.do?dosi=' + dosi;

	xmlhttp.open(method, url, true);

	xmlhttp.onload = () => {
		var gugunlist = xmlhttp.response;
		gugunlist = JSON.parse(gugunlist);
		
		gugun.options.length = 1;
		
		for(var i=0; i<gugunlist.length; i++){
			var option = document.createElement('option');
			option.innerText=gugunlist[i];
			gugun.append(option);
		}
	}
	
	xmlhttp.send();
}

function getDosi(area){
	
	var dosi = document.getElementById('dosi')
	
	var xmlhttp = new XMLHttpRequest();
	var method = 'GET';
	var url = './foodproject1/getDosi.do?area=' + area;

	xmlhttp.open(method, url, true);

	xmlhttp.onload = () => {
		var dosilist = xmlhttp.response;
		dosilist = JSON.parse(dosilist);
		
		dosi.options.length = 1;
		
		if(dosi.options.length==1){									// 지역권 바꿀시 구/군도 초기화
			var gugun = document.getElementById('gugun');
			gugun.options.length = 1;
		}
		
		for(var i=0; i<dosilist.length; i++){
			var option = document.createElement('option');
			option.innerText=dosilist[i];
			dosi.append(option);
		}
	}
	
	xmlhttp.send();
}

function creatInfoList(num, name, addr){
	
	
	// ul 태그 생성
	var ul = document.createElement("ul");
	// ul 태그에 id삽입
	ul.setAttribute('id', "uList"+num);
	// ul 태그에 style삽입
	ul.setAttribute('style', "padding-left:6px;color:#000;margin-bottom:0px;border-bottom:1px solid #0040FF;font-size:11px;");
	// 만든 ul태그 삽입
	document.getElementById('info').appendChild(ul);
	
	// li 태그 생성
	var liname = document.createElement("li");
	liname.setAttribute('id', "List"+num);
	liname.setAttribute('style', "font-weight:700;font-size:15px;list-style:none;");
	var liaddr = document.createElement("li");
	liaddr.setAttribute('style', "list-style:none;");
	
	// li태그에 보여질 text 삽입
	var text = document.createTextNode(name);
	liname.appendChild(text);
	text = document.createTextNode(addr);
	liaddr.appendChild(text);
	
	//li태그 삽입
	document.getElementById('uList'+num).appendChild(liname);
	document.getElementById('uList'+num).appendChild(liaddr);
	
}

var total_list = 0;

//현재 커서 번호 = 1
var now_cursor = 1;

// 한 페이지에 보여줄 목록 갯수 = 10
var one_page_num = 10;

// 한 블럭당 보여줄 커서의 갯수 = 5
var one_block_num = 5;

//현재 커서의 블럭 = 올림(커서 번호/한 블럭당 보여줄 커서의 갯수)
var now_block = 0;

// 마지막 커서의 번호 = 올림(목록의 총 갯수/한 페이지에 보여줄 목록 갯수)
var last_cursor_num = 0;

// 마지막 커서의 블럭 번호
var last_block_num = 0;

function Next(){
	
	now_cursor+=one_block_num;
	markerDel();
	setMark();
}

function Prev(){
	
	now_cursor-=one_block_num;
	markerDel();
	setMark();
}

function setCursor(CursorNum) {
	
	now_cursor=Number(CursorNum);
	markerDel();
	setMark();
}

function createCursor() {

	// 페이징 커서 초기화
	var cursor = document.getElementById('cursor');	
	while ( cursor.hasChildNodes() ) {				
		cursor.removeChild( cursor.firstChild );
	}
	
	// 현재 커서의 블럭의 시작 번호
	var start = (now_block - 1) * one_block_num + 1;
	
	// 현재 커서의 블럭의 마지막 번호
	var end = start + one_block_num - 1;
		
	if(now_block==last_block_num) {
		end = last_cursor_num;
	}
	
	var text=null;
	
	if(now_cursor > one_block_num){
		var prev = document.createElement("a");
		prev.setAttribute('id', "prev");
		prev.setAttribute('style', "font-weight:700;font-size:12px;color:#000;float:left;");
		prev.setAttribute('href', "#");
		prev.setAttribute('onclick', "Prev();");
		
		text = document.createTextNode("Prev");
		prev.appendChild(text);
		
		document.getElementById('cursor').appendChild(prev);
	}

	for(var i=start; i<=end; i++){
		var a = document.createElement("a");
		a.setAttribute('id', i);
		a.setAttribute('style', "font-size:12px;color:#000;float:left;");
		a.setAttribute('href', "#");
		a.setAttribute('onclick', "setCursor(this.id)");
		
		text = document.createTextNode(i);
		a.appendChild(text);
		
		document.getElementById('cursor').appendChild(a);
	}

	console.log(now_block);
	console.log(last_block_num);
	if(now_block<last_block_num){
		var next = document.createElement("a");
		next.setAttribute('id', "next");
		next.setAttribute('style', "font-weight:700;font-size:12px;color:#000;float:left;");
		next.setAttribute('href', "#");
		next.setAttribute('onclick', "Next();");
		
		text = document.createTextNode("Next");
		next.appendChild(text);
		
		document.getElementById('cursor').appendChild(next);
	}
}

function setMark() {
	
	var category_length = document.getElementsByName("Category").length;
	var category = null;
	
	// 카테고리 선택
    for (var i=0; i<category_length; i++) {
        if (document.getElementsByName("Category")[i].checked == true) {
            category = document.getElementsByName("Category")[i].value;
        }
    }
    
	var dosi_c = document.getElementById('dosi');
	var gugun_c = document.getElementById('gugun');
	var dosi = dosi_c.options[dosi_c.selectedIndex].value
	var gugun = gugun_c.options[gugun_c.selectedIndex].value;
	var keyword = document.getElementById('keyword').value;
	
	if(gugun!="지역 선택"){
		var xmlhttp = new XMLHttpRequest();
		
		var method = 'GET';
		if(category=='on'){
			var url = './foodproject1/CoordData.do?Dosi='+dosi+'&Gugun='+gugun+'&Keyword='+keyword;
		} else{
			var url = './foodproject1/CoordData.do?Category='+category+'&Dosi='+dosi+'&Gugun='+gugun+'&Keyword='+keyword;
		}
		
		xmlhttp.open(method, url, true);
	
		xmlhttp.onload = () => {
			
			var data = xmlhttp.response;
			
			// 음식점 이름, 좌표 정보 리스트
			data = JSON.parse(data);
			var positions = data.positions;
	 		
	 		// 음식점 목록 초기화 
	 		var info = document.getElementById('info');	
			while ( info.hasChildNodes() ) {				
				info.removeChild( info.firstChild );
			}
			
			// 목록의 총 갯수 = position.length
			var total_list = positions.length;
			
			console.log(total_list);
			
			// 현재 커서의 블럭 = 올림(커서 번호/한 블럭당 보여줄 커서의 갯수)
			now_block = Math.ceil(now_cursor/one_block_num);
			
			last_cursor_num = Math.ceil(total_list/one_page_num);
			
			if(now_cursor>last_cursor_num){
				now_cursor=last_cursor_num;
			}
			
			last_block_num = Math.ceil(last_cursor_num/one_block_num);
			
			// 한 목록 페이지의 시작 번호
			var list_start = now_cursor*one_page_num-one_page_num;

			// 한 목록 페이지의 끝 번호
			var list_end = now_cursor*one_page_num;

			if(now_cursor==last_cursor_num) {
				list_end = list_start+total_list%one_page_num;
			}
			
			createCursor();
			
/* 			var x = 0;
			var y = 0;
			
			for (var i = list_start; i < list_end; i ++) {
				x += Number(positions[i].latlng[0]);
				y += Number(positions[i].latlng[1]);
				console.log(x);
				console.log(y);				
			}
			
			x/=10;
			y/=10;
			
			console.log(x);
			console.log(y);
			
			MapReset(x, y); */
			
			for (var i = list_start; i < list_end; i ++) {
				
				// 음식점 목록 list 생성
				creatInfoList(i, positions[i].name , positions[i].addr);
				
			    // 마커를 생성합니다
			    var marker = new kakao.maps.Marker({
			        map: map, // 마커를 표시할 지도
			        position: new kakao.maps.LatLng(positions[i].latlng[0], positions[i].latlng[1]) /* positions[i].latlng */ // 마커의 위치
			    });
				
			    // 마커에 표시할 인포윈도우를 생성합니다 
			    var infowindow = new kakao.maps.InfoWindow({
			        content: positions[i].content // 인포윈도우에 표시할 내용
			    });
				
			    // 마커에 이벤트를 등록하는 함수 만들고 즉시 호출하여 클로저를 만듭니다
			    // 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
			    (function(marker, infowindow) {
			        // 마커에 mouseover 이벤트를 등록하고 마우스 오버 시 인포윈도우를 표시합니다 
			        kakao.maps.event.addListener(marker, 'mouseover', function() {
			            infowindow.open(map, marker);
			        });
	
			        // 마커에 mouseout 이벤트를 등록하고 마우스 아웃 시 인포윈도우를 닫습니다
			        kakao.maps.event.addListener(marker, 'mouseout', function() {
			            infowindow.close();
			        });
			    })(marker, infowindow);
			    markers.push(marker);
			}
			
		}
		
		xmlhttp.send();
		
	} else { alert("지역을 선택하세요"); }
}

var markers = [];

function markerDel(){
	
	for(var i=0; i<markers.length; i++){
		markers[i].setMap(null);
	}
}

function Search(){
	
	var keyword = document.getElementById('keyword').value;
	
	if (!keyword.replace(/^\s+|\s+$/g, '')) {
        alert('음식점을 입력해주세요!');
        
        return false;
        
    } else {
    	now_cursor=1;
    	markerDel();
    	setMark();
    }
}

function cursorReset() {
	now_cursor=1;
}

/* function MapReset(x, y){
	
	var resetmap = document.getElementById('createMap');	
	while ( resetmap.hasChildNodes() ) {				
		resetmap.removeChild( resetmap.firstChild );
	}
	
   	var div = document.createElement('div');
	div.setAttribute('id', "map");
	div.setAttribute('style', "width:100%;height:100%;position:relative;padding-bottom:0px;margin:0 0 0 250px;");
	document.getElementById('createMap').appendChild(div);
	
	div = document.createElement('div');
	div.setAttribute('id', "sky");
	div.setAttribute('class', "custom_typecontrol radius_border");
	document.getElementById('createMap').appendChild(div);
	
	div = document.createElement('div');
	div.setAttribute('id', "zoomInOut");
	div.setAttribute('class', "custom_zoomcontrol radius_border");
	document.getElementById('createMap').appendChild(div);
	
	var span = document.createElement('span');
	span.setAttribute('id', "btnRoadmap");
	span.setAttribute('class', "selected_btn");
	span.setAttribute('onclick', "setMapType('roadmap')");
	var text = document.createTextNode("지도");
	span.appendChild(text);
	document.getElementById('sky').appendChild(span);
	
	span = document.createElement('span');
	span.setAttribute('id', "btnSkyview");
	span.setAttribute('class', "btn");
	span.setAttribute('onclick', "setMapType('skyview')");
	text = document.createTextNode("스카이뷰");
	span.appendChild(text);
	document.getElementById('sky').appendChild(span);
	
	span = document.createElement('span');
	span.setAttribute('id', "zoomin");
	span.setAttribute('onclick', "zoomIn()");
	document.getElementById('zoomInOut').appendChild(span);
	
	span = document.createElement('span');
	span.setAttribute('id', "zoomout");
	span.setAttribute('onclick', "zoomOut()");
	document.getElementById('zoomInOut').appendChild(span);
	
	var img = document.createElement('img');
	img.setAttribute('src', "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/ico_plus.png");
	img.setAttribute('alt', "확대");
	document.getElementById('zoomin').appendChild(img);
	
	img = document.createElement('img');
	img.setAttribute('src', "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/ico_minus.png");
	img.setAttribute('alt', "축소");
	document.getElementById('zoomout').appendChild(img);
	
	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(y, x),	// 지도의 중심좌표
        level: 12 // 지도의 확대 레벨
    };  

	var map = new kakao.maps.Map(mapContainer, mapOption);			// 지도를 생성합니다
} */
</script>

<meta charset="UTF-8">
<title>MainPage</title>
</head>
<body>

<div class="sidenav">
	<div style="padding:5px 0 8px 10px;font-size:13px;" id="area">
		<select onchange="markerDel(); getDosi(this.value); cursorReset();">
			<option selected>지역 선택</option>
			<c:forEach var="i" items="${Arealist}">
				<option value="${i.area}">${i.area}</option>
			</c:forEach>
		</select>
		<select style="width:120px;" id="dosi" onchange="markerDel(); getgugun(this.value); cursorReset();">
			<option selected>지역 선택</option>
		</select>
		<div style="padding-top:3px;">
			<select style="width:206px;" id="gugun">
			    <option selected>지역 선택</option>
			</select>
		</div>
	</div>
	
	<div style="padding-bottom:5px;">
		<label class="container">선택 안함
			<input type="radio" name="Category" checked>
			<span class="checkmark"></span>
		</label>
		<c:forEach var="i" items="${Categorylist}">
			<label class="container">${i.middleCategory}
			  <input type="radio" name="Category" value="${i.middleCategory}" onclick="cursorReset(); markerDel(); setMark();">
			  <span class="checkmark"></span>
			</label>
		</c:forEach>
	</div>
	<div style="font-size:13px">
	<input style="width:165px;margin-left:5px" type="text" id="keyword" placeholder="음식점 이름" value="">
	<input type="button" id="search" value="검색" onclick="Search();">
	</div>
	
	<hr style="margin:5px 0 0 0;padding-top:1px;width:100%;background-color:black;">
	
	<div style="background:rgba(255, 255, 255, 0.7);height:45%;width:100%;overflow-y:auto;">
		<div id="info"></div>
		<div style="display:flex;justify-content:center" id="cursor"></div>
	</div>
</div>
<div class="main">
	<nav class="navbar navbar-expand-sm bg-primary navbar-dark" >
		<div class="collapse navbar-collapse" id="navb" >
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active"><a class="nav-link"
					href="javascript:void(0)">LOGO</a></li>
				<li class="nav-item"><a class="nav-link"
					href="javascript:void(0)">Link</a></li>
				<li class="nav-item"><a class="nav-link"
					href="javascript:void(0)">Link</a></li>
				<li class="nav-item"><a class="nav-link"
					href="javascript:void(0)">Link</a></li>
			</ul>
			<button class="btn btn-info my-2 my-sm-0" style="margin-right: 10px;" type="button" onclick="location.href='./login.do'">Login</button>
		</div>
	</nav>
	
</div>
<div class="map_wrap" id="createMap">
   	<div id="map" style="width:100%;height:100%;position:relative;padding-bottom:0px;margin:0 0 0 250px;"></div> 
  	<!-- 지도타입 컨트롤 div 입니다 -->
   	<div class="custom_typecontrol radius_border" id="sky">
       	<span id="btnRoadmap" class="selected_btn" onclick="setMapType('roadmap')">지도</span>
       	<span id="btnSkyview" class="btn" onclick="setMapType('skyview')">스카이뷰</span>
   	</div>
   	<!-- 지도 확대, 축소 컨트롤 div 입니다 -->
   	<div class="custom_zoomcontrol radius_border" id="zoomInOut"> 
       	<span onclick="zoomIn()"><img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/ico_plus.png" alt="확대"></span>  
       	<span onclick="zoomOut()"><img src="https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/ico_minus.png" alt="축소"></span>
   	</div>
</div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=cafa0034a11c64a52e5363b255eef269"></script>

<script>
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new kakao.maps.LatLng(36.050701, 129.070667),	// 지도의 중심좌표
        level: 13 // 지도의 확대 레벨
    };  

var map = new kakao.maps.Map(mapContainer, mapOption);			// 지도를 생성합니다
    
// 지도타입 컨트롤의 지도 또는 스카이뷰 버튼을 클릭하면 호출되어 지도타입을 바꾸는 함수입니다
function setMapType(maptype) { 
    var roadmapControl = document.getElementById('btnRoadmap');
    var skyviewControl = document.getElementById('btnSkyview'); 
    if (maptype === 'roadmap') {
        map.setMapTypeId(kakao.maps.MapTypeId.ROADMAP);    
        roadmapControl.className = 'selected_btn';
        skyviewControl.className = 'btn';
    } else {
        map.setMapTypeId(kakao.maps.MapTypeId.HYBRID);    
        skyviewControl.className = 'selected_btn';
        roadmapControl.className = 'btn';
    }
}

// 지도 확대, 축소 컨트롤에서 확대 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
function zoomIn() {
    map.setLevel(map.getLevel() - 1);
}

// 지도 확대, 축소 컨트롤에서 축소 버튼을 누르면 호출되어 지도를 확대하는 함수입니다
function zoomOut() {
    map.setLevel(map.getLevel() + 1);
}

</script>


</body>
</html>