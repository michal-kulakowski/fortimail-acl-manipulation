Programmatic interaction with FortiMail access lists proof of concept
=====================================================================

Proof of concept script demonstrating FortiMail access list management in programmatic way. Specific usecase is described below but the method used to achieve it is generic and can be adopted.

#Assumptions
Script addresses following situation:

1. Both receive and deliver access lists contain named set of domains to which specific TLS profile should be applied
2. All other domains are treated with default catchall rule and profile.

#Installation
Simply unzip the file and add bin subfolder to the execution path.

##Dependencies

* ruby 2.0
* Net::SSH::telnet2 gem installed

#Execution
`add_domain.rb <domain_name> <profile_name>` to add domain entry to both policies just above the catchall or update existing entry for that domain with new profile

`remove_domain.rb <domain_name>` to remove domain from both policies
