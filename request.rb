require_relative 'utility'

class Request
  attr_accessor :url, :timestamp,  :request_method,  :response_time, :response_code

  def initialize(url, request_method, response_time, response_code, timestamp)
    self.url = url
    self.timestamp = timestamp.to_i
    self.request_method = request_method.upcase
    self.response_code = response_code.to_i
    self.response_time = response_time.to_i
  end

  def masked_url
    return @masked_url unless @masked_url.nil?

    url_separator = '/'
    @masked_url = ''
    url.split(url_separator).each do |url_string|
      next if url_string.empty?

      @masked_url += if Utility.is_integer?(url_string)
                        url_separator + '{id}'
                     else
                        url_separator + url_string
                     end
    end
    @masked_url
  end

  def unique_identifier
    [masked_url, request_method].join('@')
  end
end