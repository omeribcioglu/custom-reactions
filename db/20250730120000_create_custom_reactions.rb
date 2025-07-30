class CreateCustomReactions < ActiveRecord::Migration[6.1]
  def change
    create_table :custom_reactions do |t|
      t.integer :user_id, null: false
      t.integer :post_id, null: false
      t.integer :topic_id, null: false
      t.string  :reaction_type, null: false  # "very_like", "like", "dislike", "very_dislike"
      t.integer :score, null: false          # +2, +1, -1, -2
      t.timestamps
    end

    add_index :custom_reactions, [:user_id, :post_id], unique: true
    add_index :custom_reactions, :topic_id
  end
end