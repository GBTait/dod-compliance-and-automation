control 'VCST-80-000140' do
  title 'The vCenter STS service xpoweredBy attribute must be disabled.'
  desc 'Individual connectors can be configured to display the Tomcat information to clients. This information can be used to identify server versions that can be useful to attackers for identifying vulnerable versions of Tomcat. Individual connectors must be checked for the xpoweredBy attribute to ensure they do not pass server information to clients. The default value for xpoweredBy is "false".'
  desc 'check', 'At the command prompt, run the following command:

# xmllint --xpath "//Connector/@xpoweredBy" /usr/lib/vmware-sso/vmware-sts/conf/server.xml

Example result:

XPath set is empty

If the "xpoweredBy" parameter is specified and is not "false", this is a finding.

If the "xpoweredBy" parameter does not exist, this is not a finding.'
  desc 'fix', 'Navigate to and open:

/usr/lib/vmware-sso/vmware-sts/conf/server.xml

Navigate to the <Connector> node and remove the "xpoweredBy" attribute.

Restart the service with the following command:

# vmon-cli --restart sts'
  impact 0.5
  tag check_id: 'C-62734r934638_chk'
  tag severity: 'medium'
  tag gid: 'V-258994'
  tag rid: 'SV-258994r960963_rule'
  tag stig_id: 'VCST-80-000140'
  tag gtitle: 'SRG-APP-000141-AS-000095'
  tag fix_id: 'F-62643r934639_fix'
  tag cci: ['CCI-000381']
  tag nist: ['CM-7 a']

  # Open server.xml file
  xmlconf = xml(input('serverXmlPath'))

  describe xmlconf do
    its(["name(//Connector[@xpoweredBy != 'false'])"]) { should cmp [] }
  end
end
