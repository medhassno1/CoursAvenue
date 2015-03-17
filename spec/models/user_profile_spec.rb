# -*- encoding : utf-8 -*-
require 'rails_helper'

describe UserProfile do
  let(:structure)            { FactoryGirl.create(:structure) }
  let(:structure_with_admin) { FactoryGirl.create(:structure) }

  describe '#associate_to_user_or_create' do
    let(:user)      { FactoryGirl.create(:user) }

    it 'associates to existing user if exists' do
      user_profile = structure.user_profiles.build(email: user.email)
      user_profile.send(:associate_to_user_or_create)
      expect(user_profile.user).to eq user
    end

    it 'creates user if does not exists' do
      user_profile = structure.user_profiles.build(email: 'does-not@exists.com')
      user_profile.send(:associate_to_user_or_create)
      expect(user_profile.user.persisted?).to be_truthy
    end
  end

  describe '#full_name' do
    it 'contains the first_name' do
      user_profile = UserProfile.new first_name: 'First Name', last_name: 'Last Name'
      expect(user_profile.full_name).to include 'First Name'
    end
    it 'contains the last_name' do
      user_profile = UserProfile.new first_name: 'First Name', last_name: 'Last Name'
      expect(user_profile.full_name).to include 'Last Name'
    end
  end

  context :bulk_actions do
    class UserProfile
      def some_work(number, symbol, range)
      end
    end

    let(:ids) { structure.user_profiles.to_a.map(&:id) }

    it "calls the given method, with the correct args" do
      pending "I don't know how to implement message expectations on class methods..."
      ["bob@email.com", "paul@email.com", "jill@email.com"].each do |email|
        structure.user_profiles.create(email: email);
      end
      # with block
      expect_any_instance_of(UserProfile).to receive(:some_work) do |*args|
        expect(args).to eq(["1", :cat, (1..2)])
      end

      UserProfile.perform_bulk_job(ids, :some_work, "1", :cat, (1..2))
    end
  end

  describe '#batch_create' do
    it 'creates 2 user profile' do
      emails = 'lala@lala.com lala2@lala.com lalaiswrong.com'
      mocked_message = Mail::Message.new
      # Prevent from sending email
      allow(AdminMailer).to receive(:import_batch_user_profiles_finished).and_return(mocked_message)
      allow(mocked_message).to receive(:deliver).and_return(nil)
      expect { UserProfile.batch_create(structure, emails) }.to change { structure.user_profiles.count }.by(2)
    end
  end
end
