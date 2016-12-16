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
    
                prvaMB.each do |firmaMB|
                            
                              begin 
                                jmbgHashZ = get_persons(firmaMB)
                              rescue e
                                puts "rescue"
                              
                              end
                            
                              jmbgHashZ.each do |nameANDjmbg|
                                            zas = Company.where("zastupnici LIKE ?", "%#{nameANDjmbg[1]}%")
                                            ost = Company.where("ostali_zastupnici LIKE ?", "%#{nameANDjmbg[1]}%")
                                            nad = Company.where("nadzorni_odbor LIKE ?", "%#{nameANDjmbg[1]}%")
                                            upr = Company.where("upravni_odbor LIKE ?", "%#{nameANDjmbg[1]}%")
                                            cla = Company.where("clanovi LIKE ?", "%#{nameANDjmbg[1]}%")
                                             
                                            ######## u ovom slucaju MB
                                            ime = Company.where("MB LIKE ?", "%#{nameANDjmbg[1]}%")
                                            
                                            zas.each do |x|
                                                  prviMB.push(x.MB) unless prviMB.include?(x.MB)
                                            end unless zas == nil
                                            ost.each do |x|
                                                  prviMB.push(x.MB) unless prviMB.include?(x.MB)
                                            end unless ost == nil
                                            nad.each do |x|
                                                  prviMB.push(x.MB) unless prviMB.include?(x.MB)
                                            end unless nad == nil
                                            upr.each do |x|
                                                  prviMB.push(x.MB) unless prviMB.include?(x.MB)
                                            end unless upr == nil
                                            cla.each do |x|
                                                  prviMB.push(x.MB) unless prviMB.include?(x.MB)
                                            end unless cla == nil
                                            ime.each do |x|
                                                  prviMB.push(x.MB) unless prviMB.include?(x.MB)
                                            end unless ime == nil
                                        end
        
                CSV.open("public/filerails.csv", "a+") do |csv|
                        prviMB.each_with_index do |mb, index| 
                        csv << ["#{prviMB[0]}", "#{mb}" ]
                        end
                        puts "uneto je " + "#{brojac}"
                        brojac = brojac + 1
                end
        
                break
        
                end #za prvaMB.each
                end# za IF
      end# sve.each
        
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
