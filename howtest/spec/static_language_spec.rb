require 'spec_helper'

RSpec.feature 'Static pages language testing' do
	  
	  before(:each) do
	    HomePage.open
	  end
	  
  scenario 'HomePage has links that change URL ' do
      expect(HomePage.given).to have_css("a[href=\"/?locale=es\"]")
  end

  scenario 'Clicking on spanish flag renders same page on spanish' do
      spanish_home_page = HomePage.given.click_spanish_flag
      expect(spanish_home_page.text).to include("Bienvenido")
  end
  
    scenario 'Navigating to other page keeps selected language displayed' do
      HomePage.given.click_spanish_flag
      SpanishHomePage.given. klik_about
      expect(SpanishAboutPage.given.text).to include("la página")
    end

end
