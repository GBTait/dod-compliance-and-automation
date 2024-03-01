control 'VLMN-8X-000004' do
  title 'The VMware Aria Suite Lifecycle web service must implement HTTP Strict Transport Security (HSTS) to protect the integrity of remote sessions.'
  desc  'HTTP Strict Transport Security (HSTS) instructs web browsers to only use secure connections for all future requests when communicating with a web site. Doing so helps prevent SSL protocol attacks, SSL stripping, cookie hijacking, and other attempts to circumvent SSL protection.'
  desc  'rationale', ''
  desc  'check', "
    Verify a header is configured to configure HSTS.

    View the running configuration by running the following command:

    # nginx -T

    Example configuration:

    server {
      add_header Strict-Transport-Security max-age=31536000;
    }

    or

    server {
       add_header Strict-Transport-Security \"max-age=31536000\" always;
    }

    If a header is not configured with a \"max-age\" value similar to one of the examples shown in the http, server, or location block, this is a finding.

    Note: There can be several add_header directives. These directives are inherited from the previous configuration level if and only if there are no add_header directives defined on the current level so care must be taken if add_header is defined at multiple levels to include headers configured at a higher level.
  "
  desc 'fix', "
    Navigate to and open the nginx.conf file (/etc/nginx/nginx.conf by default or the included file where the server is defined).

    Add a add_header directive, for example:

    add_header Strict-Transport-Security \"max-age=31536000\" always;

    Reload the configuration by running the following command:

    # nginx -s reload

    Note: There can be several add_header directives. These directives are inherited from the previous configuration level if and only if there are no add_header directives defined on the current level so care must be taken if add_header is defined at multiple levels to include headers configured at a higher level.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000015-WSR-000014'
  tag gid: 'V-VLMN-8X-000004'
  tag rid: 'SV-VLMN-8X-000004'
  tag stig_id: 'VLMN-8X-000004'
  tag cci: ['CCI-001453']
  tag nist: ['AC-17 (2)']

  http_block_headers = nginx_conf_custom(input('nginx_conf_path')).params['http'][0]['add_header']
  servers = nginx_conf_custom(input('nginx_conf_path')).servers
  locations = nginx_conf_custom(input('nginx_conf_path')).locations
  header_value = input('hsts_header')
  header_name = 'Strict-Transport-Security'
  http_header_found = false

  # Check to see if headers exist in the http block, if they do if any are defined in a server or location block must also include this header
  if http_block_headers
    http_header = http_block_headers.find { |item| item[0] == header_name }
    if http_header
      http_header_found = true

      describe 'Found headers defined in http block' do
        it "should have a #{header_name} header" do
          expect(http_header[1]).to include(header_value)
        end
      end
    end
  end

  # Check each server block and each listen directive for the SSL option
  # If HSTS is defined at the server level, ensure value is correct
  servers.each do |server|
    next unless server.params['listen'].flatten.include?('ssl')
    server_headers = server.params['add_header'].find { |item| item[0] == header_name }
    if server_headers
      describe "Found headers defined in server: #{server.params['server_name']}" do
        it "should have a #{header_name} header" do
          expect(server_headers[1]).to include(header_value)
        end
      end
    elsif !http_header_found
      # If HSTS is not defined at the Host level, and also not defined here, then it should be...
      describe "No headers defined in server: #{server.params['server_name']}" do
        it "should have a #{header_name} header" do
          expect(server_headers).to_not eq nil
        end
      end
    end
  end

  # If HSTS is defined at a location block, make sure the value is correct
  locations.each do |location|
    location_headers = location.params['add_header']
    next unless location_headers
    loc_header = location_headers.find { |item| item[0] == header_name }
    next unless loc_header
    describe "Found headers defined in location: #{location.params['_']}" do
      it "should have a #{header_name} header" do
        expect(loc_header[1]).to include(header_value)
      end
    end
  end
end
