#!/usr/bin/env ruby

require_relative '../lib/fortinet'

# Config variables
FORTIMAIL_ADDRESS = '10.101.0.10'
FORTIMAIL_USER='script'
FORTIMAIL_PASSWORD='script'

ARGV.length > 1 or abort 'SYNTAX: add_domain.rb <domain_name> <profile_name>'
AccessPolicyDelivery.new(FORTIMAIL_ADDRESS, FORTIMAIL_USER, FORTIMAIL_PASSWORD).add(ARGV[0], ARGV[1])
AccessPolicyReceive.new(FORTIMAIL_ADDRESS, FORTIMAIL_USER, FORTIMAIL_PASSWORD).remove(ARGV[0], ARGV[1])
