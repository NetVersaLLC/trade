// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var infowindow = null;
var map = null;
var latitude = null;
var longitude = null;
var address = null;
var city = null;
var country = null;
var loc = null;
var dat = null;
var markersArray = [];

function addMarker(lat, lon, title) {
  loc = new google.maps.LatLng(lat, lon)
  var marker = new google.maps.Marker({
    position: loc,
    map: map,
    animation: google.maps.Animation.DROP,
    title: title
  });
  markersArray.push(marker);
  return marker;
}

function clearOverlays() {
  if (markersArray) {
    for (i in markersArray) {
      markersArray[i].setMap(null);
    }
  }
}

// Shows any overlays currently in the array
function showOverlays() {
  if (markersArray) {
    for (i in markersArray) {
      markersArray[i].setMap(map);
    }
  }
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

function isSet(v) {
  if (v != null && $.trim(v) != '') {
    return true;
  } else {
    return false;
  }
}

function searchIt() {
  var address = document.getElementById('search').value;
  if (address != null && $.trim(address) != '' && address != 'Search by address...') {
    deleteOverlays();
    codeAddress(address, showResults);
  }
  return false;
}

var xpq = null;
function showResults() {
  $.getJSON('/users.js?la='+latitude+'&lo='+longitude, function (data) {
    dat = data;
    $.each(data, function (i,user) {
      $(function () {
        var marker = addMarker(user['latitude'], user['longitude'], user['name']);
        var info ='<div class="stack"><img src="http://www.gravatar.com/avatar/'+user['gravatar']+'" alt="Gravatar" class="gravatar" />';
        info += '<h3 class="boxContent">'+user['name']+'</h3></div>';
        if (isSet(user['address'])) {
          info += '<div class="boxContent stack">Address: '+user['address']+'</div>';
        }
        if (isSet(user['phone'])) {
          info += '<div class="boxContent stack">Phone: <a href="callto:'+user['phone']+'"><b>'+user['phone']+'</b></a></div>';
        }
        info += '<div class="stack">';
        if (isSet(user['aim'])) {
          info += '<a href="aim:goim?screenname='+user['aim']+'&message=Bitcoin+trade."><img src="/assets/aol_64.png" alt="AOL Instant Messenger" title="AIM User: '+user['aim']+'" class="icon" /></a>';
        }
        if (isSet(user['skype'])) {
          info += '<a href="skype:'+user['skype']+'?call"><img src="/assets/skype_icon_64x64.png" alt="Skype" title="Skype User: '+user['skype']+'" class="icon" /></a>';
        }
        if (isSet(user['yim'])) {
          info += '<a href="ymsgr:sendIM?'+user['yim']+'"><img src="/assets/yahoo_64.png" alt="Yahoo Address" title="YIM: '+user['yim']+'" class="icon" /></a>';
        }
        if (isSet(user['jabber'])) {
          info += '<a href="xmpp:'+user['jabber']+'?message"><img src="/assets/jabber_icon_64x64.png" title="Jabber: '+user['jabber']+'" alt="Jabber" /></a>';
        }
        info += '</div>';
        marker.infotext = info;
        google.maps.event.addListener(marker, 'click', function(latLng) {
          xpq = marker;
          infowindow.close();
          infowindow.setContent(marker.infotext);
          infowindow.setPosition(marker.location);
          infowindow.open(map,marker);
         });
      });
    });
  });
  return false;
}

function whereami() {
  if ($('#user_latitude').val() == null || $('#user_latitude').val() == '') {
    longitude = geoip_longitude();
    latitude  = geoip_latitude();
    city      = geoip_city();
    country   = geoip_country_name();
  } else {
    longitude = $('#user_longitude').val();
    latitude  = $('#user_latitude').val();
  }
}

function initialize() {
  geocoder = new google.maps.Geocoder();
  var myLatlng = new google.maps.LatLng(latitude, longitude);
  var myOptions = {
    zoom: 9,
    center: myLatlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
  infowindow = new google.maps.InfoWindow({
    maxWidth: 400,
    content: ''
  });
}

function userAddress() {
  return $('#user_address').val();
}

function codeAddress(address, callback) {
  if ($.trim(address) == '') {
    return false;
  }
  geocoder.geocode( { 'address': address}, function(results, status) {
      if (status == google.maps.GeocoderStatus.OK) {
        map.setCenter(results[0].geometry.location);
        loca = results[0].geometry.location;
        latitude = loca.lat();
        longitude = loca.lng();
        var marker = new google.maps.Marker({
          map: map,
          title: "Search Center",
          icon: 'http://www.google.com/intl/en_us/mapfiles/ms/micons/blue-dot.png',
          position: results[0].geometry.location
        });
        if (callback != null) {
          callback();
        }
      } else {
        $('#status').html("<h1>Error</h1><p>Geocode was not successful for the following reason: " + status + '</p>');
      }
  });
}
function showUpdate() {

}
function success(event, data, status, xhr) {
  $("#status").html('<h1 style="color: green">Profile Updated</h1>');
}
function failure(event, xhr, status, error) {
  html = '<h1 style="color: red">Error</h1>';
  html += '<p>'+xhr.responseText+'</p>';
  $("#status").html(html);
}
function gotLocation() {
  // Success, now submit the form
  $('#user_latitude').val( latitude );
  $('#user_longitude').val( longitude );
  if (marker != null) {
    marker.setMap(null);
    marker = addMarker(latitude, longitude, "My Location");
  }
  try {
  $("form.edit_user").submit();
  } catch (e) {

  }
}
function trySubmit() {
  newAddress = $.trim($('#user_address').val());
  if (newAddress == '') {
    html = '<h1 style="color: red">Error</h1>';
    html += '<p>Address field cannot be empty.</p>';
    $("#status").html(html);
  } else {
    // Geocode the address
    codeAddress(newAddress, gotLocation);
    address = newAddress;
    // gotLocation();
  }
}

$(document).ready(function(){
  $('#go').click(function(){
    searchIt();
  });
  $('#search').on('keyup', function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if (code == 13) {
      searchIt();
    }
  });
});
