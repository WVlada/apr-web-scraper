#x = Company.where("clanovi LIKE ?", "%Тип: Ак%")

x = Company.where("clanovi LIKE ?", "%Тип: Ак%").take(5)
x = Company.where(mb: 7451512)


def ccc(array)
   novi = []
    array.each_with_index do |x,i|
            if i % 2 == 0
                novi << x
            else
                if x =~ /\A\d+\Z/
                    novi << x
                else
                    novi << array[i-1]
                end
            end
    end
    puts novi
end

ccc(x[0].clanovi)