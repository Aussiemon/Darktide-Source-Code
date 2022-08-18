local Team = class("Team")

Team.init = function (self, team_config)
	fassert(type(team_config.name) == "string", "Required string name.")
	fassert(type(team_config.num_slots) == "number", "Required number num_slots.")

	self._name = team_config.name
	self._info_prefix = string.format("Team(%q)", self._name)
	self._num_slots = team_config.num_slots
	self._slots = Script.new_array(self._num_slots)
	self._peer_to_slot_lookup = {}
	self._num_occupied_slots = 0
end

Team.add_peer = function (self, peer_id)
	fassert(self._num_occupied_slots < self._num_slots, "No more room in team %q.", self._name)
	fassert(self._peer_to_slot_lookup[peer_id] == nil, "Peer already exists in team %q.", self._name)

	local slot_id = 0

	for i = 1, self._num_slots, 1 do
		if not self._slots[i] then
			slot_id = i

			break
		end
	end

	self._slots[slot_id] = peer_id
	self._peer_to_slot_lookup[peer_id] = slot_id
	self._num_occupied_slots = self._num_occupied_slots + 1

	self:_info("Added peer %q", peer_id)
end

Team.remove_peer = function (self, peer_id)
	local slot_id = self._peer_to_slot_lookup[peer_id]

	fassert(slot_id, "Peer is not a part of team %q", self._name)

	self._slots[slot_id] = nil
	self._peer_to_slot_lookup[peer_id] = nil
	self._num_occupied_slots = self._num_occupied_slots - 1

	self:_info("Removed peer %q", peer_id)
end

Team.has_space = function (self)
	return self._num_occupied_slots < self._num_slots
end

Team.num_unoccupied_slots = function (self)
	return self._num_slots - self._num_occupied_slots
end

Team.name = function (self)
	return self._name
end

Team._info = function (self, ...)
	Log.info(self._info_prefix, ...)
end

return Team
