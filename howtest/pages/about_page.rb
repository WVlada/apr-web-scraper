class AboutPage < WebPage
  
  validate :url, pattern: /\/about\?locale=en\z/
  url '/about'
 
end

class SpanishAboutPage < WebPage
  
  validate :url, pattern: /\/about\?locale=es\z/
  url '/about?locale=es'
 
end

class SerbianAboutPage < WebPage
  
  validate :url, pattern: /\/about\/?\z/
  url '/about?locale=sr'
 
end