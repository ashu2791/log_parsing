require 'spec_helper'
require 'pry'
require_relative '../heap'

describe 'Heap' do
  let!(:heap) { Struct.new(:url, :counter) }
  let!(:max_heap) { Heap.new :> do |a, b|
      a.counter == b.counter ? (a.url < b.url) : (a.counter > b.counter)
    end
  }
  it 'returns max element from heap' do
    max_heap.add heap.new('a', 5)
    max_heap.add heap.new('b', 7)

    max_element = max_heap.pop

    expect(max_element.url).to eq('b')
  end
end