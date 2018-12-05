<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>다각형에 이벤트 등록하기2</title>
    <style>
.area {
    position: absolute;
    background: #fff;
    border: 1px solid #888;
    border-radius: 3px;
    font-size: 12px;
    top: -5px;
    left: 15px;
    padding:2px;
} 

.info {
    font-size: 12px;
    padding: 5px;
}
.info .title {
    font-weight: bold;
}
</style>
</head>
<body>
<div id="map" style="width:100%;height:800px;"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0bb1cb38fd36490239710319b9bbb201"></script>
<script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
<script type="text/javascript">
// 지도에 폴리곤으로 표시할 영역데이터 배열입니다 
//행정구역 구분
var hole = [
    new daum.maps.LatLng(35.25870397600168, 126.7602893648317),
    new daum.maps.LatLng(35.25336749055866, 126.76370514919934),
    new daum.maps.LatLng(35.237086744385294, 126.75384980993594),
    new daum.maps.LatLng(35.2305749616062, 126.77536336904191),
    new daum.maps.LatLng(35.219798618848834, 126.79527046479062),
    new daum.maps.LatLng(35.219308075490204, 126.80622442693267),
    new daum.maps.LatLng(35.22838068097033, 126.83326454787166),
    new daum.maps.LatLng(35.240542126953436, 126.86023016689731),
    new daum.maps.LatLng(35.25005775748653, 126.87420883490995),
    new daum.maps.LatLng(35.24622186376321, 126.88632123960271),
    new daum.maps.LatLng(35.258242297147476, 126.90546612641126),
    new daum.maps.LatLng(35.250810280238255, 126.93125022176527),
    new daum.maps.LatLng(35.24065233751953, 126.93228483977386),
    new daum.maps.LatLng(35.22459112466017, 126.95184100162544),
    new daum.maps.LatLng(35.210587383944805, 126.9541268423971),
    new daum.maps.LatLng(35.20025817337315, 126.96450583100557),
    new daum.maps.LatLng(35.19050677715076, 126.95954618225724),
    new daum.maps.LatLng(35.18495238835343, 126.97212053398628),
    new daum.maps.LatLng(35.18881609408241, 126.99996890795069),
    new daum.maps.LatLng(35.17135964365156, 127.02227522372881),
    new daum.maps.LatLng(35.15549108580762, 127.00819000018984),
    new daum.maps.LatLng(35.127816211861905, 127.01183208720728),
    new daum.maps.LatLng(35.11405020295629, 126.99993185318249),
    new daum.maps.LatLng(35.10594532938534, 126.98635174542797),
    new daum.maps.LatLng(35.094987581610596, 126.98895069186884),
    new daum.maps.LatLng(35.087330690708214, 126.96304572560393),
    new daum.maps.LatLng(35.07484269163966, 126.95498651341448),
    new daum.maps.LatLng(35.07448168772764, 126.9359950127323),
    new daum.maps.LatLng(35.09168622515253, 126.92057624598804),
    new daum.maps.LatLng(35.08139050688823, 126.90453184391184),
    new daum.maps.LatLng(35.08159026824981, 126.88540282228499),
    new daum.maps.LatLng(35.07433782555615, 126.87167669963911 ),
    new daum.maps.LatLng(35.078359530473655, 126.85560924868967),
    new daum.maps.LatLng(35.06538123210497, 126.84397733255982),
    new daum.maps.LatLng(35.05237098474544, 126.80367730727927),
    new daum.maps.LatLng(35.06048816233756, 126.79156751964838),
    new daum.maps.LatLng(35.052803030606924, 126.7761033468128),
    new daum.maps.LatLng(35.06436185467372, 126.76510877384437),
    new daum.maps.LatLng(35.07268178401153, 126.77054431455787),
    new daum.maps.LatLng(35.09103305417451, 126.76187234958354),
    new daum.maps.LatLng(35.108227104512366, 126.73643742682233),
    new daum.maps.LatLng(35.10843711321382, 126.68510238383968),
    new daum.maps.LatLng(35.11328365538142, 126.65705889544111),
    new daum.maps.LatLng(35.120411856203084, 126.65165860824834),
    new daum.maps.LatLng(35.16661598258578, 126.65707845491326),
    new daum.maps.LatLng(35.169517507189376, 126.67042955076289),
    new daum.maps.LatLng(35.19226266320256, 126.65907088510308),
    new daum.maps.LatLng(35.19449167906539, 126.66960256055565),
    new daum.maps.LatLng(35.21521282130058, 126.68712233671978),
    new daum.maps.LatLng(35.20756444395869, 126.70255613945079),
    new daum.maps.LatLng(35.21238966196838, 126.71769487049146),
    new daum.maps.LatLng(35.221798690116685, 126.71847734430621),
    new daum.maps.LatLng(35.25076259421867, 126.73630100004037),
    new daum.maps.LatLng(35.25870397600168, 126.7602893648317)
]; // 전남에서 구멍낼 광주좌표

