module PDFService
  require 'open-uri'
  require 'pdf-reader'
  require 'securerandom'

  def self.extract_url(url)
    error = nil
    extract = nil
    begin
      io = open url
      extract = extract_io io
      extract[:url] = url
    rescue OpenURI::HTTPError => e
      error = e
    rescue Exception => e
      error = e
    rescue MalformedPDFError => e
      error = e
    rescue UnsupportedFeatureError => e
      error = e
    end
    return extract, error
  end

  def self.extract_file(file_params)
    error = nil
    extract = nil
    filename = SecureRandom.hex
    begin
      File.open('uploads/' + filename, "w") do |f|
        f.write(file_params[:tempfile].read)
      end
      io = open('uploads/' + filename)
      extract = extract_io io
      extract[:file] = file_params[:filename]
    rescue OpenURI::HTTPError => e
      error = e
    rescue Exception => e
      error = e
    rescue MalformedPDFError => e
      error = e
    rescue UnsupportedFeatureError => e
      error = e
    end
    return extract, error
  end

  def self.extract_io(io)
    extract = {
      text:       '',
      pages:      [],
      version:    nil,
      metadata:   nil,
      info:       nil
    }
    reader = PDF::Reader.new io
    reader.pages.each do |page|
      extract[:text] += page.text
      extract[:text] += '\n'
    end
    extract[:info]     = reader.info
    extract[:pages]    = reader.pages
    extract[:version]  = reader.pdf_version
    extract[:metadata] = reader.metadata
    return extract
  end

end
