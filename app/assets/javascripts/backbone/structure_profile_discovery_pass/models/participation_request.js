/* just a basic backbone model */
StructureProfileDiscoveryPass.module('Models', function(Module, App, Backbone, Marionette, $, _) {

    Module.ParticipationRequest = Backbone.Model.extend({
        // We override the toJSON function to have all the params grouped into
        // `participation_request` when syncing to server
        toJSON: function toJSON () {
            return { participation_request: _.clone( this.attributes ) }
        },

        validation: {
            'message.body': {
                required: true,
                msg: 'Vous devez remplir un message'
            },
            course_id: {
                required: true,
                msg: 'Vous devez sélectionner un cours'
            },
            planning_id: {
                required: true,
                msg: 'Vous devez sélectionner un créneau'
            },
            'user.phone_number': {
                maxLength: 20,
                msg: 'Mauvais format'
            }
        },

        initialize: function initialize () {
            var prefilled_body = 'Bonjour,\n\n' +
                                 "Je souhaiterais m'inscrire pour une séance d'essai. " +
                                 "Pouvez-vous me confirmer le jour et le créneau, et m'envoyer toute information utile (tenue exigée, digicode, adresse, etc.) ?\n\n" +
                                 'Merci et à très bientôt !';
            this.set('message', { body: prefilled_body } );
        },

        url: function url () {
            return Routes.structure_participation_requests_path({ structure_id: this.get('structure_id') });
        }
    });
});