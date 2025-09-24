-- chunkname: @scripts/managers/mutator/mutators/mutator_toxic_gas_volumes.lua

require("scripts/managers/mutator/mutators/mutator_base")

local Component = require("scripts/utilities/component")
local LiquidArea = require("scripts/extension_systems/liquid_area/utilities/liquid_area")
local LiquidAreaTemplates = require("scripts/settings/liquid_area/liquid_area_templates")
local NavQueries = require("scripts/utilities/nav_queries")
local MutatorToxicGasVolumes = class("MutatorToxicGasVolumes", "MutatorBase")
local GasPhases = table.enum("dormant", "activating", "active")
local GAS_START_SOUND_EVENT = "wwise/events/world/play_event_toxic_gas_high_start"

MutatorToxicGasVolumes.init = function (self, is_server, network_event_delegate, mutator_template, nav_world, level_seed)
	self._is_server = is_server
	self._network_event_delegate = network_event_delegate
	self._is_active = true
	self._buffs = {}
	self._template = mutator_template
	self._gas_clouds = {}
	self._corals = {}
	self._nav_world = nav_world
	self._buff_affected_units = {}
	self._active_gas_clouds = {}
	self._seed = level_seed

	local extension_manager = Managers.state.extension
	local side_system = extension_manager:system("side_system")

	self._side_system, self._side_names = side_system, side_system:side_names()

	if not self._is_server then
		return
	end
end

local CORAL_EVENT_TYPES = table.enum("starting", "trigger")

MutatorToxicGasVolumes._activate_corals = function (self, cloud, coral_event_type)
	if not cloud.corals then
		return
	end

	local corals = cloud.corals

	for i = 1, #corals do
		local coral = corals[i]

		if coral_event_type == CORAL_EVENT_TYPES.starting then
			Component.trigger_event_on_clients(coral.coral_component, "create_low_gas")

			if not DEDICATED_SERVER then
				Component.event(coral.coral_unit, "create_low_gas")
			end
		elseif coral_event_type == CORAL_EVENT_TYPES.trigger then
			Component.trigger_event_on_clients(coral.coral_component, "create_trigger_gas")

			if not DEDICATED_SERVER then
				Component.event(coral.coral_unit, "create_trigger_gas")
			end
		end
	end
end

MutatorToxicGasVolumes._deactivate_corals = function (self, cloud, coral_event_type)
	if not cloud.corals then
		return
	end

	local corals = cloud.corals

	for i = 1, #corals do
		local coral = corals[i]

		Component.trigger_event_on_clients(coral.coral_component, "despawn_low_gas")

		if not DEDICATED_SERVER then
			Component.event(coral.coral_unit, "despawn_low_gas")
		end
	end
end

MutatorToxicGasVolumes._start_fading_cloud = function (self, cloud, fade_time)
	Component.trigger_event_on_clients(cloud.fog_component, "start_fading")

	if not DEDICATED_SERVER then
		Component.event(cloud.cloud_unit, "start_fading")
	end

	cloud.started_fading = true
end

MutatorToxicGasVolumes._activate_cloud = function (self, cloud)
	local liquid_area_template = LiquidAreaTemplates.toxic_gas
	local max_liquid = cloud.max_liquid

	if max_liquid > 0 then
		local unit = LiquidArea.try_create(cloud.position:unbox(), Vector3(0, 0, 1), self._nav_world, liquid_area_template, nil, max_liquid)

		cloud.liquid_unit = unit
	end

	cloud.started_fading = false
	cloud.active = true

	cloud.fog_component:set_volume_enabled(true)

	if cloud.buff_volume_component then
		cloud.buff_volume_component:enable_buffs()
	end
end

MutatorToxicGasVolumes._deactivate_cloud = function (self, cloud)
	if ALIVE[cloud.liquid_unit] then
		Managers.state.unit_spawner:mark_for_deletion(cloud.liquid_unit)
	end

	cloud.active = false
	cloud.liquid_unit = nil

	cloud.fog_component:set_volume_enabled(false)

	cloud.phase = GasPhases.dormant

	if cloud.buff_volume_component then
		cloud.buff_volume_component:disable_buffs()
	end

	local sound_position_entry = self._sound_positions[cloud.section_id][cloud.cloud_id]

	if sound_position_entry then
		sound_position_entry.triggered = false
	end
