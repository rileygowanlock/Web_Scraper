require 'open-uri'
require 'nokogiri'
require 'net/https'
require 'openssl'
require 'json'
require 'rails'
require 'json'

class WebScraperController < ActionController::Base
  def index
  end

  def create
    params = request.GET
    # /request/?timeframe=today&language=HTML
    url = 'https://github.com/trending' + '?since=' + params['timeframe'] + '&l=' + params['language']
    doc = Nokogiri::HTML(open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

    # scrape the HTML doc
    owner = doc.css('h3 span')
    repo = doc.css('h3 a')
    description = doc.css('div.py-1')
    stars = doc.css('span.float-right')
    text = doc.css('h3 a')

    # number of trending repositories
    length = owner.length - 1

    results = Array.new

    # retrieve info for each repo
    (0..length).each do |n|
      project = Hash.new
      project['owner'] = owner[n].text.strip
      project['repo'] = 'https://github.com' + repo[n]['href'].strip
      des_text = description[n].text.strip
      project['description'] = (des_text.length == 0 ? 'No description is available :(' : des_text)
      project['stars'] = (stars[n] == nil ? '0 stars' : stars[n].text.strip)
      project['repo/_text'] = text[n].text.strip
      escape(project)

      # append (hash) project to results
      results.push(project)
    end

    # render JSON
    hash = {:results => results}
    render json: hash
  end

  # escape HTML
  def escape(project)
    project.each do |key, value|
      project[key] = CGI::escapeHTML(value)
    end
  end

end