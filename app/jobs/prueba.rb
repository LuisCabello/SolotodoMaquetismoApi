# nokogiri requires open-uri
require 'nokogiri'
require 'open-uri'
# csv will be used to export data
require 'csv'
require 'mechanize'
# pp is useful to display mechanize objects
require 'pp'


# Collect all the reviews for all movies in theaters
# ===============================================

agent = Mechanize.new

# creates a Mechanize page using rotten tomatoes
url = 'http://www.rottentomatoes.com/movie/in-theaters/'
page = agent.get(url)

# create an array for every movie on every page that has
# elements of the form: [<movie name>, <critic name>, <fresh/rotten>]
# then save the array into a csv file with columns of:
# <movie name>  <critic name>  <fresh/rotten>


# opens a new csv file and shovels column titles into the first row
CSV.open("movie_reviews.csv", "w+") do |csv|
  csv << ["Movie Name", "Critic", "Rating"]
end

# intializes another_page and page_num variables
another_page = true
page_num = 1

# the while loop runs as long as the statement evaluates to true
while another_page == true
  # searches the page for each movie link
  page.search('div.content_body div.heading a').each do |movie_link|
    movie_url = movie_link.attr('href')
    movie_page = agent.get("#{movie_url}")
    critics = movie_page.search('div#reviews div.quote_bubble')
    reviews_array = []
    critics.each do |critic|
      name = critic.css('div.media_block_content div.bold')
      name = name.text.strip
      review = [movie_link.text, name]

      fresh = critic.css('div.quote_contents div.fresh')
      if fresh.empty?
        review << "rotten"
      else
        review << "fresh"
      end
      reviews_array << review
    end
    
    # appends review information onto the csv we already created
    CSV.open("movie_reviews.csv", "a+") do |csv|
      reviews_array.each do |review|
        csv << review
      end
    end

    # output to terminal
    puts "#{movie_link.text} saved"
    puts # extra line for spacing

  end
  
  # checks if there is a disabled right button class somewhere on the page
  disabled_right_button = page.search('div.content_body a.right.disabled')
  if disabled_right_button.any?
    another_page = false # stops the loop from running again
  else
    page = agent.get("http://www.rottentomatoes.com/movie/in-theaters/?page=#{page_num+1}")
  end

  page_num += 1
end