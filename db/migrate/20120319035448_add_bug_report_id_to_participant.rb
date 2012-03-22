class AddBugReportIdToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :bug_report_id, :integer
    add_index :participants, :bug_report_id
  end
end
