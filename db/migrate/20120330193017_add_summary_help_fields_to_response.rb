class AddSummaryHelpFieldsToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :sum_help_bug_similar, :integer

    add_column :responses, :sum_help_bug_workaround, :integer

    add_column :responses, :sum_help_bug_status, :integer

  end
end
