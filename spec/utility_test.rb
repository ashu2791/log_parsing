require 'spec_helper'
require_relative '../utility'

describe 'Utility' do
	it 'returns true for integer string' do
    expect(Utility.is_integer?("123")).to be_truthy
  end

  it 'returns false for alphanumber string' do
    expect(Utility.is_integer?("12dass3")).to be_falsey
  end

  it 'returns false for empty string' do
    expect(Utility.is_integer?("")).to be_falsey
  end

  it 'returns false for nil' do
    expect(Utility.is_integer?(nil)).to be_falsey
  end
end