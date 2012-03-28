class CreateParticipantsSentences < ActiveRecord::Migration
  def change
    create_table :participants_sentences do |t|
      t.references :participant
      t.references :sentence
      t.integer :importance

      t.timestamps
    end
    add_index :participants_sentences, :participant_id
    add_index :participants_sentences, :sentence_id
  end
end
