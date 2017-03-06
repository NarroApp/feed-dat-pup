module EPUBService
  require 'open-uri'
  require 'zip'
  require 'nokogiri'

  def self.extract_url(url)
    error = nil
    extract = nil
    filename = 'uploads/' + SecureRandom.hex
    begin
      open(url) {|f|
         File.open(filename, 'w') do |file|
           file.write f.read
         end
      }
      extract = extract_path filename
      extract[:url] = url
    rescue OpenURI::HTTPError => e
      error = e
    rescue Exception => e
      error = e
    end
    return extract, error
  end

  def self.extract_file(file_params)
    error = nil
    extract = nil
    filename = 'uploads/' + SecureRandom.hex
    begin
      File.open(filename, 'w') do |f|
        f.write(file_params[:tempfile].read)
      end
      extract = extract_path filename
      extract[:file] = file_params[:filename]
    rescue OpenURI::HTTPError => e
      error = e
    rescue Exception => e
      error = e
    end
    return extract, error
  end

  def self.extract_path(filename)
    extract = {
      text:       '',
      pages:      [],
      version:    nil,
      metadata:   nil,
      info:       {}
    }
    files = Zip::File.open(filename)
    files.each do |entry|
      entry.extract(filename + '_' + entry.name.split('/').last)
    end
    toc_xml = Nokogiri::XML(File.open(filename + '_toc.ncx'))
    content_xml = Nokogiri::XML(File.open(filename + '_content.opf'))
    author = content_xml.xpath('//dc:creator', 'dc' => 'http://purl.org/dc/elements/1.1/').first.content
    version = toc_xml.at_css('ncx').attributes['version'].value
    title = toc_xml.css('ncx docTitle text').first.content
    nav_points = toc_xml.css('ncx navMap navPoint content')
    nav_points.each do |point|
      page_name = point.attributes['src'].value.split('/').last
      page_xml = Nokogiri::XML(File.open(filename + '_' + page_name))
      page_body = page_xml.css('html body p, html body h1, html body h2, html body h3, html body blockquote')
      page_body = page_body.map do |child|
        child.content
      end
      extract[:pages].push page_body.join("\n\n")
    end

    extract[:text] = extract[:pages].join("\n\n")
    extract[:info][:Title] = title
    extract[:info][:Author] = author
    extract[:version] = version
    return extract
  end
end
