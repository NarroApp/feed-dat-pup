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
      info:       {}
    }
    reader = PDF::Reader.new io
    reader.pages.each do |page|
      page_text = page.text.force_encoding("ISO-8859-1").encode("UTF-8")
      extract[:text] += page_text
      extract[:text] += '\n'
      extract[:pages].push page_text
    end
    reader.info.map do |k, v|
      next unless v.respond_to? 'force_encoding'
      extract[:info][k] = v.force_encoding("ISO-8859-1").encode("UTF-8")
    end
    extract[:version]  = reader.pdf_version
    if reader.metadata and reader.metadata.respond_to? 'force_encoding'
      extract[:metadata] = reader.metadata.force_encoding("ISO-8859-1").encode("UTF-8")
    end
    return extract
  end

end
