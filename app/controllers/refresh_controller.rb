require 'set'
class RefreshController < ApplicationController
  
def index
    #precisti
    #izbaci_na
    #populate_info_base_company_types
    #populate_info_base_sectors
    populate_info_base_people
    #populate_oblasti
    
    #izbrisi_po_izboru
    
    redirect_to :back
end

private

def populate_info_base_company_types#

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
      
      #Person.delete_all
      
      #populate_clanovi
      #populate_zastupnici
      #populate_ostali_zastupnici
      #populate_upravni_odbor
      #populate_nadzorni_odbor
      #populate_sum_column
      izbrisi_strance
end
 
def populate_clanovi
    @peopleClanovi = []
    kompclanovi = Company.pluck(:clanovi)
    kompclanovi.each do |x|
        x.each do |y|
            @peopleClanovi << y
        end
    end
    @peopleClanovi.reverse! # "2001961270050"=>"Жарко Томовић" - key -> value
    # kada se ubacuje preko 10.000 on daje: Stack to deep ERROR
    #jmbgHash = Hash[*@peopleClanovi]
    #RESENJE
    jmbgHash = Hash[@peopleClanovi.each_slice(2).to_a]
    timesHash = Hash.new(0) # u @peopleClanovi su mi sacuvani duplikati, pa njih koristim
    @peopleClanovi.each{|key| timesHash[key] += 1} # timesHash sad izgleda ovako: {"2212963782815"=>2, "Горан Николић"=>2, "0102967745011"=>2, "Јадранка Томић"=>2
          jmbgHash.each do |key, value|
            Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_clan: timesHash[key]).save!
          end   
end
def populate_zastupnici
    
    @peopleZastupnici = []
    kompzastupnici = Company.pluck(:zastupnici)
    kompzastupnici.each do |x|
        x.each do |y|
            @peopleZastupnici << y
        end
    end
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
end
def populate_ostali_zastupnici
      kompostali = Company.pluck(:ostali_zastupnici)
      @peopleOstaliZastupnici = []
      kompostali.each do |x|
          x.each do |y|
               @peopleOstaliZastupnici << y
         end
      end
      
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
end
def populate_upravni_odbor
      @peopleUO = []
      kompupravni = Company.pluck(:upravni_odbor)
      kompupravni.each do |x|
          x.each do |y|
            @peopleUO << y
         end
      end
      
      @peopleUO.reverse!
      jmbgHashUO = Hash[@peopleUO.each_slice(2).to_a]
      timesHashUO = Hash.new(0)
      @peopleUO.each{|key| timesHashUO[key] += 1}
      
      jmbgHashUO.each do |key, value|
      
       c = Person.find_by(jmbg: key)
         if c != nil
           c.update(broj_pojavljivanja_kao_upravni: timesHashUO[key])
         else
           Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_upravni: timesHashUO[key]).save!
         end    
      end
end
def populate_nadzorni_odbor
      kompnadzorni = Company.pluck(:nadzorni_odbor)
      @peopleNO = []
      kompnadzorni.each do |x|
          x.each do |y|
             @peopleNO << y
         end
      end
      
      @peopleNO.reverse!
      jmbgHashNO = Hash[@peopleNO.each_slice(2).to_a]
      timesHashNO = Hash.new(0)
      @peopleNO.each{|key| timesHashNO[key] += 1}
      
      jmbgHashNO.each do |key, value|
      
       d = Person.find_by(jmbg: key)
         if d != nil
           d.update(broj_pojavljivanja_kao_nadzorni: timesHashNO[key])
         else
           Person.new(ime_i_prezime: "#{value}", jmbg: "#{key}", broj_pojavljivanja_kao_nadzorni: timesHashNO[key]).save!
         end    
      end
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
def izbrisi_strance
    Person.where(ime_i_prezime: "Странац - Број пасоша").delete_all
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
  
def izbrisi_po_izboru
      x = []
      
      jmbg_za_brisanje = "2303981870018"
      
      x << Company.where("clanovi LIKE ?", "%#{jmbg_za_brisanje}%")
      x << Company.where("zastupnici LIKE ?", "%#{jmbg_za_brisanje}%")
      
      #a = Company.find_by(MB: firmaMB)
      #a.update(clanovi: ["greska1", "greska1jmbg"], zastupnici: ["greska1", "greska1jmbg"], ostali_zastupnici: ["greska1", "greska1jmbg"], upravni_odbor: ["greska1", "greska1jmbg"], nadzorni_odbor: ["greska1", "greska1jmbg"])
      mbovi = []
      x.each do |y|
        y.each do |z|
          mbovi << z.MB
        end
      end
      mbovi.each do |m|
        Company.where(mb: m).destroy_all
        puts "destroyed"
      end
end

def precisti

    pocetak1 = 42798
    kraj1 = 50000
    pocetak2 = 49999
    kraj2 = 60000
    pocetak3 = 59999
    kraj3 = 70000
    pocetak4 = 69999
    kraj4 = 80000
    pocetak5 = 79999
    kraj5 = 90000
    pocetak6 = 89999
    kraj6 = 100000
    pocetak7 = 99999
    kraj7 = 110000
    pocetak8 = 109999
    kraj8 = 120000
    pocetak9 = 119999
    kraj9 = 130000
    pocetak10 = 129999
    kraj10 = 140000
    pocetak11 = 139999
    kraj11 = 150000
    pocetak12 = 149999
    kraj12 = 160000
    
    sve = Company.where(:id => pocetak12..kraj12)
    sve = Company.where(:id => 138415)
    #sve = Company.where("clanovi LIKE ?", "%Тип: Ак%")
    #sve = []
    #sve << Company.where("clanovi LIKE ?", "%Тип: Ак%").first
    
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
        elsif x[0] =~ /(Државни капитал)/ || x[1] =~ /(Државни капитал)/
            novi2 << "Државни капитал"
            novi2 << "Државни капитал"
        elsif x[0] =~ /(РЕПУБЛИКА СРБИЈА)/ || x[1] =~ /(РЕПУБЛИКА СРБИЈА)/
            novi2 << "РЕПУБЛИКА СРБИЈА"
            novi2 << "РЕПУБЛИКА СРБИЈА"
        elsif x[0] =~ /(REPUBLIKA SRBIJA)/ || x[1] =~ /(REPUBLIKA SRBIJA)/
            novi2 << "РЕПУБЛИКА СРБИЈА"
            novi2 << "РЕПУБЛИКА СРБИЈА"
        elsif x[0] =~ /(ОПШТИНА)/ || x[1] =~ /(ОПШТИНА)/ || x[0] =~ /(OPŠTINE)/ || x[1] =~ /(OPŠTINЕ)/ || x[0] =~ /(OPŠTINА)/ || x[1] =~ /(OPŠTINА)/
            novi2 << "ОПШТИНА"
            novi2 << "ОПШТИНА"
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

def izbaci_na
    
    pocetak1 = 42798
    kraj1 = 50000
    pocetak2 = 49999
    kraj2 = 60000
    pocetak3 = 59999
    kraj3 = 70000
    pocetak4 = 69999
    kraj4 = 80000
    pocetak5 = 79999
    kraj5 = 90000
    pocetak6 = 89999
    kraj6 = 100000
    pocetak7 = 99999
    kraj7 = 110000
    pocetak8 = 109999
    kraj8 = 120000
    pocetak9 = 119999
    kraj9 = 130000
    pocetak10 = 129999
    kraj10 = 140000
    pocetak11 = 139999
    kraj11 = 150000
    pocetak12 = 149999
    kraj12 = 160000
    
    sve = Company.where(:id => pocetak12..kraj12)
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

end
