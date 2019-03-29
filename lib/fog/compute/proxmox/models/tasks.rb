# frozen_string_literal: true

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

require 'fog/compute/proxmox/models/task'

module Fog
  module Compute
    class Proxmox
      # class Tasks Collection of node
      class Tasks < Fog::Collection
        model Fog::Compute::Proxmox::Task
        attribute :node_id

        def new(attributes = {})
          requires :node_id
          super({ node_id: node_id }.merge(attributes))
        end

        def all(filters = {})
          requires :node_id
          load service.list_tasks(node_id, filters)
        end

        def log(id)
          requires :node_id
          log = ''
          log_array = service.log_task(node_id, id, {})
          log_array.each do |line_hash|
            log += line_hash['t'].to_s + "\n"
          end
          log
        end

        def get(id)
          requires :node_id
          status_details = service.status_task(node_id, id)
          task_hash = status_details.merge(log: log(id))
          task_data = task_hash.merge(node_id: node_id, upid: id)
          new(task_data)
        end

        def wait_for(task_upid)
          task = get(task_upid)
          task.wait_for { finished? }
          task.succeeded?
        end
      end
    end
  end
end
