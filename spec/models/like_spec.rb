# frozen_string_literal: true

# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_likes_on_post_id              (post_id)
#  index_likes_on_user_id              (user_id)
#  index_likes_on_user_id_and_post_id  (user_id,post_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (post_id => posts.id)
#  fk_rails_...  (user_id => users.id)
#

require 'rails_helper'

RSpec.describe Like, type: :model do
  describe 'validations' do
    it 'should be unique of specific user-post' do
      user = create(:user)
      post = create(:post)
      original_like = user.likes.create(post_id: post.id)
      another_like = user.likes.new(post_id: post.id)
      expect(another_like.valid?).to be false
    end
  end

  describe 'associations' do
    it 'should depend on user' do
      belong_user = create(:user)
      belong_post = create(:post)
      like = belong_user.likes.create(post_id: belong_post.id)
      belong_user.destroy
      expect { like.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'should depend on post' do
      belong_user = create(:user)
      belong_post = create(:post)
      like = belong_post.likes.create(user_id: belong_user.id)
      belong_post.destroy
      expect { like.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
