control 'VCLD-80-000004' do
  title 'The vCenter VAMI service must use cryptography to protect the integrity of remote sessions.'
  desc 'Data exchanged between the user and the web server can range from static display data to credentials used to log in the hosted application. Even when data appears to be static, the nondisplayed logic in a web page may expose business logic or trusted system relationships. The integrity of all the data being exchanged between the user and web server must always be trusted. To protect the integrity and trust, encryption methods should be used to protect the complete communication session.

To protect the integrity and confidentiality of the remote sessions, VAMI uses Secure Sockets Layer (SSL)/Transport Layer Security (TLS).'
  desc 'check', 'At the command prompt, run the following command:

# /opt/vmware/cap_lighttpd/sbin/lighttpd -p -f /var/lib/vmware/cap-lighttpd/lighttpd.conf 2>/dev/null|grep "ssl.engine"

Example result:

ssl.engine = "enable"

If "ssl.engine" is not set to "enable", this is a finding.

Note: The command must be run from a bash shell and not from a shell generated by the "appliance shell". Use the "chsh" command to change the shell for the account to "/bin/bash". Refer to KB Article 2100508 for more details:

https://kb.vmware.com/s/article/2100508'
  desc 'fix', 'Navigate to and open:

/opt/vmware/etc/lighttpd/applmgmt-lighttpd.conf

Add or reconfigure the following value:

ssl.engine = "enable"

Restart the service with the following command:

# systemctl restart cap-lighttpd'
  impact 0.5
  tag check_id: 'C-62878r1003686_chk'
  tag severity: 'medium'
  tag gid: 'V-259138'
  tag rid: 'SV-259138r1003688_rule'
  tag stig_id: 'VCLD-80-000004'
  tag gtitle: 'SRG-APP-000015-WSR-000014'
  tag fix_id: 'F-62787r1003687_fix'
  tag satisfies: ['SRG-APP-000015-WSR-000014', 'SRG-APP-000315-WSR-000003']
  tag cci: ['CCI-001453', 'CCI-002314']
  tag nist: ['AC-17 (2)', 'AC-17 (1)']

  runtime = command("#{input('lighttpdBin')} -p -f #{input('lighttpdConf')}").stdout

  describe parse_config(runtime).params['ssl.engine'] do
    it { should cmp '"enable"' }
  end
end
