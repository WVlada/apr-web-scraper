class Company < ActiveRecord::Base
    serialize :zastupnici, Array
    serialize :ostali_zastupnici, Array
    serialize :nadzorni_odbor, Array
    serialize :upravni_odbor, Array
    serialize :clanovi, Array
    
    # for temporary placement of results of search by name or surname
    #attr_accessor :zastupnici
    #attr_accessor :ostali_zastupnici
    #attr_accessor :nadzorni_odbor
    #attr_accessor :upravni_odbor
    #attr_accessor :clanovi
    # ovo mi je sve sjebalo bilo
    
    def new
    @company = Company.new(company_params)
    
    end
    def create
    @company = Company.new(company_params)
    @company.save
    end
  
    private

    
end
