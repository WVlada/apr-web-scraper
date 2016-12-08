require_relative 'home_menu'

class HomePage < WebPage
  
  validate :url, pattern: %r{\A(?:.*?:\/\/)?[^\/]*\/?\z}
  url '/'
  
 add_locator :div, xpath: "//div[@class='row']"
 add_locator :english_flag, xpath: "//img[@id='English']"
 
 add_locator :about, "a[href*=\"/about\"]"
 
 add_locator :espanol_link, "a[href='/?locale=es']"
 
 
 include HomeMenu
 
 def find_div_row
    find(locator(:div)) 
 end
 
 def flag_find
    find(locator(:english_flag))
 end
 
 def klik_about
    find(locator(:about)).click
    AboutPage.given
 end
 
 def click_spanish_flag
    find(locator(:espanol_link)).click
    SpanishHomePage.given
 end
  
end

class SpanishHomePage < WebPage
  validate :url, pattern: /\/?locale=es\z/
  url '/?locale=es'
  add_locator :about, "a[href*=\"/about\"]"
  
  def klik_about
    find(locator(:about)).click
    SpanishAboutPage.given
 end
end

