class JSONParser < Faraday::Middleware
  def on_complete(env)
    json = MultiJson.load(env.body, symbolize_keys: true)
    return env.body = { data: json } if !json.is_a?(Hash) || json[:errors].blank?

    env.body = { data: json, errors: parse_errors_in_rails5_style(json) }
  rescue MultiJson::ParseError => e
    env.body = { errors: { base: [error: e.message] } }
  end

  private

  def parse_errors_in_rails5_style(json)
    json.fetch(:errors, {}).transform_values { |messages| messages.map { |msg| { error: msg } } }
  end
end

class TestTokenAuthentication < Faraday::Middleware
  def call(env)
    env[:request_headers]['Authorization'] = "Token token=#{Howitzer.app_api_token}" if Howitzer.app_api_token.present?
    @app.call(env)
  end
end

Spyke::Base.connection = Faraday.new(url: "#{Howitzer.app_uri.site}/#{Howitzer.app_api_end_point}") do |c|
  c.request   :json
  c.response  :json
  c.use       TestTokenAuthentication
  c.use       JSONParser
  c.adapter   Faraday.default_adapter
end
