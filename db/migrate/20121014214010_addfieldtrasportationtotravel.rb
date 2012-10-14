class Addfieldtrasportationtotravel < ActiveRecord::Migration
  def change
    add_column :travels, :transportation, :string
  end
end
