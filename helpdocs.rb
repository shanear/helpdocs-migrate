require 'http'
require_relative './helpdocs'

class Helpdocs
  def self.http(instance)
    api_key = case instance
    when :source
      ENV["SOURCE_API_KEY"]
    when :destination
      ENV["DESTINATION_API_KEY"]
    else
      raise "instance must be either :source or :destination"
    end

    HTTP[Authorization: "Bearer #{api_key}"]
  end
end

