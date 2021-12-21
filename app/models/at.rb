require 'AfricasTalking'

class At
  def self.send(phone, message = "I'm a lumberjack and it's ok, I sleep all night and I work all day")
    # Set your app credentials
    username = ENV["AT_USERNAME"]
    apikey   = ENV["AT_API_KEY"]
  
    # Initialize the SDK
    at = ::AfricasTalking::Initialize.new(username, apikey)
  
    # Get the SMS service
    sms = at.sms
  
    # Set the numbers you want to send to in international format
    to = phone
  
    # Set your message
    # message = "I'm a lumberjack and it's ok, I sleep all night and I work all day"
  
    # # Set your shortCode or senderId
    # from = "shortCode or senderId"
  
    options = {
        "to" => to,
        "message" => message
    }
    begin
        # Thats it, hit send and we'll take care of the rest.
        reports = sms.send options
        reports.each {|report|
            puts report.to_yaml
        }
    rescue AfricasTalking::AfricasTalkingException => ex
        puts 'Encountered an error: ' + ex.message
    end
  end
end