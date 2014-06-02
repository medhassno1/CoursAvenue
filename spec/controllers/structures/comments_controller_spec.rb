# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Structures::CommentsController do

  let(:structure) { FactoryGirl.create(:structure_with_admin) }

  describe '#new' do
    it 'returns 200' do
      get :new, structure_id: structure.id
      expect(response.status).to eq 200
    end
  end

  describe '#create' do
    it 'raises an error if commentable_type is incorrect' do
      expect do
        post :create, structure_id: structure.id,
                      comment: {
                    commentable_type: 'FakeModel',
                    commentable_id: structure.id,
                    author_name: 'Author name',
                    title:       'Title',
                    course_name: 'Course name',
                    content:     'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,',
                    email:       'random@test.com'
                  }
      end.to raise_error
    end

    it 'creates a comment' do
      post :create, structure_id: structure.id,
                    comment: {
                    commentable_type: 'Structure',
                    commentable_id: structure.id,
                    author_name: 'Author name',
                    title:       'Title',
                    course_name: 'Course name',
                    content:     'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,',
                    email:       'random@test.com'
                  }
      response.should be_redirect
      assigns(:comment).should be_persisted
    end

    it 'creates a user' do
      post :create, structure_id: structure.id,
                    comment: {
                    commentable_type: 'Structure',
                    commentable_id: structure.id,
                    author_name: 'Author name',
                    title:       'Title',
                    course_name: 'Course name',
                    content:     'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,',
                    email:       'random@test.com'
                  }
      response.should be_redirect
      assigns(:comment).should be_persisted
    end

    context 'I change my email address' do
      it 'changes the email of the user' do
        User.delete_all
        user = FactoryGirl.create(:user)
        post :create, structure_id: structure.id,
                      comment: {
                        commentable_type: 'Structure',
                        commentable_id:    structure.id,
                        author_name:       'Author name',
                        title:             'Title',
                        course_name:       'Course name',
                        content:           'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,',
                        email:             'random@test.com'
                      },
                      default_email: user.email
        response.should be_redirect
        assigns(:comment).user.email.should eq 'random@test.com'
      end
    end
    context 'I add a private message' do
      it 'sends a private message' do
        structure.main_contact.messages.should be_empty
        post :create, structure_id: structure.id,
                      comment: {
                        commentable_type: 'Structure',
                        commentable_id:    structure.id,
                        author_name:       'Author name',
                        title:             'Title',
                        course_name:       'Course name',
                        content:           'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,',
                        email:             'random@test.com'
                      },
                      private_message: 'lorem'
        response.should be_redirect
        assigns(:conversation).should be_persisted
      end
    end
  end
end