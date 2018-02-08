require 'spec_helper'
require 'pp'

RSpec.describe SreTool::BroadbandMapAPI do
  let(:api) { SreTool::BroadbandMapAPI.new }

  context 'State requests' do
    let(:texas_response) { api.state_census('texas') }
    let(:new_mexico_response) { api.state_census('new mexico') }
    it "should return data" do
      expect(texas_response).not_to be nil
    end

    it "should allow a space in the name of the state" do
      expect(new_mexico_response).not_to be nil
    end

    context 'that have an non-existant state' do
      let (:response) { api.state_census('coruscant') }
      it 'should raise an error' do
        expect { response }.to raise_error(SreTool::StateNotFoundError)
      end
    end

  end

  context 'Demographics requests' do
    let(:texas_demographics) { api.demographics("48")}

    it "should return data" do
      expect(texas_demographics).not_to be nil
    end

    context "with comma delimited ids" do
      let(:list_of_ids) { api.demographics("48,49")}

      it "should fail with an invalid id error" do
        expect { list_of_ids }.to raise_error(SreTool::InvalidCensusIDError)
      end
    end
  end
end
