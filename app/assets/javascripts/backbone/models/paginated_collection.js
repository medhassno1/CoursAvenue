/* Sets up the details specific to coursavenue's API */
FilteredSearch.module('Models', function(Models, App, Backbone, Marionette, $, _) {
    Models.PaginatedCollection = Backbone.Paginator.requestPager.extend({
        model: FilteredSearch.Models.Structure,
        paginator_core: {
            type: 'GET',
            dataType: 'json',
            url: function() {
                return this.url.basename + this.url.resource + this.url.datatype;
            }
        },
        paginator_ui: {
            firstPage:   1,
            currentPage: 1,
            perPage:     15,
            totalPages:  10
        },
        server_api: {
            'page': function() { return this.currentPage; }
        },

        parse: function(response) {
            console.log('PaginatedCollection->parse');
            this.paginator_ui.totalPages = Math.ceil(response.meta.total / this.perPage);

            return response.structures;
        },

        url: {
            basename: 'http://www.examples.com',
            resource: '/stuff',
            datatype: '.json'
        },

        setUrl: function(basename, resource, data_type) {
            if (basename  != undefined) { this.url.basename  = basename; }
            if (resource  != undefined) { this.url.resource  = '/' + resource; }
            if (data_type != undefined) { this.url.data_type = '.' + data_type; }
        }
    });

});

// for later
//  address_name=Paris&
//  city=paris&
//  lat=48.8592&
//  lng=2.3417&
//  name=danse&
//  page=2&
//  radius=5&
//  sort=rating_desc&utf8=%E2%9C%93
