/* a view for presenting a backbone.paginator collection, and for presenting and handling
 * its pagination UI element */
FilteredSearch.module('Views', function(Views, App, Backbone, Marionette, $, _) {

    Views.PaginatedCollectionView = Views.AccordionView.extend({
        template: 'backbone/templates/paginated_collection_view',
        itemView: FilteredSearch.Views.StructureView,
        itemViewContainer: 'ul.' + FilteredSearch.slug + '__list',
        className: 'relative',

        /* forward events with only the necessary data */
        onItemviewHighlighted: function (view, data) {
            this.trigger('structures:itemview:highlighted', data);
        },

        onItemviewUnhighlighted: function (view, data) {
            this.trigger('structures:itemview:unhighlighted', data);
        },

        onAfterShow: function() {
            this.announcePaginatorUpdated();
        },

        renderSlideshows: function() {
            var self = this;
            setTimeout(function(){
                // Start slideshow
                // Removing images and adding the image url to background image in order to have the image being covered
                self.$('.rslides img').each(function(){
                    var $this = $(this);
                    $this.closest('.media__item').hide();
                    $this.closest('li').css('background-image', 'url(' + $this.attr('src') + ')')
                });
                self.$(".rslides").responsiveSlides({
                    auto: false,
                    nav: true,
                    prevText: '<i class="fa fa-chevron-left"></i>',
                    nextText: '<i class="fa fa-chevron-right"></i>'
                });
                self.$('.rslides-wrapper [data-behavior="fancy"]').fancybox({ helpers : { media : {} } });
                // Set the height of the slides
                self.$('.structure-item').each(function() {
                    var $this = $(this);
                    var media_height = $this.height();
                    $this.find('.rslides li').css('height', media_height);
                    $this.find('.rslides').removeClass('hidden');
                });
            });
        },

        /* we don't use this, but we could */
        accordionCloseAll: function () {
            var self = this;

            _.each(_.clone(this.currently_selected_cid), function(cid) {
                var itemView = self.children.findByModelCid(cid);
                itemView.accordionToggle(itemView.active_region);
            });
        },

        announcePaginatorUpdated: function () {
            var data         = this.collection;
            var first_result = (data.currentPage - 1) * data.perPage + 1;

            this.trigger('structures:updated');

            /* announce the pagination statistics for the current page */
            this.trigger('structures:updated:pagination', {
                current_page:        data.currentPage,
                last_page:           data.totalPages,
                buttons:             this.buildPaginationButtons(data),
                previous_page_query: this.collection.previousQuery(),
                next_page_query:     this.collection.nextQuery(),
                relevancy_query:     this.collection.relevancyQuery(),
                popularity_query:    this.collection.popularityQuery(),
                sort:                this.collection.server_api.sort
            });

            /* announce the summary of the result set */
            this.trigger('structures:updated:summary', {
                first: first_result,
                last: Math.min(first_result + data.perPage - 1, data.grandTotal),
                total: data.grandTotal,
            });

            /* announce the filters used in the current result set */
            this.trigger('structures:updated:filter', {
                address_name: (data.server_api.address_name ? decodeURIComponent(data.server_api.address_name) : ""),
                name:         (data.server_api.name ? decodeURIComponent(data.server_api.name) : ""),
                subject_id:   (data.server_api.subject_id ? decodeURIComponent(data.server_api.subject_id) : "")
            });

            this.trigger('structures:updated:maps');
        },

        /* we want to show buttons for the first and last pages, and the
         * pages in a radius around the current page. So we will skip pages
         * that don't meet that criteria */
        canSkipPage: function (page, data) {
            var last_page = data.totalPages,
            out_of_bounds = (data.currentPage - data.radius > page || page > data.currentPage + data.radius),
            bookend = (page == 1 || page == last_page);

            return (!bookend && out_of_bounds);
        },

        /* TODO this method and canskippage should really be methods on the
        *  pagination tool. However, the tool needs the collection's Query
        *  method to construct query strings for anchors. This is a problem!
        *  we could:
        *  - build all the query strings and put them in an array
        *  - send enough information to be able to build the query strings over there
        *  - send a reference to the pageQuery method */
        buildPaginationButtons: function (data) {
            var self = this,
            skipped = false,
            buttons = [];

            _.times(data.totalPages, function(index) {
                var current_page = index + 1;

                if (self.canSkipPage(current_page, data)) { // 1, ..., 5, 6, 7, ..., 9
                    skipped = true;
                } else {
                    if (skipped) { // push on an ellipsis if we've skipped any pages
                        buttons.push({ label: '...', disabled: true });
                    }

                    buttons.push({ // push the current page
                        label: current_page,
                        active: (current_page == data.currentPage),
                        query: self.collection.pageQuery(current_page)
                    });

                    skipped = false;
                }
            });

            return buttons;
        },

        filterQuery: function(filters) {
            /* TODO check for redundancy: if the incoming filters don't
            *  change anything, we shouldn't do the update */
            // if (this.collection.setQuery(filter) === this.collection.getQuery()) {
            //     return false;
            // }

            /* since we are changing the query, we need to reset
            *  the collection, or else some elements will be in the wrong order */
            // this.collection.reset();
            this.collection.setQuery(filters);

            /* we are updating from the location filter */
            if (filters.city && filters.lat) {
                this.trigger('filter:update:map', filters);
            }

            this.collection.currentPage = -1;

            return this.changePage(this.collection.firstPage);
        },

        nextPage: function (e) {
            var page = Math.min(this.collection.currentPage + 1, this.collection.totalPages);

            return this.changePage(page);
        },

        prevPage: function (e) {
            var page = Math.max(this.collection.currentPage - 1, 1);

            return this.changePage(page);
        },

        goToPage: function (e) {
            var page = e.currentTarget.text;

            return this.changePage(page);
        },

        changePage: function (page) {
            if (page == this.collection.currentPage) { return false };

            var self = this;

            self.trigger('structures:updating', this);
            this.collection.goTo(page, {
                success: function () {
                    self.announcePaginatorUpdated();
                }
            });

            return false;
        },

        findItemView: function (data) {
            /* find the first place that has any locations that match the given lat/lng */
            var position = data.model.getLatLng();

            var relevant_structure = this.collection.find(function (model) {

                return _.find(model.getRelation('places').related.models, function (place) {
                    var location = place.get('location');
                    var latlng = new google.maps.LatLng(location.latitude, location.longitude);

                    return (position.equals(latlng)); // ha! google to the rescue
                });
            });

            var itemview = this.children.findByModel(relevant_structure);

            /* announce the view we found */
            this.trigger('structures:itemview:found', itemview);
            this.scrollToView(itemview);

        },

        scrollToView: function(view) {
            var course_element = view.$el;

            $(document.body).animate({scrollTop: course_element.offset().top}, 200,'easeInOutCubic');
            $(document.body).scrollTo(course_element[0], {duration: 400})
            // Unselect courses if there already are that are selected
            $('.course-element').removeClass('selected');
            setTimeout(function(){
                course_element.addClass('selected');
            }, 100);

        },

        /* when rendering each collection item, we might want to
         * pass in some info from the paginator_ui or something
         * if do we would do it here */
        /* remember that itemViews are constructed and destroyed more often
        * than the corresponding models */
        itemViewOptions: function(model, index) {
            // we could pass some information from the collectionView
            var search_term;

            if (this.collection.server_api.name) {
                search_term = decodeURIComponent(this.collection.server_api.name);
            }

            return {
                search_term: search_term
            };
        }
    });
});
