require 'open-uri'
require 'nokogiri'
require 'net/https'
require 'openssl'
require 'json'
require 'rails'

# class ClientsController < ApplicationController::Base
#   def curl_get_example
#     render text: 'Thanks for sending a GET request with cURL!'
#   end
# end

doc = Nokogiri::HTML(open('https://github.com/trending',
                     :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

owner = doc.css('h3 span')
repo = doc.css('h3 a')
description = doc.css('div.py-1')
stars = doc.css('span.float-right')
text = doc.css('h3 a')
length = owner.length - 1

results = Array.new

(0..length).each do |n|
  project = Hash.new
  project['owner'] = owner[n].text.strip
  project['repo'] = 'https://github.com' + repo[n]['href'].strip
  des_text = description[n].text.strip
  project['description'] = (des_text.length == 0 ? 'No description is available :(' : des_text)
  project['stars'] = stars[n].text.strip
  project['repo/_text'] = text[n].text.strip
  results.push(project)
end

hash = {:results => results}
puts hash.to_json

# string = doc.css('h3 span')
# string.each do |node|
#   owner = node.text
#   puts owner
# end
#
# string = doc.css('h3 a')
# string.each do |node|
#   repo = 'https://github.com' + node['href']
#   puts repo
# end
#
# string = doc.css('div.py-1')
# string.each do |node|
#   description = node.text
#   puts description
# end
#
# string = doc.css('div.f6 span')
# string.each do |node|
#   stars = node.text
#   puts stars
# end
#
# string = doc.css('h3 a')
# string.each do |node|
#   text = node.text
#   puts text
# end



