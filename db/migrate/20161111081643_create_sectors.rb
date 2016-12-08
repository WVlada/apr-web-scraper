class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.string :idnumber
      t.string :naziv
      t.string :number

      t.timestamps null: false
    end
  end
end
