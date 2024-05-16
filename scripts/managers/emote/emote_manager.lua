-- chunkname: @scripts/managers/emote/emote_manager.lua

local EmoteManager = class("EmoteManager")
local RPCs = {
	"rpc_trigger_emote",
	"rpc_stop_emote",
}

EmoteManager.init = function (self, is_host, network_event_delegate)
	self._is_host = is_host
	self._tracking_size = 0
	self._tracking_id = {}
	self._tracking_time = {}
	self._network_event_delegate = network_event_delegate

	if not is_host then
		network_event_delegate:register_session_events(self, unpack(RPCs))
	end
end

EmoteManager.destroy = function (self)
	if not self._is_host then
		self._network_event_delegate:unregister_events(unpack(RPCs))
	end
end

EmoteManager.update = function (self, dt, t)
	local time = self._tracking_time

	for index = self._tracking_size, 1, -1 do
		time[index] = time[index] - dt

		if time[index] <= 0 then
			self:_stop_emote(index)
		end
	end
end

EmoteManager._get_index = function (self, unit_id)
	return table.index_of(self._tracking_id, unit_id)
end

EmoteManager.running_emote = function (self, unit_id)
	return self:_get_index(unit_id) ~= -1
end

EmoteManager._trigger_face_event = function (self, unit, event_name)
	local visual_loadout = ScriptUnit.has_extension(unit, "visual_loadout_system")

	if not visual_loadout then
		return
	end

	local face_unit = visual_loadout:unit_3p_from_slot("slot_body_face")

	if not face_unit or not Unit.has_animation_state_machine(face_unit) then
		return
	end

	if not Unit.has_animation_event(face_unit, event_name) then
		return
	end

	Unit.animation_event(face_unit, event_name)
end

EmoteManager._stop_emote = function (self, index)
	local unit_id = self._tracking_id[index]
	local unit = Managers.state.unit_spawner:unit(unit_id)

	if unit then
		self:_trigger_face_event(unit, "pose_neutral")
	end

	local size, id, time = self._tracking_size, self._tracking_id, self._tracking_time

	id[index], time[index] = id[size], time[size]
	id[size], time[size] = nil
	self._tracking_size = size - 1
end

EmoteManager._start_emote = function (self, unit, slot_id, rpc)
	local unit_id = Managers.state.unit_spawner:game_object_id(unit)

	if self:running_emote(unit_id) then
		local index = self:_get_index(unit_id)

		self:_stop_emote(index)
	end

	local player = Managers.state.player_unit_spawn:owner(unit)

	if not player then
		return
	end

	local profile = player:profile()
	local loadout = profile.loadout
	local emote_item = loadout[slot_id]

	if not emote_item then
		return
	end

	local duration = emote_item.animation_duration or 0

	self._tracking_size = self._tracking_size + 1
	self._tracking_id[self._tracking_size] = unit_id
	self._tracking_time[self._tracking_size] = duration

	if not rpc then
		local animation = ScriptUnit.has_extension(unit, "animation_system")
		local body_event = emote_item.animation_event

		animation:anim_event(body_event)
	end

	local face_animation_event = emote_item.face_animation_event

	if face_animation_event then
		self:_trigger_face_event(unit, face_animation_event)
	end
end

EmoteManager.trigger_emote = function (self, unit, slot_id)
	self:_start_emote(unit, slot_id, false)

	if self._is_host then
		local unit_id = Managers.state.unit_spawner:game_object_id(unit)
		local slot_id_lookup = NetworkLookup.emote_slots[slot_id]
		local owning_player = Managers.state.player_unit_spawn:owner(unit)

		if unit_id and slot_id_lookup and owning_player then
			local channel_id = owning_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_trigger_emote", channel_id, unit_id, slot_id_lookup)
		end
	end
end

EmoteManager.rpc_trigger_emote = function (self, _, unit_id, slot_id_lookup)
	local unit = Managers.state.unit_spawner:unit(unit_id)
	local slot_id = NetworkLookup.emote_slots[slot_id_lookup]

	self:_start_emote(unit, slot_id, true)
end

local emote_key_to_slot_id = {
	emote_1 = "slot_animation_emote_1",
	emote_2 = "slot_animation_emote_2",
	emote_3 = "slot_animation_emote_3",
	emote_4 = "slot_animation_emote_4",
	emote_5 = "slot_animation_emote_5",
}

EmoteManager.check_emote_input = function (self, input_extension)
	for emote_key, emote_slot_id in pairs(emote_key_to_slot_id) do
		if input_extension:get(emote_key) then
			return emote_slot_id
		end
	end
end

EmoteManager.stop_emote = function (self, unit_id)
	local index = self:_get_index(unit_id)

	if index ~= -1 then
		self:_stop_emote(index)
	end

	if self._is_host then
		local unit = Managers.state.unit_spawner:unit(unit_id)
		local owning_player = Managers.state.player_unit_spawn:owner(unit)

		if owning_player then
			local channel_id = owning_player:channel_id()

			Managers.state.game_session:send_rpc_clients_except("rpc_stop_emote", channel_id, unit_id)
		end
	end
end

EmoteManager.rpc_stop_emote = function (self, channel_id, unit_id)
	local index = self:_get_index(unit_id)

	if index ~= -1 then
		self:_stop_emote(index)
	end
end

return EmoteManager
