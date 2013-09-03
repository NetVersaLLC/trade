var Tradebitcoin = Tradebitcoin || { models: {}, views: {}};

(function ($) {

    Tradebitcoin.views.Profile = Backbone.View.extend({

        /**
         * Google Geocoder instance
         */
        geocoder: null,
        user: null,
        map: null,

        initialize: function(options) {
            this.geocoder = new google.maps.Geocoder();
            this.user = options.user;

            /* putting marker with user location on the map */
            var location = this._getLocation();
            if (location) {
                this.map = new Tradebitcoin.views.Map({initialLocation: location});
                this.map.setCustomMarker(this.user.get('name'), location);
            } else {
                this.map = new Tradebitcoin.views.Map();
            }
        },

        _getLocation: function() {

            var latitude = this.user.get('latitude');
            var longitude = this.user.get('longitude');
            if ((latitude == null || latitude.trim() == '')) {
                // location is not set but we can calculate it using address
                var address = this.user.get('address').trim();
                if (address == '') {
                    return false;
                }
                this.geocoder.geocode({ 'address': address}, $.proxy(this._geocoderCallback, this));
                // callback will set correct location later
                return false;
            }
            return new google.maps.LatLng(latitude, longitude);

        },

        _geocoderCallback: function (results, status) {
            if (status == google.maps.GeocoderStatus.OK) {
                var location = results[0].geometry.location;
                this.map.setCustomMarker(this.user.get('name'), location);
                this.map.setCenter(location);
            }
        }


    });

})(jQuery);