class User < ActiveRecord::Base

  acts_as_messageable

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :comments, -> { order('created_at DESC') }
  has_many :reservations

  has_and_belongs_to_many :plannings
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :places

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :provider, :uid, :oauth_token, :oauth_expires_at,
                  :name, :first_name, :last_name, :fb_avatar, :location, :avatar

  validates :name, :email, presence: true

  has_attached_file :avatar,
                    styles: { wide: '800x800#', normal: '450x', thumb: '200x200#', small: '100x100#', mini: '40x40#' }#,

  after_create :associate_all_comments

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider           = auth.provider
      user.uid                = auth.uid
      user.oauth_token        = auth.credentials.token
      user.oauth_expires_at   = Time.at(auth.credentials.expires_at)

      user.name               = "#{auth.info.first_name} #{auth.info.last_name}"
      user.email              = auth.info.email
      user.fb_avatar          = auth.info.image
      user.password           = Devise.friendly_token[0,20]

      # Extra
      user.location           = auth.info.location
      # user.gender           = auth.info.location
      # user.age              = auth.info.location
      # user.birthdate        = auth.info.location

      user.save!
    end
  end

  def has_avatar?
    self.avatar.exists? or self.fb_avatar
  end

  def avatar_url(format=:normal)
    if self.avatar.exists?
      self.avatar.url(format)
    elsif self.fb_avatar
      self.fb_avatar
    end
  end


  # Type in: small square large normal
  def fb_avatar(type='square')
    self.read_attribute(:fb_avatar).split("=")[0] << "=#{type}" unless self.read_attribute(:fb_avatar).nil?
  end

  def reservation_for?(reservable)
    self.reservations.exists?(reservable_id: reservable.id, reservable_type: (reservable.is_a?(Course) ? 'Course' : reservable.class.name))
  end

  private

  def associate_all_comments
    _email   = self.email
    _user_id = self.id
    Comment.where{email =~ _email}.each do |comment|
      comment.update_column(:user_id, _user_id)
    end
  end
end
