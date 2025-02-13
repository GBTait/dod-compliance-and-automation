# vmware-vm-6.7-stig-baseline
Inspec Profile to validate the secure configuration of VMware vSphere Virtual Machines version 6.7 against the DISA vSphere 6.7 STIG
Version: 6.7.0 Version 1 Release 2

## How to run InSpec locally from Powershell on Windows

**Note - assumes profile is downloaded to C:\Inspec\Profiles\vmware-vm-6.7-stig-baseline**
**Note - update inspec.yml with the appropriate environmental variables except the vmName**

This profile uses the VMware train to execute PowerCLI commands.  As of the current release the best way to connect to a target vCenter is with environmental variables.

For Windows from PowerShell setup the following variables for the existing session
```
$env:VISERVER="vcenter.test.local"
$env:VISERVER_USERNAME="Administrator@vsphere.local"
$env:VISERVER_PASSWORD="password"
```

Run profile against a target virtual machine within vCenter and output results to CLI
```
inspec exec C:\Inspec\Profiles\vmware-vm-6.7-stig-baseline -t vmware:// --input vmName=Name of VM as it appears in vCenter
```

Run profile against a target virtual machine within vCenter and show progress, and output results to CLI and JSON
```
inspec exec C:\Inspec\Profiles\vmware-vm-6.7-stig-baseline -t vmware:// --input vmName=Name of VM as it appears in vCenter --show-progress --reporter=cli json:C:\Inspec\Reports\vm.json
```

Run a single STIG Control against a target virtual machine within vCenter
```
inspec exec C:\Inspec\Profiles\vmware-vm-6.7-stig-baseline -t vmware:// --input vmName=Name of VM as it appears in vCenter --controls=VMCH-67-000001
```
