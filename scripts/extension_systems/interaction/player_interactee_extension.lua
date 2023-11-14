local Interactions = require("scripts/settings/interaction/interactions")
local InteractionSettings = require("scripts/settings/interaction/interaction_settings")
local InteractionTemplates = require("scripts/settings/interaction/interaction_templates")
local PlayerInteracteeExtension = class("PlayerInteracteeExtension")
local interaction_results = InteractionSettings.results

PlayerInteracteeExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data, game_object_id)
	local is_server = extension_init_context.is_server
	self._is_server = is_server
	self._unit = unit
	self._is_being_used = false
	self._active = true
	self._unit_has_context = false
	self._interaction_objects = {}
	self._override_contexts_by_type = {}

	self:_set_interaction_contexts(extension_init_data.interaction_contexts)

	local is_local_unit = extension_init_data.is_local_unit

	if is_server or is_local_unit then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local interactee_component = unit_data_extension:write_component("interactee")
		interactee_component.interacted_with = false
		interactee_component.interactor_unit = nil
		self._interactee_component = interactee_component
	end
end

PlayerInteracteeExtension.hot_join_sync = function (self, unit, sender, channel)
	if not self._active then
		local unit_id = self._unit_id
		local is_level_unit = false
		local active = false

		RPC.rpc_interaction_set_active(channel, unit_id, is_level_unit, active)
	end
end

PlayerInteracteeExtension.game_object_initialized = function (self, session, game_object_id)
	self._unit_id = game_object_id
end

PlayerInteracteeExtension._set_interaction_contexts = function (self, interaction_contexts)
	if interaction_contexts and #interaction_contexts > 0 then
		local interaction_objects = self._interaction_objects
		local override_contexts_by_type = self._override_contexts_by_type

		for i = 1, #interaction_contexts do
			local context = interaction_contexts[i]
			local interaction_type = context.interaction_type

			if not interaction_objects[interaction_type] then
				local interaction_template = InteractionTemplates[interaction_type]
				local interaction_class_name = interaction_template.interaction_class_name
				interaction_objects[interaction_type] = Interactions[interaction_class_name]:new(interaction_template)
			end

			if not override_contexts_by_type[interaction_type] then
				override_contexts_by_type[interaction_type] = context
			end
		end

		self._unit_has_context = true
	else
		self._unit_has_context = false
	end
end

PlayerInteracteeExtension.can_interact = function (self, interactor_unit, optional_interaction_type)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return false
	end

	local is_active = self._active

	if not is_active then
		return false
	end

	if self._is_being_used and interactor_unit ~= self._interactor_unit then
		return false
	end

	local unit = self._unit
	local objects = self._interaction_objects

	if optional_interaction_type then
		local interaction = objects[optional_interaction_type]

		if interaction then
			interaction:interactee_condition_func(unit)
		else
			return false
		end
	end

	for name, interaction in pairs(objects) do
		if interaction:interactee_condition_func(unit) then
			return true
		end
	end

	return false
end

PlayerInteracteeExtension.set_active = function (self, is_active)
	if self._is_server then
		local unit_id = self._unit_id
		local is_level_unit = false

		Managers.state.game_session:send_rpc_clients("rpc_interaction_set_active", unit_id, is_level_unit, is_active)
	end

	self._active = not not is_active
end

PlayerInteracteeExtension.active = function (self)
	return self._active
end

PlayerInteracteeExtension.interaction_type = function (self)
	local unit = self._unit
	local objects = self._interaction_objects

	for name, interaction in pairs(objects) do
		if interaction:interactee_condition_func(unit) then
			local interaction_type = interaction:type()

			return interaction_type
		end
	end

	return "none"
end

PlayerInteracteeExtension.show_marker = function (self, interactor_unit)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return false
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return false
	end

	local interaction = self._interaction_objects[interaction_type]

	if not interaction then
		return false
	end

	return interaction:interactee_show_marker_func(interactor_unit, self._unit)
end

PlayerInteracteeExtension.display_start_event = function (self)
	return false
end

