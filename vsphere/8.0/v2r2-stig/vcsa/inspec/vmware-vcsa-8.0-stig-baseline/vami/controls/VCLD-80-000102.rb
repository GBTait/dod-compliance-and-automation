control 'VCLD-80-000102' do
  title 'The vCenter VAMI service must enable Content Security Policy.'
  desc 'A Content Security Policy (CSP) requires careful tuning and precise definition of the policy. If enabled, CSP has significant impact on the way browsers render pages (e.g., inline JavaScript is disabled by default and must be explicitly allowed in the policy). CSP prevents a wide range of attacks, including cross-site scripting and other cross-site injections.'
  desc 'check', %q(At the command prompt, run the following command:

# /opt/vmware/cap_lighttpd/sbin/lighttpd -p -f /var/lib/vmware/cap-lighttpd/lighttpd.conf 2>/dev/null|awk '/setenv\.add-response-header/,/\)/'|sed -e 's/^[ ]*//'|grep "Content-Security-Policy"

Example result:

"Content-Security-Policy" => "default-src 'self'; img-src 'self' data: https://vcsa.vmware.com; font-src 'self' data:; object-src 'none'; style-src 'self' 'unsafe-inline'"

If the response header "Content-Security-Policy" is missing or not configured to "default-src 'self'; img-src 'self' data: https://vcsa.vmware.com; font-src 'self' data:; object-src 'none'; style-src 'self' 'unsafe-inline'", this is a finding.

Note: The command must be run from a bash shell and not from a shell generated by the "appliance shell". Use the "chsh" command to change the shell for the account to "/bin/bash". Refer to KB Article 2100508 for more details:

https://kb.vmware.com/s/article/2100508)
  desc 'fix', %q(Navigate to and open:

/opt/vmware/etc/lighttpd/applmgmt-lighttpd.conf

If header "Content-Security-Policy" is not present, add the following line to the end of the file:

setenv.add-response-header += ("Content-Security-Policy" => "default-src 'self'; img-src 'self' data: https://vcsa.vmware.com; font-src 'self' data:; object-src 'none'; style-src 'self' 'unsafe-inline'")

If header "Content-Security-Policy" is present and not set to "default-src 'self'; img-src 'self' data: https://vcsa.vmware.com; font-src 'self' data:; object-src 'none'; style-src 'self' 'unsafe-inline'", update the value as shown below:

"Content-Security-Policy" => "default-src 'self'; img-src 'self' data: https://vcsa.vmware.com; font-src 'self' data:; object-src 'none'; style-src 'self' 'unsafe-inline'",

Note: The last line in the parameter does not need a trailing comma if part of a multi-line configuration.

Restart the service with the following command:

# systemctl restart cap-lighttpd)
  impact 0.5
  tag check_id: 'C-62900r1003737_chk'
  tag severity: 'medium'
  tag gid: 'V-259160'
  tag rid: 'SV-259160r1003739_rule'
  tag stig_id: 'VCLD-80-000102'
  tag gtitle: 'SRG-APP-000516-WSR-000174'
  tag fix_id: 'F-62809r1003738_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  describe command("#{input('lighttpdBin')} -p -f #{input('lighttpdConf')} 2>/dev/null|awk '/setenv\\.add-response-header/,/\\)/'|sed -e 's/^[ ]*//'|grep Content-Security-Policy") do
    its('stdout.strip') { should match %("Content-Security-Policy"\s+=>\s+"default-src 'self'; img-src 'self' data: https://vcsa.vmware.com; font-src 'self' data:; object-src 'none'; style-src 'self' 'unsafe-inline'") }
  end
end
