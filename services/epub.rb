module EPUBService
  require 'open-uri'

  def self.extract_url(url)
    error = nil
    extract = nil
    # io = open url
    error = 'Not implemented'
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
    return extract
  end
end
