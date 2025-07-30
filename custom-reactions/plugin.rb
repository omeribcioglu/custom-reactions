# name: custom-reactions
# about: Adds a multi-level like/dislike system to Discourse
# version: 0.1
# authors: Ömer
# url: https://github.com/yourusername/custom-reactions

enabled_site_setting :custom_reactions_enabled

register_asset "javascripts/discourse/custom-reactions.js", :client_side
register_asset "javascripts/discourse/score-display.js", :client_side
register_asset "javascripts/discourse/user-score-badge.js", :client_side
register_asset "javascripts/discourse/highlight-reaction.js", :client_side
register_asset "stylesheets/common/common.scss"

require_relative "app/controllers/custom_reactions/reactions_controller"
require_relative "app/controllers/custom_reactions/admin_user_scores_controller"
require_relative "app/serializers/custom_reaction_serializer"

after_initialize do
  module ::CustomReactions
    class Engine < ::Rails::Engine
      engine_name "custom_reactions"
      isolate_namespace CustomReactions
    end
  end

  CustomReactions::Engine.routes.draw do
    post "/react" => "reactions#create"
    get "/admin/user-scores" => "admin_user_scores#index"
    put "/admin/user-scores/:id" => "admin_user_scores#update"
  end

  Discourse::Application.routes.append do
    mount ::CustomReactions::Engine, at: "/custom-reactions"
  end
end
