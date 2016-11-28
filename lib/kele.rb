class Kele
  require "kele/version"
  require 'httparty'

  def initialize(email, password)
    @email = email
    @password = password
  end

  self.class.post('https://www.bloc.io/api/v1/sessions', body: { @email, @password })

end
