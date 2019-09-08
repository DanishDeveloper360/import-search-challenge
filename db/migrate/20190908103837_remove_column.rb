class RemoveColumn < ActiveRecord::Migration[6.0]
  def change
    remove_column :ports, :created_date
    remove_column :ports, :updated_date
  end
end
