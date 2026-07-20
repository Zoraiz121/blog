require_relative "../config/environment"

Handler = proc do |request, response|
  env = request.meta_vars

  status, headers, body = Rails.application.call(env)

  response.status = status

  headers.each do |key, value|
    response[key] = value
  end

  response.body = +""

  body.each do |part|
    response.body << part
  end

  body.close if body.respond_to?(:close)
end
