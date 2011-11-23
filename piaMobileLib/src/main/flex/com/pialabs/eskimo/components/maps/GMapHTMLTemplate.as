/* Copyright (c) 2011, PIA. All rights reserved.
*
* This file is part of Eskimo.
*
* Eskimo is free software: you can redistribute it and/or modify
* it under the terms of the GNU Lesser General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Eskimo is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License
* along with Eskimo.  If not, see <http://www.gnu.org/licenses/>.
*/
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
    <style type="text/css">
      html { height: 100% }
      body { height: 100%; margin: 0; padding: 0 }
      #map_canvas { height: 100% }
    </style>
      
    <script type='text/javascript' src='http://maps.google.com/maps/api/js?sensor=false'></script>
    <script type='text/javascript'>

      var map;
      var markersArray = [];
      var zoom = 8;
      var markerVisible = true;
      var initialized = false;
      
      window.onload=initialize;
      
      
      function initialize() {
        
        var myOptions = {
          zoom: zoom,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          navigationControlOptions: {
            style: google.maps.NavigationControlStyle.ANDROID
          }
        };
        
        map = new google.maps.Map(document.getElementById('map_canvas'), myOptions);
        
        google.maps.event.addListener(map, 'bounds_changed', function() {
          if(initialized == true)
          {
            callback('onBoundsChanged', map.getCenter().lat(), map.getCenter().lng(), map.getZoom());
          }
          else
          {
          }
          initialized = true;
        });
        
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
        
        location.href = 'http://[CallBack]' + btoa( JSON.stringify( _serializeObject ) );
      }
      
      function doCall(jsonArgs)
      {
        var _serializeObject = JSON.parse( atob( jsonArgs ) );
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
      	if(getInitialized())
        {
        	var center = new google.maps.LatLng(lat, lng);
      	
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
      
      function addMarkerWindow(marker, title, description)
      {    
        var infowindow = new google.maps.InfoWindow({
          content: createInfoWindowString(title, description)
        });
        
        google.maps.event.addListener(marker, 'click', function() {
          infowindow.open(map,marker);
        });
      }
      
      function addMarker(lat, lng, title, description, showInfoWindow) {
        
      	var latlng = new google.maps.LatLng(lat, lng);
        var marker = new google.maps.Marker({
          position: latlng,
          title: title
        });
        markersArray.push(marker);
        
        if(showInfoWindow == true)
        {
          addMarkerWindow(marker, title, description);
        }
        google.maps.event.addListener(marker, 'click', function() {
          callback( 'onMarkerClicked', marker.getPosition().lat(), marker.getPosition().lng() );
        });
      
        callback( 'onMarkerAdded' );
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
        var marker = new google.maps.Marker({
          position: latlng,
          icon: image,
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
      
        callback( 'onMarkerAdded' );
      }
      
      // Removes the overlays from the map, but keeps them in the array
      function clearOverlays() {
        if (markersArray != null && markersArray.length > 0) {
          for (i in markersArray) {
            markersArray[i].setMap(null);
          }
        }
        markerVisible = false;
      }
      
      // Shows any overlays currently in the array
      function showOverlays() {
        if (markersArray != null && markersArray.length > 0) {
          for (i in markersArray) {
            markersArray[i].setMap(map);
          }
        }
        markerVisible = true;
      }
      
      // Deletes all markers in the array by removing references to them
      function deleteOverlays() {
        if (markersArray != null && markersArray.length > 0) {
          for (i in markersArray) {
            markersArray[i].setMap(null);
          }
          markersArray.length = 0;
        }
      }
      
      function fitToMarkers() {
        var bounds = new google.maps.LatLngBounds();
        
        if (markersArray != null && markersArray.length > 0) 
        {
          for (i in markersArray) 
          {
              bounds.extend(markersArray[i].getPosition());
          }
        }
        
        map.fitBounds(bounds);
      }
      
    </script>
  </head>
  <body>
    <div id="map_canvas" style="width:100%; height:100%"></div>
  </body>
</html>
]]></script>;
  
  
  
    public function GMapHTMLTemplate()
    {
    }
  }
}
