require 'httparty'
require 'pp'

module SreTool

  class BroadbandMapAPI
    include HTTParty
    base_uri 'https://www.broadbandmap.gov'

    format :json

    # broadbandmap doesn't like content-type.  it prefers a format parameter of 'json'
    OPTIONS = { query: {
        format: 'json'
      }
    }

    DATA_VERSION      = 'jun2014'
    STATE_CENSUS_PATH = '/broadbandmap/census/state/'
    DEMOGRAPHICS_PATH = "/broadbandmap/demographic/#{DATA_VERSION}/state/ids/"

    def state_census(state, opts = {})
      response = self.class.get(STATE_CENSUS_PATH + URI.encode(state) , self.options(opts))

      raise StateNotFoundError.new(state) if request_not_found(response)

      response['Results']['state']
    rescue HTTParty::Error
      raise "There has been an error with broadbandmap.gov.  Cannot continue."
    end

    # geo_ids should be a comma delimited string of ids from state_census
    def demographics(geo_id, opts = {})
      # we need to manage comma-delimited options ... I think I want to just punt and
      # accept that we call the API for each geo_id, to avoid having to manage:
      # cleaning up the geo_id string for spaces and whatnot
      # handling a request where 5 work but 1 fails and having to detect that
      # paginating requests if they enter more than 10 states
      if(geo_id.include?(','))
        raise InvalidCensusIDError.new "We only accept 1 geo_id at a time. You sent in #{geo_id}"
      end

      response = self.class.get("#{DEMOGRAPHICS_PATH}#{geo_id}", self.options(opts))
    rescue URI::InvalidURIError # a little bit of a catch-all
      raise InvalidCensusIDError.new "#{geo_id} is an invalid geo_id.  Only include a single ID."
    rescue  HTTParty::Error
      raise "There has been an error with broadbandmap.gov.  Cannot continue."
    end

    # merge request options into our constant API options
    def options(opts = {})
      OPTIONS.merge(opts)
    end

    # broadbandmap doesn't return a 404 if something isn't found, it puts that metadata into
    # the request, so here are our various conditions for a request not being found
    def request_not_found(response)
      response.code == 404 ||
      response.parsed_response['Results']['state'].size == 0
    end
  end


    class StateNotFoundError < StandardError; end
    class InvalidCensusIDError < StandardError; end

end
