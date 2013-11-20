FilteredSearch.module('Views.FilteredSearch.PaginatedCollection.Structure.Courses', function(Module, App, Backbone, Marionette, $, _) {

    Module.CoursesCollectionView = Backbone.Marionette.CompositeView.extend({
        template: Module.templateDirname() + 'courses_collection_view',

        // The "value" has an 's' at the end, that's what the slice is for
        itemView: Module.CourseView,
        itemViewContainer: '[data-type=container]',

        onRender: function() {
            this.$('[data-behavior=tooltip]').tooltip();
        },

        onItemviewToggleSelected: function (view, data) {
            var places = view.model.get('structure').get('places'),
                keys = places.findWhere({ id: data.place_id });

            if (keys.length) {
                console.log("keys had a length!");
                debugger
            }

            this.trigger('course:focus', { keys: keys });
        },

        /* when rendering each collection item, we might want to
         * pass in some info from the paginator_ui or something
         * if do we would do it here */
        itemViewOptions: function(model, index) {
            // we could pass some information from the collectionView
            return { index: index };
        },

        /* overriding super's showCollection to only show those items that
        * are valid */
        showCollection: function(){
            var self = this;
            var ItemView = this.getItemView();
            this.collection.each(function(item, index){
                if (item.get('name')) {
                    self.addItemView(item, ItemView, index);
                }
            });
        },
    });

});
