class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.datetime :submitted_at
      t.integer :number
      t.references :participant
      t.references :bug_report

      t.timestamps
    end
    add_index :comments, :participant_id
    add_index :comments, :bug_report_id
  end
end
