class AddUsernameAndSummaryAssignedToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :username, :string

    add_column :participants, :summary_assigned, :string

  end
end
