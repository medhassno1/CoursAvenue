# encoding: utf-8
class Place < ActiveRecord::Base
  acts_as_paranoid

  include ActsAsGeolocalizable

  geocoded_by      :geocoder_address

  ######################################################################
  # Validations                                                        #
  ######################################################################
  validates :name, :street, :zip_code, :city_id , presence: true

  ######################################################################
  # Relations                                                          #
  ######################################################################
  belongs_to :city
  belongs_to :location, touch: true # TODO: remove after V1 deploy
  belongs_to :structure

  has_many :contacts, as: :contactable, dependent: :destroy
  has_many :plannings, dependent: :destroy

  ######################################################################
  # Callbacks                                                          #
  ######################################################################
  after_save :reindex_structure_and_places
  after_save :geocode_if_needs_to

  ######################################################################
  # Scopes                                                             #
  ######################################################################
  scope :publics,                -> { where( type: 'Place::Public' ) }
  scope :homes,                  -> { where( type: 'Place::Home' ) }

  accepts_nested_attributes_for :contacts,
                                reject_if: lambda {|attributes| attributes.values.compact.reject(&:blank?).empty?},
                                allow_destroy: true

  attr_accessible :name, :type, :location, :structure, :contacts,
                  :info, :private_info,
                  :contacts_attributes,
                  :street, :zip_code, :city, :city_id,
                  :latitude, :longitude, :gmaps, :radius

  def main_contact
    self.contacts.first
  end

  def parisian?
    return false if zip_code.nil?
    return self.zip_code.starts_with? '75','77','78','91','92','93','94','95'
  end

  def to_gmap_json
    { lng: self.longitude, lat: self.latitude }
  end

  def is_home?
    false
  end

  private

  # Only geocode if :
  #     - lat and lng are nil
  #     - lat and lng didn't change but address changed
  def geocode_if_needs_to
    if (latitude.nil? and longitude.nil?) or (!latitude_changed? and !longitude_changed? and street_changed? and zip_code_changed?)
      self.geocode
      self.save(validate: false)
    end
  end

  def reindex_structure_and_places
    self.structure.delay.index if self.structure
    self.plannings.map{ |planning| planning.delay.index }
  end

end
