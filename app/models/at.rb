require 'AfricasTalking'

class At
  def self.send(phone, message = "")
    # Set your app credentials
    username = ENV["AT_USERNAME"]
    apikey   = ENV["AT_API_KEY"]
  
    # Initialize the SDK
    at = ::AfricasTalking::Initialize.new(username, apikey)
  
    # Get the SMS service
    sms = at.sms
  
    # Set the numbers you want to send to in international format
    to = phone
  
    options = {
        "to" => to,
        "message" => message
    }
    begin
        # Thats it, hit send and Africastalking will take care of the rest.
        reports = sms.send options
        reports.each {|report|
            puts report.to_yaml
        }
    rescue AfricasTalking::AfricasTalkingException => ex
        puts 'Encountered an error: ' + ex.message
    end
  end
end