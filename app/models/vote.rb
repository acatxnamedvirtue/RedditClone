class Vote < ActiveRecord::Base
  validates :value, :voter_id, :votable_id, :votable_type, presence: true
  validates :votable_id,
    uniqueness: { scope: :voter_id, message: "Multiple votes on same votable."}

  belongs_to :voter,
    class_name: "User"

  belongs_to :votable,
    polymorphic: true
end
