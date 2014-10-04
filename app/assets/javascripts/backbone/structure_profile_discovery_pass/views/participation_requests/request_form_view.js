StructureProfileDiscoveryPass.module('Views.ParticipationRequests', function(Module, App, Backbone, Marionette, $, _, undefined) {

    Module.RequestFormView = Marionette.CompositeView.extend({
        template: Module.templateDirname() + 'request_form_view',
        message_failed_to_send_template: Module.templateDirname() + 'message_failed_to_send',
        className: 'panel center-block push--bottom',

        events: {
            'submit form'                       : 'submitForm',
            'change @ui.$course_select'         : 'showAssociatedPlannings',
            'change @ui.$planning_select_input' : 'updateDatePicker'
        },

        ui: {
            '$course_select'           : 'select[name=course_id]',
            '$planning_select_wrapper' : '[data-element=planning-select-wrapper]',
            '$planning_select_input'   : '[data-element=planning-select-wrapper] select',
            '$datepicker_wrapper'      : '[data-element=datepicker-wrapper]',
            '$datepicker_input'        : '[data-element=datepicker-wrapper] input'
        },

        initialize: function initialize (options) {
            this.structure = options.structure;
            this.model = new StructureProfileDiscoveryPass.Models.ParticipationRequest(options.model || {});
            Backbone.Validation.bind(this);
            _.bindAll(this, 'showPopupMessageDidntSend');
        },

        /*
         * Set attributes on message model for validations
         */
        populateRequest: function populateRequest (event) {
            this.model.set({
                structure_id  : this.structure.get('id'),
                date          : this.$('[name=date]').val(),
                message: {
                    body: this.$('[name="message[body]"]').val()
                },
                user: {
                    phone_number: this.$('[name="user[phone_number]"]').val()
                }
            });
        },

        /*
         * Called when a user click on "register" on a planning
         * We create an instance of a message form view
         */
        showRegistrationForm: function showRegistrationForm (planning_data) {
            if (this.structure.get('courses').findWhere({ id: planning_data.course_id })) {
                this.model.set('course_collection_type', 'courses');
            } else {
                this.model.set('course_collection_type', 'trainings');
            }
            this.model.set('course_id', planning_data.course_id);
            this.model.set('planning_id', planning_data.id);
            this.selectCourse(planning_data.course_id);
            this.populatePlannings(planning_data.id);
            var message_form_view = new Module.RequestFormView( { structure: this.structure, model: this.model.toJSON().participation_request } ).render();
            $.magnificPopup.open({
                  items: {
                      src: $(message_form_view.$el),
                      type: 'inline'
                  }
            });
            message_form_view.$el.css('max-width', '400px');
        },

        onRender: function onRender () {
            var datepicker_options = {
                format: GLOBAL.DATE_FORMAT,
                weekStart: 1,
                language: 'fr',
                autoclose: true,
                todayHighlight: true,
                startDate: new Date()
            };
            this.ui.$datepicker_input.datepicker(datepicker_options);
            if (this.model.get('course_id')) { this.selectCourse(this.model.get('course_id')); }
            if (this.model.get('planning_id')) { this.populatePlannings(this.model.get('planning_id')); }
        },

        /*
         * When a user select a course in the select box, we show the associated plannings
         */
        showAssociatedPlannings: function showAssociatedPlannings () {
            var course_id = parseInt(this.ui.$course_select.val());
            this.selected_course_collection_type = this.ui.$course_select.find('option:selected').data('collection-type');
            this.model.set('course_collection_type', this.ui.$course_select.find('option:selected').data('collection-type'));
            this.selected_course                 = this.structure.get(this.selected_course_collection_type).findWhere({ id: course_id });
            this.model.set('course_id', course_id);
            this.selectCourse(course_id);
        },

        /*
         * Return course model
         */
        getCurrentCourse: function getCurrentCourse () {
            return this.structure.get(this.model.get('course_collection_type')).findWhere({ id: this.model.get('course_id') });
        },

        /*
         * Return all the plannings of the currently selected course
         */
        getCurrentCoursePlannings: function getCurrentCoursePlannings () {
            return this.getCurrentCourse().get('plannings');
        },

        /*
         * Return the currently selected planning
         */
        getCurrentPlanning: function getCurrentPlanning () {
            return _.findWhere(this.getCurrentCoursePlannings(), { id: this.model.get('planning_id') });
        },

        /*
         * Select course in select
         */
        selectCourse: function selectCourse (course_id) {
            this.ui.$course_select.find('option').removeAttr('selected');
            this.ui.$course_select.find('option[value=' + course_id + ']').attr('selected', true);
            this.ui.$planning_select_wrapper.slideDown();
            this.populatePlannings();
            if (this.model.get('course_collection_type') == 'courses') {
                this.ui.$datepicker_wrapper.slideDown();
            } else {
                this.ui.$datepicker_wrapper.slideUp();
            }
        },

        /*
         * Add plannings option to planning select regarding the selected course
         */
        populatePlannings: function populatePlannings (planning_id) {
            if (! this.model.get('course_id')) { return; }
            this.ui.$planning_select_input.empty();
            _.each(this.getCurrentCoursePlannings(), function(planning, index) {
                var option = $('<option>').attr('value', planning.id).text(planning.date + ' ' + planning.time_slot);
                if (planning.id == planning_id || (!planning_id && index == 0)) {
                    option.attr('selected', true);
                }
                this.ui.$planning_select_input.append(option);
            }, this);
            this.updateDatePicker();
        },

        /*
         * Set the datepicker to the next possible date
         */
        updateDatePicker: function updateDatePicker () {
            this.model.set('planning_id', parseInt(this.ui.$planning_select_input.val()));
            // if (!this.model.get('planning_id')) { return; }
            this.ui.$datepicker_input.datepicker('update', this.getCurrentPlanning().next_date);
            // Disable days of week
            var days_of_week = [0,1,2,3,4,5,6];
            days_of_week.splice(days_of_week.indexOf(this.getCurrentPlanning().week_day), 1);
            this.ui.$datepicker_input.datepicker('setDaysOfWeekDisabled', days_of_week);
        },

        /*
         * Called when the form is submitted.
         * If user is connected, will post the message, else, will ask to login first.
         */
        submitForm: function submitForm () {
            this.populateRequest();
            if (this.model.isValid(true)) {
                this.$('form').trigger('ajax:beforeSend.rails');
                this.saveMessage();
            } else {
                this.errors = this.model.validate();
                if (this.errors['user.phone_number']) {
                    this.errors.user = { phone_number: this.errors['user.phone_number'] }
                }
                this.render();
            }
            return false;
        },

        /*
         * Save message model. Will make a POST request to save the message.
         */
        saveMessage: function saveMessage () {
            this.$('.input_field_error').remove();
            this.model.save(null, {
                success: function success (model, response) {
                    // We disable the submit button
                    this.$('form').trigger('ajax:complete.rails');
                    $.magnificPopup.open({
                          items: {
                              src: $(response.popup_to_show),
                              type: 'inline'
                          }
                    });
                }.bind(this),
                error: this.showPopupMessageDidntSend
            });
        },

        showPopupMessageDidntSend: function showPopupMessageDidntSend (model, response) {
              this.$('form').trigger('ajax:complete.rails');
              // TODO
              var popup_to_show = JSON.parse(response.responseText).popup_to_show;
              $.magnificPopup.open({
                    items: {
                        src: $(popup_to_show),
                        type: 'inline'
                    }
              });
        },

        serializeData: function serializeData () {
            var data = this.model.toJSON();
            if (this.errors) { _.extend(data, { errors: this.errors }); }
            _.extend(data, {
                structure: this.structure.toJSON()
            });
            return data;
        }
    });

}, undefined);
