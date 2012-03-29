class AddBugIdentifierToBugReport < ActiveRecord::Migration
  def change
    add_column :bug_reports, :bug_identifier, :string

  end
end
