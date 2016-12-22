class CreateOblasts < ActiveRecord::Migration
  def change
    create_table :oblasts do |t|
      t.string :name
      t.integer :broj

      t.timestamps null: false
    end
  end
end
