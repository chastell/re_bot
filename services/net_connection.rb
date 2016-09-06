require "net/http"

class NetConnection
  def self.get_data(url, enocoding="UTF-8")
    Net::HTTP.get(url).force_encoding(enocoding)
  end
end
