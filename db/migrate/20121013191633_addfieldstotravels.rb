class Addfieldstotravels < ActiveRecord::Migration
  def change
    add_column :travels, :location, :string
    add_column :travels, :start_date, :date
    add_column :travels, :end_date, :date    
  end
end
