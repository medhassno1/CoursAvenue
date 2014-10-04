
/* just a basic marionette view */
StructureProfileDiscoveryPass.module('Views.Structure', function(Module, App, Backbone, Marionette, $, _) {

    Module.StructureView = StructureProfile.Views.Structure.StructureView.extend({
        template: Module.templateDirname() + 'structure_view',

        findCollectionViewForResource: function findCollectionViewForResource (resources) {
            return Module[_.capitalize(resources)][_.capitalize(resources) + 'CollectionView'];
        },

        initializeContactLink: function initializeContactLink () {
            $('body').on('click', '[data-behavior=show-contact-panel]', function() {
                this.trigger('planning:register', {});
            }.bind(this));
        }

    });
});