class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :name
      t.float :lat
      t.float :lng
      t.string :description
      t.text :markup

      t.timestamps
    end
  end
end
