# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id             :bigint           not null, primary key
#  comments_count :integer          default(0)
#  content        :text(65535)      not null
#  likes_count    :integer          default(0)
#  title          :text(65535)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint           not null
#
# Indexes
#
#  index_posts_on_user_id                 (user_id)
#  index_posts_on_user_id_and_created_at  (user_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class Post < ApplicationRecord
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  belongs_to :user

  acts_as_taggable

  default_scope -> { order(created_at: :desc) }

  validates :title, presence: true, length: { maximum: 255 }
  validates :content, presence: true, length: { maximum: 20_000 }

  def liked_by?(user)
    user.likes.find_by(post_id: id)
  end

  def self.search(search_word)
    split_search_word = search_word.split(/[[:blank:]]+/)

    sum_posts = Post.all
    split_search_word.each do |keyword|
      sum_posts = sum_posts.where(['title LIKE ? OR content LIKE ?', "%#{keyword}%", "%#{keyword}%"])
    end
    sum_posts
  end
end
