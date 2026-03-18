-- chunkname: @scripts/utilities/expeditions/event_templates/expedition_event_toxic_gas.lua

local Component = require("scripts/utilities/component")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local NavQueries = require("scripts/utilities/nav_queries")
local GasPhases = table.enum("dormant", "awaken", "active")
local GAS_START_SOUND_EVENT = "wwise/events/world/play_event_toxic_gas_high_start"
local ExpeditionEventSettings = require("scripts/settings/expeditions/expedition_event_settings")
local Settings = ExpeditionEventSettings.toxic_gas

local function _get_clouds(gas_clouds, nav_world)
	local component_system = Managers.state.extension:system("component_system")
	local fog_units = component_system:get_units_from_component_name("ToxicGasFog")

	if #fog_units == 0 then
		Log.exception("MutatorToxicGasVolumes", "No ToxicGasFog components found in the level.")

		return 0
	end

	local num_sections = 0

	for i = 1, #fog_units do
		local fog_unit = fog_units[i]
		local fog_unit_position = Unit.local_position(fog_unit, 1)
		local vertical_range = 0.5
		local horizontal_tolerance = 0.5
		local nav_position = NavQueries.position_on_mesh(nav_world, fog_unit_position, vertical_range, horizontal_tolerance)

		if nav_position then
			local components = Component.get_components_by_name(fog_unit, "ToxicGasFog")

			for _, fog_component in ipairs(components) do
				local id = fog_component:get_data(fog_unit, "id")
				local section_id = fog_component:get_data(fog_unit, "section")
				local max_liquid = fog_component:get_data(fog_unit, "max_liquid")

				if not gas_clouds[section_id] then
					gas_clouds[section_id] = {}
				end

				if not gas_clouds[section_id][id] then
					gas_clouds[section_id][id] = {}
				end

				if num_sections < section_id then
					num_sections = section_id
				end

				local entry = {
					fog_unit = fog_unit,
					max_liquid = max_liquid,
				}

				table.insert(gas_clouds[section_id][id], entry)
			end
		end
	end

	return num_sections
end

local function _awake_cloud(cloud, optional_activating_timer)
	if cloud.active then
		-- Nothing
	end

	local liquid_area_template = LiquidAreaTemplates.toxic_gas
	local max_liquid = cloud.max_liquid

	if max_liquid > 0 then
		local nav_mesh_manager = Managers.state.nav_mesh
		local nav_world = nav_mesh_manager:nav_world()
		local unit = LiquidArea.try_create(cloud.position:unbox(), Vector3(0, 0, 1), nav_world, liquid_area_template, nil, max_liquid)

		cloud.liquid_unit = unit
	end

	cloud.phase = GasPhases.awaken
	cloud.started_fading = false
	cloud.active = true
	cloud.started_low_gas = true
	cloud.activating_timer = optional_activating_timer or Settings.wakeup_time

	local low_gas_created = cloud.fog_component:low_gas_created()
	local event_name = low_gas_created and "restart_low_gas" or "create_low_gas"

	Component.trigger_event_on_clients(cloud.fog_component, event_name)

	if not DEDICATED_SERVER then
		Component.event(cloud.cloud_unit, event_name)
	end
end

local function _activate_awaken_cloud(cloud, t)
	cloud.fog_component:set_volume_enabled(true)

	if cloud.buff_volume_component then
		cloud.buff_volume_component:enable_buffs()
	end

	cloud.started_low_gas = false
	cloud.phase = GasPhases.active

	local depth = cloud.depth
	local gas_settings_by_depth = Settings.gas_settings_by_depth
	local gas_settings = gas_settings_by_depth[depth]
	local lifetime_settings = gas_settings.lifetime
	local min_lifetime = lifetime_settings.min
	local max_lifetime = lifetime_settings.max
	local lifetime = math.random(min_lifetime, max_lifetime)

	cloud.despawn_time = t + lifetime
end

