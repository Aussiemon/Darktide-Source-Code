require("scripts/extension_systems/coherency/unit_coherency_extension")
require("scripts/extension_systems/coherency/husk_coherency_extension")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local Missions = require("scripts/settings/mission/mission_templates")
local Proximity = require("scripts/utilities/proximity")
local SpecialRulesSetting = require("scripts/settings/ability/special_rules_settings")
local keywords = BuffSettings.keywords
local special_rules = SpecialRulesSetting.special_rules
local CoherencySystem = class("CoherencySystem", "ExtensionSystemBase")

CoherencySystem.init = function (self, extension_system_creation_context, ...)
	local init_result = CoherencySystem.super.init(self, extension_system_creation_context, ...)
	local broadphase_system = extension_system_creation_context.extension_manager:system("broadphase_system")
	self._broadphase = broadphase_system.broadphase
	local mission_name = Managers.state.mission:mission_name()
	local mission_settings = Missions[mission_name]
	self._is_hub = mission_settings.is_hub

	return init_result
end

CoherencySystem.on_add_extension = function (self, world, unit, extension_name, extension_init_data, ...)
	local extension = CoherencySystem.super.on_add_extension(self, world, unit, extension_name, extension_init_data, ...)
	local coherency_data = {
		units_in_direct_coherence = {},
		units_in_direct_coherence_temp = {},
		units_left_coherence_stickiness_time = {}
	}
	extension._coherency_data = coherency_data

	return extension
end

CoherencySystem.on_remove_extension = function (self, unit, extension_name)
	if self._is_server then
		local coherency_extension = ScriptUnit.extension(unit, self._name)

		self:_exit_removed_extension(unit, coherency_extension)
	end

	return CoherencySystem.super.on_remove_extension(self, unit, extension_name)
end

CoherencySystem._exit_removed_extension = function (self, exit_unit, exit_coherency_extension)
	local exit_coherence_data = exit_coherency_extension:coherency_data()

	table.clear(exit_coherence_data.units_in_direct_coherence)
	table.clear(exit_coherence_data.units_left_coherence_stickiness_time)

	for _, extension in pairs(self._unit_to_extension_map) do
		local units_in_coherence = extension:in_coherence_units()

		if units_in_coherence[exit_unit] then
			local t = FixedFrame.get_latest_fixed_time()

			extension:on_coherency_exit(exit_unit, exit_coherency_extension, t)
		end

		local data = extension:coherency_data()
		data.units_in_direct_coherence[exit_unit] = nil
		data.units_left_coherence_stickiness_time[exit_unit] = nil
	end
end

CoherencySystem.add_external_buff = function (self, target_unit, buff_name)
	local unit_to_extension_map = self._unit_to_extension_map
	local target_extension = unit_to_extension_map[target_unit]
	local index = target_extension:add_external_buff(buff_name)
	local units_currently_in_coherency = target_extension:in_coherence_units()

	for neighbour_unit, neighbour_extension in pairs(units_currently_in_coherency) do
		neighbour_extension:update_buffs_for_unit(target_unit, target_extension)
	end

	return index
end

CoherencySystem.remove_external_buff = function (self, target_unit, index)
	local unit_to_extension_map = self._unit_to_extension_map
	local target_extension = unit_to_extension_map[target_unit]

	target_extension:remove_external_buff(index)

	local units_currently_in_coherency = target_extension:in_coherence_units()

	for neighbour_unit, neighbour_extension in pairs(units_currently_in_coherency) do
		neighbour_extension:update_buffs_for_unit(target_unit, target_extension)
	end
end

local function _should_be_in_coherency_with_all(unit)
	local buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	local coherency_with_all = buff_extension and buff_extension:has_keyword(keywords.coherency_with_all_no_chain)

	if coherency_with_all then
		return true
	end

	local is_invisible = buff_extension and buff_extension:has_keyword(keywords.invisible)

	if is_invisible then
		local specialization_extension = ScriptUnit.has_extension(unit, "specialization_system")
		local has_special_rule = specialization_extension and specialization_extension:has_special_rule(special_rules.in_coherency_when_invisible)

		if has_special_rule then
			return true
		end
	end

	return false
