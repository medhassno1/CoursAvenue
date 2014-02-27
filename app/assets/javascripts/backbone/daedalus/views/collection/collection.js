/* Collection
 * ----------
 *
 * This module encapsulates construction of the basic Marionette CollectionView.
 * The basic Collection module is for those times when you want a collection, and
 * you have the data, but you only want to supply a template or an itemview implementation.
 * When the collection would just be a basic Marionette Collection.
 *
 * Normally as soon as your itemviews need to communicate with other views on the page,
 * you should stop using the base collection and implement a proper collection view.
 * This is because the collection view announces events to the View Module, not the
 * itemview.
 *
 * **data API**
 *
 *  - _view_: Collection
 *  - _of_: a capitalized name of some resource, in the plural, like "Teachers" or
 *    "Courses".
 *  - _bootstrap_: The data to populate the collection on page load.
 *  - _template_: a template to be used in place of the default. The template must
 *    live in a folder named like views/widgets/templates/
 *
 *  In addition to the above options, you can provide "sample" markup that will
 *  be used by the Collection to decide its tagName/className, and by the ItemView
 *  if a vanilla itemview is used.
 *
 * **usage**
 *
 * Without sample markup.
 *
 * ```
 * #structure-tabs{ data: { view: "Collection", of: "Teachers", bootstrap: @model.to_json }
 * ```
 *
 *  With sample markup for CollectionView and ItemView.
 *
 * ```
 * #structure-tabs{ data: { view: "Collection", of: "Teachers", bootstrap: @model.to_json }
 *   %ul.some-classes{ data: { tagName: true }}
 *     %li.another-class{ data: { itemviewTagName: true }}
 * ```
 */
Daedalus.module('Views.Collection', function(Module, App, Backbone, Marionette, $, _, undefined) {
    this.startWithParent = false;

    Module.Collection = Marionette.CollectionView;

    // a function to run when it is determined that this module will be used. Creates
    // a TabManager view object for each element with data-view=TabManager.
    Module.addInitializer(function () {
        $("[data-view=Collection]").each(function (index, element) {
            var $element     = $(element),
                view         = $element.data("view"), // the name of the constructor
                bootstrap    = $element.data("bootstrap"), // data for the collection
                flavor       = $element.data("flavor"), // a sub class
                resource     = $element.data("of"), // used for template name, model name, etc...
                sample_tag   = $element.find("[data-sample-tag]")[0],
                sample_item  = $element.find("[data-sample-item]")[0],
                template     = $element.data("template")? Module.templateDirname() + $element.data("template") : undefined,
                view, region_name, regions ={},
                $children    = $element.children().children();

            view = buildView(view, flavor, {
                template:      template,
                bootstrap:     bootstrap,
                resource:      resource,
                tag:           sample_tag,
                itemview_tag:  sample_item,
                $children:      $children
            }),

            region_name  = 'Collection' + _.capitalize(view.cid),

            regions[region_name] = "#" + view.cid;
            $element.attr("id", view.cid);

            App.addRegions(regions);
            App[region_name].show(view);

            consumeData($element);

            /* view registers to be notified of events on layout */
            Marionette.bindEntityEvents(view, App.Views, { });
            App.Views.listenTo(view, 'all', App.Views.broadcast);
        });
    });

    var consumeData = function consumeData ($element) {
        $element.removeAttr("data-view");
        $element.removeAttr("data-bootstrap");
        $element.removeAttr("data-of");
    };

    /* ***
     * the generic collection will try to use the resource name to find
     * existing collections, templates, and itemViews. If given the name
     * "Widgets" is till look for,
     *
     *     a collection in /model/widgets.js
     *     an itemView  in /views/widgets/widget
     *     a template   in /views/widgets/templates/widget
     *
     * failing to find any of these, the collection will use a plain
     * collection or itemView. If it fails to find a template it will
     * complain.
     */
    var buildView = function buildView (view, flavor, options) {
        // buildView adds some attributes commonly used in templates

        var result,
            // Widgets might have a model/widgets collection or a views/widgets/widget itemview
            resources      = options.resource.toLowerCase(),
            resource       = _.singularize(resources),
            template_name  = (options.template)? options.template : resource,
            Collection, ItemView, collection,
            itemview_options = {};

        // build up the tagNames and classNames from the sample
        if (options.tag) {
            options.tagName   = options.tag.nodeName.toLowerCase();
            options.className = options.tag.className;
        }

        if (options.itemview_tag) {
            itemview_options.tagName   = options.itemview_tag.nodeName.toLowerCase();
            itemview_options.className = options.itemview_tag.className;
        }

        if (_.isString(options.bootstrap)) {
            options.bootstrap = window.coursavenue.bootstrap[options.bootstrap];
        }

        Collection = App.Models[resources] || Backbone.Collection.extend();
        collection = new Collection(options.bootstrap || {});

        // if there is a custom itemView, use that
        if (App.Views[_.capitalize(resources)] && App.Views[_.capitalize(resources)][_.capitalize(resource)]) {
            ItemView = App.Views[_.capitalize(resources)][_.capitalize(resource)];
        } else {
            ItemView = Marionette.ItemView;
        }

        // if we are using a generic item view, extend it to use the template
        itemview_options.template = 'backbone/structure_profile/views/' + resources + '/templates/' + template_name;
        ItemView                  = ItemView.extend(itemview_options);

        options.collection          = collection;
        options.itemView            = ItemView;
        options.itemViewEventPrefix = "";

        return new Module.Collection(options);
    };

}, undefined);


