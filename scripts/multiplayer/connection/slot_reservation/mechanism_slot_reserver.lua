local SlotReserver = require("scripts/multiplayer/connection/slot_reserver")
local MechanismSlotReserver = class("MechanismSlotReserver")

MechanismSlotReserver.init = function (self, max_slots)
	self._max_slots = max_slots
	self._occupied_slots = 0
	self._reserved_slots = {}
	self._claimed_slots = {}
	self._reservation_owners = {}
end

MechanismSlotReserver.reserve_slots = function (self, reserver_peer_id, players)
	local player_ids = {}

	table.set(players, player_ids)

	local needed_slots = 0

	for peer_id, _ in pairs(player_ids) do
		if not self._reserved_slots[peer_id] then
			needed_slots = needed_slots + 1
		end
	end

	if self._max_slots < self._occupied_slots + needed_slots then
		return false
	end

	if not Managers.mechanism:is_allowed_to_reserve_slots(players) then
		return false
	end

	table.merge(self._reserved_slots, player_ids)

	self._occupied_slots = self._occupied_slots + needed_slots
	local old_reservations = self._reservation_owners[reserver_peer_id] or {}
	self._reservation_owners[reserver_peer_id] = table.merge(old_reservations, player_ids)

	Managers.mechanism:peers_reserved_slots(players)

	return true
end

MechanismSlotReserver.reserve_slot = function (self, reserver_peer_id, peer_id)
	if self._reserved_slots[peer_id] then
		return true
	end

	if self._max_slots < self._occupied_slots + 1 then
		return false
	end

	local players = {
		peer_id
	}

	if not Managers.mechanism:is_allowed_to_reserve_slots(players) then
		return false
	end

	self._reserved_slots[peer_id] = true
	self._occupied_slots = self._occupied_slots + 1
	local reservations = self._reservation_owners[reserver_peer_id] or {}
	reservations[peer_id] = true
	self._reservation_owners[reserver_peer_id] = reservations

	Managers.mechanism:peers_reserved_slots(players)

	return true
end

MechanismSlotReserver.is_a_reservation_owner = function (self, peer_id)
	return self._reservation_owners[peer_id] ~= nil
end

local temp_peers = {}

MechanismSlotReserver.reservation_owner_peers = function (self, reserver_peer_id)
	local reservations = self._reservation_owners[reserver_peer_id]

	fassert(reservations, "reserver_peer_id(%q) is not an owner.", reserver_peer_id)
	table.clear(temp_peers)

	for peer_id, _ in pairs(reservations) do
		temp_peers[peer_id] = true
	end

	return temp_peers
end

MechanismSlotReserver.claim_slot = function (self, peer_id, channel_id)
	assert(channel_id, "must provide channel")

	if self._reserved_slots[peer_id] then
		if not self._claimed_slots[peer_id] then
			self._claimed_slots[peer_id] = channel_id

			return true, true
		elseif self._claimed_slots[peer_id] == channel_id then
			return true, true
		end

		return false, true
	end

	if self._max_slots < self._occupied_slots + 1 then
		return false, false
	end

	local players = {
		peer_id
	}

	if not Managers.mechanism:is_allowed_to_reserve_slots(players) then
		return false, false
	end

	self._reserved_slots[peer_id] = true
	self._occupied_slots = self._occupied_slots + 1
	self._claimed_slots[peer_id] = channel_id

	Managers.mechanism:peers_reserved_slots(players)

	return true, true
end

MechanismSlotReserver.free_slots = function (self, players)
	for _, peer_id in ipairs(players) do
		local used_channel_id = self._claimed_slots[peer_id]

		self:free_slot(peer_id, used_channel_id)
	end
end

MechanismSlotReserver.free_slot = function (self, peer_id, channel_id)
	local used_channel_id = self._claimed_slots[peer_id]

	if (not used_channel_id or channel_id == used_channel_id) and self._reserved_slots[peer_id] then
		self._reserved_slots[peer_id] = nil
		self._claimed_slots[peer_id] = nil
		self._occupied_slots = self._occupied_slots - 1

		self:_remove_owned_reservation(peer_id)
		self:_remove_reservation_owner(peer_id)
		Managers.mechanism:peer_freed_slot(peer_id)
	end
end

MechanismSlotReserver.allocation_state = function (self)
	return self._occupied_slots, self._max_slots
end

MechanismSlotReserver.is_slot_reserved = function (self, peer_id)
	return self._reserved_slots[peer_id] or false
end

MechanismSlotReserver.is_slot_claimed = function (self, peer_id)
	return self._claimed_slots[peer_id] or false
end

MechanismSlotReserver._remove_owned_reservation = function (self, peer_id)
	for owner, reserved in pairs(self._reservation_owners) do
		reserved[peer_id] = nil

		if table.is_empty(reserved) then
			self._reservation_owners[owner] = nil
		end
	end
end

MechanismSlotReserver._remove_reservation_owner = function (self, peer_id)
	local peers = self._reservation_owners[peer_id]

	if peers then
		for reservation, _ in pairs(peers) do
			if not self._claimed_slots[reservation] then
				self:free_slot(reservation, nil)
			end
		end

		self._reservation_owners[peer_id] = nil
	end
end

implements(MechanismSlotReserver, SlotReserver)

return MechanismSlotReserver
