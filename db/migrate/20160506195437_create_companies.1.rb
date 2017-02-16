class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :mb
      t.string :poslovno_ime
      t.string :status
      t.string :pravna_forma
      t.string :opstina
      t.string :mesto
      t.string :ulica_i_broj
      t.string :datum_osnivanja
      t.integer :pib
      t.integer :sifra_delatnosti
      t.string :naziv_delatnosti
      t.text :zastupnici
      t.text :ostali_zastupnici
      t.text :nadzorni_odbor
      t.text :upravni_odbor
      t.text :clanovi

      t.timestamps null: false
    end
  end
end
