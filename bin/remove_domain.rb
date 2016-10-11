#!/usr/bin/env ruby

require_relative '../lib/fortinet'

# Config variables
FORTIMAIL_ADDRESS = '10.101.0.10'
FORTIMAIL_USER='script'
FORTIMAIL_PASSWORD='script'

ARGV.length > 0 or abort 'SYNTAX: remove_domain.rb <domain_name>'
AccessPolicyDelivery.new(FORTIMAIL_ADDRESS, FORTIMAIL_USER, FORTIMAIL_PASSWORD).remove(ARGV[0])
AccessPolicyReceive.new(FORTIMAIL_ADDRESS, FORTIMAIL_USER, FORTIMAIL_PASSWORD).remove(ARGV[0])