$.getJSON("js/map1.geojson", function(geojson) {
 
    var data = geojson.features;
    var coordinates = [];    //좌표 저장할 배열
    var name = "";            //행정 구 이름
 
    $.each(data, function(index, val) {
 
        coordinates = val.geometry.coordinates;
        name = val.properties.CTP_KOR_NM;
        
        if(val.geometry.type == "MultiPolygon"){
		    $.each(coordinates, function(index2, val2) {
		    	displayArea(val2, name);
		    }); 
        } else{
	    	displayArea(coordinates, name);        	
        }
 		
    })
})
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = { 
        center: new daum.maps.LatLng(37.566826, 126.9786567), // 지도의 중심좌표
        level: 13 // 지도의 확대 레벨
    }; 

var map = new daum.maps.Map(mapContainer, mapOption),
    customOverlay = new daum.maps.CustomOverlay({}),
    infowindow = new daum.maps.InfoWindow({removable: true});


var polygons=[];    

// 다각형을 생상하고 이벤트를 등록하는 함수입니다
function displayArea(coordinates, name) {

    var path = [];            //폴리곤 그려줄 path
    var points = [];        //중심좌표 구하기 위한 지역구 좌표들
    
    $.each(coordinates[0], function(index, coordinate) {        //console.log(coordinates)를 확인해보면 보면 [0]번째에 배열이 주로 저장이 됨.  그래서 [0]번째 배열에서 꺼내줌.
        var point = new Object(); 
        point.x = coordinate[1];
        point.y = coordinate[0];
        points.push(point);
        path.push(new daum.maps.LatLng(coordinate[1], coordinate[0]));            //new daum.maps.LatLng가 없으면 인식을 못해서 path 배열에 추가
    })
	
	
	
    // 다각형을 생성합니다 
    if (name =="전라남도"){
    	var polygon = new daum.maps.Polygon({
            map: map, // 다각형을 표시할 지도 객체
            path: [path, hole], 
            strokeWeight: 2,
            strokeColor: '#004c80',
            strokeOpacity: 0.8,
            fillColor: '#fff',
            fillOpacity: 0.7 
        });
        
    } else {
	    var polygon = new daum.maps.Polygon({
	        map: map, // 다각형을 표시할 지도 객체
	        path: path, 
	        strokeWeight: 2,
	        strokeColor: '#004c80',
	        strokeOpacity: 0.8,
	        fillColor: '#fff',
	        fillOpacity: 0.7 
	    });
    }
    
    // 다각형에 mouseover 이벤트를 등록하고 이벤트가 발생하면 폴리곤의 채움색을 변경합니다 
    // 지역명을 표시하는 커스텀오버레이를 지도위에 표시합니다
    daum.maps.event.addListener(polygon, 'mouseover', function(mouseEvent) {
        polygon.setOptions({fillColor: '#09f'});

        customOverlay.setContent('<div class="area">' + name + '</div>');
        
        customOverlay.setPosition(mouseEvent.latLng); 
        customOverlay.setMap(map);
    });
    
    // 다각형에 mousemove 이벤트를 등록하고 이벤트가 발생하면 커스텀 오버레이의 위치를 변경합니다 
    daum.maps.event.addListener(polygon, 'mousemove', function(mouseEvent) {
        
        customOverlay.setPosition(mouseEvent.latLng); 
    });

    // 다각형에 mouseout 이벤트를 등록하고 이벤트가 발생하면 폴리곤의 채움색을 원래색으로 변경합니다
    // 커스텀 오버레이를 지도에서 제거합니다 
    daum.maps.event.addListener(polygon, 'mouseout', function() {
        polygon.setOptions({fillColor: '#fff'});
        customOverlay.setMap(null);
    }); 

    // 다각형에 click 이벤트를 등록하고 이벤트가 발생하면 다각형의 이름과 면적을 인포윈도우에 표시합니다 
    daum.maps.event.addListener(polygon, 'click', function(mouseEvent) {
        var content = '<div class="info">' + 
                    '   <div class="title">' + name + '</div>' +
                    '   <div class="size">총 면적 : 약 ' + Math.floor(polygon.getArea()) + ' m<sup>2</sup></area>' +
                    '</div>';

        infowindow.setContent(content); 
        infowindow.setPosition(mouseEvent.latLng); 
        infowindow.setMap(map);
    });
}
</script>
</body>
</html>