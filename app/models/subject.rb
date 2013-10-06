class Subject < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged
  # friendly_id :name, use: [:slugged, :history]

  acts_as_tree cache_depth: true

  has_attached_file :image,
                    :styles => { super_wide: "825x250#", wide: "600x375#", thumb: "200x200#" }

  has_and_belongs_to_many :courses
  has_and_belongs_to_many :structures

  attr_accessible :name, :short_name, :image, :info, :parent, :position

  validates :name, presence: true
  validates :name, uniqueness: {scope: 'ancestry'}

  scope :children,               where{ancestry != nil}
  scope :little_children,        where{ancestry_depth == 2}
  scope :roots_with_position,    where{(ancestry == nil) & (position != nil)}
  scope :roots_without_position, where{(ancestry == nil) & (position == nil)}

  def little_children
    self.descendants.at_depth(2)
  end

  def grand_parent
    if parent and parent.parent
      parent.parent
    elsif parent
      parent
    else
      nil
    end
  end

  def as_json(options = {})
    {
      id:          self.id,
      name:        self.name,
      parent_name: self.parent.try(:name)
    }
  end
end
