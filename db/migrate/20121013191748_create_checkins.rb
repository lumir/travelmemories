class CreateCheckins < ActiveRecord::Migration
  def change
    create_table :checkins do |t|
      t.string :name      
      t.string :country     
      t.string :city      
      t.integer :travel_id 
      t.timestamps
    end
  end
end
