class Comment < ApplicationRecord
  belongs_to :user
  # belongs_to :post
  belongs_to :commentable, polymorphic: true

  has_many :replies, class_name: 'Comment', as: :commentable, dependent: :destroy
  # belongs_to :parent_comment, class_name: 'Comment', optional: true
end
