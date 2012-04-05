class AddMoreSummaryHelpFieldsToResponse < ActiveRecord::Migration
  def change
    add_column :responses, :sum_help_bug_life, :integer

    add_column :responses, :sum_help_proj_cont, :integer

    add_column :responses, :sum_help_dev, :integer

    add_column :responses, :sum_help_non_dev, :integer

  end
end
