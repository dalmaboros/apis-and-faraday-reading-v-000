class SearchesController < ApplicationController
  def search
  end

  def foursquare
    begin
    @resp = Faraday.get 'https://api.foursquare.com/v2/venues/search' do |req|
      req.params['client_id'] = 'UKJPBLXJI0L0TKGGRBKCC4SMYLJ0NYP2PLLS50PBJETBVLTQ'
      req.params['client_secret'] = 'UXKD4YV3ZVWBVVATOZSO2D1VG34TWPOLPBBIARXVVH03HJ1Z'
      req.params['v'] = '20160201'
      req.params['near'] = params[:zipcode]
      req.params['query'] = 'coffee shop'
      req.options.timeout = 0
    end

    body_hash = JSON.parse(@resp.body)

    if @resp.success?
      @venues = body_hash["response"]["venues"]
    else
      @error = body_hash["meta"]["errorDetail"]
    end

    rescue Faraday::ConnectionFailed
      @error = "There was a timeout. Please try again."
    end

    render 'search'
  end
end
