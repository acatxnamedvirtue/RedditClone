class Comment < ActiveRecord::Base
  validates :author_id, :post_id, :content, presence: true

  belongs_to :author,
    class_name: 'User',
    foreign_key: :author_id,
    primary_key: :id

  belongs_to :post,
    class_name: 'Post',
    foreign_key: :post_id,
    primary_key: :id

  belongs_to :parent,
    class_name: 'Comment',
    foreign_key: :parent_comment_id,
    primary_key: :id

  has_many :children,
    dependent: :destroy,
    class_name: 'Comment',
    foreign_key: :parent_comment_id,
    primary_key: :id

  has_many :votes,
    as: :votable

  has_many :voters,
    through: :votes,
    source: :voter
end
