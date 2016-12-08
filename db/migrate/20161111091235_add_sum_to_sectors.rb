class AddSumToSectors < ActiveRecord::Migration
  def change
    add_column :sectors, :sum, :integer
  end
end
