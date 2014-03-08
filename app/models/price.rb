class Price < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :course

  before_validation :update_nb_courses

  validates :course, presence: true

  attr_accessible :libelle, :amount, :promo_amount, :nb_courses, :info, :course, :number, :type, :duration, :promo_percentage

  before_save :remove_zeros

  has_one :structure, through: :course

  # All types

  TYPES = ['per_course',
           'book_ticket',
           'annual_subscription',
           'semestrial_subscription',
           'trimestrial_subscription',
           'monthly_subscription',
           'any_per_course',
           'all_subscriptions']

  RANGES = {
      "#{TYPES[0]}" => { min: 5, max: 500, step: 5 },
      "#{TYPES[1]}" => { min: 50, max: 2000, step: 10 },
      "#{TYPES[2]}" => { min: 20, max: 1000, step: 10 },
      "#{TYPES[3]}" => { min: 20, max: 1000, step: 10 },
      "#{TYPES[4]}" => { min: 20, max: 1000, step: 10 },
      "#{TYPES[5]}" => { min: 20, max: 1000, step: 10 }
  }

  # BookTickets
  scope :book_tickets      , -> { where{type == 'Price::BookTicket'} }
  # Retrieve individual courses
  scope :individual        , -> { where{ number == 1} }
  # Retrieve actual book tickets
  scope :multiple_only     , -> { where{ number > 1} }

  # BookTickets
  scope :subscriptions     , -> { where(type: 'Price::Subscription') }
  scope :annual            , -> { where(libelle: 'prices.subscription.annual') }
  scope :trimestrial       , -> { where(libelle: 'prices.subscription.semester') }
  scope :semestrial        , -> { where(libelle: 'prices.subscription.trimester') }
  scope :monthly           , -> { where(libelle: 'prices.subscription.month') }

  # Registration
  scope :registrations     , -> { where(type: 'Price::Registration') }
  # Discounts
  scope :discounts         , -> { where(type: 'Price::Discount') }

  # Trials
  scope :trials            , -> { where(type: 'Price::Trial') }

  def free?
    false
  end

  def localized_libelle
    I18n.t(read_attribute(:libelle)) if read_attribute(:libelle)
  end

  def book_ticket?
    false
  end

  def subscription?
    false
  end

  def registration?
    false
  end

  def discount?
    false
  end

  def trial?
    false
  end

  def per_course_amount
    return nil if amount.nil?
    if self.nb_courses and self.nb_courses > 0
      amount / self.nb_courses
    else
      amount
    end
  end

  def per_course_promo_amount
    return nil if promo_amount.nil?
    self.nb_courses
    if self.nb_courses and self.nb_courses > 0
      promo_amount / self.nb_courses
    else
      promo_amount
    end
  end

  def has_promo?
    !promo_amount.nil?
  end

  def nb_courses
    return 1 if read_attribute(:nb_courses).nil?
    read_attribute(:nb_courses)
  end

  def to_meta_data
    {
      amount:            self.amount,
      promo_amount:      self.promo_amount,
      localized_libelle: self.localized_libelle,
      libelle:           self.libelle,
      into:              self.info
    }
  end

  private

  def remove_zeros
    if promo_amount == 0
      promo_amount = nil
    end
  end

  def update_nb_courses
    case libelle
    when 'prices.free'
      self.nb_courses = 1
    when 'prices.individual_course'
      self.nb_courses = 1
    when 'prices.subscription.annual'
      self.nb_courses = 35
    when 'prices.subscription.semester'
      self.nb_courses = 17
    when 'prices.subscription.trimester'
      self.nb_courses = 11
    when 'prices.subscription.month'
      self.nb_courses = 4
    when 'prices.trial_lesson'
      self.nb_courses = 1
    else
      self.nb_courses = 0
    end
  end
end
