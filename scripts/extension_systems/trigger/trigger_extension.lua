local NetworkLookup = require("scripts/network_lookup/network_lookup")
local TriggerActionSafeVolume = require("scripts/extension_systems/trigger/trigger_actions/trigger_action_safe_volume")
local TriggerActionSendFlow = require("scripts/extension_systems/trigger/trigger_actions/trigger_action_send_flow")
local TriggerActionSetLocation = require("scripts/extension_systems/trigger/trigger_actions/trigger_action_set_location")
local TriggerConditionAllAlivePlayersInside = require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_all_alive_players_inside")
local TriggerConditionAllPlayersInside = require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_all_players_inside")
local TriggerConditionAllRequiredPlayersInEndZone = require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_all_required_players_in_end_zone")
local TriggerConditionAtLeastOnePlayerInside = require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_at_least_one_player_inside")
local TriggerConditionLuggableInside = require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_luggable_inside")
local TriggerConditionOnlyEnter = require("scripts/extension_systems/trigger/trigger_conditions/trigger_condition_only_enter")
local TriggerExtensionTestify = GameParameters.testify and require("scripts/extension_systems/trigger/trigger_extension_testify")
local TriggerExtension = class("TriggerExtension")
local trigger_condition_classes = {
	all_alive_players_inside = TriggerConditionAllAlivePlayersInside,
	all_players_inside = TriggerConditionAllPlayersInside,
	all_required_players_in_end_zone = TriggerConditionAllRequiredPlayersInEndZone,
	at_least_one_player_inside = TriggerConditionAtLeastOnePlayerInside,
	luggable_inside = TriggerConditionLuggableInside,
	only_enter = TriggerConditionOnlyEnter
}
local trigger_action_classes = {
	send_flow = TriggerActionSendFlow,
	set_location = TriggerActionSetLocation,
	safe_volume = TriggerActionSafeVolume
}

TriggerExtension.init = function (self, extension_init_context, unit, ...)
	self._unit = unit
	self._is_server = extension_init_context.is_server
	self._only_once = NetworkLookup.trigger_only_once.none
	self._triggered_by_entering_unit = {}
	self._was_triggered_by_entering_unit = {}
	self._start_active = true
	self._is_active = true
	self._volume_name = "c_volume"
	self._volume_id = 0
	self._volume_type = "content/volume_types/player_trigger"
	self._target_extension_name = "PlayerVolumeEventExtension"
	self._trigger_conditions = {}
	self._trigger_actions = {}
	self._volume_enter_while_inactive = {}
end

TriggerExtension.destroy = function (self)
	local conditions = self._trigger_conditions

	for _, condition in pairs(conditions) do
		condition:destroy()
	end

	table.clear(conditions)

	local actions = self._trigger_actions

	for _, action in pairs(actions) do
		action:destroy()
	end

	table.clear(actions)

	if self._is_server then
		self:_unregister_volume()
	end
end

TriggerExtension.reset = function (self)
	self._triggered = false
	self._was_triggered = false
	self._is_active = self._start_active
	self._units_entered_while_inactive = {}
end

TriggerExtension.setup_from_component = function (self, component_guid, trigger_condition, condition_evaluates_bots, trigger_action, action_parameters, only_once, start_active, volume_type, target_extension_name)
	self._only_once = only_once
	self._start_active = start_active
	self._is_active = start_active
	self._volume_type = volume_type or self._volume_type
	self._target_extension_name = target_extension_name or self._target_extension_name
	local is_server = self._is_server
	local unit = self._unit

	if is_server then
		self._trigger_conditions[component_guid] = trigger_condition_classes[trigger_condition]:new(unit, trigger_condition, condition_evaluates_bots)

		self:_register_volume()
	end

	self._trigger_actions[component_guid] = trigger_action_classes[trigger_action]:new(is_server, unit, action_parameters)
	self._triggered_by_entering_unit[component_guid] = {}
	self._was_triggered_by_entering_unit[component_guid] = {}
end

TriggerExtension._register_volume = function (self)
	local unit = self._unit
	local volume_name = self._volume_name
	local volume_event_system = Managers.state.extension:system("volume_event_system")

	if self._volume_id == 0 then
		self._volume_id = volume_event_system:register_unit_volume(unit, volume_name, self._target_extension_name, self._volume_type)
	end
end

TriggerExtension._unregister_volume = function (self)
	local volume_event_system = Managers.state.extension:system("volume_event_system")

	if self._volume_id ~= 0 then
		volume_event_system:unregister_unit_volume(self._volume_id, self._target_extension_name)

		self._volume_id = 0
	end
end

