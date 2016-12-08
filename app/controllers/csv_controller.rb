require 'set'
require "csv"
class CsvController < ApplicationController
  
  def index
      
      File.delete("./public/file.csv") if File.exist?("./public/file.csv")
      
      sve = Company.take(20000)
      m = 0
      sve.each do |kompanija|
                
                prvaMB = []
                prvaMB << kompanija.MB
    
                prvaMB.each do |firma|
                            unless kompanija.clanovi == ["greska1", "greska1jmbg"]
                              begin # zanimljiv slucaj MB=6002188, tu je Agencija za licenciranje bila zastupnik, ali je zbog nje negde dalje imao gresku
                              #20104279 ovde mi je pucao, jer Opstine kao clanovi nemaju maticne brojeve, pa je pucao pri pretvaranju u Hash
                              jmbgHashZ = get_persons(firma)
                              rescue
                              a = Company.find_by(MB: kompanija.MB)
                              # elementi arrayja moraju biti razliciti jer ulaze u SET pa ce dati error: odd number of elemetsn for Hash
                              a.update(clanovi: ["greska1", "greska1jmbg"], zastupnici: ["greska1", "greska1jmbg"], ostali_zastupnici: ["greska1", "greska1jmbg"], upravni_odbor: ["greska1", "greska1jmbg"], nadzorni_odbor: ["greska1", "greska1jmbg"])
                              break
                              #  moram ovde da ispravljam
                              end
                            
                              jmbgHashZ.each do |nameANDjmbg|
                                            zas = Company.where("zastupnici LIKE ?", "%#{nameANDjmbg[1]}%")
                                            ost = Company.where("ostali_zastupnici LIKE ?", "%#{nameANDjmbg[1]}%")
                                            nad = Company.where("nadzorni_odbor LIKE ?", "%#{nameANDjmbg[1]}%")
                                            upr = Company.where("upravni_odbor LIKE ?", "%#{nameANDjmbg[1]}%")
                                            cla = Company.where("clanovi LIKE ?", "%#{nameANDjmbg[1]}%")
                                             
                                            ######## u ovom slucaju MB
                                            ime = Company.where("MB LIKE ?", "%#{nameANDjmbg[1]}%")
                                            
                                            # SET se kao i HASH ne moze modifikovati u iteraciji
                                            # my_array.push(item1) unless my_array.include?(item1) 
                                            zas.each do |x|
                                                  prvaMB.push(x.MB) unless prvaMB.include?(x.MB)
                                            end unless zas == nil
                                            ost.each do |x|
                                                  prvaMB.push(x.MB) unless prvaMB.include?(x.MB)
                                            end unless ost == nil
                                            nad.each do |x|
                                                  prvaMB.push(x.MB) unless prvaMB.include?(x.MB)
                                            end unless nad == nil
                                            upr.each do |x|
                                                  prvaMB.push(x.MB) unless prvaMB.include?(x.MB)
                                            end unless upr == nil
                                            cla.each do |x|
                                                  prvaMB.push(x.MB) unless prvaMB.include?(x.MB)
                                            end unless cla == nil
                                            ime.each do |x|
                                                  prvaMB.push(x.MB) unless prvaMB.include?(x.MB)
                                            end unless ime == nil
                              end
                            end
                end
        
        CSV.open("public/file.csv", "a+") do |csv|
                                          prvaMB.each_with_index do |mb, index| 
                                                                csv << ["#{prvaMB[0]}", "#{mb}", "#{m}" ]
                                                                end
                                          end
        puts "uneto je " + "#{m}"
        m = m + 1
        
        end
          
    redirect_to :back
  
  end
  
  private
  
  def get_persons(mb) 
      
    arejprve = Set.new
    prva = Company.find_by(:MB => mb)
    
    unless prva.zastupnici.length == 0
      prva.zastupnici.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise # moj prvi raise!!!
            else
              arejprve << y
            end
      end
    end
    unless prva.ostali_zastupnici == 0
      prva.ostali_zastupnici.to_a.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise
            else
              arejprve << y
            end
      end
    end
    unless prva.upravni_odbor.length == 0
      prva.upravni_odbor.to_a.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise
            else
              arejprve << y
            end
      end
    end
    unless prva.nadzorni_odbor.length == 0
      prva.nadzorni_odbor.to_a.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise
            else
              arejprve << y
            end
      end
    end
    unless prva.clanovi.length == 0
      prva.clanovi.to_a.each do |y|
           if y[0].length == 0 || y[1].length == 0
              raise
            else
              arejprve << y
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
