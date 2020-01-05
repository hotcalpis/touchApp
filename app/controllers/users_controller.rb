# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    redirect_to(root_url) && return unless @user.confirmed?
  end
end
