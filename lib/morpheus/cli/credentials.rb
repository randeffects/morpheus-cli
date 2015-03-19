require 'yaml'
require 'io/console'
require 'rest_client'
module Morpheus
	module Cli
		class Credentials
			def initialize(appliance_url)
				@appliance_url = appliance_url
			end
			
			def request_credentials()
				# We should return an access Key for Morpheus CLI Here
				creds = load_saved_credentials
				if !creds
					puts "No Credentials on File for this Appliance: "
					puts "Enter Username: "
					username = gets().chomp
					puts "Enter Password: "
					password = STDIN.noecho(&:gets).chomp

					oauth_url = File.join(@appliance_url, "/oauth/token")
					begin
						response = RestClient.get oauth_url, {:params => {:grant_type => "password", :client_id => "morpheus-cli", :scope => "write", :username => username, :password => password}}

						json_response = JSON.parse(response)
						access_token = json_response.access_token
						if access_token
							save_credentials(access_token)
							return access_token
						else
							puts "Credentials not verified."
							return nil
						end
					rescue => e
						puts "Error Communicating with the Appliance. Please try again later."
						return nil
					end
				else
					return creds
				end
			end

			def load_saved_credentials()
				credential_map = load_credential_file
				if credential_map.nil?
					return nil
				else
					return credential_map[@appliance_url]
				end
			end

			def load_credential_file
				creds_file = credentials_file_path
				if File.exist? creds_file
					return YAML.load_file(creds_file)
				else
					return nil
				end
			end

			def credentials_file_path
				home_dir = Dir.home
				morpheus_dir = File.join(home_dir,".morpheus")
				if !Dir.exist?(morpheus_dir)
					Dir.mkdir(morpheus_dir)
				end
				return File.join(morpheus_dir,"credentials")
			end

			def save_credentials(token)
				credential_map = load_credential_file
				if credential_map.nil?
					credential_map = {}
				end
				credential_map[@appliance_url] = token
				File.open(credentials_file_path, 'w') {|f| f.write credential_map.to_yaml } #Store
			end
		end
	end
end