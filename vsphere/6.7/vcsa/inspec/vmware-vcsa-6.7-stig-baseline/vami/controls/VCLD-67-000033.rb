control 'VCLD-67-000033' do
  title 'VAMI must be protected from being stopped by a non-privileged user.'
  desc  "An attacker has at least two reasons to stop a web server. The first
is to cause a denial of service, and the second is to put in place changes the
attacker made to the web server configuration. Therefore, only administrators
should ever be able to stop VAMI.

    The VAMI is configured out of the box to be owned by root. This
configuration must be verified and maintained.
  "
  desc  'rationale', ''
  desc  'check', "
    Note: The below command must be run from a bash shell and not from a shell
generated by the \"appliance shell\". Use the \"chsh\" command to change the
shell for the account to \"/bin/bash\".

    At the command prompt, execute the following command:

    # ps -f -U root | awk '$0 ~ /vami-lighttpd/ && $0 !~ /awk/ {print $1}'

    Expected result:

    root

    If the output does not match the expected result, this is a finding.
  "
  desc 'fix', "
    Navigate to and open /usr/lib/systemd/system/vami-lighttp.service in a text
editor.

    Under the \"[Service]\" section, remove the line that beings with \"User=\".

    At the command prompt, execute the following command:

    # service vami-lighttp restart
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000435-WSR-000147'
  tag gid: 'V-239740'
  tag rid: 'SV-239740r816829_rule'
  tag stig_id: 'VCLD-67-000033'
  tag fix_id: 'F-42932r679329_fix'
  tag cci: ['CCI-002385']
  tag nist: ['SC-5']

  describe processes('vami-lighttpd') do
    its('users') { should eq ['root'] }
  end
end
