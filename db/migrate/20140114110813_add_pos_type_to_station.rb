class AddPosTypeToStation < ActiveRecord::Migration
  def change
    add_column :stations, :pos_type, :string
  end
end
