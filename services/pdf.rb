module PDFService
  require 'open-uri'
  require 'pdf-reader'

  def self.extract_url(url)
    error = nil
    extract = nil
    io = open url
    begin
      extract = extract_io io
      extract[:url] = url
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
