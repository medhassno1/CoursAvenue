
FilteredSearch.module('Views', function(Views, App, Backbone, Marionette, $, _) {
    Views.BlankView = Marionette.ItemView.extend({ template: "" });
    Views.CoursMarkerView = Backbone.GoogleMaps.RichMarkerView.extend({
        initialize: function (options) {

            /* TODO this setup should be done in the constructor, in the library, in another repo far, far away */
            this.$el = $("<div class='map-marker-image' style='font-size: 13px; top: -2em;'><a href='javascript:void(0)'></a></div>");
            this.overlayOptions.content = this.$el[0];
        },

        mapEvents: {
            'mouseover': 'select',
            'mouseout':  'deselect'
        },

        /* TODO stupidly named event that the library forces us to use *barf* */
        toggleSelect: function (e) {
            this.trigger('focus', e);
        },

        select: function (e) {
            this.$el.addClass('active');
        },

        deselect: function (e) {
            this.$el.removeClass('active');
        }
    });

    Views.GoogleMapsView = Marionette.CompositeView.extend({
        template: 'backbone/templates/google_maps_view',
        id:       'map-container',
        itemView: Views.BlankView,
        itemViewEventPrefix: 'marker',
        markerView: Views.CoursMarkerView,
        markerViewChildren: {},

        initialize: function(options) {
            this.mapOptions = {
                center: new google.maps.LatLng(0, 0),
                zoom: 12,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };

            this.mapView = new Views.BlankView({
                id: 'map',
                attributes: {
                    'class': 'map_container'
                }
            });
            this.map = new google.maps.Map(this.mapView.el, this.mapOptions);
            this.map_annex = this.mapView.el;
        },

        onMarkerFocus: function (data) {
            this.trigger('map:marker:focus', data);
        },

        changeMapRadius: function(data) {
            if (data.radius) {
                this.map.setZoom(data.radius);
            }
        },

        onRender: function() {
            this.$el.find('[data-type=map-container]').prepend(this.map_annex);
        },

        centerMap: function (data) {
            console.log("GoogleMapsView->centerMap");
            if (data.lat && data.lng) {
                this.map.setCenter(new google.maps.LatLng(data.lat, data.lng));
            }
        },

        clearForUpdate: function() {
            console.log("GoogleMapsView->clearForUpdate");
            this.closeChildren();
        },

        appendHtml: function(collectionView, itemView, index){
            this.addChild(itemView.model);
        },

        closeChildren: function() {
            for(var cid in this.markerViewChildren) {
                this.closeChild(this.markerViewChildren[cid]);
            }
        },

        closeChild: function(child) {
            // Param can be child's model, or child view itself
            var childView = (child instanceof Backbone.Model)? this.markerViewChildren[child.cid]: child;

            childView.close();
            delete this.markerViewChildren[childView.model.cid];
        },

        // Add a MarkerView and render
        addChild: function(childModel) {
            console.log("GoogleMapsView->addChild");

            var places = childModel.getRelation('places').related.models;
            var self = this;

            _.each(places, function (place) {
                var markerView = new self.markerView({
                    model: place,
                    map: self.map
                });

                self.markerViewChildren[place.cid] = markerView;
                self.addChildViewEventForwarding(markerView); // buwa ha ha ha!

                markerView.render();
            });
        },

        /* TODO for now we are using 'cid' as the key, but
         * later I would like to use (lat,long) as the key
         * since cid is not actually an attribute and so
         * should not be included in the event from structureView */
        toKey: function (model) {
            return model.cid;
        },

        selectMarkers: function(data) {
            var self = this;

            var keys = data.map(function(model) {
                return self.toKey(model);
            });

            _.each(keys, function (key) {
                var marker = self.markerViewChildren[key];

                // Prevent from undefined
                if (marker) { marker.select(); }
            });
        },

        deselectMarkers: function (data) {
            var self = this;

            var keys = data.map(function(model) {
                return self.toKey(model);
            });

            _.each(keys, function (key) {
                var marker = self.markerViewChildren[key];

                // Prevent from undefined
                if (marker) { marker.deselect(); }
            });
        }
    });
});
