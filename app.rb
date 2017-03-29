require "sinatra"
require 'json'
require './environments'
require './services/pdf'
require './services/epub'

set :haml, :format => :html5

get '/' do
  haml :index
end

post '/extracts/pdf' do
  extracted = false
  error = false
  if !params
    data = JSON.parse request.body.read
    logger.info data
    url = data['url']
    file = data['file']
  else
    logger.info params
    url = params[:url]
    file = params[:file]
  end
  content_type 'application/json; charset=UTF-8'
  stream do |out|
    extracted = false
    error = false
    Thread.new {
      if file
        extracted, error = PDFService.extract_file(file)
      elsif url
        extracted, error = PDFService.extract_url(url)
      end
    }
    while !extracted and !error do
      out << " "
      sleep 1
    end
    
    if extracted
      status 200
      out << extracted.to_json
    else
      status 400
      out << error.to_json
    end
  end
end

post '/extracts/epub' do
  if !params
    data = JSON.parse request.body.read
    logger.info data
    url = data['url']
    file = data['file']
  else
    logger.info params
    url = params[:url]
    file = params[:file]
  end
  content_type 'application/json; charset=UTF-8'
  stream do |out|
    extracted = false
    error = false
    Thread.new {
      if file
        extracted, error = EPUBService.extract_file(file)
      elsif url
        extracted, error = EPUBService.extract_url(url)
      end
    }
    while !extracted and !error do
      out << " "
      sleep 1
    end
    
    if extracted
      status 200
      out << extracted.to_json
    else
      status 400
      out << error.to_json
    end
  end
end

get '/wake.json' do
  { message: 'Wakey wakey, eggs \'n bakey...' }.to_json
end
