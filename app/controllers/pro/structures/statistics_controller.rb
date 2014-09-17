# encoding: utf-8
class Pro::Structures::StatisticsController < Pro::ProController
  before_action :authenticate_pro_admin!
  load_and_authorize_resource :structure, find_by: :slug

  layout 'admin'

  def index
    @structure  = Structure.find params[:structure_id]
    @statistics = @structure.metrics

    empty_hash_of_days = {}
    (15.days.ago.to_date..Date.today).each { |date| empty_hash_of_days[date] = 0 }

    @impressions, @views, @phone_actions, @website_actions, @message_actions, @follow_actions = (1..6).map { empty_hash_of_days.dup }
    @impressions_total_count, @views_total_count, @actions_total_count = 0, 0, 0
    # Selecting all stats from 15 days ago
    # Ordering them by creation date
    # Grouping them by creation date
    # selecting counting by DISTINCT(user_fingerprint, ip_address) because each stats is counted only onced per user & per day
    @statistics.impressions      .where(:created_at.gt => (Date.today - 15.days) )
                                 .asc(:created_at)
                                 .group_by { |metric| metric.created_at.to_date }
                                 .map{ |date, metrics| { created_at: date, user_count: metrics.uniq(&:identify).length } }
                                 .each{ |stat| @impressions[stat[:created_at]] = stat[:user_count]; @impressions_total_count += stat[:user_count] }


    @statistics.views            .where(:created_at.gt => (Date.today - 15.days) )
                                 .asc(:created_at)
                                 .group_by { |metric| metric.created_at.to_date }
                                 .map{ |date, metrics| { created_at: date, user_count: metrics.uniq(&:identify).length } }
                                 .each{ |stat| @views[stat[:created_at]] = stat[:user_count]; @views_total_count += stat[:user_count] }

    actions = @statistics.actions.where(:created_at.gt => (Date.today - 15.days) )
                                 .asc(:created_at)
                                 .group_by(&:infos)

    actions["telephone"]         .group_by { |metric| metric.created_at.to_date }
                                 .map{ |date, metrics| { created_at: date, user_count: metrics.uniq(&:identify).length } }
                                 .each{ |stat| @phone_actions[stat[:created_at]] = stat[:user_count]; @actions_total_count += stat[:user_count] } if action["telephone"].present?

    actions["website"]           .group_by { |metric| metric.created_at.to_date }
                                 .map{ |date, metrics| { created_at: date, user_count: metrics.uniq(&:identify).length } }
                                 .each{ |stat| @website_actions[stat[:created_at]] = stat[:user_count]; @actions_total_count += stat[:user_count] } if action["website"].present?

    actions["contact_message"]   .group_by { |metric| metric.created_at.to_date }
                                 .map{ |date, metrics| { created_at: date, user_count: metrics.uniq(&:identify).length } }
                                 .each{ |stat| @message_actions[stat[:created_at]] = stat[:user_count]; @actions_total_count += stat[:user_count] } if action["contact_message"].present?

    actions["follow"]            .group_by { |metric| metric.created_at.to_date }
                                 .map{ |date, metrics| { created_at: date, user_count: metrics.uniq(&:identify).length } }
                                 .each{ |stat| @follow_actions[stat[:created_at]] = stat[:user_count]; @actions_total_count += stat[:user_count] } if action["follow"].present?

  end
end