PlayerInteracteeExtension.interaction_input = function (self)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return
	end

	local interaction = self._interaction_objects[interaction_type]
	local override_config = self._override_contexts_by_type[interaction_type]

	return override_config and override_config.interaction_input or interaction:interaction_input()
end

PlayerInteracteeExtension.interaction_priority = function (self)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return
	end

	local interaction = self._interaction_objects[interaction_type]
	local override_config = self._override_contexts_by_type[interaction_type]

	return override_config and override_config.interaction_priority or interaction:interaction_priority()
end

PlayerInteracteeExtension.ui_interaction_type = function (self)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return
	end

	local interaction = self._interaction_objects[interaction_type]
	local override_config = self._override_contexts_by_type[interaction_type]

	return override_config and override_config.ui_interaction_type or interaction:ui_interaction_type()
end

PlayerInteracteeExtension.interaction_icon = function (self)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return
	end

	local interaction = self._interaction_objects[interaction_type]
	local override_config = self._override_contexts_by_type[interaction_type]

	return override_config and override_config.interaction_icon or interaction:interaction_icon()
end

PlayerInteracteeExtension.interaction_length = function (self)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return 0
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return 0
	end

	local interaction = self._interaction_objects[interaction_type]
	local override_config = self._override_contexts_by_type[interaction_type]

	return override_config and override_config.duration or interaction:duration()
end

PlayerInteracteeExtension.action_text = function (self)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return
	end

	local interaction = self._interaction_objects[interaction_type]
	local override_config = self._override_contexts_by_type[interaction_type]

	return override_config and override_config.action_text or interaction:action_text()
end

PlayerInteracteeExtension.description = function (self)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return
	end

	local interaction = self._interaction_objects[interaction_type]
	local override_config = self._override_contexts_by_type[interaction_type]

	return override_config and override_config.description or interaction:description()
end

PlayerInteracteeExtension.block_text = function (self, interactor_unit)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return
	end

	local interaction_type = self:interaction_type()

	if interaction_type == "none" then
		return
	end

	if self._is_being_used and interactor_unit ~= self._interactor_unit then
		return "loc_action_interaction_player_being_helped"
	end

	local override_config = self._override_contexts_by_type[interaction_type]

	if not override_config or not override_config.block_text then
		return
	end

	return override_config.block_text
end

PlayerInteracteeExtension.hold_required = function (self)
	local unit_has_context = self._unit_has_context

	if not unit_has_context then
		return false
	end

	return self:interaction_length() > 0
end

PlayerInteracteeExtension.started = function (self, interactor_unit)
	if self._is_server then
		local unit_id = self._unit_id
		local is_level_unit = false
		local interactor_object_id = Managers.state.unit_spawner:game_object_id(interactor_unit)

		Managers.state.game_session:send_rpc_clients("rpc_interaction_started", unit_id, is_level_unit, interactor_object_id)
	end

	self._is_being_used = true
	self._interactor_unit = interactor_unit

	self:_trigger_flow_event("lua_interaction_start")

	local interactee_component = self._interactee_component

	if interactee_component then
		interactee_component.interacted_with = true
		interactee_component.interactor_unit = interactor_unit
	end
end

PlayerInteracteeExtension.stopped = function (self, result)
	if self._is_server then
		local unit_id = self._unit_id
		local is_level_unit = false
		local result_id = NetworkLookup.interaction_result[result]

		Managers.state.game_session:send_rpc_clients("rpc_interaction_stopped", unit_id, is_level_unit, result_id)
	end

	if result == interaction_results.success then
		self:_trigger_flow_event("lua_interaction_success")
	else
		self:_trigger_flow_event("lua_interaction_cancelled")
	end

	self._interactor_unit = nil
	self._is_being_used = false
	local interactee_component = self._interactee_component

	if interactee_component then
		interactee_component.interacted_with = false
		interactee_component.interactor_unit = nil
	end
end

PlayerInteracteeExtension._trigger_flow_event = function (self, event_name)
	Unit.flow_event(self._unit, event_name)
end

return PlayerInteracteeExtension