end

local daisy_chain_cache = {}

local function _get_daisy_chain(unit)
	local chain = daisy_chain_cache[unit]

	if not chain then
		chain = {}
		daisy_chain_cache[unit] = chain
	end

	return chain
end

local function _has_coherency_system_filter_function(filter_unit)
	return ScriptUnit.has_extension(filter_unit, "coherency_system")
end

local daisy_chains = {}

CoherencySystem.update = function (self, context, dt, t, ...)
	CoherencySystem.super.update(self, context, dt, t, ...)

	if not self._is_server then
		return
	end

	if self._is_hub then
		return
	end

	local broadphase = self._broadphase

	for unit, coherency_extension in pairs(self._unit_to_extension_map) do
		local coherency_data = coherency_extension:coherency_data()
		local coherence_stickiness_time = coherency_data.units_left_coherence_stickiness_time
		local prev_units_in_direct_coherency = coherency_data.units_in_direct_coherence
		local current_units_in_direct_coherency = coherency_data.units_in_direct_coherence_temp
		local side = coherency_extension.side
		local relation_side_names = side:relation_side_names("allied")
		local coherence_radius, stickiness_limit, stickiness_time = coherency_extension:coherency_settings()

		Proximity.check_sticky_proximity(unit, relation_side_names, coherence_radius, current_units_in_direct_coherency, _has_coherency_system_filter_function, broadphase, stickiness_limit, stickiness_time, coherence_stickiness_time, prev_units_in_direct_coherency, dt)
		table.clear(prev_units_in_direct_coherency)

		coherency_data.units_in_direct_coherence = current_units_in_direct_coherency
		coherency_data.units_in_direct_coherence_temp = prev_units_in_direct_coherency
	end

	table.clear(daisy_chains)

	for unit, coherency_extension in pairs(self._unit_to_extension_map) do
		local new_chain = _get_daisy_chain(unit)

		table.clear(new_chain)

		new_chain[unit] = coherency_extension
		daisy_chains[unit] = new_chain
	end

	for unit, coherency_extension in pairs(self._unit_to_extension_map) do
		local coherency_data = coherency_extension:coherency_data()
		local direct_neighbours = coherency_data.units_in_direct_coherence
		local my_chain = daisy_chains[unit]

		for neighbour, _ in pairs(direct_neighbours) do
			local neighbours_chain = daisy_chains[neighbour]

			if my_chain ~= neighbours_chain then
				my_chain = table.merge(my_chain, neighbours_chain)
				neighbours_chain = table.merge(neighbours_chain, my_chain)
				daisy_chains[neighbour] = neighbours_chain

				for daisy_unit, _ in pairs(my_chain) do
					local dasy_unit_chain = daisy_chains[daisy_unit]
					daisy_chains[daisy_unit] = table.merge(dasy_unit_chain, my_chain)
				end
			end
		end

		daisy_chains[unit] = my_chain
	end

	for unit, daisy_chain in pairs(daisy_chains) do
		local coherency_with_all = _should_be_in_coherency_with_all(unit)

		if coherency_with_all then
			for other_unit, other_daisy_chain in pairs(daisy_chains) do
				other_daisy_chain[unit] = self._unit_to_extension_map[unit]
				daisy_chain[other_unit] = self._unit_to_extension_map[other_unit]
			end
		end
	end

	for unit, extension in pairs(self._unit_to_extension_map) do
		local units_currently_in_coherency = extension:in_coherence_units()
		local units_in_chain_coherency = daisy_chains[unit]

		for exit_unit, exit_extension in pairs(units_currently_in_coherency) do
			local in_chain = units_in_chain_coherency[exit_unit]

			if not in_chain then
				extension:on_coherency_exit(exit_unit, exit_extension, t)
			end
		end

		for daisy_unit, chained_extension in pairs(units_in_chain_coherency) do
			if not units_currently_in_coherency[daisy_unit] then
				extension:on_coherency_enter(daisy_unit, chained_extension, t)
			end
		end
	end

	table.clear(daisy_chains)
end

return CoherencySystem
