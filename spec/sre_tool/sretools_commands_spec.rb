require 'spec_helper'

RSpec.describe SreTool::ServiceFunctions do
  include SreTool::ServiceFunctions

  context 'Demographic Data' do
    let (:valid_query) { retrieve_demographic_data('texas,oregon,new mexico')}

    it "should have valid data" do
      expect(valid_query.length).to eq 3
      expect(valid_query.first['geographyName']).to eq "Texas"
      expect(valid_query[1]['geographyName']).to eq "Oregon"
      expect(valid_query[2]['geographyName']).to eq "New Mexico"
    end

    context "when output into csv" do
      let(:output) { format_csv(valid_query)}

      it "should look correct" do
        expected_output = [
          'geographyName,population,households,incomeBelowPoverty,medianIncome',
          'Texas,26967646,10884477,0.1769,57834.1715',
          'Oregon,3996309,1779290,0.1594,53775.8649',
          'New Mexico,2160227,961171,0.1963,49048.8653'
        ].join("\n")

        expect(output).to eq expected_output
      end
    end

    context "when output to averages" do
      let (:output) { format_averages(valid_query)}

      it "should look correct" do
        expected_average = (0.1769 + 0.1594 + 0.1963)/3
        expect(output).to eq "Average Povery Level:0.17753333333333332"
        expect(output.split(':').last).to eq expected_average.to_s
      end
    end
  end

end