TriggerExtension.on_volume_enter = function (self, entering_unit, dt, t)
	if self._is_server and ALIVE[entering_unit] then
		if self._is_active then
			local volume_id = self._volume_id
			local trigger_conditions = self._trigger_conditions
			local trigger_actions = self._trigger_actions

			for component_guid, condition in pairs(trigger_conditions) do
				local has_registered = condition:on_volume_enter(entering_unit, dt, t)

				if has_registered then
					local action = trigger_actions[component_guid]

					action:on_unit_enter(entering_unit)

					local can_trigger = self:_can_trigger(component_guid, entering_unit)

					if can_trigger and condition:is_condition_fulfilled(volume_id) then
						self:set_triggered(component_guid, entering_unit, true)
						self:set_was_triggered(component_guid, entering_unit, true)

						local registered_units = condition:registered_units()

						action:on_activate(entering_unit, registered_units, dt, t)
					end
				end
			end
		else
			self._volume_enter_while_inactive[entering_unit] = {
				dt = dt,
				t = t
			}
		end
	end
end

TriggerExtension.on_volume_exit = function (self, exiting_unit)
	if self._is_server and ALIVE[exiting_unit] then
		if self._is_active then
			for component_guid, condition in pairs(self._trigger_conditions) do
				local has_unregistered = condition:on_volume_exit(exiting_unit)

				if has_unregistered then
					local action = self._trigger_actions[component_guid]

					action:on_unit_exit(exiting_unit)

					local triggered = self:is_triggered(component_guid, exiting_unit)

					if triggered and not condition:is_condition_fulfilled() then
						self:set_triggered(component_guid, exiting_unit, false)

						local registered_units = condition:registered_units()

						action:on_deactivate(exiting_unit, registered_units)
					end
				end
			end
		else
			self._volume_enter_while_inactive[exiting_unit] = nil
		end
	end
end

TriggerExtension.activate = function (self, value)
	self._is_active = value

	if value then
		local ALIVE = ALIVE

		for unit, parameters in pairs(self._volume_enter_while_inactive) do
			if ALIVE[unit] then
				self:on_volume_enter(unit, parameters.dt, parameters.t)
			end
		end

		table.clear(self._volume_enter_while_inactive)
	end
end

TriggerExtension.local_action_activate = function (self, component_guid, unit)
	self._trigger_actions[component_guid]:local_on_activate(unit)
end

TriggerExtension.local_action_deactivate = function (self, component_guid, unit)
	self._trigger_actions[component_guid]:local_on_deactivate(unit)
end

TriggerExtension.local_action_on_unit_enter = function (self, component_guid, entering_unit)
	self._trigger_actions[component_guid]:local_on_unit_enter(entering_unit)
end

TriggerExtension.local_action_on_unit_exit = function (self, component_guid, exiting_unit)
	self._trigger_actions[component_guid]:local_on_unit_exit(exiting_unit)
end

TriggerExtension.update = function (self, unit, dt, t)
	if self._is_server and self._is_active then
		for component_guid, condition in pairs(self._trigger_conditions) do
			local registered_units = condition:registered_units()

			if table.size(registered_units) > 0 then
				local action = self._trigger_actions[component_guid]

				action:update(registered_units, dt, t)
			end
		end
	end
end

TriggerExtension._can_trigger = function (self, component_guid, entering_unit)
	local can_trigger = nil
	local only_once = self._only_once

	if only_once == NetworkLookup.trigger_only_once.only_once_per_unit then
		can_trigger = not self:was_triggered(component_guid, entering_unit)
	elseif only_once == NetworkLookup.trigger_only_once.only_once_for_all_units then
		can_trigger = not self:was_triggered(component_guid)
	else
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(entering_unit)
		local is_remote = player and player.remote or false
		local action = self._trigger_actions[component_guid]
		local should_trigger_on_server = action:action_on_server() and not is_remote
		local should_trigger_on_client = action:action_on_client() and is_remote

		if player then
			can_trigger = should_trigger_on_server or should_trigger_on_client
		else
			can_trigger = should_trigger_on_server
		end
	end

	return can_trigger
end

TriggerExtension.set_triggered = function (self, component_guid, entering_unit, value)
	self._triggered_by_entering_unit[component_guid][entering_unit] = value
end

TriggerExtension.set_was_triggered = function (self, component_guid, entering_unit, value)
	self._was_triggered_by_entering_unit[component_guid][entering_unit] = value
end

TriggerExtension.is_triggered = function (self, component_guid, entering_unit)
	local triggered = nil
	local triggered_by_entering_unit = self._triggered_by_entering_unit[component_guid]

	if entering_unit then
		triggered = triggered_by_entering_unit[entering_unit] == true
	else
		triggered = table.size(triggered_by_entering_unit) > 0
	end

	return triggered
end

TriggerExtension.was_triggered = function (self, component_guid, entering_unit)
	local was_triggered = nil
	local was_triggered_by_entering_unit = self._was_triggered_by_entering_unit[component_guid]

	if entering_unit then
		was_triggered = was_triggered_by_entering_unit[entering_unit] == true
	else
		was_triggered = table.size(was_triggered_by_entering_unit) > 0
	end

	return was_triggered
end

TriggerExtension.trigger_condition = function (self)
	return self._trigger_condition
end

TriggerExtension.trigger_action = function (self)
	return self._trigger_action
end

TriggerExtension.volume_id = function (self)
	return self._volume_id
end

return TriggerExtension
