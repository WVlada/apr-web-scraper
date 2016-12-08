class AddIndexToCompaniesMb < ActiveRecord::Migration
  def change
   add_index :companies, :MB, unique: true
  end
end
