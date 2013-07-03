var Tradebitcoin = Tradebitcoin || { models: {}, views: {}};

(function ($) {

    Tradebitcoin.views.Map = Backbone.View.extend({

        /**
         * Google map instance
         */
        googleMap: null,

        /**
         * Indicates searched location and/or current user location
         */
        customMarker: null,

        /**
         * New markers loaded only 500ms after user stopped dragging the map
         */
        timeout: false,

        /**
         * View initialization
         */
        initialize: function(options) {
            this.users = new Tradebitcoin.models.Users();
            this.infoWindow = new google.maps.InfoWindow({ maxWidth: 400, content: ''});
            this.setElement(document.getElementById("map_canvas"));
            this._initMap();
            this._initEventListeners();
        },


        _initEventListeners: function() {
            this.users.on("add", function(user) {
                var marker = user.getMarker();
                marker.setMap(this.googleMap);
                google.maps.event.addListener(marker, 'click', $.proxy(function (location) {
                    this.infoWindow.close();
                    this.infoWindow.setContent(marker.infotext);
                    this.infoWindow.setPosition(marker.position);
                    this.infoWindow.open(this.googleMap, marker);
                }, this));
            }, this);

            this.users.on("remove", function(user) {
                user.getMarker().setMap(null);
            }, this);
        },

        _initMap: function() {
            if (typeof this.options.initialLocation === 'undefined') {
                if (Tradebitcoin.user) {
                    this.options.initialLocation = new google.maps.LatLng(Tradebitcoin.user.latitude, Tradebitcoin.user.longitude);
                } else {
                    this.options.initialLocation = new google.maps.LatLng(geoip_latitude(), geoip_longitude());
                }
            }
            this.googleMap = new google.maps.Map(this.el, {
                zoom: 9,
                center:  this.options.initialLocation,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            });

        },

        clear: function() {
            this.users.each(function (user) {
                user.getMarker().setMap(null);
            });
            this.users.reset();
            this.clearCustomMarker();
        },

        setCenter: function(location) {
            this.googleMap.setCenter(location);
        },

        loadUsersForCurrentLocation: function() {
            var center = this.googleMap.getCenter();
            this.users.loadForLocation(center.lat(), center.lng());
        },

        addListener: function(event, callback) {
            google.maps.event.addListener(this.googleMap, event, callback);
        },

        setCustomMarker: function(text, position) {
            this.clearCustomMarker();
            this.customMarker = new google.maps.Marker({
                title: text,
                icon: 'http://www.google.com/intl/en_us/mapfiles/ms/micons/blue-dot.png',
                position: position
            })
            this.customMarker.setMap(this.googleMap);
        },

        clearCustomMarker: function() {
            if (this.customMarker) {
                this.customMarker.setMap(null);
            }
            this.customMarker = null;
        }

    });

})(jQuery);