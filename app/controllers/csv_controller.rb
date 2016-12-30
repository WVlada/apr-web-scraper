require 'set'
require "csv"
class CsvController < ApplicationController
  
  def index
      
      sve = Company.pluck(:MB)
      brojac = 0
      
      #File.delete("./public/file.csv") if File.exist?("./public/file.csv")
      # append fora
      lista = []
      CSV.foreach('./public/filerails.csv') do |row|
          lista << row[0]
      end
      
      sve.each do |kompanijaMB|
                
                # append
                if lista.include?(kompanijaMB.to_s)
                  puts "preskacem"
                  next
                else
                
                prviMB = []
                prviMB << kompanijaMB
    
                prviMB.each do |firmaMB|
                drugi = [] # ovaj se isto resetuje posle breaka            
                              begin 
                                jmbgHashZ = get_persons(firmaMB)
                              rescue
                                puts "rescue"
                              end
                              
                              jmbgHashZ.each do |nameANDjmbg|
                                          povezanost_preko = ""# ovaj se resetuje za svakog Persona              
                                          # moram nekako izbaciti broj pasosa, ostali imaju smisla zbog drzavnog sektora
                                          if nameANDjmbg[1] =~ /\A\d+\Z/
                                            broj = Company.where('zastupnici LIKE :search OR ostali_zastupnici LIKE :search OR nadzorni_odbor LIKE :search OR upravni_odbor LIKE :search OR clanovi LIKE :search OR MB LIKE :search', search: "%#{nameANDjmbg[1]}%")
                                          else
                                            # neka bude za pocetak bez stranaca
                                            broj = Company.where('zastupnici LIKE :search OR ostali_zastupnici LIKE :search OR nadzorni_odbor LIKE :search OR upravni_odbor LIKE :search OR clanovi LIKE :search OR MB LIKE :search', search: "%#{nameANDjmbg[0]}%") unless nameANDjmbg[0] == "Странац - Број пасоша"
                                          end
                                          
                                          povezanost_preko = nameANDjmbg[0]  
                                          broj.each do |x|
                                                # mora unless inace dodaje duplikate za svakog Persona
                                                # ali moram da unosim selfloop, jer ne bi bilo singl-nodova
                                                # a unless prviMB iskljucuje cak i self-loop
                                                drugi.push([x.MB, povezanost_preko]) unless prviMB.include?(x.MB) 
                                          end unless broj == nil
                              
                              end#
                # ovaj prvi upis ide za self-loop-ove da bih dobio i singl nodove              
                CSV.open("public/filerails.csv", "a+") do |csv|
                  csv << ["#{prviMB[0]}", "#{prviMB[0]}" ]
                end
                # ovaj drugi loop ide za povezanost i on ima 3 upisa
                CSV.open("public/filerails.csv", "a+") do |csv|
                        drugi.each_with_index do |mb, index| 
                        csv << ["#{prviMB[0]}", mb[0], mb[1] ]
                        end
                        puts "uneto je " + "#{brojac}"
                        brojac = brojac + 1
                end
                #
                
                break #ovaj brejk ne dozvoljava veze drugog i visih nivoa
        
                end #za prvaMB.each
                end# za IF
      end# sve.each
        
      redirect_to :back
  
  end
  
  private
  
  def get_persons(mb) 
      
    #arejprve = Set.new - ne sme biti set zbog ispravki koje sam uneo, da se imena ponavljaju
    arejprve = []
    prva = Company.find_by(:MB => mb)
    
    unless prva.zastupnici.length == 0
      prva.zastupnici.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise # moj prvi raise!!!
            else
              arejprve << y unless y == ["n/a", "n/a"]
            end
      end
    end
    unless prva.ostali_zastupnici == 0
      prva.ostali_zastupnici.to_a.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise
            else
              arejprve << y unless y == ["n/a", "n/a"]
            end
      end
    end
    unless prva.upravni_odbor.length == 0
      prva.upravni_odbor.to_a.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise
            else
              arejprve << y unless y == ["n/a", "n/a"]
            end 
      end
    end
    unless prva.nadzorni_odbor.length == 0
      prva.nadzorni_odbor.to_a.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise
            else
              arejprve << y unless y == ["n/a", "n/a"]
            end
      end
    end
    unless prva.clanovi.length == 0
      prva.clanovi.to_a.each do |y|
           if y[0].length == 0 || y[1].length == 0
              raise
            else
              arejprve << y unless y == ["n/a", "n/a"]
           end
      end
    end
    
    # jer mi kolone nisu araj arajova, nego obican aray za svakog zastupnika
    jmbgHashZ = Hash[*arejprve]
    jmbgHashZ[prva.poslovno_ime] = prva.MB.to_s
    
    # Mora biti array, jer kroz Hash ne mogu da dodajem nove kljuceve u iteracijama, u araju moze
    return jmbgHashZ.to_a
  end  

end
