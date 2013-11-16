FilteredSearch.module('Views', function(Views, App, Backbone, Marionette, $, _) {

    Views.SubjectFilterView = Backbone.Marionette.ItemView.extend({
        template: 'backbone/templates/subject_filter_view',
        className: 'very-soft',

        setup: function (data) {
            this.activateButton(data.subject_id);
        },

        serializeData: function(data) {
            return { subjects: coursavenue.bootstrap.subjects };
        },

        events: {
            'click [data-type="button"]': 'announceSubject'
        },

        announceSubject: function (e, data) {
            var subject_slug = e.currentTarget.dataset.value;
            if (this.$('[data-value=' + subject_slug + ']').hasClass('active')) {
                this.trigger("filter:subject", { 'subject_id': null });
                this.disabledButton(subject_slug);
            } else {
                this.trigger("filter:subject", { 'subject_id': subject_slug });
                this.activateButton(subject_slug);
            }
        },

        disabledButton: function(subject_slug) {
            this.$('[data-value=' + subject_slug + ']').removeClass('active');
        },

        activateButton: function(subject_slug) {
            this.$('[data-type="button"]').removeClass('active');
            this.$('[data-value=' + subject_slug + ']').addClass('active');
        }
    });
});
