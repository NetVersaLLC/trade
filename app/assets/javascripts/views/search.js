var Tradebitcoin = Tradebitcoin || { models: {}, views: {}};

(function ($) {

    Tradebitcoin.views.Search = Backbone.View.extend({

        /**
         * Google Geocoder instance
         */
        geocoder: null,

        initialize: function(options) {
            this.geocoder = new google.maps.Geocoder();
            this.map = new Tradebitcoin.views.Map();
            this.map.loadUsersForCurrentLocation();
            this.setElement(document.getElementById("searchIt"));
            this._bindEvents(this.map);
        },

        _bindEvents: function(map) {
            this.$el.find(".submit").click($.proxy(function() {
                this.search(this.$el.find("input").val());
            }, this));
            this.$el.find('input').on('keyup', $.proxy(function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13) {
                    this.search(this.$el.find('input').val());
                }
            }, this));

            map.addListener('center_changed', $.proxy(function () {
                if (this.timeout !== false) {
                    window.clearTimeout(this.timeout);
                }
                this.timeout = window.setTimeout($.proxy(function () {
                    this.map.loadUsersForCurrentLocation();
                }, this), 500);
            }, this));
        },

        search: function(address) {
            $('#status').hide();
            if (address == null && $.trim(address) == '' && address == 'Search by address...') {
                return false;
            }
            this.map.clear();
            this.geocoder.geocode({ 'address': address}, $.proxy(function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    var foundLocation = results[0].geometry.location;
                    this.map.setCenter(foundLocation);
                    this.map.loadUsersForCurrentLocation(); // users search happens here
                    this.map.setCustomMarker("Search Center", foundLocation);
                    return true;
                } else {
                    $('#status').html("<h1>Error</h1><p>Geocode was not successful for the following reason: " + status + '</p>').fadeIn();
                }
            }, this));
        },
    });

})(jQuery);
