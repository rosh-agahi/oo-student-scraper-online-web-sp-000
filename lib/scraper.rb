require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper

attr_accessor :name, :location, :profile_url

  def self.scrape_index_page(index_url)
    students = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".roster-cards-container").each do |div|
      div.css(".student-card a").each do |info|
        stud_name = info.css('.student-name').text
        stud_location = info.css('.student-location').text
        stud_profile_url = "#{info.attr('href')}"
        students << {
          name: stud_name,
          location: stud_location,
          profile_url: stud_profile_url
        }
      end
    end
    students
  end
    

  def self.scrape_profile_page(profile_url)
    students = {}
    
    profile = Nokogiri::HTML(open(profile_url))
    social = profile.css(".social-icon-container a")
    social.each do |link|
      link = link.attribute("href").value 
      if link.include?("twitter")
        students[:twitter] = link
      elsif link.include?("linkedin")
       students[:linkedin] = link 
      elsif link.include?("github")
       students[:github] = link
      else
       students[:blog] = link
      end
    end
    students[:profile_quote] = profile.css(".profile-quote").text if profile.css(".profile-quote")
    students[:bio] = profile.css(".description-holder p").text
    students

end

