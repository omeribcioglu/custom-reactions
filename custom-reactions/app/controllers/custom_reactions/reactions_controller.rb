# frozen_string_literal: true

module ::CustomReactions
  class Engine < ::Rails::Engine
    engine_name "custom_reactions"
    isolate_namespace CustomReactions
  end
end

CustomReactions::Engine.routes.draw do
  post "/react" => "reactions#create"
end

Discourse::Application.routes.append do
  mount ::CustomReactions::Engine, at: "/custom-reactions"
end

module ::CustomReactions
  class ReactionsController < ::ApplicationController
    requires_plugin ::Plugin::Instance.new.name

    before_action :ensure_logged_in

    def create
      post = Post.find(params[:post_id])
      topic = post.topic
      reaction_type = params[:reaction_type]

      score = case reaction_type
              when "very_like" then 2
              when "like" then 1
              when "dislike" then -1
              when "very_dislike" then -2
              else 0
              end

      if score == 0
        render_json_error("Invalid reaction type") and return
      end

      reaction = CustomReaction.find_by(user: current_user, post: post)

      if reaction && reaction.reaction_type == reaction_type
        # Aynı tepkiyi tekrar tıkladıysa: sil (oy sıfırlama)
        reaction.destroy
      else
        # Yeni ya da farklı tepki verildiyse: güncelle veya oluştur
        reaction ||= CustomReaction.new(user: current_user, post: post)
        reaction.topic = topic
        reaction.reaction_type = reaction_type
        reaction.score = score
        reaction.save!
      end

      update_topic_score(topic)
      render json: success_json
    rescue => e
      render_json_error(e.message)
    end

    private

    def update_topic_score(topic)
      score_sum = CustomReaction.where(topic: topic).sum(:score)
      topic.custom_fields["topic_score"] = score_sum
      topic.save_custom_fields

      if score_sum >= 50 && !topic.custom_fields["score_bonus_given"]
        topic.user.custom_fields["user_score"] ||= 0
        topic.user.custom_fields["user_score"] = topic.user.custom_fields["user_score"].to_i + 10
        topic.user.save_custom_fields
        topic.custom_fields["score_bonus_given"] = true
        topic.save_custom_fields
      elsif score_sum <= -50 && !topic.custom_fields["score_penalty_given"]
        topic.user.custom_fields["user_score"] ||= 0
        topic.user.custom_fields["user_score"] = topic.user.custom_fields["user_score"].to_i - 10
        topic.user.save_custom_fields
        topic.custom_fields["score_penalty_given"] = true
        topic.save_custom_fields
      end
    end
  end
end