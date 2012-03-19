class AddParticipantIdToBugReport < ActiveRecord::Migration
  def change
    add_column :bug_reports, :participant_id, :integer
  end
end
