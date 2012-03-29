class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :subject
      t.text :body
      t.string :email_type
      t.references :experiment

      t.timestamps
    end
    add_index :emails, :experiment_id
  end
end
