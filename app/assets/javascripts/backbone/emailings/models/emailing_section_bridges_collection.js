Emailing.module('Models', function(Module, App, Backbone, Marionette, $, _) {
    Module.EmailingSectionBridgesCollection = Backbone.Collection.extend({
        model: Module.EmailingSectionBridge,

        url: function () {
            var id = window.coursavenue.bootstrap.id;
            return Routes.sections_pro_emailing_path(id);
        },

        parse: function (data) {
            return data;
        }
    });
});
