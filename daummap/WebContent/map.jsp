<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

    <title>마커 클러스터러에 클릭이벤트 추가하기</title>
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>   
</head>
    <style>
.overlaybox {position:relative;width:360px;height:350px;background:url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/box_movie.png') no-repeat;padding:15px 10px;}
.overlaybox div, ul {overflow:hidden;margin:0;padding:0;}
.overlaybox li {list-style: none;}
.overlaybox .boxtitle {color:#fff;font-size:16px;font-weight:bold;background: url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/overlay_close.png') no-repeat right 120px center;margin-bottom:8px;}
.overlaybox .first {position:relative;width:247px;height:136px;background: url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/thumb.png') no-repeat;margin-bottom:8px;}
.first .text {color:#fff;font-weight:bold;}
.first .triangle {position:absolute;width:48px;height:48px;top:0;left:0;background: url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/triangle.png') no-repeat; padding:6px;font-size:18px;}
.first .movietitle {position:absolute;width:100%;bottom:0;background:rgba(0,0,0,0.4);padding:7px 15px;font-size:14px;}
.overlaybox ul {width:247px;}
.overlaybox li {position:relative;margin-bottom:2px;background:#2b2d36;padding:5px 10px;color:#aaabaf;line-height: 1;}
.overlaybox li span {display:inline-block;}
.overlaybox li .number {font-size:16px;font-weight:bold;}
.overlaybox li .title {font-size:13px;}
.overlaybox ul .arrow {position:absolute;margin-top:8px;right:25px;width:5px;height:3px;background:url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/updown.png') no-repeat;} 
.overlaybox li .up {background-position:0 -40px;}
.overlaybox li .down {background-position:0 -60px;}
.overlaybox li .count {position:absolute;margin-top:5px;right:15px;font-size:10px;}
.overlaybox li:hover {color:#fff;background:#d24545;}
.overlaybox li:hover .up {background-position:0 0px;}
.overlaybox li:hover .down {background-position:0 -20px;}   
.wrap {position: absolute;left: 0;bottom: 40px;width: 288px;height: 132px;margin-left: -144px;text-align: left;overflow: hidden;font-size: 12px;font-family: 'Malgun Gothic', dotum, '돋움', sans-serif;line-height: 1.5;}
    .wrap * {padding: 0;margin: 0;}
    .wrap .info {width: 286px;height: 120px;border-radius: 5px;border-bottom: 2px solid #ccc;border-right: 1px solid #ccc;overflow: hidden;background: #fff;}
    .wrap .info:nth-child(1) {border: 0;box-shadow: 0px 1px 2px #888;}
    .info .title {padding: 5px 0 0 10px;height: 30px;background: #eee;border-bottom: 1px solid #ddd;font-size: 18px;font-weight: bold;}
    .info .close {position: absolute;top: 10px;right: 10px;color: #888;width: 17px;height: 17px;background: url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/overlay_close.png');}
    .info .close:hover {cursor: pointer;}
    .info .body {position: relative;overflow: hidden;}
    .info .desc {position: relative;margin: 13px 0 0 90px;height: 75px;}
    .desc .ellipsis {overflow: hidden;text-overflow: ellipsis;white-space: nowrap;}
    .desc .jibun {font-size: 11px;color: #888;margin-top: -2px;}
    .info .img {position: absolute;top: 6px;left: 5px;width: 73px;height: 71px;border: 1px solid #ddd;color: #888;overflow: hidden;}
    .info:after {content: '';position: absolute;margin-left: -12px;left: 50%;bottom: 0;width: 22px;height: 12px;background: url('http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/vertex_white.png')}
    .info .link {color: #5085BB;}
</style>
<body>

<div id="map" style="width:100%;height:850px;"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=0bb1cb38fd36490239710319b9bbb201&libraries=clusterer"></script>
<script>
	var _cluster = {}
	_cluster.markers = [];
	_cluster.overlay = [];
	_cluster.marker = [];
	_cluster.markerItemNos = [];
	_cluster.images = {};
	
// 오버레이 클리어
	_cluster.overlay.clear = function() {
		if (_cluster.overlay.length > 0) {
			for (var index = 0; index < _cluster.overlay.length; index++) {
				_cluster.overlay[index].setMap(null);
			}
		}
	};

// 마커 클리어
	_cluster.marker.clear = function() {
		if (_cluster.marker.length > 0) {
			for (var index = 0; index < _cluster.marker.length; index++) {
				_cluster.marker[index].setMap(null);
			}
		}
	};

// 지도 위 클리어
	_cluster.clear = function() {
		if (_cluster.overlay)
			_cluster.overlay.clear();
		
		if (_cluster.marker)
			_cluster.marker.clear();
		
		if (_cluster.markers)
			_cluster.markers.clear();
}

// n개의 마커를 생성한다.
	var markers = $(map/chicken.json).map(function(i, item) {
		var content = '<div class="wrap">' + 
        '    <div class="info">' + 
        '        <div class="title">' + 
        '            카카오 스페이스닷원' + 
        '            <div class="close" onclick="closeOverlay()" title="닫기"></div>' + 
        '        </div>' + 
        '        <div class="body">' + 
        '            <div class="img">' +
        '                <img src="http://cfile181.uf.daum.net/image/250649365602043421936D" width="73" height="70">' +
        '           </div>' + 
        '            <div class="desc">' + 
        '                <div class="ellipsis">제주특별자치도 제주시 첨단로 242</div>' + 
        '                <div class="jibun ellipsis">(우) 63309 (지번) 영평동 2181</div>' + 
        '                <div><a href="http://www.kakaocorp.com/main" target="_blank" class="link">홈페이지</a></div>' + 
        '            </div>' + 
        '        </div>' + 
        '    </div>' +    
        '</div>';
        
        var marker = new daum.maps.Marker({
        	position: new daum.maps.LatLng(item.lat, item.lng),
        	image: new daum.maps.MarkerImage(imageSrc, imageSize, imageOption),
        	clickable: true,
        	
        });
        
// 마커에 클릭이벤트를 등록합니다.        
        daum.maps.event.addListener(marker, 'click', function(){
        	if (_cluster.overlay.length > 0)
        		_cluster.overlay.clear();
        	
        	// 커스텀 오버레이를 생성합니다
        	var customOverlay = new daum.maps.CustomOverlay({
        		map: map,
        		postion: marker.getPosition(),
        		content: content,
        		yAnchor: 0.5,
        		xAnchor: 0.5,
        		zIndex: 3
        	});
        	customOverlay.setMap(map);
        	_cluster.overlay.push(customOverlay);
        });
        
        return marker;
	})

// 클러스터에 클릭이벤트를 등록합니다
	daum.maps.event.addListener(_cluster.markers, 'clusterclick',function(cluster) {
		_cluster.markerItemNos = [];
		
		$.each(cluster.getMarkers(), function (index, item) {
			_cluster.markerItemNos.push(item.getTitle());
		});
		
	});





</script>
</body>
</html>