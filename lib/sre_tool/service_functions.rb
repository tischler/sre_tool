module SreTool
  module ServiceFunctions

    API = SreTool::BroadbandMapAPI.new

    # given a command delimited list of states
    # do a census lookup to get the census ID, and then
    # query for each states sensus data
    def retrieve_demographic_data(list_of_states)
      list_of_states.split(',')
        .map {|state| API.state_census(state) }
        .map {|census_data| census_data['fips'] }
        .map {|census_id| API.demographics(census_id) }
    end

    # take a demographcs data array, extract a set of keys and display in CSV format
    def format_csv(demographics_data)
      keys = ['geographyName', 'population', 'households', 'incomeBelowPoverty', 'medianIncome']
      csv = demographics_data
        .map { |row| row.fetch_values(*keys) }
        .map { |row| row.join(',')}

      keys.join(',') + "\n" + csv.join("\n")
    end

    # take the output of demographics data, and display the average of
    # incomeBelowPovertyLevel
    def format_averages(demographics_data)
      poverty_levels = demographics_data
        .map { |row| row.fetch_values('incomeBelowPoverty')}
        .flatten

      average_poverty_level = poverty_levels.inject(0.0) { |a,b| a+b } / demographics_data.length
      "Average Povery Level:#{average_poverty_level}"
    end
  end
end
