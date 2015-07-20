var SearchPageDispatcher = require('../dispatcher/SearchPageDispatcher'),
    SearchPageConstants  = require('../constants/SearchPageConstants'),
    ActionTypes          = SearchPageConstants.ActionTypes;

module.exports = {

    selectGroupSubjectById: function selectGroupSubjectById (subject_group_id) {
        SearchPageDispatcher.dispatch({
            actionType: ActionTypes.SELECT_GROUP_SUBJECT_BY_ID,
            data: parseInt(subject_group_id, 10) // Ensure it's an integer
        });
    },
    /*
     * subject_group: Hash as { group_id, name }
     */
    selectGroupSubject: function selectGroupSubject (subject_group) {
        SearchPageDispatcher.dispatch({
            actionType: ActionTypes.SELECT_GROUP_SUBJECT,
            data: subject_group
        });
    },

    /*
     * root_subject: Hash as { slug, name }
     */
    selectRootSubject: function selectRootSubject (root_subject) {
        SearchPageDispatcher.dispatch({
            actionType: ActionTypes.SELECT_ROOT_SUBJECT,
            data: root_subject
        });
    },

    /*
     * subject: Hash as { slug, name }
     */
    selectSubject: function selectSubject (subject) {
        SearchPageDispatcher.dispatch({
            actionType: ActionTypes.SELECT_SUBJECT,
            data: subject
        });
    }
};