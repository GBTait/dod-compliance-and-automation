control 'PHTN-30-000056' do
  title 'The Photon operating system must configure auditd to keep logging in the event max log file size is reached.'
  desc  "
    Audit logs are most useful when accessible by date, rather than size. This can be accomplished through a combination of an audit log rotation cron job, setting a reasonable number of logs to keep, and configuring auditd to not rotate the logs on its own. This ensures audit logs are accessible to the information system security officer (ISSO) in the event of a central log processing failure.

    If another solution is not used to rotate auditd logs, auditd can be configured to rotate logs.
  "
  desc  'rationale', ''
  desc  'check', "
    At the command line, run the following command:

    # grep \"^max_log_file_action\" /etc/audit/auditd.conf

    Example result:

    max_log_file_action = IGNORE

    If logs are rotated outside of auditd with a tool such as logrotated, and this setting is not set to \"IGNORE\", this is a finding.

    If logs are NOT rotated outside of auditd, and this setting is not set to \"ROTATE\", this is a finding.
  "
  desc 'fix', "
    Navigate to and open:

    /etc/audit/auditd.conf

    Add or change the \"max_log_file_action\" line as follows:

    max_log_file_action = IGNORE

    Note: This can also be set to \"ROTATE\" if another tool is not used to rotate auditd logs.

    At the command line, run the following commands:

    # killproc auditd -TERM
    # systemctl start auditd
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000341-GPOS-00132'
  tag gid: 'V-256528'
  tag rid: 'SV-256528r887258_rule'
  tag stig_id: 'PHTN-30-000056'
  tag cci: ['CCI-001849']
  tag nist: ['AU-4']

  describe.one do
    describe auditd_conf do
      its('max_log_file_action') { should cmp 'IGNORE' }
    end
    describe auditd_conf do
      its('max_log_file_action') { should cmp 'ROTATE' }
    end
  end
end
