// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require global

// ---------------------------------- Core include
//= require jquery_ujs
//= require libs/jquery-ui-1.10.3.custom

// ---------------------------------- Lib includes
//= require libs/handlebars
//= require libs/handlebars-helpers
// require libs/autocomplete
// require libs/simple-modal
//= require libs/chosen.jquery
//= require libs/jquery.tablesorter
//= require libs/jquery.cookie

//= require libs/fancybox/jquery.fancybox
//= require_tree ./libs/fancybox/helpers/

//---- Bootstrap plugins
//= require libs/bootstrap.tooltip
//= require libs/bootstrap.tab
//= require libs/bootstrap.datepicker
//= require libs/locales/bootstrap.datepicker.fr


//---- Highcharts
//= require libs/highcharts/highcharts
//= require libs/highcharts/modules/exporting

//= require zeroclipboard

// ---------------------------------- Mootols Objects
// See boilerplate and pattern:
// - http://jqueryboilerplate.com/
// - https://github.com/jquery-boilerplate/jquery-patterns/
// - https://github.com/jquery-boilerplate/jquery-boilerplate
// require_tree ./plugins/
//= require plugins/address_picker
//= require plugins/checkbox_list
//= require plugins/city_autocomplete
//= require plugins/closer
//= require plugins/date_range
//= require plugins/drop_down
//= require plugins/dropped_options
//= require plugins/flash
//= require plugins/input_updaters
//= require plugins/read_more
//= require plugins/text_counter
//= require plugins/textarea_resizer
//= require plugins/toggler
//= require plugins/time_range

//= require_tree ./gmaps4rails/

$(function() {
    var global = GLOBAL.namespace('GLOBAL');
    $('[data-behavior=datepicker]').each(function() {
        $(this).datepicker({
            format: 'dd/mm/yyyy',
            weekStart: 1
        });
    });

    $('[data-behavior=datepicker-range]').each(function() {
        $(this).datepicker({
            format: 'dd/mm/yyyy',
            weekStart: 1
        });
        $(this).on('changeDate', function() {
            $(this).datepicker('hide');
        });
        if ($(this).data('end-range-el')) {
            var end_range = $($(this).data('end-range-el'));
            $(this).on('changeDate', function() {
                end_range.val(this.value);
                end_range.datepicker('show');
            });
         }
    });
    // global.Scroller = new Fx.Scroll($(document.body), {
    //     wait: false,
    //     duration: 500,
    //     transition: Fx.Transitions.Quad.easeInOut
    // });

    // -------------------------- Chosen

    $('[data-behavior=chosen]').each(function(select) {
        $(this).chosen();
    });

    // -------------------------- Modal handler
    // Options
    // ------- data:
    // ------------ width
    // ------------ title
    // ------------ el : ID refferring to the content of the modal
    // $$("[data-behavior=modal]").addEvent("click", function() {
    //     var width = parseInt(this.get('data-width')) || 500,
    //         title = this.get('data-title'),
    //         el    = $(this.get('data-el'));
    //         ajax  = this.get('data-url') !== null
    //     var modal = new SimpleModal({
    //         width: width,
    //         "onAppend": function() {
    //             $("simple-modal").fade("hide");
    //             setTimeout((function(){ $("simple-modal").fade("show")}), 200 );
    //             var tw = new Fx.Tween($("simple-modal"),{
    //               duration: 800,
    //               transition: Fx.Transitions.Cubic.easeOut,
    //               link: 'cancel',
    //               property: 'top'
    //             }).start(-400, 150);
    //         }
    //     });

    //   if (ajax) {
    //     modal.show({
    //         model: 'modal-ajax',
    //         title: title,
    //         param: {
    //             url: this.get('data-url')
    //         }
    //     });
    //   } else {
    //     modal.show({
    //         model: 'modal',
    //         title: title,
    //         contents: el.get('html')
    //     });
    //   }
    // });
    // $("[data-behavior=copy-to-clipboard]").each(function(index, element) {
    //     var clip = new ZeroClipboard(element);
    //     clip.on('click', function(client) {
    //         GLOBAL.flash('Votre texte à bien été copié');
    //     });
    // });
    $('[data-behavior=tooltip]').each(function(el) {
        $(this).tooltip();
    });

});
