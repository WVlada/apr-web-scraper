class UploadsController < ApplicationController
  
  def unesi

    puts params[:fajl]

    pocetni_array = []
    CSV.foreach("#{params[:fajl]}", {:col_sep => "xxxx"}) do |row|
        pocetni_array << row
    end
    
    # SELECT ALL MBS and SAVE THEM
    pocetni_array.each do |x|
         params[:company] = {}   	
         x_pravnaforma = x[2].scan(/Правна форма:(.*?)Седиште: Општина:/)
         
         if x_pravnaforma.empty?
            next #ovime sam resio udruzenje, jer ono x_pravnaforma vraca nil - iako je greska nil - ali samo za prvog clana araaya, nego prazan array
         end
         if x_pravnaforma[0][0].strip == "Друштво са ограниченом одговорношћу"	
            skinidoo(x)
         end
         if x_pravnaforma[0][0].strip == "Акционарско друштво"	
            skinidoo(x)
         end
         if x_pravnaforma[0][0].strip == "Јавно предузеће"	
            skinidoo(x)
         end
         if x_pravnaforma[0][0].strip == "Командитно друштво"	
            skinidoo(x)
         end
         if x_pravnaforma[0][0].strip == "Отворено акционарско друштво"	
            skinidoo(x)
         end
         if x_pravnaforma[0][0].strip == "Задруга"	
            skinidoo(x)
         end
         if x_pravnaforma[0][0].strip == "Друштвено предузеће"	
            skinidoo(x)
         end
         if x_pravnaforma[0][0].strip == "Ортачко друштво"	
            skinidoo(x)
         end
         if x_pravnaforma[0][0].strip == "Друго"	
            skinidoo(x)
         end
    end
    
    check_file_passed(params[:fajl])
    redirect_to :back
    
  end
  
  def create
    begin
    
    if params[:database].content_type != "application/vnd.ms-excel"
       redirect_to '/'
       flash[:error] = "File not uploaded!"
       return
    end
    
    name = "#{Time.now.month}-#{Time.now.mday}-#{Time.now.hour}:#{Time.now.min}:#{Time.now.sec}-"+ params[:database].original_filename 
    
    directory = "public"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:database].read) }
    flash[:successs] = "File uploaded"
    redirect_to :back
    
    rescue Exception => e  
        puts e.message 
        flash[:error] = "Some file must be selected in order to be uploaded!"
        redirect_to :back
    end
  end
  
  private

  def check_file_passed(fajl)
      File.rename("#{fajl}", "#{fajl} - prosao.csv")
  end
  
  def company_params
      params.require(:company).permit(:mb, 
                                      :poslovno_ime,
                                      :status,
                                      :pravna_forma,
                                      :opstina,
                                      :mesto,
                                      :ulica_i_broj,
                                      :datum_osnivanja,
                                      :pib,
                                      :sifra_delatnosti,
                                      :naziv_delatnosti,
                                      :zastupnici => [],
                                      :ostali_zastupnici => [],
                                      :nadzorni_odbor => [],
                                      :upravni_odbor => [],
                                      :clanovi => [])
  end
  
  def skinidoo(x)
            begin
                x_pravnaforma = x[2].scan(/Правна форма:(.*?)Седиште: Општина:/)
                x_poslovnoime = x[2].scan(/Пословно Име:(.*?)Статус:/)
              	#x_skracenoime = x[2].scan(/Скраћено пословно име:(.*?)"/)
              	x_status = x[2].scan(/Статус:(.*?)Матични број:/)
              	x_mb = x[2].scan(/Матични број:(.*?)Правна форма:/)
              	x_sediste = x[2].scan(/Седиште: Општина:(.*?)\| Место:/)
              	x_mesto = x[2].scan(/Место:(.*?)\| Улица и број:/)
              	x_ulica = x[2].scan(/Улица и број:(.*?)Датум оснивања:/)
              	x_datum = x[2].scan(/Датум оснивања:(.*?)ПИБ:/)
              	x_pib = x[2].scan(/ПИБ:(.*)/)
            	
              	params[:company][:poslovno_ime] = x_poslovnoime[0][0].strip
              	#params[:company][:skraceno_ime] = x_skracenoime[0][0].strip
              	params[:company][:status] = x_status[0][0].strip
              	params[:company][:mb] = x_mb[0][0].strip.to_i
              	params[:company][:pravna_forma] = x_pravnaforma[0][0].strip
              	params[:company][:opstina] = x_sediste[0][0].strip
              	params[:company][:mesto] = x_mesto[0][0].strip
              	params[:company][:ulica_i_broj] = x_ulica[0][0].strip
              	params[:company][:datum_osnivanja] = x_datum[0][0].strip
              	params[:company][:pib] = x_pib[0][0].strip.to_i
             	   
                ###############
                x_sifradelatnosti = x[3].scan(/Шифра делатности:(.*?)Назив делатности:/)
	              x_nazivdelatnosti = x[3].scan(/Назив делатности:(.*)/)
	              params[:company][:sifra_delatnosti] = x_sifradelatnosti[0][0].strip.to_i
	              params[:company][:naziv_delatnosti] = x_nazivdelatnosti[0][0].strip
	              
	            ### kada je zastpnik ili clan ili bilo sta strano pravno lice, njegov maticni/registarski broj
	            ################ need to serialize
              	z_zastupnici_zajedno = x[4].scan(/Име Презиме:(.*?)Јмбг\/Лични број:(.*?)Функција/)
              	x_zastupnici_zajedno = []
              	z_zastupnici_zajedno.each_with_index do |y,i|
              		x_zastupnici_zajedno << [y[0].strip, y[1].strip]
              	end
              	params[:company][:zastupnici] = x_zastupnici_zajedno.flatten(1)
                ############### need to serialize
              	z_ostali = x[5].scan(/Име Презиме:(.*?)Јмбг\/Лични број: (\d*)/)
              	x_ostali = []
              	z_ostali.each_with_index do |y,i|
              		x_ostali << [y[0].strip, y[1].strip]
              	end
              	params[:company][:ostali_zastupnici] = x_ostali.flatten(1)
              	############### need to serialize
              	z_nadzorni = x[6].scan(/Име Презиме:(.*?)Јмбг\/Лични број: (\d*)/)
              	x_nadzorni = []
              	z_nadzorni.each_with_index do |y,i|
              		x_nadzorni << [y[0].strip, y[1].strip]
              	end
              	params[:company][:nadzorni_odbor] = x_nadzorni.flatten(1)
              	############### need to serialize
              	z_upravni = x[7].scan(/Име Презиме:(.*?)Јмбг\/Лични број: (\d*)/)
              	x_upravni = []
              	z_upravni.each_with_index do |y,i|
              		x_upravni << [y[0].strip, y[1].strip]
              	end
              	params[:company][:upravni_odbor] = x_upravni.flatten(1)
              	############### need to serialize
              	# ispravno: Пословно име:(.*?) Матични број:(.*?) |Име Презиме:(.*?) Јмбг\/Лични број: (\d*)
              	# pokusaj: Пословно име:(.*?) Матични број:(.{8})|Име Презиме:(.*?) Јмбг\/Лични број: (\d*)
              	z_clanovi = x[8].scan(/Пословно име:(.*?) Матични број:(.{8})|Име Презиме:(.*?) Јмбг\/Лични број: (\d*)/)
              	x_clanovi = []
              	z_clanovi.each do |y|
              		#if y[0].nil?
              		#    x_clanovi << [y[2].strip,y[3].strip]
              		#else
              		#    x_clanovi << [y[0].strip,y[1].strip]
              		#end
              		# sa ovim sam izbacio DAFINU MILANOVIC sa  MB 6004431 jer ona nema JG
              		if (y[0] != nil && y[0] != "") && (y[1] != nil && y[1] != "") 
              		    x_clanovi << [y[0].strip,y[1].strip]
              		end
              		if (y[2] != nil && y[2] != "") && (y[3] != nil && y[3] != "")
              		    x_clanovi << [y[2].strip,y[3].strip]
              		end
              	end
              	params[:company][:clanovi] = x_clanovi.flatten(1)
                
                y =  Company.create(company_params)
                y.save
                
            
            rescue Exception => error
             puts error
            end
  end
  
  def skiniad(x)
  end
  def skinijavno(x)
  end
  def skinikomanditno(x)
  end
  def skiniotvoreno(x)
  end
  def skinizadrugu(x)
  end
  def skinidrustveno(x)
  end
  def skiniortacko(x)
  end
  
end
