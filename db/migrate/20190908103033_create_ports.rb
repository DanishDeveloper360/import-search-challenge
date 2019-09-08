class CreatePorts < ActiveRecord::Migration[6.0]
  def change
    create_table :ports do |t|
      t.string :name
      t.string :code
      t.string :city
      t.string :oceans_insights_code
      t.decimal :lat
      t.decimal :lng
      t.string :big_schedules
      t.boolean :port_hub
      t.string :ocean_insights
      t.date :created_date
      t.date :updated_date
      t.references :port_type, null: false, foreign_key: true

      t.timestamps
    end
    add_index :ports, :code, unique: true
  end
end
