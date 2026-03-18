-- chunkname: @scripts/extension_systems/flee/flee_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local FleeConstants = require("scripts/extension_systems/flee/flee_constants")
local flee_states = FleeConstants.flee_states
local flee_types = FleeConstants.flee_types
local FleeExtension = class("FleeExtension")

FleeExtension.init = function (self, extension_init_context, unit, extension_init_data)
	local breed = extension_init_data.breed

	self._flee_settings = breed.flee_settings
	self._unit = unit
	self._side_system = Managers.state.extension:system("side_system")
	self._state = flee_states.idle
	self._budget = self._flee_settings.flee_budget
end

FleeExtension.update = function (self, unit, dt, t)
	self:_update_has_aggroed()

	if self._state == flee_states.idle then
		self:_update_budget(dt)
	end
end

FleeExtension._update_has_aggroed = function (self)
	if self._has_aggroed then
		return
	end

	local blackboard = BLACKBOARDS[self._unit]
	local perception_component = blackboard.perception

	self._has_aggroed = perception_component.aggro_state == "aggroed" or perception_component.aggro_state == "alerted"
end

FleeExtension._update_budget = function (self, dt)
	local rate = 0
	local flee_settings = self._flee_settings

	if flee_settings.budget_falloff_per_second then
		rate = flee_settings.budget_falloff_per_second
	end

	local modifier = 1

	modifier = modifier + self:_in_combat_multiplier()
	modifier = modifier + self:_before_aggro_multiplier()
	modifier = math.max(modifier, 0)

	local budget = self._budget + rate * modifier * dt

	self._budget = budget

	if budget < 0 then
		self:_flee()
	end
end

FleeExtension._in_combat_multiplier = function (self)
	local flee_settings = self._flee_settings
	local by_tag = flee_settings.rate_modifiers_by_in_combat_tags
	local side = self._side_system.side_by_unit[self._unit]
	local aggroed_minion_target_units = side.aggroed_minion_target_units
	local num_aggroed_minion_target_units = side.num_aggroed_minion_target_units
	local total_modifier = 0

	for i = 1, num_aggroed_minion_target_units do
		local unit = aggroed_minion_target_units[i]
		local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")

		if unit_data_extension then
			local breed = unit_data_extension:breed()
			local breed_tags = breed.tags
			local most_impactful_modifier = 0

			for tag_name, modifier in pairs(by_tag) do
				if math.abs(modifier) > math.abs(most_impactful_modifier) and breed_tags[tag_name] then
					most_impactful_modifier = modifier
				end
			end

			total_modifier = total_modifier + most_impactful_modifier
		end
	end

	return total_modifier
end

FleeExtension._before_aggro_multiplier = function (self)
	if self._has_aggroed then
		return 0
	end

	return self._flee_settings.before_aggro_modifier or 0
end

FleeExtension._flee = function (self)
	local blackboard = BLACKBOARDS[self._unit]
	local flee_component = Blackboard.write_component(blackboard, "flee")

	flee_component.wants_flee = true

	local flee_settings = self._flee_settings
	local flee_type = flee_settings.flee_type

	if flee_type == flee_types.bounds_air then
		local soft_cap_extents = Managers.state.out_of_bounds:soft_cap_extents()

		soft_cap_extents[3] = 0

		local soft_length = Vector3.length(soft_cap_extents)
		local own_pos = POSITION_LOOKUP[self._unit]
		local target_pos = Vector3.from_array(own_pos)

		target_pos[3] = 0

		local target_length = Vector3.length(target_pos)

		target_pos = target_pos * (soft_length / target_length) * 0.95
		target_pos[3] = own_pos[3]

		flee_component.flee_position:store(target_pos)
	end

	self._state = flee_states.fleeing
end

return FleeExtension
