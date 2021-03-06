# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin_flg              :boolean
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  github                 :string(255)
#  name                   :string(255)      default(""), not null
#  profile                :text(65535)
#  provider               :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  twitter                :string(255)
#  uid                    :string(255)
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'validation' do
    it 'should be valid' do
      expect(user.valid?).to eq(true)
    end

    it 'name should be present' do
      user.name = ''
      expect(user.valid?).to eq(false)
    end

    it 'email should be present' do
      user.email = ''
      expect(user.valid?).to eq(false)
    end

    # 50文字以下にするとfailure
    it 'nameは50文字まで' do
      user.name = 'a' * 51
      expect(user.valid?).to eq(false)
    end

    # 255文字以下にするとfailure
    it 'emailは255文字まで' do
      user.email = 'a' * 244 + '@example.com'
      expect(user.valid?).to eq(false)
    end

    it 'profileは400文字まで' do
      user.profile = 'a' * 401
      expect(user.valid?).to eq(false)
    end

    it '適切なアドレスが通る' do
      valid_addresses = %w[rt@example.com A_SA-MU_RA@foo.bar.com one.two.three@gmail.com love+seibu@gg.com]
      valid_addresses.each do |address|
        user.email = address
        expect(user.valid?).to eq(true)
      end
    end

    it '適切でないアドレスが弾かれる' do
      invalid_addresses = %w[user@example,com userpexample.com aruaru@iitai. foo@ba_aar.com 20202@ezweb..com]
      invalid_addresses.each do |address|
        user.email = address
        expect(user.valid?).to eq(false), "#{address.inspect} is failure"
      end
    end

    it 'email addresses should be unique' do
      duplicate_user = user.dup
      duplicate_user.email = user.email
      user.save
      expect(duplicate_user.valid?).to eq(false)
    end

    it 'email should be downcased before save' do
      @user = build(:user)
      @user.email = 'EXAMple@rAiLs.CoM'
      @user.save
      expect('example@rails.com').to eq(@user.reload.email)
    end

    it 'password should not be blank' do
      user.password = ' ' * 8
      expect(user.valid?).to eq(false)
    end

    # 8文字以上にするとfailure
    it 'password valitation should have minimum length 8' do
      user.password = 'asamura'
      expect(user.valid?).to eq(false)
    end
  end

  describe 'association' do
    it 'can have many posts' do
      user = create(:user, :have_posts)
      expect(user.posts.length).to eq 5
    end

    it 'can have many likes' do
      user = create(:user, :have_likes)
      expect(user.likes.length).to eq 5
    end

    it 'can have many comments' do
      user = create(:user, :have_comments)
      expect(user.comments.length).to eq 5
    end
  end
end
