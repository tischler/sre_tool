require 'spec_helper'
require 'pp'

RSpec.describe SreTool::BrandbandMapAPI do
  let(:api) { SreTool::BrandbandMapAPI.new }
  let(:texas_response) { api.state_census('texas') }
  let(:json_data) { JSON.parse(texas_response) }

  it "should return data" do
    expect(texas_response).not_to be nil
  end

  it "should be valid JSON" do
    JSON.parse(texas_response)
  end

  it "should have valid structure" do
    expect(json_data['status']).to eql 'OK'
    expect(json_data['Results']).not_to be nil
    expect(json_data['Results']['state'].first['name']).to eql 'Texas'
  end

  it "should just print it out" do
    # pp JSON.parse(texas_response)
  end
end
