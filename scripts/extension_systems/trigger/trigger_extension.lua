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
local TriggerSettings = require("scripts/extension_systems/trigger/trigger_settings")
local VOLUME_NAME = TriggerSettings.trigger_volume_name
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
	self._start_active = true
	self._is_active = true
	self._volume_id = 0
	self._volume_type = "content/volume_types/player_trigger"
	self._target_extension_name = "PlayerVolumeEventExtension"
	self._trigger_condition = nil
	self._trigger_action = nil
	self._volume_event_system = Managers.state.extension:system("volume_event_system")
end

TriggerExtension.destroy = function (self)
	if self._trigger_condition then
		self._trigger_condition:destroy()
	end

	self._trigger_action:destroy()

	if self._is_server then
		self:_unregister_volume()
	end
end

TriggerExtension.reset = function (self)
	self._triggered = false
	self._was_triggered = false
	self._is_active = self._start_active
end

TriggerExtension.setup_from_component = function (self, trigger_condition, condition_evaluates_bots, trigger_action, action_parameters, only_once, start_active, volume_type_or_nil, target_extension_name_or_nil)
	self._start_active = start_active
	self._is_active = start_active
	self._volume_type = volume_type_or_nil or self._volume_type
	self._target_extension_name = target_extension_name_or_nil or self._target_extension_name
	local is_server = self._is_server
	local unit = self._unit
	local volume_event_system = self._volume_event_system
	local engine_volume_event_system = volume_event_system:engine_volume_event_system()

	if is_server then
		self._trigger_condition = trigger_condition_classes[trigger_condition]:new(engine_volume_event_system, is_server, unit, only_once, trigger_condition, condition_evaluates_bots)

		self:_register_volume()
	end

	self._trigger_action = trigger_action_classes[trigger_action]:new(is_server, unit, action_parameters, trigger_action)
end

TriggerExtension._register_volume = function (self)
	local unit = self._unit

	if self._volume_id == 0 then
		self._volume_id = self._volume_event_system:register_unit_volume(unit, VOLUME_NAME, self._target_extension_name, self._volume_type)
	end
end

TriggerExtension._unregister_volume = function (self)
	if self._volume_id ~= 0 then
		self._volume_event_system:unregister_unit_volume(self._volume_id, self._target_extension_name)

		self._volume_id = 0
	end
end

TriggerExtension.on_volume_enter = function (self, entering_unit, dt, t)
	if self._is_server and ALIVE[entering_unit] and self._is_active then
		local trigger_condition = self._trigger_condition
		local trigger_action = self._trigger_action
		local has_registered = trigger_condition:on_volume_enter(entering_unit, dt, t)

		if has_registered then
			trigger_action:on_unit_enter(entering_unit)

			local can_trigger = trigger_condition:can_trigger_from_unit(entering_unit)
			local filter_passed = self:filter_passed(entering_unit, self._volume_id)

			if can_trigger and filter_passed then
				trigger_condition:set_triggered_by_unit(entering_unit, true)
				trigger_condition:set_was_triggered_by_unit(entering_unit, true)

				local registered_units = trigger_condition:registered_units()

				trigger_action:on_activate(entering_unit, registered_units, dt, t)
			end
		end
	end
end

TriggerExtension.on_volume_exit = function (self, exiting_unit)
	if self._is_server and ALIVE[exiting_unit] and self._is_active then
		local trigger_condition = self._trigger_condition
		local trigger_action = self._trigger_action
		local has_unregistered = trigger_condition:on_volume_exit(exiting_unit)

		if has_unregistered then
			trigger_action:on_unit_exit(exiting_unit)

			local triggered = trigger_condition:is_triggered(exiting_unit)
			local filter_passed = self:filter_passed(exiting_unit, self._volume_id)

			if triggered and not filter_passed then
				trigger_condition:set_triggered_by_unit(exiting_unit, false)

				local registered_units = trigger_condition:registered_units()

				trigger_action:on_deactivate(exiting_unit, registered_units)
			end
		end
	end
end

TriggerExtension.filter_passed = function (self, filter_unit)
	local filter_passed = false

	if self._is_server and ALIVE[filter_unit] then
		filter_passed = self._trigger_condition:filter_passed(filter_unit, self._volume_id)
	end

	return filter_passed
end

TriggerExtension.set_active = function (self, is_active)
	self._is_active = is_active
end

TriggerExtension.local_action_activate = function (self, unit)
	self._trigger_action:local_on_activate(unit)
end

TriggerExtension.local_action_deactivate = function (self, unit)
	self._trigger_action:local_on_deactivate(unit)
end

TriggerExtension.local_action_on_unit_enter = function (self, entering_unit)
	self._trigger_action:local_on_unit_enter(entering_unit)
end

TriggerExtension.local_action_on_unit_exit = function (self, exiting_unit)
	self._trigger_action:local_on_unit_exit(exiting_unit)
end

TriggerExtension.update = function (self, unit, dt, t)
	if self._is_server and GameParameters.testify then
		Testify:poll_requests_through_handler(TriggerExtensionTestify, self, unit)
	end
end

return TriggerExtension
