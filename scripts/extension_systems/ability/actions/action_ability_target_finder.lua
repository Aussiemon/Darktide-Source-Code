-- chunkname: @scripts/extension_systems/ability/actions/action_ability_target_finder.lua

require("scripts/extension_systems/weapon/actions/action_ability_base")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local ActionAbilityTargetFinder = class("ActionAbilityTargetFinder", "ActionAbilityBase")

ActionAbilityTargetFinder.init = function (self, action_context, action_params, action_settings)
	ActionAbilityTargetFinder.super.init(self, action_context, action_params, action_settings)

	local player_unit = self._player_unit
	local unit_data_extension = action_context.unit_data_extension
	local target_finder_module_class_name = action_settings.target_finder_module_class_name
	local action_module_target_finder_component = unit_data_extension:write_component("action_module_target_finder")

	self._action_module_target_finder_component = action_module_target_finder_component
	self._target_finder_module = ActionModules[target_finder_module_class_name]:new(self._is_server, self._physics_world, player_unit, action_module_target_finder_component, action_settings)

	if action_settings.use_alternate_fire then
		self._spread_control_component = unit_data_extension:write_component("spread_control")
		self._sway_control_component = unit_data_extension:write_component("sway_control")
		self._sway_component = unit_data_extension:read_component("sway")
	end
end

ActionAbilityTargetFinder.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionAbilityTargetFinder.super.start(self, action_settings, t, time_scale, action_start_params)
	self._target_finder_module:start(t)
end

ActionAbilityTargetFinder.fixed_update = function (self, dt, t, time_in_action)
	self._target_finder_module:fixed_update(dt, t)

	if self._is_server then
		local new_target_unit = self._action_module_target_finder_component.target_unit_1
		local companion_spawner_extension = ScriptUnit.extension(self._player_unit, "companion_spawner_system")
		local companion_unit = companion_spawner_extension:companion_unit()

		if companion_unit and ALIVE[companion_unit] then
			local companion_blackboard = BLACKBOARDS[companion_unit]
			local whistle_component = Blackboard.write_component(companion_blackboard, "whistle")

			whistle_component.current_target = new_target_unit

			local sound_event = action_settings.companion_sound_event

			if sound_event then
				local fx_system = Managers.state.extension:system("fx_system")
				local fx_node_name = "fx_jaw"
				local fx_node = Unit.node(companion_unit, fx_node_name)

				fx_system:trigger_wwise_event(sound_event, nil, companion_unit, fx_node)
			end
		end
	end
end

ActionAbilityTargetFinder.finish = function (self, reason, data, t, time_in_action)
	ActionAbilityTargetFinder.super.finish(self, reason, data, t, time_in_action)
	self._target_finder_module:finish(reason, data, t)
end

return ActionAbilityTargetFinder
