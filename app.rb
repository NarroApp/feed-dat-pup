require "sinatra"
require 'json'
require './environments'
require './services/pdf'
require './services/epub'

get '/' do
  redirect 'https://www.narro.co'
end

post '/extracts/pdf' do
  if params
    data = JSON.parse request.body.read
    logger.info data
    url = data['url']
    # file = data['file']
  else
    logger.info params
    url = params[:url]
    # file = params[:file]
  end
  extracted, error = PDFService.extract_url(url)
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
  if params
    data = JSON.parse request.body.read
    logger.info data
    url = data['url']
    # file = data['file']
  else
    logger.info params
    url = params[:url]
    # file = params[:file]
  end
  extracted, error = EPUBService.extract_url(url)
  content_type 'application/json'
  if extracted
    status 200
    extracted.to_json
  else
    status 400
    error.to_json
  end
end
