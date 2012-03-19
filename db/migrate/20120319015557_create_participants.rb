class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.string :name
      t.string :email
      t.string :access_token
      t.boolean :is_selected
      t.boolean :is_email_sent
      t.datetime :eval_started_at
      t.datetime :eval_submitted_at
      t.boolean :is_reminder_sent
      t.datetime :reminder_sent_at
      t.integer :reminder_count
      t.references :experiment

      t.timestamps
    end
    add_index :participants, :experiment_id
  end
end
