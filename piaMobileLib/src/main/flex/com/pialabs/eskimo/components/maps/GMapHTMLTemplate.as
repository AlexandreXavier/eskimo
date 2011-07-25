package com.pialabs.eskimo.components.maps
{
  
  /**
  * HTML template for GMap component.
  * @see com.pialabs.eskimo.components.maps.GMap
  */
  public class GMapHTMLTemplate
  {
    public static const HTML_TEMPLATE:XML = <script><![CDATA[
<html>
  <head>
    <meta name='viewport' content='user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0' />
    <meta http-equiv='content-type' content='text/html; charset=UTF-8'/>
    <title>GMAP</title>
    <link href='http://code.google.com/apis/maps/documentation/javascript/examples/default.css' rel='stylesheet' type='text/css' />
    <script type='text/javascript' src='http://maps.google.com/maps/api/js?sensor=false'></script>
    <script type='text/javascript'>
      
      var map;
      var markersArray = [];
      var center = new google.maps.LatLng(48.833679, 2.290113);
      var zoom = 8;
      var markerVisible = true;
      
      function initialize() {
         
        var myOptions = {
          zoom: zoom,
          center: center,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          navigationControlOptions: {
                style: google.maps.NavigationControlStyle.ANDROID
            }
        };
        
        map = new google.maps.Map(document.getElementById('map_canvas'), myOptions);
            
            
        callback('onInitialized');
      }
      
      function callback()
      {
        var argumentsArray = [];
        var _serializeObject = {};
        _serializeObject.method = arguments[ 0 ];
        
        if( arguments.length > 1)
        {
        	for (var i = 1; i < arguments.length; i++)
        	{
        		argumentsArray.push( arguments[ i ] );
        	}
        }
        
        _serializeObject.arguments = argumentsArray;
        
        location.href = 'message://[CallBack]' + JSON.stringify( _serializeObject );
      }
      
      function doCall(jsonArgs)
      {
        var _serializeObject = JSON.parse( jsonArgs );
        var method = _serializeObject.method;
        
        var targetFunction;
        if( method.indexOf('.')==-1)
        {
          targetFunction = window[ method ];
        }
        targetFunction.apply(null, _serializeObject.arguments );
      }
      
      function getInitialized()
      {
      	if(map == null)
      	{
      	  return false;
      	}
      	return true;
      }
      
      function setCenter(lat, lng) {
      	center = new google.maps.LatLng(lat, lng);
      	
      	if(getInitialized())
        {
      		map.setCenter(center);
        }
      }
      
      function setZoom(value) {
        zoom = value;
        
        if(getInitialized())
        {
        	  map.setZoom(value);
        }
      }
      
      
      function addMarker(lat, lng, title, description, showInfoWindow) {
      	var latlng = new google.maps.LatLng(lat, lng);
        marker = new google.maps.Marker({
          position: latlng,
          title: title
        });
        markersArray.push(marker);
        
        if(showInfoWindow)
        {
          addMarkerWindow(marker, title, description);
        }
        
        google.maps.event.addListener(marker, 'click', function() {
          callback( 'onMarkerClicked', marker.getPosition().lat(), marker.getPosition().lng() );
        });
      }
      
      function addMarkerImage(lat, lng, iconURL, iconWidth,iconHeight, anchorX, anchorY, title, description, showInfoWindow) {
        var image = new google.maps.MarkerImage(iconURL,
        // This marker is 20 pixels wide by 32 pixels tall.
        new google.maps.Size(iconWidth, iconHeight),
        // The origin for this image is 0,0.
        new google.maps.Point(0,0),
        // The anchor for this image is the base of the flagpole at 0,32.
        new google.maps.Point(anchorX, anchorY));
        
        
      	var latlng = new google.maps.LatLng(lat, lng);
        marker = new google.maps.Marker({
          position: latlng,
          icon: image,
          title: title
        });
        markersArray.push(marker);
        
        if(description != 'null')
        {
          addMarkerWindow(marker, title, description);
        }
        
        google.maps.event.addListener(marker, 'click', function() {
          callback( 'onMarkerClicked', marker.getPosition().lat(), marker.getPosition().lng() );
        });
      }
      
      function addMarkerWindow(marker, title, description)
      {    
        var infowindow = new google.maps.InfoWindow({
            content: createInfoWindowString(title, description)
        });
          
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.open(map,marker);
        });
      }
      
      // Removes the overlays from the map, but keeps them in the array
      function clearOverlays() {
        if (markersArray) {
          for (i in markersArray) {
            markersArray[i].setMap(null);
          }
        }
        markerVisible = false;
      }
      
      // Shows any overlays currently in the array
      function showOverlays() {
        if (markersArray) {
          for (i in markersArray) {
            markersArray[i].setMap(map);
          }
        }
        markerVisible = true;
      }
      
      // Deletes all markers in the array by removing references to them
      function deleteOverlays() {
        if (markersArray) {
          for (i in markersArray) {
            markersArray[i].setMap(null);
          }
          markersArray.length = 0;
        }
      }
      
      function fitToMarkers() {
        var bounds = new google.maps.LatLngBounds();
        
        if (markersArray) 
        {
          for (i in markersArray) 
          {
              bounds.extend(markersArray[i].getPosition());
          }
        }
        
        map.fitBounds(bounds);
      }
      
      function createInfoWindowString(title, content)
      {
        var contentString = '<div id=\'content\'>'+
          '<h1 id=\'firstHeading\' class=\'firstHeading\'>' + title + '</h1>'+
          '<div id=\'bodyContent\'>'+
          '<p>' + content + '</p>'+
          '</div>'+
          '</div>';
          
        return contentString;
      }
    </script>
  </head>
  <body onload='initialize()'>
    <!--<a id='myLink'>toto</a>-->
    <div id='map_canvas'></div>
  </body>
</html>
]]></script>;
  
  
  
    public function GMapHTMLTemplate()
    {
    }
  }
}
