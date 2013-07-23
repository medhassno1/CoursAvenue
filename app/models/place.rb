# encoding: utf-8
class Place < ActiveRecord::Base
  acts_as_paranoid recover_dependent_associations: false

  include ActsAsGeolocalizable
  include HasSubjects

  acts_as_gmappable validation: false,
                    language: 'fr'
  before_save :retrieve_address

  extend FriendlyId
  friendly_id :long_name, use: :slugged

  belongs_to :city,                 touch: true
  belongs_to :structure,            touch: true
  has_many   :reservations,         as: :reservable
  has_many   :courses,              dependent: :destroy
  # has_many   :rooms
  has_many   :comments, through: :structure
  # has_many   :subjects, through: :courses

  has_and_belongs_to_many :users

  validates  :name     , presence: true
  validates  :street   , presence: true
  validates  :city     , presence: true
  validates  :zip_code , presence: true, numericality: { only_integer: true }
  validates  :structure, presence: true

  has_attached_file :image,
                    :styles => { wide: "800x480#", thumb: "200x200#" }

  has_attached_file :thumb_image,
                    :styles => { wide: "400x400#", thumb: "200x200#" }

  after_save :delay_subscribe_to_mailchimp if Rails.env.production?
  after_touch :reindex

  # To be able to delete images in view
  attr_reader :delete_image
  attr_reader :delete_thumb_image
  attr_accessible :name,
                  :street, :zip_code, :city, :city_id,
                  :latitude, :longitude, :gmaps,
                  :contact_email, :contact_name, :contact_phone, :contact_mobile_phone,
                  :description,
                  :info, # Digicode, etc.
                  :has_handicap_access,
                  :image, :thumb_image,
                  :has_handicap_access, :has_cloackroom, :has_internet, :has_air_conditioning, :has_swimming_pool, :has_free_parking, :has_jacuzzi, :has_sauna, :has_daylight

  # ------------------------------------------------------------------------------------ Search attributes
  searchable do

    text :name, boost: 5 do
      self.long_name
    end

    text :teachers do
      self.structure.teachers.map(&:name)
    end

    text :description

    # text :street

    # text :course_names do
    #   courses.map(&:name)
    # end

    text :subjects, boost: 5 do
      subject_array = []
      self.subjects.uniq.each do |subject|
        subject_array << subject
        subject_array << subject.parent
      end
      subject_array.uniq.map(&:name)
    end

    # string :street

    latlon :location do
      Sunspot::Util::Coordinates.new(self.latitude, self.longitude)
    end

    integer :subject_ids, multiple: true do
      subject_ids = []
      self.subjects.uniq.each do |subject|
        subject_ids << subject.id
        subject_ids << subject.parent.id
      end
      subject_ids.uniq
    end

    string :subject_slugs, multiple: true do
      subject_slugs = []
      self.subjects.uniq.each do |subject|
        subject_slugs << subject.slug
        subject_slugs << subject.parent.slug
      end
      subject_slugs.uniq
    end

    boolean :active do
      self.structure.active
    end

    double :rating do
      self.structure.rating
    end

    integer :nb_courses do
      courses.count
    end
    integer :nb_comments do
      self.comments.count
    end
    boolean :has_comment do
      self.comments.count > 0
    end
    boolean :has_picture do
      self.image.present? or self.structure.image.present?
    end
  end

  handle_asynchronously :solr_index

  def subjects
    structure.subjects
  end

  def description
    if read_attribute(:description).present?
      read_attribute(:description)
    else
      structure.description
    end
  end

  # Return name of the place with structure name
  def long_name
    if self.name == self.structure.try(:name)
      self.name
    elsif self.name == 'Adresse principale' and self.structure
      self.structure.name
    elsif self.structure # Prevents from nil when submiting with an image
      "#{self.structure.name} - #{self.name}"
    else
      self.name
    end
  end

  def to_gmap_json
    {lng: self.longitude, lat: self.latitude}
  end

  # # Return structure contact email if self is not present
  def contact_email
    if read_attribute(:contact_email).present?
      read_attribute(:contact_email)
    else
      self.structure.contact_email
    end
  end

  # Return structure contact name if self is not present
  def contact_name
    if read_attribute(:contact_name).present?
      read_attribute(:contact_name)
    else
      self.structure.contact_name
    end
  end

  # Return structure contact phone if self is not present
  def contact_phone
    if read_attribute(:contact_phone).present?
      read_attribute(:contact_phone)
    else
      self.structure.phone_number
    end
  end

  def contact_mobile_phone
    if read_attribute(:contact_mobile_phone).present?
      read_attribute(:contact_mobile_phone)
    else
      self.structure.mobile_phone_number
    end
  end

  def should_generate_new_friendly_id?
    new_record?
  end

  private

  def reindex
    self.index
  end

  def delay_subscribe_to_mailchimp
    self.delay.subscribe_to_mailchimp
  end

  def subscribe_to_mailchimp
    Gibbon.list_subscribe({:id => CoursAvenue::Application::MAILCHIMP_TEACHERS_LIST_ID,
                           :email_address => self.contact_email,
                           :merge_vars => {
                              :NAME => self.long_name,
                              :STATUS => (self.structure.admins.count > 0 ? 'registered' : 'not registered')
                           },
                           :double_optin => false,
                           :update_existing => true,
                           :send_welcome => false})
  end
end
