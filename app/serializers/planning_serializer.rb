class PlanningSerializer < ActiveModel::Serializer
  attributes :id,
             :day_one,
             :day_one_duration,
             :day_one_start_time,
             :day_two,
             :day_two_duration,
             :day_two_start_time,
             :day_three,
             :day_three_duration,
             :day_three_start_time,
             :day_four,
             :day_four_duration,
             :day_four_start_time,
             :day_five,
             :day_five_duration,
             :day_five_start_time,
             :duration,
             :end_date,
             :start_date,
             :start_time, # Format: Time.parse("2000-01-01 #{value} UTC")
             :end_time,   # Format: Time.parse("2000-01-01 #{value} UTC")
             :week_day,
             :class_during_holidays


  def start_date
    I18n.l object.start_date, format: :long
  end

  def end_date
    I18n.l object.end_date, format: :long
  end
end
