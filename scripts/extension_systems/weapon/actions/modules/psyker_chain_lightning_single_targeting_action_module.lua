local SmartTargeting = require("scripts/utilities/smart_targeting")
local EMPTY_TABLE = {}
local PsykerSingleTargetSmartTargetingActionModule = class("PsykerSingleTargetSmartTargetingActionModule")

PsykerSingleTargetSmartTargetingActionModule.init = function (self, physics_world, player_unit, component, action_settings)
	self._physics_world = physics_world
	self._player_unit = player_unit
	self._component = component
	self._action_settings = action_settings
	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	self._unit_data_extension = unit_data_extension
	self._first_person_component = unit_data_extension:read_component("first_person")
	self._combat_ability_action_component = unit_data_extension:read_component("combat_ability_action")
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._smart_targeting_extension = ScriptUnit.extension(player_unit, "smart_targeting_system")
	self._buff_extension = ScriptUnit.extension(player_unit, "buff_system")
end

PsykerSingleTargetSmartTargetingActionModule.start = function (self, action_settings, t)
	if self._action_settings.no_target_reset then
		return
	end

	local component = self._component
	component.target_unit_1 = nil
	component.target_unit_2 = nil
	component.target_unit_3 = nil
end

local ChainLightning = require("scripts/utilities/action/chain_lightning")

PsykerSingleTargetSmartTargetingActionModule.fixed_update = function (self, dt, t)
	if self._unit_data_extension.is_resimulating then
		return
	end

	local action_settings = self._action_settings
	local component = self._component
	local smart_targeting_extension = self._smart_targeting_extension
	local targeting_data = smart_targeting_extension:targeting_data()
	local new_target_unit = targeting_data.unit
	local current_target_unit = component.target_unit_1
	local sticky_targeting = action_settings.sticky_targeting

	if (not current_target_unit or not sticky_targeting) and new_target_unit ~= current_target_unit then
		if new_target_unit and HEALTH_ALIVE[new_target_unit] then
			local smart_targeting_template = SmartTargeting.smart_targeting_template(t, self._combat_ability_action_component, self._weapon_action_component)
			local precision_target_settings = smart_targeting_template and smart_targeting_template.precision_target or EMPTY_TABLE
			local max_range = precision_target_settings.max_range
			local target_pos = POSITION_LOOKUP[new_target_unit]
			local player_pos = POSITION_LOOKUP[self._player_unit]
			local is_in_range = Vector3.distance_squared(target_pos, player_pos) < max_range * max_range
			component.target_unit_1 = is_in_range and new_target_unit or nil
		elseif new_target_unit == nil and current_target_unit ~= nil then
			local stat_buffs = self._buff_extension:stat_buffs()
			local chain_settings = action_settings and action_settings.chain_settings_targeting
			local time_in_action = t - self._weapon_action_component.start_t
			local player_unit = self._player_unit
			local query_position = POSITION_LOOKUP[player_unit]
			local rotation = self._first_person_component.rotation
			local forward_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(rotation)))
			local min_distance = 1
			local smart_targeting_template = SmartTargeting.smart_targeting_template(t, self._combat_ability_action_component, self._weapon_action_component)
			local precision_target_settings = smart_targeting_template and smart_targeting_template.precision_target or EMPTY_TABLE
			local max_range = precision_target_settings.max_range
			local target_pos = POSITION_LOOKUP[current_target_unit]
			local player_pos = POSITION_LOOKUP[self._player_unit]
			local is_in_range = Vector3.distance_squared(target_pos, player_pos) < max_range * max_range
			local max_angle, close_max_angle = ChainLightning.targeting_parameters(time_in_action, chain_settings, stat_buffs)
			local valid_target, debug_reason = ChainLightning.is_valid_target(self._physics_world, self._player_unit, current_target_unit, query_position, -forward_direction, max_angle, close_max_angle, nil, nil, nil, min_distance)

			if not valid_target or not is_in_range then
				component.target_unit_1 = nil
			end
		else
			component.target_unit_1 = nil
		end
	end
end

PsykerSingleTargetSmartTargetingActionModule.finish = function (self, reason, data, t)
	if reason == "hold_input_released" or reason == "stunned" then
		local component = self._component
		component.target_unit_1 = nil
		component.target_unit_2 = nil
		component.target_unit_3 = nil
	end
end

return PsykerSingleTargetSmartTargetingActionModule
