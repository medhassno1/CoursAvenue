var _           = require('underscore'),
  SubjectStore  = require('../stores/AnswerStore'),
  MainSubject   = require('./results/MainSubject'),
  SubjectList   = require('./results/SubjectList'),
  CourseSearch  = require('./results/CourseSearch'),
  FluxBoneMixin = require('../../mixins/FluxBoneMixin');

var Results = React.createClass({
    mixins: [
        FluxBoneMixin(['subject_store'])
    ],

    getInitialState: function getInitialState () {
        return { subject_store: SubjectStore };
    },

    render: function render () {
      // The store is sorted in ASC order on the score.
      var main_subject   = SubjectStore.last(); // The last.
      var other_subjects = SubjectStore.initial(); // Everything but the last.

      return (
          <div className='section relative one-whole relative white full-screen-item bg-cover'>
              <MainSubject subject={ main_subject } />
              <CourseSearch subject={ main_subject } />
              <SubjectList subjects={ other_subjects } />
          </div>
      );
    },
});

module.exports = Results;
