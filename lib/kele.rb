require 'httparty'
require 'json'
require 'roadmap.rb'


class Kele
  include HTTParty
  include Roadmap

  def initialize(email, password)
    response = self.class.post(api_url("sessions"), body: {"email": email, "password": password})
    raise "Invalid email or password" if response.code == 404
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get(api_url('users/me'), headers: { "authorization" => @auth_token })
    @user_data = JSON.parse(response.body).to_a
    @user_id = @user_data[0][1]
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get(api_url("mentors/#{mentor_id}/student_availability"), headers: { "authorization" => @auth_token })
    @mentor_availability = JSON.parse(response.body).to_a
  end

  def get_messages(page)
    response = self.class.get(api_url("message_threads"), headers: { "authorization" => @auth_token }, body: {"page": page})
    @messages = JSON.parse(response.body)
  end

  def create_message(sender, recipient_id, token, subject, body)
    response = self.class.post(api_url("messages"),
      headers: { "authorization" => @auth_token },
        body: {
          "sender": sender,
          "recipient_id": recipient_id,
          "token": token,
          "subject": subject,
          "stripped-text": body})
    @success = response["success"]
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
    response = self.class.post(api_url("checkpoint_submissions"),
      headers: { "authorization" => @auth_token },
        body: {
          "assignment_branch": assignment_branch,
          "assignment_commit_link": assignment_commit_link,
          "checkpoint_id": checkpoint_id,
          "comment": comment,
          "enrollment_id": @enrollment_id })
      @submission_response = JSON.parse([response.body].to_json).first
  end


  private

  def api_url(endpoint)
    "https://www.bloc.io/api/v1/#{endpoint}"
  end


end
