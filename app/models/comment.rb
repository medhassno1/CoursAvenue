class Comment < ActiveRecord::Base
  MIN_LENGTH  = 20

  acts_as_paranoid
  attr_accessible :commentable, :commentable_id, :commentable_type, :content, :author_name, :email, :rating,
                  :title, :course_name, :deletion_reason, :subjects, :subject_ids
  # A comment has a status which can be one of the following:
  #   - pending
  #   - accepted
  #   - waiting_for_deletion

  ######################################################################
  # Relations                                                          #
  ######################################################################
  belongs_to :commentable, polymorphic: true, touch: true
  belongs_to :user

  has_and_belongs_to_many :subjects

  ######################################################################
  # Validations                                                        #
  ######################################################################
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }
  validates :email, :author_name, :course_name, :content, :commentable, :title, presence: true
  validate  :doesnt_exist_yet, on: :create
  validate  :content_length, on: :create

  ######################################################################
  # Callbacks                                                          #
  ######################################################################
  before_create    :set_pending_status
  before_create    :remove_quotes_from_title

  before_save      :strip_names
  before_save      :downcase_email
  before_save      :sanatize_content

  after_save       :update_comments_count

  after_create     :send_email
  after_create     :create_user, if: -> { self.user.nil? }
  after_create     :affect_structure_to_user
  after_create     :create_passions_for_associated_user
  after_create     :complete_comment_notification
  after_create     :create_or_update_user_profile

  after_destroy    :update_comments_count

  ######################################################################
  # Scopes                                                             #
  ######################################################################
  scope :ordered,              -> { order('created_at DESC') }
  scope :pending,              -> { where(status: 'pending') }
  scope :accepted,             -> { where(status: 'accepted') }
  scope :waiting_for_deletion, -> { where(status: 'waiting_for_deletion') }

  # ------------------------------------------------------------------------------------ Search attributes
  searchable do
    latlon :location, multiple: true do
      self.structure.locations.collect do |location|
        Sunspot::Util::Coordinates.new(location.latitude, location.longitude)
      end
    end

    boolean :has_title do
      self.title.present?
    end

    string :subject_slugs, multiple: true do
      subject_slugs = []
      self.structure.subjects.uniq.each do |subject|
        subject_slugs << subject.slug
        subject_slugs << subject.root.slug if subject.root
      end
      subject_slugs.uniq
    end
  end

  def recover!
    self.status = :accepted
    self.save
  end

  def accept!
    self.status = :accepted
    self.save
    case self.commentable.comments_count
    when 5
      AdminMailer.delay.congratulate_for_fifth_comment(self)
    when 15
      AdminMailer.delay.congratulate_for_fifteenth_comment(self)
    end
    self.notify_user
  end

  def decline!
    self.status = :declined
    self.save
  end

  def ask_for_deletion!(deletion_reason=nil)
    self.status          = :waiting_for_deletion
    self.deletion_reason = deletion_reason if deletion_reason
    self.save
    AdminMailer.delay.ask_for_deletion(self)
  end

  def waiting_for_deletion?
    self.status == 'waiting_for_deletion'
  end

  def accepted?
    self.status == 'accepted'
  end

  def pending?
    self.status == 'pending'
  end

  def declined?
    self.status == 'declined'
  end

  def structure
    self.commentable
  end

  def owner?(user)
    if user.is_a? Admin
      user.super_admin or self.commentable == user.structure
    else
      self.user == user
    end
  end

  # Update rating of the commentable (course, or structure)
  def update_comments_count
    self.commentable.update_comments_count
  end

  protected

  def set_pending_status
    if self.structure and self.email
      _structure_id = self.structure.id
      _email        = self.email
      user          = User.where{email == _email}.first
      _user_id      = user.id if user
      if _user_id and CommentNotification.where{(structure_id == _structure_id) & (user_id == _user_id)}.count > 0
        self.status = 'accepted'
      end
    end
    self.status ||= 'pending'
  end

  def notify_user
    UserMailer.delay.comment_has_been_validated(self)
  end

  private

  def content_length
    if content.split.size < MIN_LENGTH
      self.errors.add :content, I18n.t('comments.errors.content_too_small', count: MIN_LENGTH)
    end
  end

  # Creates an inactive user after a comment is created if the user wasn't connected
  #
  # @return nil
  def create_user
    user_email = email
    if (user = User.where{email == user_email}.first).nil?
      user = User.new email: email
      user.first_name = author_name.split(' ')[0..author_name.split(' ').length - 2].join(' ')
      user.last_name  = author_name.split(' ').last        if self.author_name.split(' ').length > 1
    end

    self.user = user
    user.save(validate: false)
    self.save
    nil
  end

  def affect_structure_to_user
    self.user.structures << self.structure
    self.user.save(validate: false)
  end

  def create_passions_for_associated_user
    self.subjects.each do |child_subject|
      passion = self.user.passions.build(practiced: true)
      passion.subjects << child_subject.root
      passion.subjects << child_subject
    end
    self.user.comments << self
    self.user.save(validate: false)
  end

  def complete_comment_notification
    _structure_id = self.structure.id
    if (comment_notification = user.comment_notifications.where(structure_id: _structure_id).first).present?
      comment_notification.complete!
    end
  end

  # Add errors if the user has already commented the commentable
  #
  # @return nil
  def doesnt_exist_yet
    _structure_id = self.commentable_id
    _email        = self.email
    if Comment.where{(commentable_id == _structure_id) & (email == _email) & (created_at > 2.months.ago)}.any?
      self.errors.add :email, I18n.t('comments.errors.already_posted')
    end
  end

  #
  # Strip names in case they have a starting or ending space
  #
  # @return nil
  def strip_names
    self.author_name = self.author_name.strip if author_name.present?
    self.title       = self.title.strip       if title.present?
    self.course_name = self.course_name.strip if course_name.present?
  end

  # Sends an email to the user and the admin regarding the status of the comment
  #
  # @return nil
  def send_email
    if self.accepted?
      AdminMailer.delay.congratulate_for_accepted_comment(self)
      UserMailer.delay.congratulate_for_accepted_comment(self)
    else
      AdminMailer.delay.congratulate_for_comment(self)
      UserMailer.delay.congratulate_for_comment(self)
    end
  end

  # Change the email to force it to be downcase
  #
  # @return
  def downcase_email
    self.email = self.email.downcase
    nil
  end

  # Remove quotes from title if they are at the begining
  #
  # @return nil
  def remove_quotes_from_title
    string_title = self.title
    string_title[0]                       = '' if string_title[0] == '"' or string_title[0] == "'"
    string_title[string_title.length - 1] = '' if string_title.last == '"' or string_title.last == "'"
    self.title = string_title.strip
    nil
  end

  # Create or update the user profile attached to the structure
  #
  # @return nil
  def create_or_update_user_profile
    user_profile = UserProfile.update_info(structure, user)
    # Tag it as commented
    structure.add_tags_on(user_profile, UserProfile::DEFAULT_TAGS[:comments])
    nil
  end

  # Remove unwanted character from the content
  #
  # @return nil
  def sanatize_content
    self.content = self.content.scan(/[[:print:]]|[[:space:]]/).join if self.content.present?
    nil
  end
end
