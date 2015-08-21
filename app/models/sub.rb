class Sub < ActiveRecord::Base
  validates :title, :description, :moderator_id, presence: true
  validates :title, uniqueness: true

  belongs_to :moderator,
    class_name: 'User',
    foreign_key: :moderator_id,
    primary_key: :id
end
