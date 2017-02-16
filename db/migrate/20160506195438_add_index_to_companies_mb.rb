class AddIndexToCompaniesMb < ActiveRecord::Migration
  def change
   add_index :companies, :mb, unique: true
  end
end
