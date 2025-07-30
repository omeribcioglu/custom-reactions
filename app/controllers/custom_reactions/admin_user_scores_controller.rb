# frozen_string_literal: true

module ::CustomReactions
  class AdminUserScoresController < ::Admin::AdminController
    requires_plugin ::Plugin::Instance.new.name

    def index
      users = User.all.limit(100).map do |u|
        {
          id: u.id,
          username: u.username,
          score: u.custom_fields["user_score"].to_i
        }
      end

      render json: { users: users }
    end

    def update
      user = User.find(params[:id])
      new_score = params[:score].to_i

      user.custom_fields["user_score"] = new_score
      user.save_custom_fields

      render json: success_json
    end
  end
end

CustomReactions::Engine.routes.draw do
  get "/admin/user-scores" => "admin_user_scores#index"
  put "/admin/user-scores/:id" => "admin_user_scores#update"
end