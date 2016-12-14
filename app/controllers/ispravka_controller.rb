require 'set'
require "csv"
class IspravkaController < ApplicationController
  
  def index
      
      obelezi_sa_greskom
      pobrisi_sa_greskom
      
      redirect_to :back
  
  end
  
  private
  
  def get_persons(mb)
    
    arejprve = Set.new
    prva = Company.find_by(:MB => mb)
    
    unless prva.zastupnici.length == 0
      prva.zastupnici.each do |y|
            if y[0].length == 0 || y[1].length == 0
              raise # moj drugi raise :)
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
    
    # ovde mi ne treba nista, treba samo da pukne ako treba
    jmbgHashZ = Hash[*arejprve]
    
  end
  
  def obelezi_sa_greskom
  
      sve = Company.pluck(:MB)
      brojac = 0
      
      sve.each do |firmaMB|
      
                begin 
                  jmbgHashZ = get_persons(firmaMB)
                rescue
                  a = Company.find_by(MB: firmaMB)
                  a.update(clanovi: ["greska1", "greska1jmbg"], zastupnici: ["greska1", "greska1jmbg"], ostali_zastupnici: ["greska1", "greska1jmbg"], upravni_odbor: ["greska1", "greska1jmbg"], nadzorni_odbor: ["greska1", "greska1jmbg"])
                  puts brojac
                  brojac += 1
                  next
                end
      
       end
  
  
  
  end
  
  def pobrisi_sa_greskom
    
      # ima ih 1009 na 12.12.2016
      #Company.where("clanovi IN (?)", ["greska1", "greska1jmbg"]).destroy_all
      #Company.find_by(clanovi: ["greska1", "greska1jmbg"].to_yml).destroy_all
      # ne mogu da pretrazujem ovako ne znam sto?? - uradicu sa LIKE
      puts Company.where("clanovi LIKE ?", "%greska1%").count
      Company.where("clanovi LIKE ?", "%greska1%").destroy_all
      puts Company.where("clanovi LIKE ?", "%greska1%").count

  end

end