local function _update_awaken_cloud(cloud, dt, t)
	if cloud.activating_timer < 1 and not cloud.activated_trigger then
		local trigger_gas_created = cloud.trigger_gas_created
		local event_name = trigger_gas_created and "restart_trigger_gas" or "create_trigger_gas"

		if not trigger_gas_created then
			cloud.trigger_gas_created = true
		end

		if not trigger_gas_created then
			if not cloud.corals or #cloud.corals == 0 then
				Component.trigger_event_on_clients(cloud.fog_component, event_name)
			end

			if not DEDICATED_SERVER and (not cloud.corals or #cloud.corals == 0) then
				Component.event(cloud.cloud_unit, event_name)
			end
		end

		cloud.activated_trigger = true
	end

	if cloud.activating_timer and cloud.activating_timer > 0 then
		cloud.activating_timer = math.max(cloud.activating_timer - dt, 0)

		if cloud.activating_timer > 0 then
			return false
		end
	end

	_activate_awaken_cloud(cloud, t)

	return true
end

local function _deactivate_cloud(cloud, t)
	if ALIVE[cloud.liquid_unit] then
		Managers.state.unit_spawner:mark_for_deletion(cloud.liquid_unit)
	end

	local depth = cloud.depth
	local gas_settings_by_depth = Settings.gas_settings_by_depth
	local gas_settings = gas_settings_by_depth[depth]
	local respawn_delay_settings = gas_settings.respawn_delay
	local min_respawn_delay = respawn_delay_settings.min
	local max_respawn_delay = respawn_delay_settings.max
	local respawn_delay = math.random(min_respawn_delay, max_respawn_delay)

	cloud.respawn_delay_time = t + respawn_delay
	cloud.despawn_time = 0
	cloud.timer = 0
	cloud.active = false
	cloud.liquid_unit = nil

	cloud.fog_component:set_volume_enabled(false)

	cloud.phase = GasPhases.dormant

	if cloud.buff_volume_component then
		cloud.buff_volume_component:disable_buffs()
	end

	Component.trigger_event_on_clients(cloud.fog_component, "stop_all_gas")

	if not DEDICATED_SERVER then
		Component.event(cloud.cloud_unit, "stop_all_gas")
	end

	Component.trigger_event_on_clients(cloud.fog_component, "despawn_low_gas")

	if not DEDICATED_SERVER then
		Component.event(cloud.cloud_unit, "despawn_low_gas")
	end
end

local function _start_fading_cloud(cloud, fade_time)
	Component.trigger_event_on_clients(cloud.fog_component, "start_fading")

	if not DEDICATED_SERVER then
		Component.event(cloud.cloud_unit, "start_fading")
	end

	cloud.started_fading = true
end

local _broadphase_results = {}
local _gas_clouds_in_player_proximity = {}
local definition = {
	server_only = true,
	settings = Settings,
	init = function (data, template, context, time_into_event)
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local level_grid_handler = context.level_grid_handler
		local settings = template.settings

		data.broadphase_delay = settings.broadphase_delay

		local broadphase_category = settings.broadphase_category
		local gas_settings_by_depth = settings.gas_settings_by_depth
		local nav_world = context.nav_world
		local gas_clouds = {}

		data.gas_clouds = gas_clouds

		local num_sections = _get_clouds(gas_clouds, nav_world)
		local alternating_gas_clouds = {}

		data.alternating_gas_clouds = alternating_gas_clouds

		for i = 1, num_sections do
			repeat
				local section_entry = gas_clouds[i]

				for k = 1, #section_entry do
					local clouds = section_entry[k]
					local num_active_clouds = 0

					for j = 1, #clouds do
						local cloud = clouds[j]
						local cloud_unit = cloud.fog_unit
						local max_liquid = cloud.max_liquid
						local fog_components = Component.get_components_by_name(cloud_unit, "ToxicGasFog")
						local wanted_component

						for _, fog_component in ipairs(fog_components) do
							wanted_component = fog_component
						end

						local buff_volume_components = Component.get_components_by_name(cloud_unit, "BuffVolume")
						local wanted_buff_volume_component

						for _, buff_volume_component in ipairs(buff_volume_components) do
							wanted_buff_volume_component = buff_volume_component
						end

						local alternating_min_range = wanted_component:get_data(cloud_unit, "alternating_min_range")
						local alternating_max_range = wanted_component:get_data(cloud_unit, "alternating_max_range")
						local position = Unit.local_position(cloud_unit, 1)
						local boxed_position = Vector3Box(position)
						local deep_search = true
						local grid_cell = level_grid_handler:grid_cell_by_position(position, deep_search)
						local depth = grid_cell.depth
						local gas_settings = gas_settings_by_depth[depth]
						local broadphase_radius = gas_settings.broadphase_radius
						local cloud_entry = {
							active = false,
							respawn_delay_time = 0,
							should_be_active = false,
							cloud_unit = cloud_unit,
							phase = GasPhases.dormant,
							section_id = i,
							cloud_id = k,
							alternating_min_range = alternating_min_range,
							alternating_max_range = alternating_max_range,
							depth = depth,
							position = boxed_position,
							max_liquid = max_liquid,
							fog_component = wanted_component,
							buff_volume_component = wanted_buff_volume_component,
						}

						num_active_clouds = num_active_clouds + 1
						alternating_gas_clouds[#alternating_gas_clouds + 1] = cloud_entry

						Broadphase.add(broadphase, cloud_unit, position, broadphase_radius or 1, broadphase_category)
					end
				end
			until true
		end
	end,
	update = function (data, template, context, dt, t)
		local settings = template.settings
		local broadphase_delay = data.broadphase_delay

		if broadphase_delay <= 0 then
			data.broadphase_delay = settings.broadphase_delay

			local seed = data.seed

			data.seed = seed

			local broadphase_system = Managers.state.extension:system("broadphase_system")
			local broadphase = broadphase_system.broadphase

			table.clear(_broadphase_results)
			table.clear(_gas_clouds_in_player_proximity)

			local broadphase_category = settings.broadphase_category
			local categories = {
				broadphase_category,
			}
			local player_broadphase_radius = settings.player_broadphase_radius
			local player_manager = Managers.player
			local players = player_manager:players()

			for _, player in pairs(players) do
				local player_unit = player.player_unit

				if player_unit and Unit.alive(player_unit) then
					local player_position = Unit.local_position(player_unit, 1)
					local num_hits = Broadphase.query(broadphase, player_position, player_broadphase_radius, _broadphase_results, categories)

					for ii = 1, num_hits do
						repeat
							local target_unit = _broadphase_results[ii]

							_gas_clouds_in_player_proximity[target_unit] = true
						until true
					end
				end
			end
		else
			data.broadphase_delay = broadphase_delay - dt
		end

		local alternating_gas_clouds = data.alternating_gas_clouds

		for i = 1, #alternating_gas_clouds do
			local entry = alternating_gas_clouds[i]
			local cloud_unit = entry.cloud_unit
			local phase = entry.phase

			if phase == GasPhases.active then
				local despawn_time = entry.despawn_time

				if despawn_time <= t then
					_deactivate_cloud(entry, t)
				end
			elseif phase == GasPhases.awaken then
				_update_awaken_cloud(entry, dt, t)
			end

			if _gas_clouds_in_player_proximity[cloud_unit] and t >= entry.respawn_delay_time then
				if not entry.active then
					_awake_cloud(entry)
				end
			elseif entry.active then
				_deactivate_cloud(entry, t)
			end
		end
	end,
	done = function (data, template, context, dt, t)
		return false
	end,
	destroy = function (data, template, context)
		local minion_unit = data.minion_unit

		if minion_unit and Unit.alive(minion_unit) then
			local minion_spawn_manager = Managers.state.minion_spawn

			minion_spawn_manager:despawn_minion(minion_unit)

			data.minion_unit = nil
		end
	end,
}

return definition
