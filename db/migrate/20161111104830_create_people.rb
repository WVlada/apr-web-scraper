class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      
      t.string :ime_i_prezime
      t.string :jmbg
      
      t.timestamps null: false
    
    end
  end
end
