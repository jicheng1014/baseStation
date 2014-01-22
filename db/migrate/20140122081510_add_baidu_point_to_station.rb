class AddBaiduPointToStation < ActiveRecord::Migration
  def change
    add_column :stations, :baidu_lng, :float
    add_column :stations, :baidu_lat, :float
    add_column :stations, :translated, :string
  end
end
