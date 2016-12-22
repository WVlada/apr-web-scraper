class AddOblastToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :oblast, :string
  end
end
