class CreateSentenceEvaluations < ActiveRecord::Migration
  def change
    create_table :sentence_evaluations do |t|
      t.references :participant
      t.references :sentence
      t.integer :importance

      t.timestamps
    end
    add_index :sentence_evaluations, :participant_id
    add_index :sentence_evaluations, :sentence_id
    add_index :sentence_evaluations, [:participant_id, :sentence_id]
  end
end
