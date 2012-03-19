class CreateBugReports < ActiveRecord::Migration
  def change
    create_table :bug_reports do |t|
      t.string :title
      t.string :project
      t.string :original_link
      t.references :experiment

      t.timestamps
    end
    add_index :bug_reports, :experiment_id
  end
end
