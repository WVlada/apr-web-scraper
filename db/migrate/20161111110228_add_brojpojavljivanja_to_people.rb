class AddBrojpojavljivanjaToPeople < ActiveRecord::Migration
  def change
    add_column :people, :broj_pojavljivanja_kao_clan, :integer
    add_column :people, :broj_pojavljivanja_kao_zastupnik, :integer
    add_column :people, :broj_pojavljivanja_kao_ostali_zastupnik, :integer
    add_column :people, :broj_pojavljivanja_kao_upravni, :integer
    add_column :people, :broj_pojavljivanja_kao_nadzorni, :integer
    add_column :people, :ukupno, :integer
  end
end
