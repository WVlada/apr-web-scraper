module CompaniesHelper
require "csv"
  def pretraga_povezanih_admin(kompanija)
        
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
  
  def pretraga_povezanih(kompanija)

        prva = kompanija
        
        prvaMB = []
        prvaMB << prva.MB

        prvaMB.each do |firma|
            jmbgHashZ = get_persons(firma)
            
            unless jmbgHashZ.nil?
            
                jmbgHashZ.each do |nameANDjmbg|
                    zas = Company.where("zastupnici LIKE ?", "%#{nameANDjmbg[1]}%")
                    ost = Company.where("ostali_zastupnici LIKE ?", "%#{nameANDjmbg[1]}%")
                    nad = Company.where("nadzorni_odbor LIKE ?", "%#{nameANDjmbg[1]}%")
                    upr = Company.where("upravni_odbor LIKE ?", "%#{nameANDjmbg[1]}%")
                    cla = Company.where("clanovi LIKE ?", "%#{nameANDjmbg[1]}%")
                    ######## u ovom slucaju MB
                    ime = Company.where("cast(\'MB\' as text) LIKE ?", "%#{nameANDjmbg[1]}%")
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
                    break
                end
            end
            # ovde cu da vratim sve kompanije kao relacije
            povezaneKompanije = []
            prvaMB.each do |x|
            povezaneKompanije << Company.find_by(:MB => x)
        end
        return povezaneKompanije
  end

  def get_persons(mb) 
      
    #arejprve = Set.new ovo nesme da bude Set, jer onda ne ulaze u array oni sto sam stavio da budu npr: DRUŠTVENO DRUŠTVENO
    arejprve = []
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