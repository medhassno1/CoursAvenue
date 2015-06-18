require 'rails_helper'

describe IndexableCard::Creator do
  let(:structure) { FactoryGirl.create(:structure_with_place) }

  describe '#initialize' do
    it do
      creator = IndexableCard::Creator.new(structure)
      expect(creator.structure).to eq(structure)
    end
  end

  describe '#create_cards' do
    subject { IndexableCard::Creator.new(structure) }

    it 'creates new cards' do
      expect { subject.create_cards; structure.reload }.
        to change { structure.indexable_cards.count }
    end
  end

  describe '#update_cards' do
    subject { IndexableCard::Creator.new(structure) }

    context 'when there are no cards' do
      it 'creates new cards' do
        expect { subject.create_cards; structure.reload }.
          to change { structure.indexable_cards.count }
      end
    end

    context 'when there are cards' do
      let(:new_subject)  { FactoryGirl.create(:subject_with_grand_parent) }
      let(:new_course)   { FactoryGirl.create(:course, structure: structure) }
      let(:new_place)    { FactoryGirl.create(:place, structure: structure) }
      let(:new_planning) { FactoryGirl.create(:planning, course: new_course, place: new_place) }

      before do
        subject.create_cards
      end

      context "when there's a new course" do
        it 'creates a new card' do
          new_planning
          structure.reload

          expect { subject.update_cards }.
            to change { structure.indexable_cards.with_courses.count }.by(1)
        end

        it 'associates the new card with the course plannings'
      end

      context "when there are new subjects and places" do
        before do
          structure.places << new_place
          structure.reload
        end

        it 'creates a new card' do
          expect { subject.update_cards; structure.reload }.
            to change { structure.indexable_cards.count }.by(1)
        end

        it 'associates the new card with the place' do
          cards = subject.update_cards
          expect(cards.first.place).to eq(new_place)
        end
      end
    end
  end
end
