control 'TCSV-00-000117' do
  title 'Changes to $CATALINA_HOME/bin/ folder must be logged.'
  desc  'The $CATALINA_HOME/bin folder contains startup and control scripts for the tc Server Catalina service. To provide forensic evidence in the event of file tampering, changes to content in this folder must be logged.  This can be done on the Ubuntu OS via the auditctl command (For Linux OS flavors other than Ubuntu, use the relevant OS commands). Use the "-p wa" flag to set the permissions flag for a file system watch to log change events.'
  desc  'rationale', ''
  desc  'check', "
    At the command prompt, run the following command to check the audit rules for the tc Server folders:

    # auditctl -l | grep -i tomcat

    If the results do not include -w $CATALINA_HOME/bin -p wa -k tomcat, or if there are no results, this is a finding.

    Note: The names tomcat.service and tomcat are used here as references, but technically they can be called anything.
  "
  desc 'fix', "
    At the command prompt, run the following command to audit the configuration files:

    # auditctl -w $CATALINA_HOME/bin -p wa -k tomcat

    Validate the audit watch was created.

    # auditctl -l

    EXAMPLE:
    -w /opt/tomcat/latest/bin -p wa -k tomcat

    Note: The name tomcat is used here as a reference, but technically it can be called anything.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-APP-000504-AS-000229'
  tag gid: 'V-TCSV-00-000117'
  tag rid: 'SV-TCSV-00-000117'
  tag stig_id: 'TCSV-00-000117'
  tag cci: ['CCI-000172']
  tag nist: ['AU-12 c']

  describe auditd do
    its('lines') { should include %r{-w #{input('catalinaHome')}/bin -p wa -k #{input('tcCoreUser')}} }
  end
end
