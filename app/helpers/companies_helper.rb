module CompaniesHelper

  def pretraga_povezanih(kompanija)
        
        prva = kompanija
        
        prvaMB = []
        prvaMB << prva.MB
        
        prvaMB.each do |firma|
            
        jmbgHashZ = get_persons(firma)
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
    
      # ovde cu da vratim sve kompanije kao relacije
      povezaneKompanije = []
      prvaMB.each do |x|
          povezaneKompanije << Company.find_by(:MB => x)
      end
      
      return povezaneKompanije
  
  end

  def get_persons(mb) 
      
  arejprve = Set.new
  prva = Company.find_by(:MB => mb)
   
    prva.zastupnici.each do |y|
            arejprve << y
    end
    prva.ostali_zastupnici.to_a.each do |y|
            arejprve << y
    end
    prva.upravni_odbor.to_a.each do |y|
            arejprve << y
    end
    prva.nadzorni_odbor.to_a.each do |y|
            arejprve << y
    end
    prva.clanovi.to_a.each do |y|
           arejprve << y
    end
    
    jmbgHashZ = Hash[*arejprve]
    jmbgHashZ[prva.poslovno_ime] = prva.MB.to_s
    
    # Mora biti array, jer kroz Hash ne mogu da dodajem nove kljuceve u iteracijama, u araju moze
    return jmbgHashZ.to_a
  end  
        
end