class Metro::Stop < ActiveRecord::Base
  include AlgoliaSearch
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  reverse_geocoded_by :latitude, :longitude

  has_and_belongs_to_many :lines, class_name: 'Metro::Line'

  attr_accessible :name, :description, :latitude, :longitude

  validates :name,      presence: true
  validates :latitude,  presence: true
  validates :longitude, presence: true

  # TODO: Enable indexing when it will be needed.
  # :nocov:
  algoliasearch per_environment: true, disable_indexing: Rails.env.test? do
    attribute :id
    attribute :slug
    attribute :name
    attribute :description

    add_attribute :_geoloc do
      { lat: self.latitude, lng: self.longitude }
    end

    add_attribute :metro_lines do
      self.lines.map(&:slug)
    end
  end
  # :nocov:
end
