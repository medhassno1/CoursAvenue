
StructureProfile.module('Views.Map.GoogleMap', function(Module, App, Backbone, Marionette, $, _) {

    Module.InfoBoxView = CoursAvenue.Views.Map.GoogleMap.InfoBoxView.extend({
        template: Module.templateDirname() + 'place_info_box_view'
    });
});
