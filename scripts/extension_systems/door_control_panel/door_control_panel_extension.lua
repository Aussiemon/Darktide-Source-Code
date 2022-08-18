local DoorControlPanelExtension = class("DoorControlPanelExtension")
local STATES = table.enum("active", "inactive")

DoorControlPanelExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._state = STATES.inactive
	self._door_extension = nil
	self._animation_extension = nil
end

DoorControlPanelExtension.setup_from_component = function (self, start_active)
	if start_active then
		self._state = STATES.active
	else
		self._state = STATES.inactive
	end
end

DoorControlPanelExtension.extensions_ready = function (self, world, unit)
	if not self._is_server then
		return
	end

	local interactee_extension = ScriptUnit.extension(unit, "interactee_system")
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")

	if self:is_active() then
		interactee_extension:set_active(true)
		self:_play_anim("activate")
	else
		interactee_extension:set_active(false)
		self:_play_anim("deactivate")
	end

	self:_update_appearance(self._state)
end

DoorControlPanelExtension.hot_join_sync = function (self, unit, sender)
	self:_sync_server_state(sender, self._state)
end

DoorControlPanelExtension.is_active = function (self)
	local is_active = self._state == STATES.active

	return is_active
end

DoorControlPanelExtension.set_active = function (self, active)
	fassert(self._is_server, "[DoorControlPanelExtension] Server only method.")

	if active and not self:is_active() then
		self:_activate()
	elseif not active and self:is_active() then
		self:_deactivate()
	end
end

DoorControlPanelExtension._activate = function (self)
	fassert(self._is_server, "[DoorControlPanelExtension] Server only method.")

	local unit = self._unit
	local interactee_extension = ScriptUnit.extension(unit, "interactee_system")

	interactee_extension:set_active(true)
	self:_play_anim("activate")

	self._state = STATES.active

	self:_update_appearance(self._state)
end

DoorControlPanelExtension._deactivate = function (self)
	fassert(self._is_server, "[DoorControlPanelExtension] Server only method.")

	local unit = self._unit
	local interactee_extension = ScriptUnit.extension(unit, "interactee_system")

	interactee_extension:set_active(false)
	self:_play_anim("deactivate")

	self._state = STATES.inactive

	self:_update_appearance(self._state)
end

DoorControlPanelExtension.register_door = function (self, door_extension)
	fassert(self._is_server, "[DoorControlPanelExtension] Server only method.")

	self._door_extension = door_extension
end

DoorControlPanelExtension.toggle_door_state = function (self, interactor_unit)
	fassert(self._is_server, "[DoorControlPanelExtension] Server only method.")

	local door_extension = self._door_extension

	if door_extension:can_open(interactor_unit) then
		door_extension:open("open", interactor_unit)
	elseif door_extension:can_close() then
		door_extension:close()
	end

	self:_play_anim("handle_push")
end

DoorControlPanelExtension._activate_lightbulbs = function (self, val)
	local color = Vector3(0, 255, 0)

	if not val then
		color = Vector3(255, 0, 0)
	end

	Unit.set_vector3_for_material(self._unit, "basic_il_red", "emissive_color", color)
end

DoorControlPanelExtension._play_anim = function (self, anim_event)
	fassert(self._is_server, "[DoorControlPanelExtension] Server only method.")
	self._animation_extension:anim_event(anim_event)
end

DoorControlPanelExtension._update_appearance = function (self, state)
	local is_active = state == STATES.active

	if is_active then
		self:_activate_lightbulbs(true)
	else
		self:_activate_lightbulbs(false)
	end
end

DoorControlPanelExtension._sync_server_state = function (self, peer_id, state)
	local unit = self._unit
	local object_id = Managers.state.unit_spawner:game_object_id(unit)
	local state_lookup_id = NetworkLookup.door_control_panel_states[state]

	if peer_id then
		local channel = Managers.state.game_session:peer_to_channel(peer_id)

		RPC.rpc_sync_door_control_panel_state(channel, object_id, state_lookup_id)
	else
		local game_session_manager = Managers.state.game_session

		game_session_manager:send_rpc_clients("rpc_sync_door_control_panel_state", object_id, state_lookup_id)
	end
end

DoorControlPanelExtension.rpc_sync_door_control_panel_state = function (self, new_state)
	self._state = new_state

	self:_update_appearance(self._state)
end

return DoorControlPanelExtension
