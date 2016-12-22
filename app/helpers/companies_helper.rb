module CompaniesHelper
require "csv"
  def pretraga_povezanih(kompanija)
        
         lista = []
         CSV.foreach('./public/file.csv') do |row|
            lista << [row[0], row[1]]
         end
          # lista je sada array arrayjova parova
          
          rezultat = []
          lista.each do |svakipar|
             if svakipar[0] == kompanija.MB.to_s
                rezultat << svakipar[1]
             end
          end
       
        return Company.where(MB: rezultat)
  
  end

  def get_persons(mb) 
      
#   arejprve = Set.new
#   prva = Company.find_by(:MB => mb)
   
#     prva.zastupnici.each do |y|
#             arejprve << y
#     end
#     prva.ostali_zastupnici.to_a.each do |y|
#             arejprve << y
#     end
#     prva.upravni_odbor.to_a.each do |y|
#             arejprve << y
#     end
#     prva.nadzorni_odbor.to_a.each do |y|
#             arejprve << y
#     end
#     prva.clanovi.to_a.each do |y|
#           arejprve << y
#     end
    
#     jmbgHashZ = Hash[*arejprve]
#     jmbgHashZ[prva.poslovno_ime] = prva.MB.to_s
    
#     # Mora biti array, jer kroz Hash ne mogu da dodajem nove kljuceve u iteracijama, u araju moze
#     return jmbgHashZ.to_a
   end  
        
end