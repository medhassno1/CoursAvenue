var _                    = require('lodash'),
    Backbone             = require('backbone'),
    AlgoliaSearchUtils   = require('../utils/AlgoliaSearchUtils'),
    FilterStore          = require('./FilterStore'),
    SearchPageDispatcher = require('../dispatcher/SearchPageDispatcher'),
    SearchPageConstants  = require('../constants/SearchPageConstants'),
    ActionTypes          = SearchPageConstants.ActionTypes;

var SubjectAutocompleteStore = Backbone.Collection.extend({
    model: Backbone.Model.extend({}),

    initialize: function initialize () {
        _.bindAll(this, 'dispatchCallback');
        this.dispatchToken = SearchPageDispatcher.register(this.dispatchCallback);
    },

    dispatchCallback: function dispatchCallback (payload) {
        switch(payload.actionType) {
            case ActionTypes.SELECT_SUBJECT:
                this.full_text_search = '';
                this.trigger('change');
                break;
            case ActionTypes.SEARCH_FULL_TEXT:
                this.full_text_search = payload.data;
                this.searchSubjects();
                break;
        }
    },

    searchSubjects: function searchSubjects () {
        var data = { hitsPerPage: 15, facets: '*'}
        AlgoliaSearchUtils.searchSubjects(data, this.full_text_search).then(function(content){
            this.reset(content.hits);
            this.trigger('change');
        }.bind(this)).catch(function(error) {
            this.error   = true;
            this.trigger('change');
        }.bind(this));
    },

});

// the Store is an instantiated Collection; a singleton.
module.exports = new SubjectAutocompleteStore();
