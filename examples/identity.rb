# Copyright 2018 Tristan Robert  

# This file is part of Fog::Proxmox.

# Fog::Proxmox is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# Fog::Proxmox is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with Fog::Proxmox. If not, see <http://www.gnu.org/licenses/>.

# frozen_string_literal: true

# There are basically two modes of operation for these specs.
#
# 1. ENV[PVE_URL] exists: talk to an actual Proxmox server and record HTTP
#    traffic in VCRs at "spec/debug" (credentials are read from the conventional
#    environment variables: PVE_URL, PVE_USERNAME, PVE_PASSWORD)
# 2. otherwise (under Travis etc.): use VCRs at "spec/fixtures/proxmox/#{service}"

require 'fog/proxmox'

auth_url = "https://172.26.49.146:8006/api2/json/access/token"
username = 'root@pam'
password = 'proxmox01'

proxmox = Fog::Identity::Proxmox.new(:proxmox_url => auth_url, :proxmox_username => username, :proxmox_password => password)

# Get proxmox version
proxmox.version

# List users
proxmox.users.each do |user|
    # user ...
end

# Create a new user
user = proxmox.users.create :userid     => 'bobsinclar',
                            :firstname  => 'bob',
                            :lastname   => 'sinclar',
                            :groups     => []
                            :email      => 'bobsinclar@proxmox.com'

# List groups
proxmox.groups.each do |group|
    # group ...
end

# List domains
proxmox.domains.each do |domain|
    # domain ...
end

# Create a new domain (authentication server)
domain = proxmox.domains.create :realm      => 'myrealm',
                                :type       => 'pam',
                                :domain     => 'mydomain'

# Delete user
poxmox.users.delete :userid => 'bobsinclar'