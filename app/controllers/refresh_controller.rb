require 'set'
class RefreshController < ApplicationController
  
  def index
    
    populate_info_base_company_types
    populate_info_base_sectors
    populate_info_base_people

    redirect_to :back
  end
  
  private
  
  def populate_info_base_company_types
    
    first_populate_company_types
    
    forma_doo = Company.where ("pravna_forma = 'Друштво са ограниченом одговорношћу'")
    forma_ad = Company.where ("pravna_forma = 'Акционарско друштво'")
    forma_javno = Company.where ("pravna_forma = 'Јавно предузеће'")
    forma_komanditno_drustvo = Company.where ("pravna_forma = 'Командитно друштво'")
    forma_otvoreno_akcionarsko_drustvo = Company.where ("pravna_forma = 'Отворено акционарско друштво'")
    forma_zadruga = Company.where ("pravna_forma = 'Задруга'")
    forma_drustveno_preduzece = Company.where ("pravna_forma = 'Друштвено предузеће'")
    forma_ortacko_drustvo = Company.where ("pravna_forma = 'Ортачко друштво'")
    
    forma_drugo = Company.where ("pravna_forma = 'Друго'")
    
    doo = CompanyType.find_by_skraceno("doo")
    doo.number = forma_doo.count
    doo.save
    
    ad = CompanyType.find_by_skraceno("ad")
    ad.number = forma_ad.count
    ad.save
    
    javno = CompanyType.find_by_skraceno("javno")
    javno.number = forma_javno.count
    javno.save
    
    komanditno_drustvo = CompanyType.find_by_skraceno("komanditno")
    komanditno_drustvo.number = forma_komanditno_drustvo.count
    komanditno_drustvo.save
    
    otvoreno_akcionarsko_drustvo = CompanyType.find_by_skraceno("otvoreno ad")
    otvoreno_akcionarsko_drustvo.number = forma_otvoreno_akcionarsko_drustvo.count
    otvoreno_akcionarsko_drustvo.save
    
    zadruga = CompanyType.find_by_skraceno("zadruga")
    zadruga.number = forma_zadruga.count
    zadruga.save
    
    drustveno_preduzece = CompanyType.find_by_skraceno("dp")
    drustveno_preduzece.number = forma_drustveno_preduzece.count
    drustveno_preduzece.save
    
    ortacko_drustvo = CompanyType.find_by_skraceno("od")
    ortacko_drustvo.number = forma_ortacko_drustvo.count
    ortacko_drustvo.save
    
    drugo = CompanyType.find_by_skraceno("drugo")
    drugo.number = forma_drugo.count
    drugo.save
    
  end
    
  def first_populate_company_types
      CompanyType.delete_all
      
      CompanyType.new(idnumber: 1, name: "Društvo sa ograničenom odgovornošću", skraceno: "doo").save!
      CompanyType.new(idnumber: 2, name: "Akcionarsko društvo", skraceno: "ad").save!
      CompanyType.new(idnumber: 3, name: "Javno preduzeće", skraceno: "javno").save!
      CompanyType.new(idnumber: 4, name: "Komanditno društvo", skraceno: "komanditno").save!
      CompanyType.new(idnumber: 5, name: "Otvoreno akcionarsko duštvo", skraceno: "otvoreno ad").save!
      CompanyType.new(idnumber: 6, name: "Zadruga", skraceno: "zadruga").save!
      CompanyType.new(idnumber: 7, name: "Društveno preduzeće", skraceno: "dp").save!
      CompanyType.new(idnumber: 8, name: "Ortačko društvo", skraceno: "od").save!
      CompanyType.new(idnumber: 9, name: "Drugo", skraceno: "drugo").save!
      
  end
  
  def populate_info_base_sectors
      Sector.delete_all
      @sectors = Set.new
      
      Company.all.to_a.each do |x|
          @sectors << x.sifra_delatnosti
          @sectors << x.naziv_delatnosti
      end
      
      h = Hash[*@sectors]
      
      h.each do |key,value|
        Sector.new(number: "#{key}", naziv: "#{value}").save!
      end
      
      @sectorssum = []
      Company.all.to_a.each do |x|
          @sectorssum << x.sifra_delatnosti
          @sectorssum << x.naziv_delatnosti
      end
      
      hash = Hash.new(0)
      @sectorssum.each{|key| hash[key] += 1}
      puts hash
      
      Sector.all.each do |x|
        x.update(sum: "#{hash[x.number.to_i]}" )
      end
      
  end
  
  def populate_info_base_people
      Person.delete_all
      
      ################### KAO CLANOVI
      @peopleClanovi = []
      Company.all.each do |row|
        row.clanovi.to_a.each do |x|
          @peopleClanovi << x
        end
      end
      # moram reverse, da bi mi kljucevi vili JMBG-ovi, a ne imena
      # "Жарко Томовић"=>"2001961270050"
      @peopleClanovi.reverse!      
      # "2001961270050"=>"Жарко Томовић" - key -> value
      jmbgHash = Hash[*@peopleClanovi] # izgleda ovako: {"2212963782815"=>"Горан Николић", "0102967745011"=>"Јадранка Томић", "2711960788444"=>"Нада Дамјановић",
                                       # ovde sam ostalo bez duplikata!!!!!
      
      timesHash = Hash.new(0) # u @peopleClanovi su mi sacuvani duplikati, pa njih koristim
      @peopleClanovi.each{|key| timesHash[key] += 1} # timesHash sad izgleda ovako: {"2212963782815"=>2, "Горан Николић"=>2, "0102967745011"=>2, "Јадранка Томић"=>2
                                                     # imena i prezimena ce biti zanemarena, jer cu pretrazivati samo JMBG-ove
      jmbgHash.each do |key, value|
            Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_clan: timesHash[key]).save!
      end
  
      ################### KAO ZASTUPNICI
      @peopleZastupnici = []
      Company.all.each do |row|
         row.zastupnici.to_a.each do |x|
          @peopleZastupnici << x
         end
      end
      # takodje moram reverse
      @peopleZastupnici.reverse!
      
      jmbgHashZ = Hash[*@peopleZastupnici]
      timesHashZ = Hash.new(0)
      @peopleZastupnici.each{|key| timesHashZ[key] += 1}
      
      jmbgHashZ.each do |key, value|
      
       a = Person.find_by(jmbg: key)
         if a != nil
         #update postojeci
           a.update(broj_pojavljivanja_kao_zastupnik: timesHashZ[key])
         else
         #napravi novi
           Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_zastupnik: timesHashZ[key]).save!
         end
      end
  ################### KAO OSTALI ZASTUPNICI
      @peopleOstaliZastupnici = []
      Company.all.each do |row|
         row.ostali_zastupnici.to_a.each do |x|
          @peopleOstaliZastupnici << x
         end
      end
      # takodje moram reverse
      @peopleOstaliZastupnici.reverse!
      
      jmbgHashOZ = Hash[*@peopleOstaliZastupnici]
      timesHashOZ = Hash.new(0)
      @peopleOstaliZastupnici.each{|key| timesHashOZ[key] += 1}
      
      jmbgHashOZ.each do |key, value|
      
       b = Person.find_by(jmbg: key)
         if b != nil
         #update postojeci
           b.update(broj_pojavljivanja_kao_ostali_zastupnik: timesHashOZ[key])
         else
         #napravi novi
           Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_ostali_zastupnik: timesHashOZ[key]).save!
         end    
      end
      ################### KAO UO
      @peopleUO = []
      Company.all.each do |row|
         row.upravni_odbor.to_a.each do |x|
          @peopleUO << x
         end
      end
      # takodje moram reverse
      @peopleUO.reverse!
      
      jmbgHashUO = Hash[*@peopleUO]
      timesHashUO = Hash.new(0)
      @peopleUO.each{|key| timesHashUO[key] += 1}
      
      jmbgHashUO.each do |key, value|
      
       c = Person.find_by(jmbg: key)
         if c != nil
         #update postojeci
           c.update(broj_pojavljivanja_kao_upravni: timesHashUO[key])
         else
         #napravi novi
           Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_upravni: timesHashUO[key]).save!
         end    
      end
      
      ################### KAO NO
      @peopleNO = []
      Company.all.each do |row|
         row.nadzorni_odbor.to_a.each do |x|
          @peopleNO << x
         end
      end
      # takodje moram reverse
      @peopleNO.reverse!
      
      jmbgHashNO = Hash[*@peopleNO]
      timesHashNO = Hash.new(0)
      @peopleNO.each{|key| timesHashNO[key] += 1}
      
      jmbgHashNO.each do |key, value|
      
       d = Person.find_by(jmbg: key)
         if d != nil
         #update postojeci
           d.update(broj_pojavljivanja_kao_nadzorni: timesHashNO[key])
         else
         #napravi novi
           Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_nadzorni: timesHashNO[key]).save!
         end    
      end
  
  populate_sum_column
  
  end
  
  def populate_sum_column
  
    svi = Person.all
    svi.each do |row|
      b = 0
      b = b + row.broj_pojavljivanja_kao_clan unless row.broj_pojavljivanja_kao_clan == nil
      b = b + row.broj_pojavljivanja_kao_zastupnik unless row.broj_pojavljivanja_kao_zastupnik == nil
      b = b + row.broj_pojavljivanja_kao_ostali_zastupnik unless row.broj_pojavljivanja_kao_ostali_zastupnik == nil
      b = b + row.broj_pojavljivanja_kao_upravni unless row.broj_pojavljivanja_kao_upravni == nil
      b = b + row.broj_pojavljivanja_kao_nadzorni unless row.broj_pojavljivanja_kao_nadzorni == nil
      
      row.update(ukupno: b)
        
      end
    
    end
  
  
  
  
end
