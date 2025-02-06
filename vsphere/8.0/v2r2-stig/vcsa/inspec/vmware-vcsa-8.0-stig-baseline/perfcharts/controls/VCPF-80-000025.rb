control 'VCPF-80-000025' do
  title 'The vCenter Perfcharts service logs folder permissions must be set correctly.'
  desc 'Log data is essential in the investigation of events. The accuracy of the information is always pertinent. One of the first steps an attacker will take is the modification or deletion of log records to cover tracks and prolong discovery. The web server must protect the log data from unauthorized modification.'
  desc 'check', "At the command prompt, run the following command:

# find /var/log/vmware/perfcharts/ -xdev -type f -a '(' -perm -o+w -o -not -user perfcharts -o -not -group users ')' -exec ls -ld {} \\;

If any files are returned, this is a finding."
  desc 'fix', 'At the command prompt, run the following commands:

# chmod o-w <file>
# chown perfcharts:users <file>

Note: Substitute <file> with the listed file.'
  impact 0.5
  tag check_id: 'C-62815r934881_chk'
  tag severity: 'medium'
  tag gid: 'V-259075'
  tag rid: 'SV-259075r960930_rule'
  tag stig_id: 'VCPF-80-000025'
  tag gtitle: 'SRG-APP-000118-AS-000078'
  tag fix_id: 'F-62724r934882_fix'
  tag satisfies: ['SRG-APP-000118-AS-000078', 'SRG-APP-000119-AS-000079', 'SRG-APP-000120-AS-000080']
  tag cci: ['CCI-000162', 'CCI-000163', 'CCI-000164']
  tag nist: ['AU-9 a', 'AU-9 a', 'AU-9 a']

  logfiles = command("find '#{input('logPath')}' -type f -xdev").stdout
  if !logfiles.empty?
    logfiles.split.each do |fname|
      describe file(fname) do
        it { should_not be_writable.by('others') }
        its('owner') { should eq 'perfcharts' }
        its('group') { should eq 'users' }
      end
    end
  else
    describe 'No log files found...skipping.' do
      skip 'No log files found...skipping.'
    end
  end
end
