local DoorControlPanelExtension = class("DoorControlPanelExtension")
local STATES = table.enum("active", "inactive")

DoorControlPanelExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._state = STATES.inactive
	self._door_extension = nil
	self._animation_extension = nil
	self._light_active = nil
	self._interaction_interlude = 0
	self._last_interaction = -100
end

DoorControlPanelExtension.setup_from_component = function (self, start_active, interaction_interlude)
	if start_active then
		self._state = STATES.active
	else
		self._state = STATES.inactive
	end

	self._interaction_interlude = interaction_interlude
end

DoorControlPanelExtension.extensions_ready = function (self, world, unit)
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
end

DoorControlPanelExtension.on_gameplay_post_init = function (self, level)
	if not self._is_server then
		return
	end

	local unit = self._unit
	local interactee_extension = ScriptUnit.extension(unit, "interactee_system")

	if self:is_active() then
		interactee_extension:set_active(true)
		self:_play_anim("activate")
	else
		interactee_extension:set_active(false)
		self:_play_anim("deactivate")
	end

	self:_update_appearance()
end

DoorControlPanelExtension.hot_join_sync = function (self, unit, sender)
	self:_sync_server_state(sender, self._state)
end

DoorControlPanelExtension.is_active = function (self)
	local is_active = self._state == STATES.active

	return is_active
end

DoorControlPanelExtension.is_on_hold = function (self)
	return Managers.time:time("gameplay") < self._last_interaction + self._interaction_interlude
end

DoorControlPanelExtension.set_active = function (self, active)
	if active and not self:is_active() then
		self:_activate()
	elseif not active and self:is_active() then
		self:_deactivate()
	end
end

DoorControlPanelExtension._activate = function (self)
	local unit = self._unit
	local interactee_extension = ScriptUnit.extension(unit, "interactee_system")

	interactee_extension:set_active(true)
	self:_play_anim("activate")

	self._state = STATES.active

	self:_sync_server_state(nil, self._state)
	self:_update_appearance()
end

DoorControlPanelExtension._deactivate = function (self)
	local unit = self._unit
	local interactee_extension = ScriptUnit.extension(unit, "interactee_system")

	interactee_extension:set_active(false)
	self:_play_anim("deactivate")

	self._state = STATES.inactive

	self:_sync_server_state(nil, self._state)
	self:_update_appearance()
end

DoorControlPanelExtension.register_door = function (self, door_extension)
	self._door_extension = door_extension
end

DoorControlPanelExtension.toggle_door_state = function (self, interactor_unit)
	local door_extension = self._door_extension

	if door_extension:can_open(interactor_unit) then
		door_extension:open("open", interactor_unit)
	elseif door_extension:can_close() then
		door_extension:close()
	end

	self:_play_anim("handle_push")
end

DoorControlPanelExtension.trigger_interlude = function (self)
	self._last_interaction = Managers.time:time("gameplay")
end

DoorControlPanelExtension._activate_lightbulbs = function (self, val)
	if self._light_active == val then
		return
	end

	if val then
		Unit.flow_event(self._unit, "lua_lightbulb_on")
	else
		Unit.flow_event(self._unit, "lua_lightbulb_off")
	end

	self._light_active = val
end

DoorControlPanelExtension._play_anim = function (self, anim_event)
	self._animation_extension:anim_event(anim_event)
end

DoorControlPanelExtension._update_appearance = function (self)
	local is_active = self._state == STATES.active

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

	self:_update_appearance()
end

return DoorControlPanelExtension
