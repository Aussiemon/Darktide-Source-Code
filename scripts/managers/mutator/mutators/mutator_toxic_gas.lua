require("scripts/managers/mutator/mutators/mutator_base")

local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local MutatorToxicGas = class("MutatorToxicGas", "MutatorBase")

MutatorToxicGas.init = function (self, is_server, network_event_delegate, mutator_template, nav_world)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
	self._gas_clouds = {}
	self._nav_world = nav_world

	if not self._is_server then
		return
	end

	local is_main_path_available = Managers.state.main_path:is_main_path_available()

	if not is_main_path_available then
		return
	end

	local gas_settings = self._template.gas_settings
	local num_gas_clouds = gas_settings.num_gas_clouds
	local distance_range = gas_settings.cloud_spawn_distance_range
	local current_distance = 0

	for i = 1, num_gas_clouds do
		current_distance = current_distance + math.random_range(distance_range[1], distance_range[2])
		local wanted_position = MainPathQueries.position_from_distance(current_distance)

		if not wanted_position then
			break
		end

		self._gas_clouds[#self._gas_clouds + 1] = {
			position = Vector3Box(wanted_position),
			travel_distance = current_distance
		}
	end
end

MutatorToxicGas._activate_cloud = function (self, cloud)
	local liquid_area_template = LiquidAreaTemplates.toxic_gas
	local unit = LiquidArea.try_create(cloud.position:unbox(), Vector3(0, 0, 1), self._nav_world, liquid_area_template)
	cloud.active = true
	cloud.unit = unit
end

MutatorToxicGas._deactivate_cloud = function (self, cloud)
	if ALIVE[cloud.unit] then
		Managers.state.unit_spawner:mark_for_deletion(cloud.unit)
	end

	cloud.active = false
	cloud.unit = nil
end

local TARGET_SIDE_ID = 1
local CLOUD_SPAWN_DISTANCE = 60

MutatorToxicGas.update = function (self, dt, t)
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

	local _, behind_travel_distance = main_path_manager:behind_unit(TARGET_SIDE_ID)
	local gas_clouds = self._gas_clouds

	for i = 1, #gas_clouds do
		repeat
			local gas_cloud = gas_clouds[i]
			local cloud_travel_distance = gas_cloud.travel_distance
			local ahead_travel_distance_diff = math.abs(ahead_travel_distance - cloud_travel_distance)
			local behind_travel_distance_diff = math.abs(behind_travel_distance - cloud_travel_distance)
			local is_between_ahead_and_behind = cloud_travel_distance < ahead_travel_distance and behind_travel_distance < cloud_travel_distance
			local should_activate = is_between_ahead_and_behind or ahead_travel_distance_diff < CLOUD_SPAWN_DISTANCE or behind_travel_distance_diff < CLOUD_SPAWN_DISTANCE
			local is_active = gas_cloud.active

			if should_activate and not is_active then
				self:_activate_cloud(gas_cloud)
			elseif not should_activate and is_active then
				self:_deactivate_cloud(gas_cloud)
			end
		until true
	end
end

return MutatorToxicGas
