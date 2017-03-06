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
  if file
    extracted, error = PDFService.extract_file(file)
  elsif url
    extracted, error = PDFService.extract_url(url)
  end
  content_type 'application/json'
  if extracted
    status 200
    extracted.to_json
  else
    status 400
    error.to_json
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
  if file
    extracted, error = EPUBService.extract_file(file)
  elsif url
    extracted, error = EPUBService.extract_url(url)
  end
  content_type 'application/json'
  if extracted
    status 200
    extracted.to_json
  else
    status 400
    error.to_json
  end
end
