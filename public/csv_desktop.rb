require 'set'
require "csv"
require "active_record"
require "sqlite3"


  
def csv_desktop
      
      sve = Company.pluck(:MB)
      brojac = 0
      
      #File.delete("file.csv") if File.exist?("file.csv")
      
      lista = []
      CSV.foreach('file.csv') do |row|
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
                            
                              begin
                                jmbgHashZ = get_persons(firmaMB)
                              rescue e
                               puts "rescue"
                              # da li ostaviti ovo?
                              #a = Company.find_by(MB: firmaMB)
                              #a.update(clanovi: ["greska1", "greska1jmbg"], zastupnici: ["greska1", "greska1jmbg"], ostali_zastupnici: ["greska1", "greska1jmbg"], upravni_odbor: ["greska1", "greska1jmbg"], nadzorni_odbor: ["greska1", "greska1jmbg"])
                              #puts e
                              #break
                              
                              end
                            
                              jmbgHashZ.each do |nameANDjmbg|
                                            zas = Company.where("zastupnici LIKE ?", "%#{nameANDjmbg[1]}%")
                                            ost = Company.where("ostali_zastupnici LIKE ?", "%#{nameANDjmbg[1]}%")
                                            nad = Company.where("nadzorni_odbor LIKE ?", "%#{nameANDjmbg[1]}%")
                                            upr = Company.where("upravni_odbor LIKE ?", "%#{nameANDjmbg[1]}%")
                                            cla = Company.where("clanovi LIKE ?", "%#{nameANDjmbg[1]}%")
                                             
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
               
                              CSV.open("file.csv", "a+") do |csv|
                                  prviMB.each_with_index do |mb, index| 
                                    csv << ["#{prviMB[0]}", "#{mb}" ]
                                  end
                              puts "uneto je " + "#{brojac}"
                              brojac = brojac + 1
                              end

                            break
                            
         
                            end
                end  
      end  
    #redirect_to :back
  
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
    
    jmbgHashZ = Hash[*arejprve]
    jmbgHashZ[prva.poslovno_ime] = prva.MB.to_s
    
    return jmbgHashZ.to_a
  end

  
ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'csvdesktop.sqlite3'
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

csv_desktop
# x = Company.find_by(MB: 17162870)
# puts x.clanovi
# puts x.poslovno_ime
# puts x.zastupnici.length
# puts x.upravni_odbor