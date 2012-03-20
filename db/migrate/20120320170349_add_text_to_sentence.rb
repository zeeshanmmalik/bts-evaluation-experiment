class AddTextToSentence < ActiveRecord::Migration
  def change
    add_column :sentences, :text, :text

  end
end
