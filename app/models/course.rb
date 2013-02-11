# encoding: utf-8
# Courses are grouped by same name, audiences and levels
class Course < ActiveRecord::Base

  # ------------------------------------------------------------------------------------ Model attributes and settings
  extend FriendlyId
  friendly_id :name, use: :slugged
  # friendly_id :name, use: :scoped, scope: [:city, :subject]

  has_attached_file :homepage_image, :styles => {default: '1600×500#'}
  has_attached_file :image, :styles => { wide: "800x480#", thumb: "200x200#" }

  belongs_to :structure
  has_one :city, through: :structure

  has_many :plannings
  has_many :prices           , dependent: :destroy
  has_many :book_tickets     , dependent: :destroy
  has_many :registration_fees, dependent: :destroy

  has_and_belongs_to_many :audiences
  has_and_belongs_to_many :levels

  has_and_belongs_to_many :subjects, :uniq => true

  # ------------------------------------------------------------------------------------ Validations
  validates :structure  , presence: true
  # validates :subjects, presence: true


  attr_accessible :name,
                  :has_online_payment,
                  :homepage_image,
                  :frequency,
                  :is_promoted,
                  :description,
                  :info,
                  :registration_date,
                  :is_individual,
                  :is_for_handicaped,
                  :trial_lesson_info, # Info prix
                  :price_details,
                  :price_info,
                  :conditions,
                  :partner_rib_info,
                  :audition_mandatory,
                  :refund_condition,
                  :can_be_joined_during_year,
                  :subject_ids
  # ------------------------------------------------------------------------------------ Search methods
  searchable do
    text :name, :boost => 2
    text :structure_name do
      structure.name
    end

    text :teachers do
      plannings.map(&:teacher_name).uniq.compact
    end

    text :subjects do
      subject_array = []
      subjects.each do |subject|
        subject_array << subject
        subject_array << subject.parent
      end
      subject_array.uniq.map(&:name)
    end

    integer :subject_ids, multiple: true do
      subject_ids = []
      subjects.each do |subject|
        subject_ids << subject.id
        subject_ids << subject.parent.id
      end
      subject_ids.uniq
    end
    string  :type do
      case type
      when 'Course::Lesson'
        'lesson'
      when 'Course::Training'
        'training'
      when 'Course::Workshop'
        'workshop'
      end
    end

    string :city do
      city.slug
    end

    integer :audience_ids, multiple: true
    integer :level_ids   , multiple: true

    string :week_days, multiple: true do
      plannings.map(&:week_day).uniq.compact
    end

    integer :min_age_for_kid, multiple: true do
      plannings.map(&:min_age_for_kid).uniq.compact
    end
    integer :max_age_for_kid, multiple: true do
      plannings.map(&:max_age_for_kid).uniq.compact
    end

    string :time_slots, multiple: true

    time :start_time, multiple: true do
      plannings.map(&:start_time).uniq.compact
    end
    time :end_time, multiple: true do
      plannings.map(&:end_time).uniq.compact
    end

    date :start_date, multiple: true do
      plannings.map(&:start_date).uniq.compact
    end

    date :end_date, multiple: true do
      plannings.map(&:end_date).uniq.compact
    end

    integer :zip_code do
      structure.zip_code
    end
    integer :min_price
    integer :max_price

    boolean :is_promoted
    boolean :has_online_payment
    boolean :has_promotion do
      plannings.order('promotion ASC').first.promotion != nil
    end

    boolean :has_package_price
    boolean :has_trial_lesson
    boolean :has_unit_course_price
  end

  def has_package_price
    return prices.where{libelle.eq_any ['prices.annual', 'prices.semester', 'prices.trimester', 'prices.month', 'prices.two_lesson_per_week_package']}.any?
  end

  def has_trial_lesson
    return prices.where(libelle: 'prices.trial_lesson').any?
  end

  def has_unit_course_price
    return (book_tickets.any? or prices.where(libelle: 'prices.individual_course').any?)
  end

  def min_price
    prices.map(&:amount).compact.sort.first
  end

  def max_price
    prices.map(&:amount).compact.sort.last
  end

  def time_slots
    time_slots = []
    plannings.each do |planning|
      if planning.start_time and planning.end_time
        LeBonCours::Application::TIME_SLOTS.each do |time_slot_name, time_slot|
          if (planning.start_time >= TimeParser.parse_time_string(time_slot[:start_time])) & (planning.start_time <= TimeParser.parse_time_string(time_slot[:end_time]))
            time_slots << time_slot_name.to_s
          end
        end
      end
    end
    time_slots.uniq
  end



  # ------------------------------------------------------------------------------------ Self methods

  # def self.from_city(city, scope = Course)
  #   city_id = City.find(city).id
  #   scope.joins{structure}.where{structure.city_id == city_id}
  # end

  # def self.name_subjects_and_structure_name_contains(name_string, scope)
  #   name_string    = '%' + name_string + '%'
  #   subject_models = Subject.where{name =~ name_string}
  #   if subject_models.size == 1 and subject_models.first.is_root?
  #     subject_ids = subject_models.first.children.map(&:id)
  #   else
  #     subject_ids = Subject.where{name =~ name_string}.map(&:id)
  #   end
  #   scope.joins{subjects}.joins{structure}.where{(name =~ name_string) | (structure.name =~ name_string) | (subjects.id.eq_any subject_ids)}
  # end

  # def self.is_of_type(types_array, scope)
  #   types = []
  #   types << 'Course::Lesson'   if types_array.include? 'lesson'
  #   types << 'Course::Training' if types_array.include? 'training'
  #   types << 'Course::Workshop' if types_array.include? 'workshop'
  #   scope.where{type.eq_any types}
  # end

  # def self.has_price_specificities(price_specificities, scope)
  #   return scope if price_specificities.length == 3 # Doesn't search if all options are checked
  #   scope = scope.joins{book_tickets.outer}.joins{prices}.where do
  #     query = nil
  #     price_specificities.each_with_index do |price_specificity|
  #       case price_specificity
  #       when 'has_package_price'
  #         if query
  #           query |= (prices.libelle.eq_any ['prices.annual', 'prices.semester', 'prices.trimester', 'prices.month', 'prices.two_lesson_per_week_package'])
  #         else
  #           query =  (prices.libelle.eq_any ['prices.annual', 'prices.semester', 'prices.trimester', 'prices.month', 'prices.two_lesson_per_week_package'])
  #         end
  #       when 'has_trial_lesson'
  #         if query then query |= (prices.libelle.eq 'prices.trial_lesson') else query = (prices.libelle.eq 'prices.trial_lesson') end
  #       when 'has_unit_course_price'
  #         if query then query |= (prices.libelle.eq 'prices.individual_course') else query = (prices.libelle.eq 'prices.individual_course') end
  #       end
  #     end
  #     query
  #   end
  #   scope
  # end

  # def self.is_for_audience(audience_ids, scope)
  #   scope.joins{audiences}.where{audiences.id.eq_any audience_ids.map(&:to_i)}
  # end

  # def self.is_for_ages(age, scope)
  #   if age[:min].blank? and age[:max].blank?
  #     scope
  #   else
  #     age[:min] = 0  if age[:min].blank?
  #     age[:max] = 18 if age[:max].blank?
  #     if age[:min].to_i > 18
  #       scope
  #     else
  #       scope.joins{plannings}.where{(plannings.min_age_for_kid < age[:max]) & (plannings.max_age_for_kid > age[:min])}
  #     end
  #   end
  # end

  # def self.is_for_level(level_ids, scope)
  #   scope.joins{levels}.where{levels.id.eq_any level_ids}
  # end

  # def self.that_happens(week_day_indexes, scope)
  #   scope.joins{plannings}.where{(type == 'Course::Training') | ((type == 'Course::Lesson') & (plannings.week_day.eq_any week_day_indexes.map(&:to_i))) | ((type == 'Course::Workshop') & (plannings.week_day.eq_any week_day_indexes.map(&:to_i)))}
  # end

  # def self.in_these_time_slots(values, scope)
  #   time_slots = []
  #   values.each do |slot|
  #     start_time = TimeParser.parse_time_string LeBonCours::Application::TIME_SLOTS[slot.to_sym][:start_time]
  #     end_time   = TimeParser.parse_time_string LeBonCours::Application::TIME_SLOTS[slot.to_sym][:end_time]
  #     time_slots << [start_time, end_time]
  #   end
  #   scope.joins{plannings}.where do
  #     time_slots.map { |start_time, end_time| ((plannings.start_time >= start_time) & (plannings.start_time <= end_time)) }.reduce(&:|)
  #   end
  # end

  # def self.in_time_range(start_time, end_time, scope)
  #   if start_time.blank? and end_time.blank?
  #     scope
  #   else
  #     start_time = TimeParser.parse_time_string( start_time.blank? ? '00:00' : start_time )
  #     end_time   = TimeParser.parse_time_string( end_time.blank?   ? '23:59' : end_time )

  #     scope.joins{plannings}.where{(plannings.start_time >= start_time) & (plannings.end_time <= end_time)}
  #   end
  # end

  # def self.in_price_range(min_price, max_price, scope)
  #   if min_price.blank? and max_price.blank?
  #     scope
  #   else
  #     min_price = 0     if min_price.blank? and !max_price.blank?
  #     max_price = 10000 if max_price.blank? and !min_price.blank?
  #     if !min_price.blank? and !max_price.blank? and max_price.to_i > 0
  #       scope.joins{prices}.where{(prices.amount >= min_price.to_i) & (prices.amount <= max_price.to_f)}
  #     end
  #   end
  # end

  # TODO: To be improved
  def similar_courses(limit = 5)
    subject_ids       = self.subject_ids.map(&:to_i)
    similar_courses   = Course.joins{subjects}.where{subjects.id.eq_any subject_ids}.limit(limit) # With same subject
    if similar_courses.length < 5
      max_id          = Course.maximum('id')
      min_id          = Course.minimum('id')
      id_range        = max_id - min_id + 1
      random_id       = min_id + rand(id_range).to_i
      similar_courses = Course.limit(limit).offset(random_id)
    end
    similar_courses
  end

  def promotion_planning
    self.plannings.where{promotion != nil}.order('promotion ASC').first
  end

  def is_for_kid
    self.plannings.where{min_age_for_kid != nil}.length > 0
  end

  def has_multiple_teacher?
    self.plannings.map(&:teacher_name).uniq.compact.length > 1
  end

  def has_teacher?
    self.plannings.map(&:teacher_name).uniq.compact.length > 0
  end

  def promotion
    self.plannings.order('promotion ASC').first.promotion
  end

  def promotion_price
    new_price = best_price.amount + (best_price.amount * (promotion / 100))
    ('%.2f' % new_price).gsub('.', ',').gsub(',00', '')
  end

  def is_workshop?
    false
  end

  def is_lesson?
    false
  end

  def is_training?
    false
  end

  def best_price
    prices.where{amount > 0}.order('amount ASC').first
  end

  def type_name
    'Cours'
  end

  def should_generate_new_friendly_id?
    new_record?
  end
end
