require("scripts/managers/mutator/mutators/mutator_base")

local Component = require("scripts/utilities/component")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local LevelProps = require("scripts/settings/level_prop/level_props")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MutatorToxicGasVolumes = class("MutatorToxicGasVolumes", "MutatorBase")

MutatorToxicGasVolumes.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, level_seed)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
	self._gas_clouds = {}
	self._nav_world = nav_world
	self._buff_affected_units = {}
	self._seed = level_seed
	local extension_manager = Managers.state.extension
	local side_system = extension_manager:system("side_system")
	self._side_names = side_system:side_names()
	self._side_system = side_system

	if not self._is_server then
		return
	end

	self._in_fog_buff_template_name = "in_toxic_gas"
	self._leaving_fog_buff_template_name = "left_toxic_gas"
	self._broadphase_radius = 50
	local broadphase_system = extension_manager:system("broadphase_system")
	self._broadphase = broadphase_system.broadphase
end

MutatorToxicGasVolumes._activate_cloud = function (self, cloud)
	local liquid_area_template = LiquidAreaTemplates.toxic_gas
	local unit = LiquidArea.try_create(cloud.position:unbox(), Vector3(0, 0, 1), self._nav_world, liquid_area_template)
	cloud.active = true
	cloud.unit = unit
end

local fog_unit_name = "content/environment/volumetrics/toxic_fog_volume"

MutatorToxicGasVolumes.on_gameplay_post_init = function (self, level, themes)
	local gas_clouds = self._gas_clouds
	local component_system = Managers.state.extension:system("component_system")
	local fog_units = component_system:get_units_from_component_name("ToxicGasFog")

	if #fog_units == 0 then
		return
	end

	local num_sections = 0

	for i = 1, #fog_units do
		local fog_unit = fog_units[i]
		local components = Component.get_components_by_name(fog_unit, "ToxicGasFog")
		local pos = Unit.world_position(fog_unit, 1)
		local rot = Unit.world_rotation(fog_unit, 1)

		for _, fog_component in ipairs(components) do
			local id = fog_component:get_data(fog_unit, "id")
			local section_id = fog_component:get_data(fog_unit, "section")

			if not gas_clouds[section_id] then
				gas_clouds[section_id] = {}
			end

			if not gas_clouds[section_id][id] then
				gas_clouds[section_id][id] = {}
			end

			if num_sections < section_id then
				num_sections = section_id
			end

			table.insert(gas_clouds[section_id][id], fog_unit)
		end

		QuickDrawerStay:sphere(pos, 2, Color.lime())
	end

	local active_gas_clouds = {}

	for i = 1, num_sections do
		local max_section_id = #gas_clouds
		local random_section_id = self:_random(1, max_section_id)
		local section_entry = gas_clouds[random_section_id]
		local random_id = self:_random(1, #section_entry)
		local clouds = section_entry[random_id]

		for j = 1, #clouds do
			local cloud = clouds[j]
			local fog_components = Component.get_components_by_name(cloud, "ToxicGasFog")

			for _, fog_component in ipairs(fog_components) do
				fog_component:set_volume_enabled(true)
			end

			QuickDrawerStay:sphere(POSITION_LOOKUP[cloud], 4, Color.yellow())

			active_gas_clouds[#active_gas_clouds + 1] = cloud
		end

		table.remove(gas_clouds, random_section_id)
	end

	self._active_gas_clouds = active_gas_clouds
end

MutatorToxicGasVolumes._deactivate_cloud = function (self, cloud)
	if ALIVE[cloud.unit] then
		Managers.state.unit_spawner:mark_for_deletion(cloud.unit)
	end

	cloud.active = false
	cloud.unit = nil
end

MutatorToxicGasVolumes._random = function (self, ...)
	local seed, value = math.next_random(self._seed, ...)
	self._seed = seed

	return value
end

local TARGET_SIDE_ID = 1
local CLOUD_SPAWN_DISTANCE = 60
local TEMP_ALREADY_CHECKED_UNITS = {}
local BROADPHASE_RESULTS = {}

MutatorToxicGasVolumes.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	local is_main_path_available = Managers.state.main_path:is_main_path_available()

	if not is_main_path_available then
		return
	end

	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(TARGET_SIDE_ID)

	if not ahead_travel_distance then
		return
	end

	table.clear(TEMP_ALREADY_CHECKED_UNITS)

	local buff_affected_units = self._buff_affected_units
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side_from_name("heroes")
	local valid_player_units = side.valid_player_units
	local active_gas_clouds = self._active_gas_clouds
	local ALIVE = ALIVE

	for unit, buff_indices in pairs(buff_affected_units) do
		local is_inside_any_cloud = false

		for j = 1, #active_gas_clouds do
			local cloud_unit = active_gas_clouds[j]

			if not ALIVE[unit] or Unit.is_point_inside_volume(cloud_unit, "fog_volume", POSITION_LOOKUP[unit]) then
				is_inside_any_cloud = true

				break
			end
		end

		if not is_inside_any_cloud then
			local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

			if buff_extension then
				local local_index = buff_indices.local_index
				local component_index = buff_indices.component_index

				buff_extension:remove_externally_controlled_buff(local_index, component_index)

				local leaving_liquid_buff_template_name = self._leaving_fog_buff_template_name

				if leaving_liquid_buff_template_name then
					buff_extension:add_internally_controlled_buff(leaving_liquid_buff_template_name, t, "owner_unit", unit)
				end
			end

			buff_affected_units[unit] = nil
		end

		TEMP_ALREADY_CHECKED_UNITS[unit] = true
	end

	local broadphase = self._broadphase
	local side_names = self._side_names
	local broadphase_radius = self._broadphase_radius

	for i = 1, #active_gas_clouds do
		local cloud_unit = active_gas_clouds[i]
		local cloud_unit_position = Unit.world_position(cloud_unit, 1)
		local num_results = broadphase:query(cloud_unit_position, broadphase_radius, BROADPHASE_RESULTS, side_names)

		for j = 1, num_results do
			repeat
				local unit = BROADPHASE_RESULTS[j]

				if not ALIVE[unit] or TEMP_ALREADY_CHECKED_UNITS[unit] then
					break
				end

				local unit_position = POSITION_LOOKUP[unit]
				local unit_is_inside = Unit.is_point_inside_volume(cloud_unit, "fog_volume", unit_position)

				if unit_is_inside then
					QuickDrawer:sphere(unit_position, 1, Color.red())

					local buff_extension = ScriptUnit.has_extension(unit, "buff_system")

					if buff_extension and not TEMP_ALREADY_CHECKED_UNITS[unit] then
						local _, local_index, component_index = buff_extension:add_externally_controlled_buff(self._in_fog_buff_template_name, t, "owner_unit", cloud_unit)
						buff_affected_units[unit] = {
							local_index = local_index,
							component_index = component_index
						}
					end

					TEMP_ALREADY_CHECKED_UNITS[unit] = true
				end
			until true
		end
	end
end

return MutatorToxicGasVolumes
