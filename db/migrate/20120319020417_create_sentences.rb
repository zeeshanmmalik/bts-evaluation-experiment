class CreateSentences < ActiveRecord::Migration
  def change
    create_table :sentences do |t|
      t.integer :number
      t.boolean :is_in_lex_summary
      t.boolean :is_in_email_summary
      t.references :comment

      t.timestamps
    end
    add_index :sentences, :comment_id
  end
end
