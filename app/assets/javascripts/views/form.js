var Tradebitcoin = Tradebitcoin || { models: {}, views: {}};

(function ($) {

    Tradebitcoin.views.Form = Backbone.View.extend({

        /**
         * Google Geocoder instance
         */
        geocoder: null,

        initialize: function(options) {
            this.geocoder = new google.maps.Geocoder();
            this.setElement($('form').get());
            this._bindEvents();

            // initial values. Google's geocoder is not used
            if ($.trim($('#user_address').val()) == '') {
                var city = geoip_city();
                $('#user_address').val( (city.length ? city + ', ' : '') + geoip_country_name());
                $('#user_latitude').val(geoip_latitude());
                $('#user_longitude').val(geoip_longitude());
            }

            /* at this point we are sure that most precise address is filled */

            if ($('#user_latitude').val() == null || $('#user_latitude').val() == '') {
                /* loaction was not set - calculating with google's geocoder */
                this._codeAddress();
            } else {
                /* location was set - just showing the map */
                var location = new google.maps.LatLng($('#user_latitude').val(), $('#user_longitude').val());
                this.map = new Tradebitcoin.views.Map({initialLocation: location});
                this.map.setCustomMarker("My Location", location);
            }

        },

        _bindEvents: function() {
            this.$el.bind('ajax:success', this.success).bind('ajax:failure', this.failure);
            this.$el.find("button").click($.proxy(this.submit, this));
            $("#user_address").change($.proxy(this._onAddressChange, this));
        },

        _onAddressChange: function() {
            this._codeAddress();
        },

        _codeAddress: function(callback) {
            var address = $('#user_address').val().trim();
            if (address == '') {
                return false;
            }
            this.geocoder.geocode({ 'address': address}, $.proxy(function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    var location = results[0].geometry.location;
                    if (!this.map) {
                        this.map = new Tradebitcoin.views.Map({initialLocation: location});
                    }
                    this.map.setCustomMarker("My Location", location);
                    this.map.setCenter(location);
                    $("#user_latitude").val(location.lat());
                    $("#user_longitude").val(location.lng());
                    if (callback != null) {
                        callback();
                    }
                } else {
                    if (!this.map) {
                        // falling back to empty map
                        this.map = new Tradebitcoin.views.Map();
                    }
                    $('#status').html("<h1>Error</h1><p>Geocode was not successful for the following reason: " + status + '</p>').fadeIn();
                }
            }, this));
            return true;
        },

        submit: function() {
            if (!this._codeAddress($.proxy(function() {
                this.el.submit();
            }, this))) {
                var html = '<h1 style="color: red">Error</h1>';
                html += '<p>Address field cannot be empty.</p>';
                $("#status").html(html);
            }
        },

        success: function() {
            $("#status").html('<h1 style="color: green">Profile Updated</h1>');
        },

        failure: function(event, xhr, status, error) {
            html = '<h1 style="color: red">Error</h1>';
            html += '<p>' + xhr.responseText + '</p>';
            $("#status").html(html);
        }


    });

})(jQuery);