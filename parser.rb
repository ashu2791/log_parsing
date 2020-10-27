require 'csv'
require_relative 'request'
require_relative 'request_analytics'
class Parser

  attr_accessor :file_path, :requests

  def initialize(file_path)
    self.file_path = file_path
  end

  def execute
    contents.each do |item|
      data = parse_row item
      request = Request.new(
        data['url'],
        data['method'],
        data['response_time'],
        data['response_code'],
        data['timestamp'],
      )
      self.requests = requests.push request
    end
    RequestAnalytics.new(requests).top_requests
    RequestAnalytics.new(requests).time_taken_by_each_request
  end

  private

  def requests
    (@requests || [])
  end

  def contents
    @contents ||= CSV.foreach(file_path, headers: true)
  end

  def parse_row(item)
    item.to_hash
  end

end


Parser.new('data/parser.csv').execute

