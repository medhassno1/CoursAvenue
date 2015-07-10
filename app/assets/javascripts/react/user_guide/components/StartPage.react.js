var QuestionActionCreators = require('../actions/QuestionActionCreators');

var StarPage = React.createClass({
    propTypes: {
        title:          React.PropTypes.string.isRequired,
        description:    React.PropTypes.string.isRequired,
        call_to_action: React.PropTypes.string.isRequired
    },

    start: function start (event) {
        event.preventDefault();
        QuestionActionCreators.nextQuestion();
    },

    render: function render () {
        return (
            <div className='section relative one-whole relative white full-screen-item bg-cover'>
              <div className='flexbox full-screen-item soft'>
                <div className='black-curtain north west one-whole absolute'></div>
                <div className='push--top soft--top one-whole flexbox__item'>
                  <div className='v-middle relative'>
                    <h1 className='flush soft--top text--center f-size-really-big'>
                      { this.props.title }
                    </h1>
                    <hr className=' push-half--ends main-container main-container--medium' />
                    <div className='text--center'>
                      <a onClick={ this.start } className='btn--yellow btn btn--enormous'>
                        { "C'est parti !" }
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
        );
    },
});

module.exports = StarPage;
