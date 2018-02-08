require 'httparty'
require 'pp'

module SreTool

  class BroadbandMapAPI
    include HTTParty
    base_uri 'https://www.broadbandmap.gov'

    format :json

    # broadbandmap doesn't like content-type.  it prefers a format parameter of 'json'
    # so we'll include it here
    OPTIONS = { query: { format: 'json' } }

    DATA_VERSION      = 'jun2014'
    STATE_CENSUS_PATH = '/broadbandmap/census/state/'
    DEMOGRAPHICS_PATH = "/broadbandmap/demographic/#{DATA_VERSION}/state/ids/"

    def state_census(state, opts = {})
      response = self.class.get(STATE_CENSUS_PATH + URI.encode(state) , self.options(opts))

      raise StateNotFoundError.new(state) if request_not_found(response)

      response['Results']['state'].first
    rescue HTTParty::Error
      raise SreToolHTTPError.new http.message
    end

    # geo_ids should be a comma delimited string of ids from state_census
    def demographics(geo_id, opts = {})
      # we need to manage comma-delimited options ... I think I want to just punt and
      # accept that we call the API for each geo_id, to avoid having to manage:
      # cleaning up the geo_id string for spaces and whatnot
      # handling a request where 5 work but 1 fails and having to detect that
      # paginating requests if they enter more than 10 states
      if(geo_id.include?(','))
        raise InvalidCensusIDError.new geo_id
      end

      response = self.class.get("#{DEMOGRAPHICS_PATH}#{geo_id}", self.options(opts))
      response['Results'].first
    rescue URI::InvalidURIError # a little bit of a catch-all
      raise InvalidCensusIDError.new geo_id.to_s
    rescue  HTTParty::Error => http
      raise SreToolHTTPError.new http.message
    end

    # merge request options into our constant API options
    def options(opts = {})
      OPTIONS.merge(opts)
    end

    # broadbandmap doesn't return a 404 if something isn't found, it puts that metadata into
    # the request, so here are our various conditions for a request not being found
    def request_not_found(response)
      response.code == 404 ||
      response['status'] == 'Bad Request' ||
      response.parsed_response['Results']['state'].size == 0
    end
  end

    class SreToolError < StandardError; end
    class StateNotFoundError < SreToolError; end
    class InvalidCensusIDError < SreToolError; end
    class SreToolHTTPError < SreToolError; end
end
