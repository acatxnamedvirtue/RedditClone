class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true
  validate :ensure_at_least_one_sub

  belongs_to :author,
    class_name: 'User',
    foreign_key: :author_id,
    primary_key: :id

  has_many :subs,
    through: :post_subs,
    source: :sub

  has_many :post_subs,
    dependent: :destroy,
    class_name: "PostSub",
    foreign_key: :post_id,
    primary_key: :id,
    inverse_of: :post

  has_many :comments,
    dependent: :destroy,
    class_name: "Comment",
    foreign_key: :post_id,
    primary_key: :id

  has_many :votes,
    as: :votable

  has_many :voters,
    through: :votes,
    source: :voter

  def ensure_at_least_one_sub
    if subs.empty?
      errors[:post] << "must have at least one sub"
    end
  end

  def comments_by_parent_id
    result = Hash.new { |h,k| h[k] = [] }

    comments.includes(:author).each do |comment|
      result[comment.parent_comment_id] << comment
    end

    result
  end
end
