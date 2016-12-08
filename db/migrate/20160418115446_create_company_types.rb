class CreateCompanyTypes < ActiveRecord::Migration
  def change
    create_table :company_types do |t|
      t.integer :idnumber
      t.string :name
      t.string :skraceno

      t.timestamps null: true
    end
    add_index :company_types, :skraceno, unique: true
  end
end
