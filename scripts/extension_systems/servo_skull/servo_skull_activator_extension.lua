local ServoSkullActivatorExtension = class("ServoSkullActivatorExtension")

ServoSkullActivatorExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._is_server = extension_init_context.is_server
	self._unit = unit
	self._hide_timer = 0
	self._hidden = true
	self._interactee_extension = nil
	self._mission_objective_target_extension = nil
	self._objective_name = nil

	fassert(Unit.has_visibility_group(unit, "main"), "[LuggableSocketExtension][init] Missing visibility group 'main' for Unit(%s)", tostring(unit))
	Unit.set_visibility(unit, "main", false)
end

ServoSkullActivatorExtension.extensions_ready = function (self, world, unit)
	local interactee_extension = ScriptUnit.extension(unit, "interactee_system")
	local interaction_type = interactee_extension:interaction_type()

	fassert(interaction_type == "servo_skull_activator", "[ServoSkullActivatorExtension] Set correct interaction type to 'servo_skull_activator'.")

	local mission_objective_target_extension = ScriptUnit.extension(unit, "mission_objective_target_system")
	self._objective_name = mission_objective_target_extension:objective_name()
	self._interactee_extension = interactee_extension
	self._mission_objective_target_extension = mission_objective_target_extension
end

ServoSkullActivatorExtension.on_gameplay_post_init = function (self, unit, level)
	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	local synchronizer_unit = mission_objective_system:get_objective_synchronizer_unit(self._objective_name)

	if synchronizer_unit == nil then
		Log.error("ServoSkullActivatorExtension", "[on_gameplay_post_init] Please setup ServoSkullActivator component for unit(%s, %s) else the scanning event is not functional.", tostring(self._unit), Unit.id_string(self._unit))
	else
		local synchronizer_unit_extension = ScriptUnit.extension(synchronizer_unit, "event_synchronizer_system")

		fassert(synchronizer_unit_extension, "[ServoSkullActivatorExtension] could not find synchronizer unit with objective_name(%s)", self._objective_name)
		synchronizer_unit_extension:register_servor_skull_activator_extension(self)
		self._interactee_extension:set_active(false)
	end
end

ServoSkullActivatorExtension.setup_from_component = function (self, hide_timer)
	self._hide_timer = hide_timer
end

ServoSkullActivatorExtension.on_start_event = function (self)
	fassert(self._is_server, "[ServoSkullActivatorExtension] Server only method.")
	self:set_visibility(true)
	self._interactee_extension:set_active(true)
end

ServoSkullActivatorExtension.deactivate = function (self)
	self:set_visibility(false)
	self._interactee_extension:set_active(false)
end

ServoSkullActivatorExtension.hidden = function (self)
	return self._hidden
end

ServoSkullActivatorExtension.objective_name = function (self)
	return self._objective_name
end

ServoSkullActivatorExtension.set_visibility = function (self, value)
	local unit = self._unit

	Unit.set_visibility(unit, "main", value)

	self._hidden = not value

	if self._is_server then
		local level_unit_id = Managers.state.unit_spawner:level_index(unit)

		Managers.state.game_session:send_rpc_clients("rpc_servo_skull_activator_set_visibility", level_unit_id, value)
	end
end

return ServoSkullActivatorExtension
