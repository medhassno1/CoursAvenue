Newsletter.module('Views', function(Module, App, Backbone, Marionette, $, _) {
    Module.NewsletterView = Backbone.Marionette.ItemView.extend({
        template: Module.templateDirname() + 'newsletter_view',

        events: {
        },

        bindings: {
            '#title': 'title',
        },

        initialize: function initialize () {
        },

        // We overwrite render so we can call the stickit plugin.
        render: function render () {
            // Invoke original render function
            var args = Array.prototype.slice.apply(arguments);
            var result = Marionette.ItemView.prototype.render.apply(this, args);

            // Apply stickit
            this.stickit();

            // Apply stickit to the submodels.
            _.each(this.model.get('blocs'), function(model) {
                this.stickit(model, {
                  '#image': 'remote_image_url',
                  '#content': 'content'
                });
            }, this);

            // Return render result
            return result;
        },

        // TODO: Ask for confirmation ("Changing layout will lose your current
        // blocs. Are you sure you want to continue ?").
        updateLayout: function updateLayout (data) {
            var model = data.model;

            // If the layout is already selected, do nothing.
            if (model.get('id') == this.model.get('layout_id')) {
                return ;
            }

            // Store the chosen model in the layout.
            this.model.set({ layout_id: model.get('id'), layout: model });

            // Create associated newsletter blocs.
            var blocs = [];
            _.each(model.get('blocs'), function(blocType, index) {
                var bloc = new Newsletter.Models.Bloc({ type: blocType, position: index + 1 })
                blocs.push(bloc);
            }, this);

            // console.log(blocs);
            this.model.set('blocs', blocs);

            this.render();
        },

        renderedBloc: function renderedBloc (bloc) {
            var path = Module.templateDirname() + 'bloc_' + bloc.get('type');

            return (JST[path](bloc.attributes));
        },

        // TODO: - Save / Create the newsletter.
        //       - Save the blocs using the (id / slug) of the newsletter.
        submit: function submit () {
        },
    });
});
