module UsersHelper
  # Returns the Gravatar for the given user.
  def gravatar_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  def ima_li_baza_koje_nisu_prosle?
      files = Dir["#{Rails.root}/public/*.db"]
      files.each_with_index do |x,i|
        return false if x.to_s !=~ /prosao/
      end
  end
  
  def lista_baza_koje_nisu_prosle
      files = Dir["#{Rails.root}/public/*.db"]
      neuneti_files = []
      files.each_with_index do |x,i|
        if x.to_s =~ /prosao/
          next
        else
          neuneti_files << x
        end
      end
    neuneti_files
  end
  
  
end