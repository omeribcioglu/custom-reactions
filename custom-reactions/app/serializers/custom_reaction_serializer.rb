# frozen_string_literal: true

# Extending the PostSerializer to include user reactions

module ::CustomReactions
  module PostSerializerExtension
    def custom_fields
      fields = super || {}
      reactions = CustomReaction.where(post_id: object.id)
      reaction_map = reactions.each_with_object({}) do |r, hash|
        hash[r.user_id] = r.reaction_type
      end
      fields["custom_reactions"] = reaction_map
      fields
    end
  end
end

require_dependency "post_serializer"
class ::PostSerializer
  prepend ::CustomReactions::PostSerializerExtension
end