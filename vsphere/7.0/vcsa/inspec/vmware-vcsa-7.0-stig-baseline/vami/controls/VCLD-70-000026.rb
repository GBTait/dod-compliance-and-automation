control 'VCLD-70-000026' do
  title 'VAMI must disable client-initiated Transport Layer Security (TLS) renegotiation.'
  desc  "
    All versions of the Secure Sockets Layer (SSL) and TLS protocols (up to and including TLS 1.2) are vulnerable to a man-in-the-middle attack (CVE-2009-3555) during a renegotiation. This vulnerability allows an attacker to \"prefix\" a chosen plaintext to the HTTP request as seen by the web server. The protocols have since been amended by RFC 5746, but the fix must be supported by both client and server to be effective.

    While Lighttpd and the underlying OpenSSL libraries are no longer vulnerable, steps must be taken to account for older clients that do not support RFC 5746. To this end, Lighttpd disables client-initiated renegotiation entirely by default. This configuration must be validated and maintained.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following command:

    # /opt/vmware/sbin/vami-lighttpd -p -f /opt/vmware/etc/lighttpd/lighttpd.conf 2>/dev/null|grep \"ssl\\.disable-client-renegotiation\"|sed 's: ::g'

    If no line is returned, this is NOT a finding.

    If \"ssl.disable-client-renegotiation\" is set to \"disabled\", this is a finding.

    Note: The command must be run from a bash shell and not from a shell generated by the \"appliance shell\". Use the \"chsh\" command to change the shell for the account to \"/bin/bash\". Refer to KB Article 2100508 for more details:

    https://kb.vmware.com/s/article/2100508
  "
  desc 'fix', "
    Navigate to and open:

    /opt/vmware/etc/lighttpd/lighttpd.conf

    Remove any setting for \"ssl.disable-client-renegotiation\".

    Restart the service with the following command:

    # vmon-cli --restart applmgmt
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000516-WSR-000174'
  tag gid: 'V-256670'
  tag rid: 'SV-256670r888532_rule'
  tag stig_id: 'VCLD-70-000026'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  runtime = command("#{input('lighttpdBin')} -p -f #{input('lighttpdConf')}").stdout

  describe.one do
    describe parse_config(runtime).params['ssl.disable-client-renegotiation'] do
      it { should cmp nil }
    end

    describe parse_config(runtime).params['ssl.disable-client-renegotiation'] do
      it { should cmp '"enabled"' }
    end
  end
end
