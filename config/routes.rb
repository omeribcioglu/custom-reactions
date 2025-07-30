# frozen_string_literal: true

CustomReactions::Engine.routes.draw do
  post "/react" => "reactions#create"
end

Discourse::Application.routes.append do
  mount ::CustomReactions::Engine, at: "/custom-reactions"
end
