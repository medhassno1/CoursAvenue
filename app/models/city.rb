# encoding: utf-8
class City < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :places
  has_many :structures, through: :structures
  has_many :courses   , through: :structures

  has_attached_file :no_result_image, :styles => {default: '900×600#'}

  validates :name            , presence: true
  validates :zip_code        , presence: true
  validates :region_name     , presence: true
  validates :department_name , presence: true
  validates :commune_name    , presence: true
  validates :latitude        , presence: true
  validates :longitude       , presence: true

  attr_accessible :name,
                  :no_result_image,
                  :iso_code,
                  :zip_code,
                  :region_name,
                  :region_code,
                  :department_name,
                  :department_code,
                  :commune_name,
                  :commune_code,
                  :latitude,
                  :longitude,
                  :acuracy

  def to_gmap_json
    {lng: self.longitude, lat: self.latitude}
  end

  def should_generate_new_friendly_id?
    new_record?
  end
end
