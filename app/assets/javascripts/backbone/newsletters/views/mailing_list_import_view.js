Newsletter.module('Views', function(Module, App, Backbone, Marionette, $, _) {
    Module.MailingListImportView = Backbone.Marionette.ItemView.extend({
        template: Module.templateDirname() + 'mailing_list_import_view',

        events: {
            'change [name=mailing_list]' : 'showImportOptions',
            'change [data-import-file]'  : 'importFromFile',
            'click [data-import-emails]' : 'importFromEmails',
            'submit'                     : 'chooseFileHeaders',
            'click [data-popup]'         : 'chooseFileHeaders',
        },
        ui: {
            '$import_options' : '[data-type=import-option"]'
        },

        initialize: function initialize (options) {
            this.model = options.model;
            _.bindAll(this, 'importFromFile', 'chooseFileHeaders', 'importFromEmails');
        },

        showImportOptions: function showImportOptions (options) {
            this.ui.$import_options.slideDown();
            debugger
        },

        importFromFile: function importFromFile () {
            event.preventDefault();

            var structure  = window.coursavenue.bootstrap.structure;
            var newsletter = this.model.get('id');

            var file = event.srcElement.files[0];
            var data = new FormData();

            if (!file) {
                COURSAVENUE.helperMethods.flash("Veuillez séléctionner un fichier.", 'error');
                return ;
            }

            data.append('file', file);
            var url = Routes.file_import_pro_structure_newsletter_mailing_lists_path(structure, newsletter);
            $.ajax(url, {
                data: data,
                type: 'POST',
                cache: false,
                contentType: false,
                processData: false,
                success: function success (data) {
                    $('[data-type=second-method]').slideUp();
                    var $data_file_headers_wrapper = $('[data-file-headers]');
                    $data_file_headers_wrapper.html(data.popup_to_show)
                    $data_file_headers_wrapper.slideDown();
                    this.user_profile_import = data.user_profile_import.id;
                }.bind(this),
                error: function error (data) {
                    COURSAVENUE.helperMethods.flash("Erreur lors de l'import du fichier, veuillez rééssayer.", 'error');
                }
            });
        },

        chooseFileHeaders: function chooseFileHeaders () {
            event.preventDefault();

            var structure  = window.coursavenue.bootstrap.structure;
            var newsletter = this.model.get('id');

            var form = $('form[data-header]');
            var data = form.serialize();
            var url  = Routes.update_headers_pro_structure_newsletter_mailing_lists_path(structure, newsletter, { user_profile_import: this.user_profile_import });

            $.ajax(url, {
                data: data,
                type: 'POST',
                success: function success (data) {
                    var mailingList = new Newsletter.Models.MailingList(data.mailing_list);
                    COURSAVENUE.helperMethods.flash(data.message, 'notice');
                    this.collection.add(mailingList);
                    this.trigger('selected', { model: this.model });
                }.bind(this),
                error: function error (data) {
                    var message = data.message || "Erreur lors de l'association des colonnes, veuillez rééssayer.";
                    COURSAVENUE.helperMethods.flash(message, 'error');
                }
            });
        },

        importFromEmails: function importContacts () {
            event.preventDefault();

            var emails     = $('[name=emails]').val();
            var structure  = window.coursavenue.bootstrap.structure;
            var newsletter = this.model.get('id');

            if (_.isEmpty(emails)) {
                COURSAVENUE.helperMethods.flash("Veuillez renseigner des adresses emails à importer.", 'error');
                return ;
            }

            var data = { emails: emails };

            var url = Routes.bulk_import_pro_structure_newsletter_mailing_lists_path(structure, newsletter)

            $.ajax(url, {
                data: data,
                type: 'POST',
                success: function (data) {
                    var mailingList = new Newsletter.Models.MailingList(data.mailing_list);
                    COURSAVENUE.helperMethods.flash(data.message, 'notice');
                    this.collection.add(mailingList);
                    this.trigger('selected', { model: this.model });
                }.bind(this),
                error: function (data) {
                    var message = data.message || "Une erreur est seurvenue lors de l'import des emails, veuillez rééssayer.";
                    COURSAVENUE.helperMethods.flash(message, 'error');
                }
            });
        },
    });
});
