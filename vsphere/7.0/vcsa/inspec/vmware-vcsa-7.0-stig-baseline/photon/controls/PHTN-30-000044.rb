control 'PHTN-30-000044' do
  title 'The Photon operating system must audit all account disabling actions.'
  desc  'When operating system accounts are disabled, user accessibility is affected. Accounts are used for identifying individual users or operating system processes. To detect and respond to events affecting user accessibility and system processing, operating systems must audit account disabling actions.'
  desc  'rationale', ''
  desc  'check', "
    At the command line, run the following command:

     # auditctl -l | grep \"w /usr/bin/passwd\"

     Expected result:

     -w /usr/bin/passwd -p x -k passwd

     If the output does not match the expected result, this is a finding.

    Note: This check depends on the auditd service to be in a running state for accurate results. The auditd service is enabled in control PHTN-30-000013.
  "
  desc 'fix', "
    Navigate to and open:

    /etc/audit/rules.d/audit.STIG.rules

    Add the following lines:

    -w /usr/bin/passwd -p x -k passwd

     At the command line, run the following command to load the new audit rules:

    # /sbin/augenrules --load

    Note: A new \"audit.STIG.rules\" file is provided for placement in \"/etc/audit/rules.d\" that contains all rules needed for auditd.

    Note: An older \"audit.STIG.rules\" may exist if the file exists and references older \"GEN\" SRG IDs. This file can be removed and replaced as necessary with an updated one.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000240-GPOS-00090'
  tag gid: 'V-256519'
  tag rid: 'SV-256519r887231_rule'
  tag stig_id: 'PHTN-30-000044'
  tag cci: ['CCI-001404']
  tag nist: ['AC-2 (4)']

  describe auditd do
    its('lines') { should include %r{-w /usr/bin/passwd -p x -k passwd} }
  end
end
