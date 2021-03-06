# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    redirect_to(root_url) && return unless @user.confirmed?
    @posts = @user.posts.includes([:tags]).page(params[:page]).per(8)
    @like_posts = @user.liked_posts.includes([:tags, user: :avatar_attachment]).page(params[:page]).per(8)
  end

  def testlogin
    user = User.find_by(email: 'testuser@testuser.testuser')
    user ||= User.create!(name: 'テストユーザー',
                          email: 'testuser@testuser.testuser',
                          password: Rails.application.credentials[:testuser_password].to_s,
                          confirmed_at: Time.now.utc.to_s)
    sign_in user
    flash[:success] = 'テストユーザーでログインしました。'
    redirect_to root_url
  end
end
