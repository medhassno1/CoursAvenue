/* just a basic backbone model */
StructureProfile.module('Models.Comments', function(Module, App, Backbone, Marionette, $, _) {

    Module.CertifiedCommentsCollection = StructureProfile.Models.CommentsCollection.extend({

        url: function url () {
            return Routes.structure_comments_path(this.options.structure_id, { certified: true })
        }

    });
});