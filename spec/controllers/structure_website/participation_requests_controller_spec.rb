# -*- encoding : utf-8 -*-
require 'rails_helper'
require 'stripe_mock'

describe StructureWebsite::ParticipationRequestsController, type: :controller do
  before(:all) { StripeMock.start }
  after(:all)  { StripeMock.stop }

  let (:stripe_helper)         { StripeMock.create_test_helper }
  let (:participation_request) { FactoryGirl.create(:participation_request) }
  let (:structure)             { FactoryGirl.create(:structure_with_admin) }
  let (:user)                  { FactoryGirl.create(:user) }
  let (:planning)              { FactoryGirl.create(:planning) }
  let(:token)                  { stripe_helper.generate_card_token }

  before(:each) do
    @request.host = "#{participation_request.structure.slug}.example.com"
  end

  describe '#create', with_mail: true do
    before(:each) do
      request.env["HTTP_ACCEPT"] = 'application/json'
    end
    context 'when resource is found' do
      it 'creates a participation_request' do
        post :create, { participation_request: {
                          planning_id: planning.id,
                          date: Date.tomorrow.to_s,
                          structure_id: structure.id,
                          message: {
                            body: 'Lorem'
                          },
                          user: {
                            phone_number: '021402104',
                            name: 'Lorem',
                            email: 'lorem@ipsum.com'
                          }
                        }
        }
        expect(assigns(:participation_request)).to be_persisted
      end

      it 'creates a user' do
        post :create, { participation_request: {
                          structure_id: structure.id,
                          message: {
                            body: 'Lorem'
                          },
                          user: {
                            phone_number: '021402104',
                            name: 'Lorem',
                            email: 'lorem@ipsum.com'
                          }
                        }
        }
        expect(assigns(:user)).to be_persisted
        expect(assigns(:user).email).to eq 'lorem@ipsum.com'
        expect(assigns(:user).phone_number).to eq '021402104'
        expect(assigns(:user).first_name).to eq 'Lorem'
      end

      it 'creates a stripe customer for the user' do
        post :create, { participation_request: {
                          structure_id: structure.id,
                          stripe_token: token,
                          message: {
                            body: 'Lorem'
                          },
                          user: {
                            phone_number: '021402104',
                            name: 'Lorem',
                            email: 'lorem@ipsum.com'
                          }
                        }
        }

        expect(assigns(:user).stripe_customer).to_not be_nil
      end

      it 'updates existing user' do
        post :create, { participation_request: {
                          structure_id: structure.id,
                          message: {
                            body: 'Lorem'
                          },
                          user: {
                            phone_number: '021402104',
                            name: 'Lorem',
                            email: user.email
                          }
                        }
        }
        expect(assigns(:user).id).to eq user.id
        expect(assigns(:user).phone_number).to eq '021402104'
        expect(assigns(:user).first_name).to eq 'Lorem'
      end
    end
  end

  describe '#show' do
    it 'finds the participation_request' do
      get :show, id: participation_request.token
      expect(response.status).to eq 200
    end

    it 'redirects because only ID was given' do
      get :show, id: participation_request.id
      expect(response.status).to eq 302
    end
  end

end