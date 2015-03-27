Newsletter.module('Views', function(Module, App, Backbone, Marionette, $, _) {
    Module.MailingListsEmptyCollectionView = Backbone.Marionette.ItemView.extend({
        template: Module.templateDirname() + 'mailing_lists_empty_collection_view',

        events: {
            'click [data-import]': 'importList',
        },

        initialize: function initialize () {
            _.bindAll(this, 'importList');
        },

        // When the user wants to import its mailing list.
        importList: function importList () {
            this.model.save();
            var path = Routes.new_pro_structure_user_profile_import_url(
                window.coursavenue.bootstrap.structure, {
                    return_to: this.model.get('id')
                });

                window.location = path;
        },
    });
});