# encoding: UTF-8
require 'set'
require "csv"
require "active_record"
require "sqlite3"

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'desktop.sqlite3'
)

class Company < ActiveRecord::Base
    
    serialize :zastupnici, Array
    serialize :ostali_zastupnici, Array
    serialize :nadzorni_odbor, Array
    serialize :upravni_odbor, Array
    serialize :clanovi, Array
    
    def new
    @company = Company.new(company_params)
    
    end
    def create
    @company = Company.new(company_params)
    @company.save
    end
  
end

def precisti_clanove_i_ostale
    
    pocetak1 = 42798
    kraj1 = 60000
    pocetak2 = 59999
    kraj2 = 80000
    pocetak3 = 79999
    kraj3 = 100000
    pocetak4 = 99999
    kraj4 = 120000
    pocetak5 = 119999
    kraj5 = 144000
    pocetak6 = 143999
    kraj6 = 160000
    
    sve = Company.where(:id => pocetak6..kraj6)
    
    brojac = 1
    sve.each do |firma|
            y = []
            y = precisti_array(firma.clanovi)
            firma.update(clanovi: y)
            
            z = []
            z = precisti_array(firma.zastupnici)
            firma.update(zastupnici: z)
            
            m = []
            m = precisti_array(firma.ostali_zastupnici)
            firma.update(ostali_zastupnici: m)
            
            k = []
            k = precisti_array(firma.upravni_odbor)
            firma.update(upravni_odbor: k)
            
            l = []
            l = precisti_array(firma.nadzorni_odbor)
            firma.update(nadzorni_odbor: l)
        
        puts brojac
        brojac += 1
    end 
end

def precisti_array(array)

    novi = []
    # ovo je uneto za drustva koje nemaju clanove
    if array.length == 0
        novi << "n/a"
        novi << "n/a"
    end
    # sad tek moze ciscenje
    array.each_with_index do |x,i|
            if i % 2 == 0
                novi << x
            else
                if x =~ /\A\d+\Z/
                    novi << x
                else
                    novi << array[i-1]
                end
            end
    end
    
    novi2 = []
    novi.each_slice(2).to_a.each do |x|
        if x[0] =~ /(Друштвени капитал)/ || x[1] =~ /(Друштвени капитал)/
            novi2 << "Друштвени капитал"
            novi2 << "Друштвени капитал"
        elsif x[0] =~ /(Акцијски капитал)/ || x[1] =~ /(Акцијски капитал)/
            novi2 << "Акцијски капитал"
            novi2 << "Акцијски капитал"
        elsif x[0] =~ /(РЕПУБЛИКА СРБИЈА)/ || x[1] =~ /(РЕПУБЛИКА СРБИЈА)/
            novi2 << "РЕПУБЛИКА СРБИЈА"
            novi2 << "РЕПУБЛИКА СРБИЈА"
        elsif x[0] =~ /(Број пасоша)/ || x[1] =~ /(Број пасоша)/
            novi2 << "Странац - Број пасоша"
            novi2 << "Странац - Број пасоша"
        else
            novi2 << x[0]
            novi2 << x[1]
        end
    end

    return novi2
end

def provera
    x = Company.take(100)
    x.each do |c|
        puts c.clanovi
    end
end

def zamena_na_sa_nil
    
    pocetak1 = 42798
    kraj1 = 60000
    pocetak2 = 59999
    kraj2 = 80000
    pocetak3 = 79999
    kraj3 = 100000
    pocetak4 = 99999
    kraj4 = 120000
    pocetak5 = 119999
    kraj5 = 144000
    pocetak6 = 143999
    kraj6 = 160000
    
    sve = Company.where(:id => pocetak6..kraj6)
    brojac = 1
    sve.each do |kompanija|
        c = kompanija.clanovi
        c.delete("n/a")
        z = kompanija.zastupnici
        z.delete("n/a")
        o = kompanija.ostali_zastupnici
        o.delete("n/a")
        u = kompanija.upravni_odbor
        u.delete("n/a")
        n = kompanija.nadzorni_odbor
        n.delete("n/a")
        
        kompanija.update(clanovi: c)
        kompanija.update(zastupnici: z)
        kompanija.update(ostali_zastupnici: o)
        kompanija.update(upravni_odbor: u)
        kompanija.update(nadzorni_odbor: n)
        puts brojac
        brojac += 1
    end
    
  end

#precisti_clanove_i_ostale
provera
#zamena_na_sa_nil