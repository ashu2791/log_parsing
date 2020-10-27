require_relative 'heap'
require_relative 'writer'
require 'pry'

RequestData = Struct.new(:url, :counter)
class RequestAnalytics
  attr_accessor :requests

  def initialize(requests)
    self.requests = requests
  end

  def top_requests(number_of_requests = 5)
    aggregated_data.keys.each do |item|
      element = RequestData.new(
          item,
          aggregated_data[item][:frequency]
      )
      max_heap.add element
    end
    file  = Writer.new("data/top_requests.csv")
    file.headers(top_requests_headers)
    [number_of_requests, max_heap.size].min.times do
      element = max_heap.pop
      file.push_data top_request_data_row(element)
    end
    file.close
  end

  def time_taken_by_each_request    
    file  = ::Writer.new("data/total_time_taken.csv")
    headers = ['Method', 'URL', 'Min Time', 'Max Time', 'Average Time']
    file.headers(headers)
    aggregated_data.keys.each do |key|
      element = aggregated_data[key]
      file.push_data time_taken_data_row(element)
    end
    file.close
  end

  private

  def top_request_data_row(element)
    [
      element.url.split("@").first,
      element.url.split("@").last,
      element.counter.to_s
    ]
  end

  def time_taken_data_row(element)
    [
      element[:method],
      element[:url],
      element[:min_time],
      element[:max_time],
      (element[:total_time].to_f/element[:frequency]).round(2)
    ]
  end

  def aggregated_data
    return @data unless @data.nil?
    
    @data = {}
    requests.each do |request|
      element = @data[request.unique_identifier]
      if element.nil?
        @data[request.unique_identifier] = {
            url: request.masked_url,
            method: request.request_method,
            min_time: request.response_time,
            max_time: request.response_time,
            frequency: 1,
            total_time: request.response_time
        }
      else
        element[:frequency] += 1
        element[:min_time] = request.response_time if request.response_time < element[:min_time]
        element[:max_time] = request.response_time if request.response_time > element[:max_time]
        element[:total_time] += request.response_time
      end
    end
    @data
  end

  def max_heap
    return @max_heap unless @max_heap.nil?
    @max_heap = Heap.new :> do |a, b|
      a.counter == b.counter ? (a.url < b.url) : (a.counter > b.counter)
    end
  end

  def top_requests_headers
    ['Method', 'URL', 'Frequency']
  end
end