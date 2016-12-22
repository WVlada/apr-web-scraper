require 'set'
class RefreshController < ApplicationController
  
  def index
    
    #populate_info_base_company_types
    #populate_info_base_sectors
    #populate_info_base_people
    #populate_sum_column
    populate_oblasti

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
      
      kompclanovi = Company.pluck(:clanovi)
      #Company.all.each do |row|
      kompclanovi.each do |x|
          x.each do |y|
      #  row.clanovi.to_a.each do |x|
      # @peopleClanovi << x
        @peopleClanovi << y unless y == nil
          end
      end
      # moram reverse, da bi mi kljucevi vili JMBG-ovi, a ne imena
      # "Жарко Томовић"=>"2001961270050"
      @peopleClanovi.reverse!      
      # "2001961270050"=>"Жарко Томовић" - key -> value
      
      # kada se ubacuje preko 10.000 on daje: Stack to deep ERROR
      #jmbgHash = Hash[*@peopleClanovi]
      #RESENJE
      jmbgHash = Hash[@peopleClanovi.each_slice(2).to_a]
      
      timesHash = Hash.new(0) # u @peopleClanovi su mi sacuvani duplikati, pa njih koristim
      @peopleClanovi.each{|key| timesHash[key] += 1} # timesHash sad izgleda ovako: {"2212963782815"=>2, "Горан Николић"=>2, "0102967745011"=>2, "Јадранка Томић"=>2
                                                     # imena i prezimena ce biti zanemarena, jer cu pretrazivati samo JMBG-ove
      jmbgHash.each do |key, value|
            Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_clan: timesHash[key]).save!
      end
  
      ################### KAO ZASTUPNICI
      @peopleZastupnici = []
      #Company.all.each do |row|
      kompzastupnici = Company.pluck(:zastupnici)
      kompzastupnici.each do |x|
          x.each do |y|
      #   row.zastupnici.to_a.each do |x|
          @peopleZastupnici << y unless y == nil
      end
      end
      #end
      # takodje moram reverse
      @peopleZastupnici.reverse!
      
      jmbgHashZ = Hash[@peopleZastupnici.each_slice(2).to_a]
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
      kompostali = Company.pluck(:ostali_zastupnici)
      @peopleOstaliZastupnici = []
      kompostali.each do |x|
          x.each do |y|
      #Company.all.each do |row|
    #     row.ostali_zastupnici.to_a.each do |x|
          @peopleOstaliZastupnici << y unless y == nil
         end
      end
      # takodje moram reverse
      @peopleOstaliZastupnici.reverse!
      
      jmbgHashOZ = Hash[@peopleOstaliZastupnici.each_slice(2).to_a]
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
      kompupravni = Company.pluck(:upravni_odbor)
      #Company.all.each do |row|
      kompupravni.each do |x|
          x.each do |y|
    #     row.upravni_odbor.to_a.each do |x|
          @peopleUO << y unless y == nil
         end
      end
      # takodje moram reverse
      @peopleUO.reverse!
      
      jmbgHashUO = Hash[@peopleUO.each_slice(2).to_a]
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
      kompnadzorni = Company.pluck(:nadzorni_odbor)
      @peopleNO = []
      #Company.all.each do |row|
      kompnadzorni.each do |x|
          x.each do |y|
     #    row.nadzorni_odbor.to_a.each do |x|
          @peopleNO << y unless y == nil
         end
      end
      # takodje moram reverse
      @peopleNO.reverse!
      
      jmbgHashNO = Hash[@peopleNO.each_slice(2).to_a]
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
  
  
  def populate_oblasti
      
      Company.all.each do |kompanija|
      
        x = kompanija.sifra_delatnosti.to_i
        
        if x > 0 && x < 1000
        ob = "ПОЉОПРИВРЕДА, ШУМАРСТВО И РИБАРСТВО"
        end
        if x > 1000 && x < 2000
        ob = "ПРЕРАЂИВАЧКА ИНДУСТРИЈА"  
        end
        if x > 2000 && x < 4000
        ob = "ПРЕРАЂИВАЧКА ИНДУСТРИЈА"  
        end
        if x > 4000 && x < 4500
        ob = "ГРАЂЕВИНАРСТВО"  
        end
        if x > 4500 && x < 4900
        ob = "ТРГОВИНА НА ВЕЛИКО И ТРГОВИНА НА МАЛО; ПОПРАВКА МОТОРНИХ ВОЗИЛА И МОТОЦИКАЛА"  
        end
        if x > 4900 && x < 5500
        ob = "САОБРАЋАЈ И СКЛАДИШТЕЊЕ"  
        end
        if x > 5500 && x < 5800
        ob = "УСЛУГЕ СМЕШТАЈА И ИСХРАНЕ"  
        end
        if x > 5800 && x < 6400
        ob = "ИНФОРМИСАЊЕ И КОМУНИКАЦИЈЕ"  
        end
        if x > 6400 && x < 6800
        ob = "ФИНАНСИЈСКЕ ДЕЛАТНОСТИ И ДЕЛАТНОСТ ОСИГУРАЊА"  
        end
        if x > 6800 && x < 6900
        ob = "ПОСЛОВАЊЕ НЕКРЕТНИНАМА"  
        end
        if x > 6900 && x < 7700
        ob = "СТРУЧНЕ, НАУЧНЕ, ИНОВАЦИОНЕ И ТЕХНИЧКЕ ДЕЛАТНОСТИ"  
        end
        if x > 7700 && x < 8400
        ob = "АДМИНИСТРАТИВНЕ И ПОМОЋНЕ УСЛУЖНЕ ДЕЛАТНОСТИ"  
        end
        if x > 8400 && x < 8600
        ob = "ДРЖАВНА УПРАВА И ОДБРАНА; ОБАВЕЗНО СОЦИЈАЛНО ОСИГУРАЊЕ"  
        end
        if x > 8600 && x < 9000
        ob = "ЗДРАВСТВЕНА И СОЦИЈАЛНА ЗАШТИТА"  
        end
        if x > 9000 && x < 9850
        ob = "УМЕТНОСТ; ЗАБАВА И РЕКРЕАЦИЈА"  
        end
        if x > 9850 && x < 9999
        ob = "ДЕЛАТНОСТ ЕКСТЕРИТОРИЈАЛНИХ ОРГАНИЗАЦИЈА И ТЕЛА"  
        end
       
       kompanija.update(oblast: ob)
       
      end
    
  
  end
  
end
