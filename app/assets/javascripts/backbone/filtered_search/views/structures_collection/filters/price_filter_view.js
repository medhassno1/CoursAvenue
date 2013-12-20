
/* just a basic marionette view */
FilteredSearch.module('Views.StructuresCollection.Filters', function(Module, App, Backbone, Marionette, $, _) {

    Module.PriceFilterView = Backbone.Marionette.ItemView.extend({
        template: Module.templateDirname() + 'price_filter_view',

        SUBSCRIPTION_PRICE_TYPES: ['all_subscriptions', 'annual_subscription', 'semestrial_subscription', 'trimestrial_subscription', 'monthly_subscription'],
        COURSE_PRICE_TYPES:       ['any_per_course', 'per_course', 'book_ticket'],

        initialize: function() {
            this.announce = _.debounce(this.announce, 800);
        },

        setup: function (data) {
            var $min_value = this.ui.$min_value,
                $max_value = this.ui.$max_value;


            if (this.SUBSCRIPTION_PRICE_TYPES.indexOf(data.price_type) !== -1) {
                this.ui.$price_type_radio_subscription.prop('checked', true);
                this.ui.$subscription_prices_select.show().val(data.price_type);
            } else if (this.COURSE_PRICE_TYPES.indexOf(data.price_type) !== -1) {
                this.ui.$price_type_radio_course.prop('checked', true);
                this.ui.$course_prices_select.show().val(data.price_type);
            }
            range = this.getRange();
            step  = this.getStep();

            if (data.min_price === "" && data.max_price === "") {
                min = range[0];
                max = range[1];
            } else {
                min = data.min_price;
                max = data.max_price;
            }
            this.ui.$slider.noUiSlider({
                range: range,
                start: [min, max],
                connect: true,
                handles: 2,
                margin: 2,
                step: step,
                serialization: {
                    to: [ [$min_value, 'text'], [$max_value, 'text']],
                    resolution: 1
                }
            });
            this.announceBreadcrumb();
        },

        ui: {
            '$price_type_radio_course':       '#radio-course',
            '$price_type_radio_subscription': '#radio-subscription',
            '$price_type_radio':              '[name=price_type]',
            '$select':                        'select',
            '$slider':                        '[data-behavior=slider]',
            '$min_value':                     '[data-behavior="slider-min-value"]',
            '$max_value':                     '[data-behavior="slider-max-value"]',
            '$subscription_prices_select':    '[data-type="subscription-prices"]',
            '$course_prices_select':          '[data-type="course-prices"]'
        },

        events: {
            'change @ui.$price_type_radio': 'changeSelect',
            'change @ui.$select':           'changeRange',
            'change @ui.$slider':           'announce'
        },

        changeSelect: function() {
            if (this.$('[name=price_type]:checked').val() == 'course') {
                this.ui.$subscription_prices_select.hide();
                this.ui.$course_prices_select.show();
            } else {
                this.ui.$course_prices_select.hide();
                this.ui.$subscription_prices_select.show();
            }
            this.changeRange();
        },

        currentShownSelect: function() {
            if (this.$('[name=price_type]:checked').val() === 'course') {
                return this.ui.$course_prices_select;
            } else if (this.$('[name=price_type]:checked').val() === 'subscription') {
                return this.ui.$subscription_prices_select;
            }
            return null;
        },

        getRange: function() {
            if (this.currentShownSelect()) {
                var $option = $('[value="' + this.currentShownSelect().val() + '"]');
                return $option.data('range').split(',');
            } else {
                return [0, 2000];
            }
        },

        getStep: function() {
            if (this.currentShownSelect()) {
                var $option = $('[value="' + this.currentShownSelect().val() + '"]');
                return $option.data('step');
            } else {
                return 5
            }
        },

        changeRange: function() {
            var range   = this.getRange(),
                step    = this.getStep();
            this.ui.$slider.noUiSlider({ range: range, start: range, step: step }, true);
            this.ui.$slider.parent().animate({backgroundColor: 'rgba(255, 255, 13, 0.35)'}, {duration: 300})
                                    .animate({backgroundColor: 'transparent'}, {duration: 300});
            this.announce();
        },

        announce: function (e) {
            var slider_value = this.ui.$slider.val();
            if (this.$('[name=price_type]:checked').length === 0) {
                this.trigger("filter:price", {
                    'price_type': null,
                    'min_price':  null,
                    'max_price':  null
                });
            } else {
                this.trigger("filter:price", {
                    'price_type': this.currentShownSelect().val(),
                    'min_price': slider_value[0],
                    'max_price': slider_value[1]
                });
            }
            this.announceBreadcrumb();
        },
        announceBreadcrumb: function() {
            var title;
            if (this.$('[name=price_type]:checked').length === 0) {
                this.trigger("filter:breadcrumb:remove", {target: 'price'});
            } else {
                title = this.currentShownSelect().find('option:selected').text();
                title += ' de ' + this.ui.$slider.val()[0] + ' à ' + this.ui.$slider.val()[1] + '€'
                this.trigger("filter:breadcrumb:add", {target: 'price', title: title});
            }
        },

        // Clears all the given filters
        clear: function (filters) {
            this.ui.$price_type_radio.prop('checked', false);
            this.ui.$subscription_prices_select.hide();
            this.ui.$subscription_prices_select.val('all_subscriptions');
            this.ui.$course_prices_select.hide();
            this.ui.$course_prices_select.val('any_per_course');
            this.ui.$slider.val([5, 2000]);
            this.announce();
        }
    });
});
