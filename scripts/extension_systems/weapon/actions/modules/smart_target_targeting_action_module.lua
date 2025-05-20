-- chunkname: @scripts/extension_systems/weapon/actions/modules/smart_target_targeting_action_module.lua

local SmartTargeting = require("scripts/utilities/smart_targeting")
local EMPTY_TABLE = {}
local SmartTargetingActionModule = class("SmartTargetingActionModule")

SmartTargetingActionModule.init = function (self, is_server, physics_world, player_unit, component, action_settings)
	self._is_server = is_server
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._component = component
	self._action_settings = action_settings

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

	self._unit_data_extension = unit_data_extension
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._smart_targeting_extension = ScriptUnit.extension(player_unit, "smart_targeting_system")
end

SmartTargetingActionModule.start = function (self, action_settings, t)
	local component = self._component

	component.target_unit_1 = nil
	component.target_unit_2 = nil
	component.target_unit_3 = nil
end

SmartTargetingActionModule.fixed_update = function (self, dt, t)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local action_settings = self._action_settings
	local component = self._component
	local current_target_unit = component.target_unit_1
	local sticky_targeting = action_settings.sticky_targeting

	if not current_target_unit or not sticky_targeting then
		local smart_targeting_extension = self._smart_targeting_extension
		local targeting_data = smart_targeting_extension:targeting_data()
		local new_target_unit = targeting_data.unit

		if new_target_unit ~= current_target_unit then
			local is_in_range

			if HEALTH_ALIVE[new_target_unit] then
				local smart_targeting_template = SmartTargeting.smart_targeting_template(t, self._weapon_action_component)
				local precision_target_settings = smart_targeting_template and smart_targeting_template.precision_target or EMPTY_TABLE
				local max_range = precision_target_settings.max_range
				local target_pos = POSITION_LOOKUP[new_target_unit]
				local player_pos = POSITION_LOOKUP[self._player_unit]

				is_in_range = Vector3.distance_squared(target_pos, player_pos) < max_range * max_range
			end

			local soft_sticky_targeting = action_settings.soft_sticky_targeting

			if not soft_sticky_targeting then
				component.target_unit_1 = is_in_range and new_target_unit or nil
			else
				component.target_unit_1 = is_in_range and new_target_unit or current_target_unit
			end
		end
	end
end

SmartTargetingActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		local component = self._component

		component.target_unit_1 = nil
		component.target_unit_2 = nil
		component.target_unit_3 = nil
	end
end

return SmartTargetingActionModule
