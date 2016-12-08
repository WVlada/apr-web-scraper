module ApplicationHelper
    Words = ["NA", "VELIKO", "MALO","TURIZAM","UGOSTITELJSTVO","REKREATIVNE","PRIVREDNO","DRUŠTVO","PROMET","PROIZVODNJU","POSLOVNE","SPOLJNU","UNUTRAŠNJU","TRGOVINU","I", "KOMPANIJA","ZASTUPANJE","POSLOVE", "DEONIČKO", "АКCIONARSKO", "AKCIONARSKO ", "PREDUZEĆE", "ZA", "KNJIGOVODSTVENE", "USLUGE", "PROIZVODNO", "TRGOVINSKO", "USLUŽNO", "DRUŠTVO", "SA", "OGRANIČENOM", "ODGOVORNOŠĆU", "Preduzeće", "za", "reviziju", "finansijskih", "izveštaja"  ]
    
    def precisti_ime(x)
    
        Words.each do |word| 
            x.gsub!(/\b(?:#{word})\b/, "")
            # moje resenje nije bilo ispravno jer jer radilo zamenu i unutar stringa, a ovo
            # radi samo na cele reci, pa se moze zameniti "ad", a ne i "ad" u "Beograd"
        end
    # da sklonim spaces, zamenim ih sa jednim
    fixed_string = x.gsub(/\s+/, ' ')
    return fixed_string.strip
    end
end
