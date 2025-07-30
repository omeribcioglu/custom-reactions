# frozen_string_literal: true

class ::CustomReaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  belongs_to :topic

  validates :reaction_type, presence: true, inclusion: {
    in: %w[very_like like dislike very_dislike],
    message: "%{value} is not a valid reaction type"
  }

  validates :score, inclusion: { in: [-2, -1, 1, 2] }
  validates :user_id, :post_id, :topic_id, presence: true
  validates_uniqueness_of :user_id, scope: :post_id
end
