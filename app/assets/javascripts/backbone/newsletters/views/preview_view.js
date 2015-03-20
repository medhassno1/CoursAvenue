Newsletter.module('Views', function(Module, App, Backbone, Marionette, $, _) {
    Module.PreviewView = Backbone.Marionette.ItemView.extend({
        template: Module.templateDirname() + 'preview_view',
        tagName: 'div',
        className: 'panel',

        initialize: function initialize () {
            _.bindAll(this, 'onShow');
        },

        templateHelpers: function templateHelpers () {
            return {
                preview_url: function () {
                    var structure = window.coursavenue.bootstrap.structure;
                    var newsletter = this.model.get('id');

                    return Routes.preview_newsletter_pro_structure_newsletter_path(structure, newsletter);
                }.bind(this),
            };
        },

        // TODO: Find a better way to do this.
        onShow: function onShow () {
            this.$el.find('[data-behavior]').click()
        },
    });
});
