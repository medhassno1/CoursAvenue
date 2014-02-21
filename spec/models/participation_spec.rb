# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Participation do

  context :waiting_list do
    let (:planning) { FactoryGirl.create(:planning) }
    before do
      subject.user = FactoryGirl.create(:user)
    end
    it 'goes' do
      planning.update_attribute(:nb_participants_max, 0)
      subject.planning = planning
      subject.save
      expect(subject.waiting_list).to be_true
    end

    it 'does not go' do
      planning.update_attribute(:nb_participants_max, 1)
      subject.planning = planning
      subject.save
      expect(subject.waiting_list).to be_false
    end
  end

  describe '#with_kid?' do
    it 'returns true' do
      subject.participation_for = 'participations.for.one_kid_and_one_adult'
      expect(subject.with_kid?).to be_true
    end

    it 'returns false' do
      subject.participation_for = 'participations.for.one_kid'
      expect(subject.with_kid?).to be_false
    end
  end

  describe '#size' do
    it 'returns 1' do
      subject.participation_for = 'participations.for.one_kid'
      expect(subject.size).to eq 1
    end

    it 'returns 1' do
      subject.participation_for = 'participations.for.one_adult'
      expect(subject.size).to eq 1
    end

    it 'returns 2' do
      subject.participation_for = 'participations.for.one_kid_and_one_adult'
      expect(subject.size).to eq 2
    end
  end

  describe '#canceled?' do
    it 'returns true' do
      expect(subject.canceled?).to be_false
    end

    it 'returns false' do
      subject.canceled_at = Time.now
      expect(subject.canceled?).to be_false
    end
  end

  describe '#cancel!' do
    it 'update canceled_at' do
      subject.user = FactoryGirl.create(:user)
      subject.cancel!
      expect(subject.canceled_at).not_to be_nil
    end
  end

  context :callbacks do
    let (:planning) { FactoryGirl.create(:planning) }

    describe '#set_waiting_list' do
      it 'set it to true' do
        planning.update_attribute(:nb_participants_max, 0)
        subject.planning             = planning
        subject.set_waiting_list
        expect(subject.waiting_list).to be_true
      end
      it 'set it to false' do
        planning.update_attribute(:nb_participants_max, 2)
        subject.planning = planning
        subject.set_waiting_list
        expect(subject.waiting_list).to be_false
      end
    end

    describe '#update_planning_participations_waiting_list' do
      it 'updates waiting_list if someone unsubscribe' do
        planning = FactoryGirl.create(:planning)
        planning.update_attribute(:nb_participants_max, 1)
        first_participation = planning.participations.create user: FactoryGirl.create(:user)
        last_participation  = planning.participations.create user: FactoryGirl.create(:user)
        first_participation.cancel!
        expect(last_participation.reload.waiting_list).to be_false
      end
    end
  end
end
