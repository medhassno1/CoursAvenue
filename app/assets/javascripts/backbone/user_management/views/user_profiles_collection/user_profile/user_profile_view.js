UserManagement.module('Views.UserProfilesCollection.UserProfile', function(Module, App, Backbone, Marionette, $, _) {

    var ENTER  = 13;
    var ESC    = 27;

    Module.UserProfileView = CoursAvenue.Views.EventLayout.extend({
        template: Module.templateDirname() + 'user_profile_view',
        tagName: 'tr',
        className: 'table__cell--editable unflipped',

        initialize: function (options) {
            this.finishEditing = _.bind(this.finishEditing, this);
            // callbacks need to be bound to this
            _.bindAll(this, "updateSuccess", "updateError", "flashError");

            this.model.set("checked", options.checked);
            this.tags_url = options.tags_url;
            this.edits = {};

            $(window).scroll(this.stickyControls);
            this.sticky_home = -1;
        },

        announceEditableClicked: function (e) {
            this.trigger("editable:clicked", e);
        },

        /* TODO seriously? What is this doing here? This should be in the
        *  collection view for sure. */
        /* TODO also, why does it sometimes stop docking? Reproduce this. */
        stickyControls: function () {
            var $control = $("[data-behavior=sticky-controls]");

            var scroll_top = $(window).scrollTop();
            var control_top = $control.offset().top;
            var fixed = $control.hasClass("sticky");

            if (!fixed && scroll_top >= control_top) {
                // we have scrolled past the controls

                var old_width = $control.width();
                var $placeholder = $control.clone()
                                      .css({ visibility: "hidden" })
                                      .attr("data-placeholder", "")
                                      .attr("data-behavior", "");

                // $placehold stays behind to hold the place
                $control.parent().prepend($placeholder);

                this.sticky_home = control_top;
                $control.addClass("sticky");
                $control.css({ width: old_width });
            } else if ( fixed && scroll_top < this.sticky_home) {
                // we have now scrolled back up, and are replacing the controls

                this.$("[data-placeholder]").remove();
                $control.removeClass("sticky");
                $control.css({ width: "" });
                this.sticky_home = -1;
            }
        },

        /* incrementally build up a set of attributes */
        collectEdits: function (edits) {
            this.edits[edits.attribute] = edits.data;
        },

        showTagBar: function () {

            /* TODO this initialization code will probably change */
            /* we have tag_name, which is a property: it is a CSV
            *  derived from the attribute "tags", which is an array
            *  of objects. */
            var attribute = this.$("[data-behavior=editable-tag-bar]").data("name"),
                data      = this.model.get(attribute);

            var view = new Module.EditableTagBar.EditableTagBarView({
                data: data,
                attribute: attribute,
                url: this.tags_url
            });

            this.showWidget(view, {
                events: {
                    'start:editing'     : 'startEditing',
                    'rollback'          : 'rollback',
                    'update:start'      : 'stopEditing',
                    'update:success'    : 'commit',
                    'update:error'      : 'rollback',
                    'update:sync'       : 'setData'
                }
            });
        },

        showEditableText: function (element) {

            var attribute = $(element).data("name"),
            data = this.model.get(attribute);

            var view = new Module.EditableText.EditableTextView({
                data: data,
                attribute: attribute
            });

            this.showWidget(view, {
                events: {
                    'start:editing'     : 'startEditing',
                    'rollback'          : 'rollback',
                    'update:start'      : 'stopEditing',
                    'update:success'    : 'commit',
                    'update:error'      : 'rollback',
                    'update:sync'       : 'setData'
                },
                selector: '[data-type=editable-' + attribute + ']'
            });
        },

        /* TODO I don't understand how the fancybox is being shown:
         * it appears that this method is never called... and yet
         * we see a fancy box and it appears to do what it ought to. */
        showFancybox: function () {
            console.log("in showFancybox");
            var data = this.data;
            this.$("[data-behavior=modal]").fancybox({
                openSpeed   : 300,
                maxWidth    : 800,
                maxHeight   : 500,
                fitToView   : false,
                autoSize    : true,
                autoResize  : true,
                keys: {
                    close: [ESC]
                },
                ajax        : {
                    /* don't use .simple_form to select the form, use some data */
                    complete: _.bind(function() {
                        $('.simple_form').on("ajax:before", _.bind(function () {
                            $.fancybox.close();
                        }, this));
                        $('.simple_form').on("ajax:success", _.bind(this.syncModel, this));
                    }, this)
                }
            });
        },

        /* TODO instead of doing this on render we can do it when the user
        * first clicks on a row. We need to keep the event, and pass it down
        * to the newly new born new editables. We also need to remove the
        * click listener after the editables are created. */
        onRender: function () {

            this.showTagBar();

            this.ui.$editable.each(_.bind(function (index, element) {
                this.showEditableText(element);
            }, this));

        },

        ui: {
            '$editable': "[data-behavior=editable]",
            '$editing' : "[data-behavior=editable]:has('input')",
            '$checkbox': "[data-behavior=select]"
        },

        events: {
            'change @ui.$checkbox'       : 'addToSelected',
            'click [data-behavior=modal]': 'showFancybox'
        },

        modelEvents: {
            'change': 'syncFields'
        },

        /* TODO when the group action occurs, we need to update the
        *  affected fields that are visible. The 'tags' are returned
        *  as an object, but we are presenting them as a string.
        *  Maybe the user_profiles model should have just the string? */
        /* TODO this needs a better name... maybe "refresh" fields?
        *  or "sync fields" */
        syncFields: function (model) {
            /* we don't want to clobber fields with focus */
            if (this.isEditing()) { return; }

            this.trigger("update:sync", model.changed);
        },

        /* TODO poorly named */
        /* we have just returned from update the model server side
        *  so we need to set the new data on the model, and then
        *  sync fields */
        syncModel: function (xhr, data, status) {
            this.model.set(data);

            this.trigger("update:sync", this.model);
        },


        /* is this row being worked on? */
        /* TODO this should just check a flag */
        isEditing: function () {
            return this.is_editing;
        },

        /* we have a boolean stored as a mask. It is true when
        * the or of the bits is a true value, and false when it
        * it a false value.
        * The value can become "more" true, but not "more" false.
        * That is, once the value is a false value, it will stop
        * accepting "false" inputs */
        setEditing: function (value) {
            var old = this.is_editing;

            this.is_editing = value;

            if (this.is_editing != old) {
                this.trigger("changed:editing");
            }
        },

        addToSelected: function () {
            console.log("in addToSelected");
            this.trigger("add:to:selected");
        },

        /* called: when an editable is clicked */
        /* notifies all the other editables in the layout
        *  and gets them started
        *  gives focus to the editable that was clicked */
        startEditing: function ($target) {
            this.setEditing(true);
            /* tell all the other fields to start themselves */
            this.trigger("start:editing");

            /* give the main dude focus */
            $target.focus();
        },

        /* given a $field, replace that $field's contents with text */
        // TODO this method needs to be cleaned up
        // TODO we can probably move the "if restore" code to the top
        // TODO we can probably remove the !e.restore clause from that conditional
        finishEditing: function (e) {
            this.setEditing(false);

            // rollback if we aught to, or if there are no edits
            if (e.restore || _.isEmpty(this.edits)) {

                // if the model was new, we are done
                if (this.model.get("new")) {
                    this.close();
                } else {
                    this.trigger("rollback");
                }

                return;
            }

            // otherwise, collect and save the updates
            var update    = {
                user_profile: this.edits
            };

            this.trigger("update:start"); // let everyone know we've started

            // the updateSuccess callback needs to know the action
            var action = this.model.get("new")? "create" : "update";
            update_success = _.partial(this.updateSuccess, action);

            this.model.save(update, {
                error: this.flashError,
                wait: true

            }).success(update_success)
              .error(this.updateError);

            this.edits = {};
        },

        /* Callbacks: these are all bound to 'this' */

        updateSuccess: function (action, response) {
            response.action = action;

            this.trigger("update:success", response);
        },

        updateError: function () {
            this.trigger("update:error");
        },

        flashError: function (model, response) {
            /* display a flash containing the error message */
            GLOBAL.flash(response.responseJSON.errors.join("\n"), "alert");
        }
    });
});
