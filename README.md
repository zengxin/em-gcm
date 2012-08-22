em-gcm
======

Google Cloud Messaging for Android for Event Machine 

See [Google's Documention](http://developer.android.com/guide/google/gcm/index.html) to learn more.

This project is based on groupme/em-c2dm and doesn't include spec yet

## Usage

    require "em-gcm"

    EM::GCM.token = "abcedfg..."

    EM.run do
      #plain old c2dm compatible send
      EM::GCM.push_plain(["registration_id"], :alert => "hi!", :collapse_key => "required")
      #new json style send and support broadcase
      EM::GCM.push_json(["registration_id1", "registration_id2"], :alert => "hi!", :collapse_key => "required")
    end
    
### Custom Params

You can add custom params (which will be converted to `data.<KEY>`):
  
    EM::GCM.push_plain(["registration_id"],
      :alert        => "Hello!",
      :collapse_key => "required",
      :custom       => "data",
      :awesome      => true
    )
            

### Response Callback

You can register a response callback to check success and handle errors:

    EM::GCM.push_plain(["registration_id1"], :alert => "hi!") do |response|
      if response.success?
        puts "success! id=#{response.id}" # ID of sent message
      else
        case response.error
        when "InvalidToken"
          # reauthenticate
        when "InvalidRegistration"
          # clear our registration id
        when "RetryAfter"
          # pause sending for response.retry_after seconds
        end        
      end
    end



## Contributing

Please feel free to fork and update this!