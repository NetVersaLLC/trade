var Tradebitcoin = Tradebitcoin || { models: {}, views: {}};

(function ($) {

    /**
     * Signle user object with google map marker included
     * @type {*}
     */
    Tradebitcoin.models.User = Backbone.Model.extend({
        defaults: {
            id: null,
            name: null,
            latitude: null,
            longitude: null,
            address: null,
            phone: null,
            aim: null,
            yim: null,
            jabber: null,
            skype: null,
            gravatar: null
        },

        getMarker: function() {
            if (!this.has("marker")) {
                var location = new google.maps.LatLng(this.get("latitude"), this.get("longitude"));
                var title = this.get("name");
                var marker = new google.maps.Marker({
                    position: location,
                    animation: google.maps.Animation.DROP,
                    title: title
                });
                var info = '<div class="stack"><img src="http://www.gravatar.com/avatar/' + this.get("gravatar") + '" alt="Gravatar" class="gravatar" />';
                info += '<h3 class="boxContent">' + this.get("name") + '</h3></div>';
                if (this.notEmpty("address")) {
                    info += '<div class="boxContent stack">Address: ' + this.get("address") + '</div>';
                }
                if (this.notEmpty("phone")) {
                    info += '<div class="boxContent stack">Phone: <a href="callto:' + this.get("phone") + '"><b>' + this.get("phone") + '</b></a></div>';
                }
                info += '<div class="stack">';
                if (this.notEmpty("aim")) {
                    info += '<a href="aim:goim?screenname=' + this.get("aim") + '&message=Bitcoin+trade."><img src="/assets/aol_64.png" alt="AOL Instant Messenger" title="AIM User: ' + this.get("aim") + '" class="icon" /></a>';
                }
                if (this.notEmpty("skype")) {
                    info += '<a href="skype:' + this.get("skype") + '?call"><img src="/assets/skype_icon_64x64.png" alt="Skype" title="Skype User: ' + this.get("skype") + '" class="icon" /></a>';
                }
                if (this.notEmpty("yim")) {
                    info += '<a href="ymsgr:sendIM?' + this.get("yim") + '"><img src="/assets/yahoo_64.png" alt="Yahoo Address" title="YIM: ' + this.get("yim") + '" class="icon" /></a>';
                }
                if (this.notEmpty("jabber")) {
                    info += '<a href="xmpp:' + this.get("jabber") + '?message"><img src="/assets/jabber_icon_64x64.png" title="Jabber: ' + this.get("jabber") + '" alt="Jabber" /></a>';
                }
                info += '</div>';
                marker.infotext = info;
                this.set("marker", marker);
            }
            return this.get("marker");
        },

        notEmpty: function(attr) {
            return this.has(attr) && $.trim(this.get(attr)) != '';
        }
    });


    /**
     * Users collection
     * @type {*}
     */
    Tradebitcoin.models.Users = Backbone.Collection.extend({
            model: Tradebitcoin.models.User,

            // search users around this location
            latitude: null,
            longitude: null,

            url: function() {
                return '/users?la=' + this.latitude + '&lo=' + this.longitude;
            },
            loadForLocation: function(latitude, longitude) {
                this.latitude = latitude;
                this.longitude = longitude;
                this.fetch({remove: false}); // fetch users for new location without removing existing objects
            }
    });

})(jQuery);
