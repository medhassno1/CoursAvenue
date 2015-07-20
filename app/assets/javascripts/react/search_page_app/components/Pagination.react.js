var CardStore             = require('../stores/CardStore'),
    CardActionCreators    = require("../actions/CardActionCreators"),
    cx                    = require('classnames/dedupe'),
    FluxBoneMixin         = require("../../mixins/FluxBoneMixin"),
    PAGINATION_RADIUS     = 2;

var Pagination = React.createClass({

    mixins: [
        FluxBoneMixin('card_store')
    ],

    getInitialState: function getInitialState() {
        return { card_store: CardStore };
    },

    /*
     * Return closure function
     */
    goToPage: function goToPage (page) {
        return function() {
            if (_.isUndefined(page)) { return; }
            $.scrollTo(0, { easing: 'easeOutCubic', duration: 500 });
            CardActionCreators.goToPage(page);
        }
    },

    goToPreviousPage: function goToPreviousPage () {
        if (this.state.card_store.isFirstPage()) { return; }
        $.scrollTo(0, { easing: 'easeOutCubic', duration: 500 });
        CardActionCreators.goToPreviousPage();
    },

    goToNextPage: function goToNextPage () {
        if (this.state.card_store.isLastPage()) { return; }
        $.scrollTo(0, { easing: 'easeOutCubic', duration: 500 });
        CardActionCreators.goToNextPage();
    },

    /* we want to show buttons for the first and last pages, and the
     * pages in a radius around the current page. So we will skip pages
     * that don't meet that criteria */
    canSkipPage: function canSkipPage (page) {
        var current_page  = this.state.card_store.current_page,
            last_page     = this.state.card_store.total_pages,
            out_of_bounds = (current_page - PAGINATION_RADIUS > page || page > current_page + PAGINATION_RADIUS),
            bookend       = (page == 1 || page == last_page);

        return (!bookend && out_of_bounds);
    },

    /* the query_strings are built in the paginated collection view */
    buildPaginationButtons: function buildPaginationButtons () {
        var skipped = false,
            buttons = [];

        _.times(this.state.card_store.total_pages, function(index) {
            var current_page = index + 1;

            if (this.canSkipPage(current_page)) { // 1, ..., 5, 6, 7, ..., 9
                skipped = true;
            } else {
                if (skipped) { // push on an ellipsis if we've skipped any pages
                    buttons.push({ label: '...', disabled: true });
                }

                buttons.push({ // push the current page
                    label: current_page,
                    page:  current_page,
                    active: (current_page == current_page)
                    //query: (data.query_strings ? data.query_strings[current_page] : '')
                });

                skipped = false;
            }
        }.bind(this));

        return buttons;
    },

    render: function render () {
        var back_class = cx('pagination__prev', { 'visibility-hidden': this.state.card_store.isFirstPage() });
        var next_class = cx('pagination__next', { 'visibility-hidden': this.state.card_store.length == 0 || this.state.card_store.isLastPage() });
        var buttons = _.map(this.buildPaginationButtons(), function(button, index) {
            var button_classes = cx('pagination__page',
                                    { 'pagination__page--active': (this.state.card_store.current_page == button.page),
                                      'pagination__page--disabled': button.disabled });
            return (<a className={button_classes}
                        key={index}
                        href="javascript:void(0)"
                        onClick={this.goToPage(button.page)}>
                        {button.label}
                    </a>);
        }.bind(this));
        return (
          <div className="main-container main-container--1000">
              <div className="flexbox pagination pagination--large">
                  <div className="flexbox__item">
                      <a className={back_class}
                         href="javascript:void(0)"
                         onClick={this.goToPreviousPage}>
                         <i className="fa fa-chevron-left"></i>
                         Précédent
                      </a>
                  </div>
                  <div className="flexbox__item nowrap text--center">
                      {buttons}
                  </div>
                  <div className="flexbox__item text--right">
                      <a className={next_class}
                         href="javascript:void(0)"
                         onClick={this.goToNextPage}>
                         Suivant
                         <i className="fa fa-chevron-right"></i>
                      </a>
                  </div>
              </div>
          </div>
        );
    }
});

module.exports = Pagination;