end

local ACTIVATING_TIME = 8.5

MutatorToxicGasVolumes._activate_alternating_cloud = function (self, cloud, optional_activating_timer, timer)
	cloud.active = true
	cloud.phase = GasPhases.activating
	cloud.activating_timer = optional_activating_timer or ACTIVATING_TIME
	cloud.started_fading = false
	timer.started_low_gas = true

	Component.trigger_event_on_clients(cloud.fog_component, "create_low_gas")

	if not DEDICATED_SERVER then
		Component.event(cloud.cloud_unit, "create_low_gas")
	end

	self:_activate_corals(cloud, CORAL_EVENT_TYPES.starting)
end

MutatorToxicGasVolumes._update_activating_cloud = function (self, dt, cloud, timer)
	if cloud.activating_timer < 1 and not cloud.activated_trigger then
		if not cloud.corals or #cloud.corals == 0 then
			Component.trigger_event_on_clients(cloud.fog_component, "create_trigger_gas")
		end

		if not DEDICATED_SERVER and (not cloud.corals or #cloud.corals == 0) then
			Component.event(cloud.cloud_unit, "create_trigger_gas")
		end

		local sound_position_entry = self._sound_positions[cloud.section_id][cloud.cloud_id]

		if not sound_position_entry.triggered then
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(GAS_START_SOUND_EVENT, sound_position_entry.position:unbox())

			sound_position_entry.triggered = true
		end

		self:_activate_corals(cloud, CORAL_EVENT_TYPES.trigger)

		cloud.activated_trigger = true
	end

	if cloud.activating_timer and cloud.activating_timer > 0 then
		cloud.activating_timer = math.max(cloud.activating_timer - dt, 0)

		if cloud.activating_timer > 0 then
			return false
		end
	end

	self:_activate_activating_cloud(cloud, timer)

	return true
end

MutatorToxicGasVolumes._activate_activating_cloud = function (self, cloud, timer)
	cloud.fog_component:set_volume_enabled(true)

	if cloud.buff_volume_component then
		cloud.buff_volume_component:enable_buffs()
	end

	Component.trigger_event_on_clients(cloud.fog_component, "despawn_low_gas")

	if not DEDICATED_SERVER then
		Component.event(cloud.cloud_unit, "despawn_low_gas")
	end

	self:_deactivate_corals(cloud)

	timer.started_low_gas = false
	cloud.phase = GasPhases.active
	cloud.activated_trigger = nil
end

local CHANCE_TO_NOT_SPAWN_CLOUD = 0.15
local ALTERNATING_CLOUDS = true

MutatorToxicGasVolumes.on_spawn_points_generated = function (self, level, themes)
	if ALTERNATING_CLOUDS then
		self:_setup_alternating_clouds()
	else
		self:_setup_static_clouds()
	end
end

MutatorToxicGasVolumes._get_clouds = function (self, gas_clouds)
	local component_system = Managers.state.extension:system("component_system")
	local fog_units = component_system:get_units_from_component_name("ToxicGasFog")

	if #fog_units == 0 then
		Log.exception("MutatorToxicGasVolumes", "No ToxicGasFog components found in the level.")

		return 0
	end

	local num_sections = 0

	for i = 1, #fog_units do
		local fog_unit = fog_units[i]
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

	return num_sections
end

MutatorToxicGasVolumes._get_corals = function (self, corals)
	local component_system = Managers.state.extension:system("component_system")
	local coral_units = component_system:get_units_from_component_name("ToxicGasCorals")

	if #coral_units == 0 then
		return
	end

	local num_sections = 0

	for i = 1, #coral_units do
		local coral_unit = coral_units[i]
		local components = Component.get_components_by_name(coral_unit, "ToxicGasCorals")

		for _, coral_component in ipairs(components) do
			local id = coral_component:get_data(coral_unit, "id")
			local section_id = coral_component:get_data(coral_unit, "section_id")

			if not corals[section_id] then
				corals[section_id] = {}
			end

			if not corals[section_id][id] then
				corals[section_id][id] = {}
			end

			if num_sections < section_id then
				num_sections = section_id
			end

			local entry = {
				coral_unit = coral_unit,
				coral_component = coral_component,
			}

			table.insert(corals[section_id][id], entry)
		end
	end
end

MutatorToxicGasVolumes._setup_static_clouds = function (self)
	local gas_clouds = self._gas_clouds
	local num_sections = self:_get_clouds(gas_clouds)
	local main_path_manager = Managers.state.main_path
	local active_gas_clouds, nav_world = {}, self._nav_world
	local force_next_to_not_skip = false

	for i = 1, num_sections do
		repeat
			local max_section_id = #gas_clouds
			local random_section_id = self:_random(1, max_section_id)
			local section_entry = gas_clouds[random_section_id]
			local random_id = self:_random(1, #section_entry)
			local clouds = section_entry[random_id]

			if not force_next_to_not_skip and math.random() < CHANCE_TO_NOT_SPAWN_CLOUD then
				force_next_to_not_skip = true

				break
			end

			force_next_to_not_skip = false

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

				local position = Unit.local_position(cloud_unit, 1)
				local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, 5, 10, 5)

				if position_on_navmesh then
					local travel_distance = main_path_manager:travel_distance_from_position(position_on_navmesh)
					local boxed_position = Vector3Box(position)

					active_gas_clouds[#active_gas_clouds + 1] = {
						cloud_unit = cloud_unit,
						travel_distance = travel_distance,
						position = boxed_position,
						max_liquid = max_liquid,
						fog_component = wanted_component,
						buff_volume_component = wanted_buff_volume_component,
					}
				end
			end

			table.remove(gas_clouds, random_section_id)
		until true
	end

	self._active_gas_clouds = active_gas_clouds
end

MutatorToxicGasVolumes._setup_alternating_clouds = function (self)
	local gas_clouds = self._gas_clouds
	local num_sections = self:_get_clouds(gas_clouds)
	local corals = self._corals

	self:_get_corals(corals)

	local main_path_manager, nav_world = Managers.state.main_path, self._nav_world
	local alternating_gas_clouds = {}
	local alternating_timers = {}
	local sound_positions = {}

	for i = 1, num_sections do
		repeat
			local section_entry = gas_clouds[i]

			for k = 1, #section_entry do
				local clouds = section_entry[k]

				if not alternating_timers[i] then
					alternating_timers[i] = {}
					sound_positions[i] = {}
				end

				if not alternating_timers[i][k] then
					alternating_timers[i][k] = {
						active = false,
						timer = 1,
					}
				end

				local sound_position = Vector3(0, 0, 0)
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

					local position = Unit.local_position(cloud_unit, 1)
					local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, 5, 10, 5)

					if position_on_navmesh then
						local alternating_min_range = wanted_component:get_data(cloud_unit, "alternating_min_range")
						local alternating_max_range = wanted_component:get_data(cloud_unit, "alternating_max_range")

						alternating_timers[i][k].min_range = alternating_min_range
						alternating_timers[i][k].max_range = alternating_max_range

						local travel_distance = main_path_manager:travel_distance_from_position(position_on_navmesh)
						local boxed_position = Vector3Box(position)
						local corals_for_cloud = corals[i] and corals[i][k]

						if not alternating_timers[i][k].travel_distance or travel_distance < alternating_timers[i][k].travel_distance then
							alternating_timers[i][k].travel_distance = travel_distance
						end

						local cloud_entry = {
							should_be_active = false,
							cloud_unit = cloud_unit,
							phase = GasPhases.dormant,
							section_id = i,
							cloud_id = k,
							alternating_min_range = alternating_min_range,
							alternating_max_range = alternating_max_range,
							corals = corals_for_cloud,
							travel_distance = travel_distance,
							position = boxed_position,
							max_liquid = max_liquid,
							fog_component = wanted_component,
							buff_volume_component = wanted_buff_volume_component,
						}

						sound_position = sound_position + position
						num_active_clouds = num_active_clouds + 1
						alternating_gas_clouds[#alternating_gas_clouds + 1] = cloud_entry
					end
				end

				if num_active_clouds > 0 then
					sound_position = sound_position / num_active_clouds
					sound_positions[i][k] = {
						triggered = false,
						position = Vector3Box(sound_position),
					}
				end
			end
		until true
	end

	self._sound_positions = sound_positions
	self._alternating_gas_clouds = alternating_gas_clouds
	self._alternating_timers = alternating_timers
end

local TARGET_SIDE_ID = 1
local CLOUD_SPAWN_DISTANCE = 60

MutatorToxicGasVolumes._update_static_clouds = function (self, dt, t)
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(TARGET_SIDE_ID)

	if not ahead_travel_distance then
		return
	end

	local _, behind_travel_distance = main_path_manager:behind_unit(TARGET_SIDE_ID)
	local gas_clouds = self._active_gas_clouds

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

				break
			end

			if not should_activate and is_active then
				self:_deactivate_cloud(gas_cloud)
			end
		until true
	end
end

local FADING_TIME = 5

MutatorToxicGasVolumes._update_alternating_clouds = function (self, dt, t)
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(TARGET_SIDE_ID)

	if not ahead_travel_distance then
		return
	end

	local move_timer_override = false

	if Managers.state.terror_event:num_active_events() > 0 then
		move_timer_override = true
	end

	local gas_clouds = self._alternating_gas_clouds
	local alternating_timers = self._alternating_timers

	for section_id = 1, #alternating_timers do
		local timers = alternating_timers[section_id]
		local num_timers = #timers

		for i = 1, num_timers do
			local timer = timers[i]

			if timer.timer and timer.timer > 0 and not timer.started_low_gas then
				timer.timer = math.max(timer.timer - dt, 0)

				if timer.timer <= 0 then
					if num_timers > 1 then
						local new_cloud_id

						repeat
							new_cloud_id = math.random(1, num_timers)
						until new_cloud_id ~= i

						local new_cloud_timer = timers[new_cloud_id]

						new_cloud_timer.active = true
						new_cloud_timer.timer = math.random_range(new_cloud_timer.min_range, new_cloud_timer.max_range)
						timer.active = false
					else
						timer.active = not timer.active
						timer.timer = math.random_range(timer.min_range, timer.max_range)
					end
				end
			end
		end
	end

	local _, behind_travel_distance = main_path_manager:behind_unit(TARGET_SIDE_ID)

	for i = 1, #gas_clouds do
		repeat
			local gas_cloud = gas_clouds[i]
			local is_active = gas_cloud.active
			local timer = alternating_timers[gas_cloud.section_id][gas_cloud.cloud_id]
			local should_be_active = timer.active

			if not should_be_active then
				if is_active then
					self:_deactivate_cloud(gas_cloud)
				end

				break
			end

			local shortest_travel_distance = timer.travel_distance

			if is_active and timer.timer <= FADING_TIME and not gas_cloud.started_fading then
				self:_start_fading_cloud(gas_cloud)
			end

			local can_activate = move_timer_override or gas_cloud.phase == GasPhases.activating or shortest_travel_distance < ahead_travel_distance
			local ahead_travel_distance_diff = math.abs(ahead_travel_distance - shortest_travel_distance)
			local behind_travel_distance_diff = math.abs(behind_travel_distance - shortest_travel_distance)
			local is_between_ahead_and_behind = shortest_travel_distance < ahead_travel_distance and behind_travel_distance < shortest_travel_distance
			local should_activate = is_between_ahead_and_behind or ahead_travel_distance_diff < CLOUD_SPAWN_DISTANCE or behind_travel_distance_diff < CLOUD_SPAWN_DISTANCE

			if gas_cloud.phase == GasPhases.activating then
				self:_update_activating_cloud(dt, gas_cloud, timer)

				break
			end

			if should_activate and not is_active and can_activate then
				self:_activate_alternating_cloud(gas_cloud, nil, timer)

				break
			end

			if not should_activate and is_active then
				self:_deactivate_cloud(gas_cloud)
			end
		until true
	end
end

MutatorToxicGasVolumes._random = function (self, ...)
	local seed, value = math.next_random(self._seed, ...)

	self._seed = seed

	return value
end

MutatorToxicGasVolumes.update = function (self, dt, t)
	if not self._is_server then
		return
	end

	local is_main_path_available = Managers.state.main_path:is_main_path_available()

	if not is_main_path_available then
		return
	end

	if ALTERNATING_CLOUDS then
		self:_update_alternating_clouds(dt, t)
	else
		self:_update_static_clouds(dt, t)
	end
end

return MutatorToxicGasVolumes
