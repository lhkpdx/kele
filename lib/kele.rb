require 'httparty'

class Kele
  include HTTParty


  def initialize(email, password)
    @base_uri = 'https://www.bloc.io/api/v1/sessions'
    @email = email
    @password = password
    @token = self.class.post(@base_uri, body: { email: @email, password: @password })
    p @token
  end
end


#Use load './lib/kele.rb' to test from IRB
