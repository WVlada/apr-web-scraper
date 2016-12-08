class AddNumberToCompanyTypes < ActiveRecord::Migration
  def change
    add_column :company_types, :number, :integer
  end
end
