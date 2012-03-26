class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.integer :imp_points_incl_lex_sum
      t.integer :imp_points_incl_email_sum
      t.integer :redundancy_lex_sum
      t.integer :redundancy_email_sum
      t.integer :unnecessary_info_lex_sum
      t.integer :unnecessary_info_email_sum
      t.integer :coherence_lex_sum
      t.integer :coherence_email_sum
      t.string :summary_view_pref
      t.text :view_pref_reason
      t.boolean :is_summarizing_br_helpful
      t.text :summarizing_reason
      t.text :important_info_in_summary
      t.string :contact_for_results
      t.references :participant
      t.references :bug_report

      t.timestamps
    end
    add_index :responses, :participant_id
    add_index :responses, :bug_report_id
  end
end
