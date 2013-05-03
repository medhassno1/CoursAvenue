class Comment < ActiveRecord::Base
  attr_accessible :commentable_id, :commentable_type, :content, :author_name, :email, :rating, :title

  belongs_to :commentable, :polymorphic => true
  belongs_to :user

  validates :author_name, :content, presence: true
  validates :rating, numericality: { greater_than: 0, less_than: 6 }

  after_save    :update_commentable_rating
  after_destroy :update_commentable_rating

  before_save :replace_slash_n_r_by_brs

  private

  # Update rating of the commentable (course, or place)
  def update_commentable_rating
    commentable = self.commentable
    ratings     = commentable.comments.group(:rating).count
    nb_rating    = 0
    total_rating = 0
    ratings.delete_if {|k,v| k.nil?}.each do |key, value|
      nb_rating    += value
      total_rating += key * value
    end
    new_rating = (nb_rating == 0 ? nil : (total_rating.to_f / nb_rating.to_f))
    self.commentable.update_attribute :rating, new_rating
  end

  def replace_slash_n_r_by_brs
    self.content = self.content.gsub(/\r\n/, '<br>')
  end

end
