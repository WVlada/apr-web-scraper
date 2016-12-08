require 'spec_helper'

RSpec.feature 'Static pages and basic links' do
	  
	  before(:each) do
	    HomePage.open
	  end
	  
  scenario 'Text "static" is present on HomePage' do
    #HomePage.open
    expect(HomePage.given.text).to include("Welcome")
  end

  scenario 'Element named "div" with class "row" is present on HomePage' do
    #HomePage.open
    HomePage.given.find_div_row
  end
  
  scenario 'English flag is present on HomePage' do
    #HomePage.open
    HomePage.given.flag_find
    end
    
  scenario 'Navigating to "About" page by clicking on link that is on th HomePage' do
    about_page = HomePage.given.klik_about
    expect(about_page.title).to eql("About page")
    end

end
