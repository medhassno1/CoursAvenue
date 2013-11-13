FilteredSearch.module('Views', function(Views, App, Backbone, Marionette, $, _) {

    Views.AccordionView = Backbone.Marionette.CompositeView.extend({

        initialize: function () {
            this.currently_selected_cid = [];
        },

        onItemviewAccordionClose: function (view, model_cid) {
            var index = this.currently_selected_cid.indexOf(model_cid);
            if (index > -1) {
                this.currently_selected_cid.splice(index, 1);
            }
        },

        /* function that is called in order to clear the currently active accordion */
        onItemviewAccordionOpen: function(view, model_cid) {
            /*
            if (this.currently_selected_cid) {
                var child_view = this.children.findByModelCid(this.currently_selected_cid);

                if (child_view) {
                    child_view.accordionClose();
                }
            }*/

            this.currently_selected_cid.push(model_cid);
            view.trigger('show');
        }
    });
});
