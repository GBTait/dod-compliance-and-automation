control 'VCSA-80-000287' do
  title 'The vCenter Server must have new Key Encryption Keys (KEKs) reissued at regular intervals for vSAN encrypted datastore(s).'
  desc 'The KEK for a vSAN encrypted datastore is generated by the Key Management Server (KMS) and serves as a wrapper and lock around the Disk Encryption Key (DEK). The DEK is generated by the host and is used to encrypt and decrypt the datastore. A shallow rekey is a procedure in which the KMS issues a new KEK to the ESXi host, which rewraps the DEK but does not change the DEK or any data on disk.

This operation must be done on a regular, site-defined interval and can be viewed as similar in criticality to changing an administrative password. If the KMS is compromised, a standing operational procedure to rekey will put a time limit on the usefulness of any stolen KMS data.'
  desc 'check', 'If vSAN is not in use, this is not applicable.

Interview the system administrator (SA) to determine that a procedure has been put in place to perform a shallow rekey of all vSAN encrypted datastores at regular, site-defined intervals.

VMware recommends a 60-day rekey task, but this interval must be defined by the SA and the ISSO.

If vSAN encryption is not in use, this is not a finding.

If vSAN encryption is in use and a regular rekey procedure is not in place, this is a finding.'
  desc 'fix', 'If vSAN encryption is in use, ensure a regular rekey procedure is in place.

To generate new encryption keys for vSAN, do the following:

From the vSphere Client, go to Host and Clusters.

Select the vCenter Server >> Select the cluster >> Configure >> vSAN >> Services >> Data Services.

Select "Generate New Encryption Keys" and optionally generate new DEKs and click "Generate".'
  impact 0.5
  tag check_id: 'C-62694r934518_chk'
  tag severity: 'medium'
  tag gid: 'V-258954'
  tag rid: 'SV-258954r1003610_rule'
  tag stig_id: 'VCSA-80-000287'
  tag gtitle: 'SRG-APP-000516'
  tag fix_id: 'F-62603r1003609_fix'
  tag cci: ['CCI-000366']
  tag nist: ['CM-6 b']

  describe 'This check is a manual or policy based check and must be reviewed manually.' do
    skip 'This check is a manual or policy based check and must be reviewed manually.'
  end
end
