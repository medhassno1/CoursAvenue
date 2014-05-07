class Subject < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  acts_as_tree cache_depth: true

  ######################################################################
  # Relations                                                          #
  ######################################################################
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :structures
  has_and_belongs_to_many :users
  has_and_belongs_to_many :comments
  has_and_belongs_to_many :medias

  has_many :passions
  has_many :city_subject_infos

  ######################################################################
  # Validations                                                        #
  ######################################################################
  validates :name, presence: true
  validates :name, uniqueness: {scope: 'ancestry'}

  ######################################################################
  # Scopes                                                            #
  ######################################################################
  scope :children,               -> { where{ancestry != nil} }
  scope :little_children,        -> { where{ancestry_depth == 2} }
  scope :roots_with_position,    -> { where{(ancestry == nil) & (position != nil)} }
  scope :roots_without_position, -> { where{(ancestry == nil) & (position == nil)} }
  scope :stars,                  -> { where{position < 10}.order('position ASC') }
  scope :roots_not_stars,        -> { where{(position >= 10) & (ancestry == nil)}.order('position ASC') }

  attr_accessible :name, :short_name, :info, :parent, :position, :title, :subtitle, :description, :image,
                  :good_to_know, :needed_meterial, :tips, :ancestry
  has_attached_file :image,
                    :styles => { super_wide: "825x250#", wide: "600x375#", small: '250x200#', thumb: "200x200#" }

  # Tells wether the given subject is a descendant of self by checking its ancestry string
  # @param  subject [type] [description]
  #
  # @return Boolean
  def descendant_of?(supposed_root)
    return false if self.ancestry.blank? or supposed_root.nil?
    _ancestor_ids = self.ancestor_ids
    if supposed_root.is_a? Array
      return supposed_root.find{|_supposed_root| _ancestor_ids.include?(_supposed_root.id) } || false
    else
      return _ancestor_ids.include? supposed_root.id
    end
  end

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
      parent_name: self.parent.try(:name),
      slug:        self.slug
    }
  end

  def good_to_know
    if read_attribute(:good_to_know).nil? and self.parent
      self.parent.good_to_know
    else
      read_attribute(:good_to_know)
    end
  end

  def needed_meterial
    if read_attribute(:needed_meterial).nil? and self.parent
      self.parent.needed_meterial
    else
      read_attribute(:needed_meterial)
    end
  end

  def tips
    if read_attribute(:tips).nil? and self.parent
      self.parent.tips
    else
      read_attribute(:tips)
    end
  end
end
