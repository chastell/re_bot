require "net/http"

class NetConnector
  def self.get_data(url, enocoding="UTF-8")
    Net::HTTP.get(url).force_encoding(enocoding)
  end
end
