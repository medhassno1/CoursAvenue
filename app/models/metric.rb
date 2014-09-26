# encoding: utf-8
class Metric
  include Mongoid::Document
  include Mongoid::Timestamps

  ACTION_TYPES = %w(impression view action)

  ######################################################################
  # Model definition                                                   #
  ######################################################################

  field :structure_id    , type: Integer
  field :action_type     , type: String
  field :user_fingerprint, type: String
  field :infos           , type: String

  field :ip_address      , type: String
  field :deleted_at      , type: DateTime

  ######################################################################
  # Scopes                                                             #
  ######################################################################

  scope :impressions,          -> { where( action_type: 'impression') }
  scope :views,                -> { where( action_type: 'view') }
  scope :actions,              -> { where( action_type: 'action') }
  scope :structure_go_premium, -> { where( action_type: /structure_go_premium_/) }

  ######################################################################
  # Creation and migration methods                                     #
  ######################################################################

  # Migrate the statistics from a structure to if it hasn't already been done.
  # @param structure The structure to migrate
  #
  # @return Nothing
  def self.migrate_statistics_from_structure(structure)
    if structure.metrics.count == 0 && structure.statistics.count != 0
      structure.statistics.each do |stat|
        Metric.create_from_statistic(stat)
      end
    end
  end

  # Copies a Statistic to a Metric
  # @param statistic The original Statistic
  #
  # @return The Metric created
  def self.create_from_statistic(statistic)
    Metric.create(structure_id:      statistic.structure_id,
                   action_type:      statistic.action_type,
                   user_fingerprint: statistic.user_fingerprint,
                   infos:            statistic.infos,
                   ip_address:       statistic.ip_address,
                   created_at:       statistic.created_at)
  end

  # Creates a statistic when a structure appears in the results of a search
  # @param structure_id Integer Structure id that appeared in the search
  # @param user User who searched for it
  # @param fingerprint String, Fingerprint (hash) generated client side to identify a unique user
  # @param infos=nil String, more info on the stat
  #
  # @return Metric
  def self.print(structure_id, user, fingerprint, ip_address, infos=nil)
    Metric.create(action_type: 'impression', structure_id: structure_id, user_fingerprint: fingerprint, ip_address: ip_address)
  end

  # Creates a statistic when a structure has been viewed (#show action)
  # @param structure_id Integer Structure id that appeared in the search
  # @param user User who searched for it
  # @param fingerprint String, Fingerprint (hash) generated client side to identify a unique user
  # @param infos=nil String, more info on the stat
  #
  # @return Metric
  def self.view(structure_id, user, fingerprint, ip_address, infos=nil)
    Metric.create(action_type: 'view', structure_id: structure_id, user_fingerprint: fingerprint, ip_address: ip_address)
  end

  # Creates a statistic when there has been an action on a structure (eg. contact etc.)
  # @param structure_id Integer Structure id that appeared in the search
  # @param user User who searched for it
  # @param fingerprint String, Fingerprint (hash) generated client side to identify a unique user
  # @param infos=nil String, more info on the stat
  #
  # @return Metric
  def self.action(structure_id, user, fingerprint, ip_address, infos=nil)
    Metric.create(action_type: 'action', structure_id: structure_id, user_fingerprint: fingerprint, ip_address: ip_address, infos: infos )
  end

  # Creates a statistic regarding the action name
  # @param action_name String Type of an action
  # @param structure_id Integer Structure id that appeared in the search
  # @param user User who searched for it
  # @param fingerprint String, Fingerprint (hash) generated client side to identify a unique user
  # @param infos=nil String, more info on the stat
  #
  # @return Metric
  def self.create_action(action_name, structure_id, user, fingerprint, ip_address, infos=nil)
    case action_name
    when 'impression'
      stat = Metric.print(structure_id, user, fingerprint, ip_address, infos)
    when 'action'
      stat = Metric.action(structure_id, user, fingerprint, ip_address, infos)
    when 'view'
      stat = Metric.view(structure_id, user, fingerprint, ip_address, infos)
    end
    return stat
  end

  ######################################################################
  # Retrieval methods                                                  #
  ######################################################################

  # Total view count
  # @param structure Structure concerned
  # @param from_date=(Date.today - 10.years Date Date from where to start
  #
  # @return Integer number of view counts since `from_date`
  def self.view_count(structure, from_date=(Date.today - 10.years))
    return self.generic_count(structure, :views, from_date)
  end

  # Total impression count
  # @param structure Structure concerned
  # @param from_date=(Date.today - 10.years Date Date from where to start
  #
  # @return Integer number of view counts since `from_date`
  def self.impression_count(structure, from_date=(Date.today - 10.years))
    return self.generic_count(structure, :impressions, from_date)
  end

  # Total action count
  # @param structure Structure concerned
  # @param from_date=(Date.today - 10.years Date Date from where to start
  #
  # @return Integer number of view counts since `from_date`
  def self.action_count(structure, from_date=(Date.today - 10.years))
    return self.generic_count(structure, :actions, from_date)
  end

  # Total telephone action count
  # @param structure Structure concerned
  # @param from_date=(Date.today - 10.years Date Date from where to start
  #
  # @return Integer number of view counts since `from_date`
  def self.telephone_count(structure, from_date=(Date.today - 10.years))
    return self.generic_count(structure, :actions, from_date, 'telephone')
  end

  # Total website action count
  # @param structure Structure concerned
  # @param from_date=(Date.today - 10.years Date Date from where to start
  #
  # @return Integer number of view counts since `from_date`
  def self.website_count(structure, from_date=(Date.today - 10.years))
    return self.generic_count(structure, :actions, from_date, 'website')
  end

  # Score from the action and conversations statistics
  #
  # @return an Integer between 0 and 4 included.
  def self.score(action, conversations)
    case
    when action == 0
      0
    when action.in?(1..4) && conversations <= 2
      1
    when action.in?(1..4) && conversations > 2
      2
    when action > 5 && conversations <= 2
      2
    when action > 5 && conversations.in?(3..5)
      3
    when action > 5 && conversations > 5
      4
    else
      0
    end
  end

  ######################################################################
  # Helper Methods                                                     #
  ######################################################################

  # Identify the Metric using its user_fingerprint and its ip address.
  #
  # @return a Hash
  def identify
    { user_fingerprint: self.user_fingerprint,
      ip_address:       self.ip_address }
  end

  # Identify the Metric using its user_fingerprint, its ip address and the related Structure id.
  #
  # @return a Hash
  def identify_with_structure
    { structure_id:     self.structure_id,
      user_fingerprint: self.user_fingerprint,
      ip_address:       self.ip_address }
  end

  def self.generic_interval_count(type, interval, infos=nil)
    count = Metric.send(type).where(created_at: interval).asc(:created_at)

    count = count.where(infos: infos) if infos
    count = count.group_by{ |metric| metric.created_at.to_date }

    return count.map { |key, values| values.uniq(&:identify_with_structure).length }.reduce(&:+)
  end

  # Total metric count from type
  # @param structure Structure concerned
  # @param type The type symbol, to call scopes
  # @param from_date=(Date.today - 10.years Date Date from where to start
  # @param infos=nil Additional information like the type of action for example
  #
  # @return Integer number of view counts since `from_date`
  def self.generic_count(structure, type, from_date=(Date.today - 10.years), infos=nil)
    values = Metric.send(type).where(structure_id: structure.id)
                              .not.where(user_fingerprint: nil)
                              .where(:created_at.gt => from_date)
                              .asc(:created_at)

    values = values.where(infos: infos) if infos
    values = values.group_by { |metric| metric.created_at.to_date }

    return values.map { |key, values| values.uniq(&:user_fingerprint).length }
                 .reduce(&:+) || 0
  end

end