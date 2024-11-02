require 'net/http'

class OrderNotifier
  def self.send(namespace, order)
    uri =  URI(ENV['WEBHOOK_URL'])
    payload = { namespace => order }.to_json
    Net::HTTP.post(uri, payload, "Content-Type" => "application/json")
  end
end