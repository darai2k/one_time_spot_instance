require 'aws-sdk'
require 'forwardable'

module OneTimeSpotInstance
  class Core
    extend Forwardable

    def_delegators :@client, :cancel_spot_instance_requests, :create_tags, :describe_instances

    def initialize(options = {})
      @options = options

      config = {
        access_key_id: @options[:aws_access_key_id] || ENV["AWS_ACCESS_KEY_ID"],
        secret_access_key: @options[:aws_secret_access_key] || ENV["AWS_SECRET_ACCESS_KEY"],
        region: @options[:region] || "ap-northeast-1"
      }

      @client = AWS::EC2.new(config).client
    end

    def final_spot_price
      options = {
        start_time: Time.now.iso8601,
        end_time: Time.now.iso8601,
        instance_types: ["t1.micro"],
        product_descriptions: ["Linux/UNIX"],
        availability_zone: @options[:availability_zone] || "ap-northeast-1c"
      }
      results = @client.describe_spot_price_history(options)
      results[:spot_price_history_set].first[:spot_price].to_f
    end

    def request_spot_instance(spot_price)
      options = {
        spot_price: spot_price.to_s,
        instance_count: 1,
        type: "one-time",
        valid_until: (Time.now + 60*60).iso8601,
        launch_specification: {
          image_id: @options[:image_id] || "ami-39b23d38",
          key_name: @options[:key_name] || "",
          instance_type: "t1.micro",
          placement: {
            availability_zone: @options[:availability_zone] || "ap-northeast-1c"
          },
          security_groups: (@options[:security_groups] || [@options[:security_group]] || ["default"])
        }
      }
      results = @client.request_spot_instances(options)
      results[:spot_instance_request_set]
    end

    def instance_id(spot_instance_request_id)
      options = {
        spot_instance_request_ids: [spot_instance_request_id]
      }
      request = @client.describe_spot_instance_requests(options)
      request[:spot_instance_request_set].first[:instance_id]
    end
  end
end
