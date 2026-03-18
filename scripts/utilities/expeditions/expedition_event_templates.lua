-- chunkname: @scripts/utilities/expeditions/expedition_event_templates.lua

local Explosion = require("scripts/utilities/attack/explosion")
local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local NavQueries = require("scripts/utilities/nav_queries")
local ExpeditionEventSettings = require("scripts/settings/expeditions/expedition_event_settings")
local FixedFrame = require("scripts/utilities/fixed_frame")
local VortexLocomotion = require("scripts/extension_systems/locomotion/utilities/vortex_locomotion")

local function _ray_cast(world, from, to, collision_filter)
	local physics_world = World.physics_world(world)
	local to_target = to - from
	local direction, distance = Vector3.normalize(to_target), Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", collision_filter or "filter_player_mover")

	return result, hit_position, hit_distance, normal
end

local function _spawn_network_unit(unit_name, unit_template_name, position, rotation)
	rotation = rotation or Quaternion.axis_angle(Vector3.forward(), math.random() * math.pi * 2)

	local random_x = math.random() * 2 - 1
	local random_y = math.random() * 2 - 1
	local random_z = math.random() * 2 - 1
	local random_direction = Vector3(random_x, random_y, random_z)
	local force_direction_boxed = Vector3Box(Vector3.normalize(random_direction))
	local projectile_unit, _ = Managers.state.unit_spawner:spawn_network_unit(unit_name, unit_template_name, position, rotation, nil, force_direction_boxed)

	return projectile_unit
end

local function _get_sorted_player_list(player_list)
	local sorted = {}

	for _, player in pairs(player_list) do
		local peer_id = player:peer_id()

		for i = 1, #sorted + 1 do
			local other_peer = sorted[i] and sorted[i]:peer_id()

			if not other_peer or #peer_id > #other_peer or #peer_id == #other_peer and other_peer < peer_id then
				table.insert(sorted, i, player)

				break
			end
		end
	end

	return sorted
end

local FX_PADDING = 0.5
local Z_OFFSET = 0.1

local function _create_lightning_fx(context, settings, deal_damage, position)
	if not deal_damage then
		return
	end

	local radius = settings.impact_radius
	local diameter = radius * 2
	local v = Vector3(FX_PADDING, radius - FX_PADDING, 0)
	local world = context.world
	local impact_decal_unit_name = settings.impact_decal_unit_name
	local particle_name = settings.lightning_particle
	local decal_unit = World.spawn_unit_ex(world, impact_decal_unit_name, nil, position + Vector3(0, 0, Z_OFFSET))
	local particle_id = World.create_particles(world, particle_name, position)
	local length_variable_index = World.find_particles_variable(world, particle_name, "radius")

	Unit.set_local_scale(decal_unit, 1, Vector3(diameter, diameter, diameter))
	Unit.set_scalar_for_materials(decal_unit, "charge_progress", 0, true)
	World.set_particles_variable(world, particle_id, length_variable_index, v)
	World.set_particles_emit_rate_multiplier(world, particle_id, 0)

	local buildup_sound = settings.buildup_sound

	if buildup_sound then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:trigger_local_unit_wwise_event(buildup_sound, decal_unit)
	end

	return particle_id, decal_unit
end

local EMIT_RATE_MAX = 10
local EMIT_RATE_MULTIPLIER = 20

local function _update_lightning_fx(world, dynamic_unit_data)
	if not dynamic_unit_data.deal_damage then
		return
	end

	local spawn_time_fraction = 1 - math.clamp(dynamic_unit_data.delayed_spawn_time / dynamic_unit_data.initial_delayed_spawn_time, 0, 1)
	local decal_unit = dynamic_unit_data.decal_unit
	local particle_id = dynamic_unit_data.particle_id

	if decal_unit then
		Unit.set_scalar_for_materials(decal_unit, "charge_progress", spawn_time_fraction, true)
	end

	if particle_id then
		local multiplier = math.clamp(spawn_time_fraction * EMIT_RATE_MULTIPLIER, 0, EMIT_RATE_MAX)

		World.set_particles_emit_rate_multiplier(world, particle_id, multiplier)
	end
end

local function _destroy_lightning_fx(world, dynamic_unit_data, settings, is_server)
	local decal_unit = dynamic_unit_data.decal_unit
	local buildup_stop_sound = settings.buildup_stop_sound

	if decal_unit and Unit.alive(decal_unit) then
		if buildup_stop_sound then
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_local_unit_wwise_event(buildup_stop_sound, decal_unit)
		end

		Managers.state.unit_spawner:mark_for_deletion(decal_unit)
	end

	local particle_id = dynamic_unit_data.particle_id

	if particle_id then
		World.destroy_particles(world, particle_id)

		dynamic_unit_data.particle_id = nil
	end
end

local function _update_storm_state(data, settings)
	local loop_duration = settings.loop_duration

	if not loop_duration then
		return true
	end

	local t = FixedFrame.get_latest_fixed_time()
	local sfx_settings = settings.sfx
	local seed = data.seed
	local random_range_duration, sfx_event

	if not data.pause_loop_t and not data.resume_loop_t then
		seed, random_range_duration = math.next_random(seed, loop_duration.pause_duration_min, loop_duration.pause_duration_max)
		data.resume_loop_t = t + random_range_duration
		data.resume_sfx_loop_t = data.resume_loop_t - sfx_settings.storm_loop_headstart
	end

	if data.resume_sfx_loop_t and t > data.resume_sfx_loop_t then
		sfx_event = sfx_settings.storm_start_event
		data.resume_sfx_loop_t = nil
	end

	if data.resume_loop_t and t > data.resume_loop_t then
		seed, random_range_duration = math.next_random(seed, loop_duration.pause_duration_min, loop_duration.pause_duration_max)
		data.pause_loop_t = t + random_range_duration
		data.resume_loop_t = nil
	elseif data.pause_loop_t and t > data.pause_loop_t then
		sfx_event = sfx_settings.storm_stop_event
		seed, random_range_duration = math.next_random(seed, loop_duration.loop_duration_min, loop_duration.loop_duration_max)
		data.resume_loop_t = t + random_range_duration
		data.resume_sfx_loop_t = data.resume_loop_t - sfx_settings.storm_loop_headstart
		data.pause_loop_t = nil
	end

	local should_run = data.pause_loop_t and t < data.pause_loop_t

	data.seed = seed

	return should_run, sfx_event
end

local function _create_lightning_explosion(world, physics_world, explosion_settings, hit_position, lightning_unit)
	local explosion_template_name = explosion_settings.template_name
	local explosion_template = ExplosionTemplates[explosion_template_name]
	local charge_level = explosion_settings.charge_level
	local power_level = explosion_settings.power_level
	local attack_type = AttackSettings.attack_types.explosion

	Explosion.create_explosion(world, physics_world, hit_position, Vector3.up(), lightning_unit, explosion_template, power_level, charge_level, attack_type, nil, nil, nil, nil, nil, nil, nil, nil, true)
end

local function _add_lightning_strikes_close_to_position(context, data, settings, time_into_event, parent_position, min_distance, max_distance, amount, deal_damage, unique_seed)
	local initial_life_time = settings.initial_life_time
	local initial_life_time_min = initial_life_time.min
	local initial_life_time_max = initial_life_time.max
	local additional_life_time = settings.additional_life_time
	local world = context.world

	for i = 1, amount do
		local windup_time_multiplier

		unique_seed, windup_time_multiplier = math.next_random(unique_seed)

		local windup_time = initial_life_time_min + windup_time_multiplier * (initial_life_time_max - initial_life_time_min)
		local startup_delay = 0

		if settings.startup_delay_max then
			local startup_delay_multiplier

			unique_seed, startup_delay_multiplier = math.next_random(unique_seed)
			startup_delay = settings.startup_delay_max * startup_delay_multiplier
		end

		local start_time = FixedFrame.get_latest_fixed_time() + startup_delay
		local random_x, random_y

		unique_seed, random_x = math.next_random(unique_seed, min_distance, max_distance)
		unique_seed, random_y = math.next_random(unique_seed, min_distance, max_distance)

		local position = Vector3(parent_position.x + -max_distance * 0.5 + random_x, parent_position.y + -max_distance * 0.5 + random_y, parent_position.z + 50)
		local random_angle_multiplier

		unique_seed, random_angle_multiplier = math.next_random(unique_seed, 0, 1)

		local initial_delayed_spawn_time = windup_time + i * additional_life_time
		local delayed_spawn_time = initial_delayed_spawn_time - time_into_event
		local _, hit_position, _, _ = _ray_cast(world, position, position + Vector3(0, 0, -100))

		if hit_position then
			local random_rotation = Quaternion.axis_angle(Vector3.forward(), random_angle_multiplier * (math.pi * 2))
			local entry = {
				boxed_position = Vector3Box(position),
				boxed_rotation = QuaternionBox(random_rotation),
				delayed_spawn_time = delayed_spawn_time,
				initial_delayed_spawn_time = initial_delayed_spawn_time,
				start_time = start_time,
				hit_position = Vector3Box(hit_position),
				deal_damage = deal_damage,
			}

			data.dynamic_unit_spawning[#data.dynamic_unit_spawning + 1] = entry
		end
	end
end

local expedition_event_templates = {}

expedition_event_templates.spawn_sand_vortex = {
	server_only = true,
	settings = ExpeditionEventSettings.spawn_sand_vortex,
	init = function (data, template, context, time_into_event)
		local settings = template.settings

		data.spawn_delay = settings.spawn_delay
	end,
	update = function (data, template, context, dt, t)
		local settings = template.settings
		local spawn_delay = data.spawn_delay
		local player_manager = Managers.player
		local human_players = player_manager:human_players()
		local num_human_players = player_manager:num_human_players()
		local unit_alive = data.minion_unit and Unit.alive(data.minion_unit)
		local unit_was_alive = data.unit_alive

		if unit_was_alive and not unit_alive then
			spawn_delay = settings.spawn_delay
			data.spawn_delay = spawn_delay
			data.unit_alive = false
		elseif unit_alive then
			data.unit_alive = true
		end

		if num_human_players > 0 then
			if spawn_delay <= 0 then
				if not data.minion_unit or not Unit.alive(data.minion_unit) then
					data.spawn_delay = settings.spawn_delay

					local seed = data.seed
					local random_player_index

					seed, random_player_index = math.next_random(seed, 1, num_human_players)

					local target_player
					local player_counter = 0

					for _, player in pairs(human_players) do
						player_counter = player_counter + 1

						if player_counter == random_player_index then
							target_player = player

							break
						end
					end

					if target_player then
						local player_unit = target_player.player_unit

						if player_unit and Unit.alive(player_unit) then
							local player_navigation_extension = ScriptUnit.extension(player_unit, "navigation_system")
							local nav_world = player_navigation_extension:nav_world()
							local player_position = POSITION_LOOKUP[player_unit]
							local unit_data = ScriptUnit.extension(player_unit, "unit_data_system")
							local first_person_component = unit_data:read_component("first_person")
							local player_rotation = first_person_component.rotation
							local player_forward_direction = Quaternion.forward(player_rotation)
							local player_flat_forward_direction = Vector3.normalize(Vector3.flat(player_forward_direction))
							local spawn_distance_infront_of_selected_player_target = settings.spawn_distance_infront_of_selected_player_target
							local wanted_position = player_position + player_flat_forward_direction * spawn_distance_infront_of_selected_player_target
							local vertical_range = 10
							local horizontal_tolerance = 10
							local nav_position = NavQueries.position_on_mesh(nav_world, wanted_position, vertical_range, horizontal_tolerance)

							if nav_position == nil then
								local distance_from_obstacle = 0.5

								nav_position = GwNavQueries.inside_position_from_outside_position(nav_world, wanted_position, vertical_range, vertical_range, horizontal_tolerance, distance_from_obstacle)
							end

							local success = false

							if nav_position ~= nil then
								local world = context.world
								local physics_world = World.physics_world(world)

								success = not VortexLocomotion.is_position_indoors(nav_position, physics_world)
							end

							if success then
								local breed_name = "sand_vortex"
								local enemy_side_id = 2
								local params = {}
								local minion_spawn_manager = Managers.state.minion_spawn
								local minion_unit = minion_spawn_manager:spawn_minion(breed_name, nav_position, Quaternion.identity(), enemy_side_id, params)

								data.minion_unit = minion_unit
							else
								local wait_time_on_spawn_failed = settings.wait_time_on_spawn_failed

								data.spawn_delay = wait_time_on_spawn_failed
							end
						end
					end

					data.seed = seed
				end
			else
				data.spawn_delay = spawn_delay - dt
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
expedition_event_templates.spawn_nurgle_flies = {
	server_only = true,
	settings = ExpeditionEventSettings.spawn_nurgle_flies,
	init = function (data, template, context, time_into_event)
		local settings = template.settings

		data.spawn_delay = settings.spawn_delay
	end,
	update = function (data, template, context, dt, t)
		local settings = template.settings
		local spawn_delay = data.spawn_delay
		local player_manager = Managers.player
		local human_players = player_manager:human_players()
		local num_human_players = player_manager:num_human_players()

		if num_human_players > 0 and (not data.minion_unit or not Unit.alive(data.minion_unit)) then
			if spawn_delay <= 0 then
				data.spawn_delay = settings.spawn_delay

				local seed = data.seed
				local random_player_index

				seed, random_player_index = math.next_random(seed, 1, num_human_players)

				local target_player
				local player_counter = 0

				for _, player in pairs(human_players) do
					player_counter = player_counter + 1

					if player_counter == random_player_index then
						target_player = player

						break
					end
				end

				if target_player then
					local player_unit = target_player.player_unit

					if player_unit and Unit.alive(player_unit) then
						local player_navigation_extension = ScriptUnit.extension(player_unit, "navigation_system")
						local nav_world = player_navigation_extension:nav_world()
						local player_position = POSITION_LOOKUP[player_unit]
						local unit_data = ScriptUnit.extension(player_unit, "unit_data_system")
						local first_person_component = unit_data:read_component("first_person")
						local player_rotation = first_person_component.rotation
						local player_forward_direction = Quaternion.forward(player_rotation)
						local player_flat_forward_direction = Vector3.normalize(Vector3.flat(player_forward_direction))
						local spawn_distance_infront_of_selected_player_target = settings.spawn_distance_infront_of_selected_player_target
						local wanted_position = player_position + player_flat_forward_direction * spawn_distance_infront_of_selected_player_target
						local vertical_range = 10
						local horizontal_tolerance = 10
						local nav_position = NavQueries.position_on_mesh(nav_world, wanted_position, vertical_range, horizontal_tolerance)

						if nav_position == nil then
							local distance_from_obstacle = 0.5

							nav_position = GwNavQueries.inside_position_from_outside_position(nav_world, wanted_position, vertical_range, vertical_range, horizontal_tolerance, distance_from_obstacle)
						end

						if nav_position ~= nil then
							local breed_name = "nurgle_flies"
							local enemy_side_id = 2
							local params = {}
							local minion_spawn_manager = Managers.state.minion_spawn
							local minion_unit = minion_spawn_manager:spawn_minion(breed_name, nav_position, Quaternion.identity(), enemy_side_id, params)

							data.minion_unit = minion_unit
						else
							local wait_time_on_spawn_failed = settings.wait_time_on_spawn_failed

							data.spawn_delay = wait_time_on_spawn_failed
						end
					end
				end

				data.seed = seed
			else
				data.spawn_delay = spawn_delay - dt
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
expedition_event_templates.lightning_strikes_backdrop = {
	settings = ExpeditionEventSettings.lightning_strikes_backdrop,
	init = function (data, template, context, time_into_event)
		local settings = template.settings
		local PI = math.pi
		local world = context.world

		data.dynamic_unit_spawning = {}
		data.lightning_units = {}

		local seed = data.seed

		time_into_event = time_into_event or 0

		local distance_from_level_origo = settings.distance_from_level_origo
		local distance_from_level_origo_min = distance_from_level_origo.min
		local distance_from_level_origo_max = distance_from_level_origo.max
		local amount_of_strikes = settings.amount_of_strikes
		local amount_of_strikes_min = amount_of_strikes.min
		local amount_of_strikes_max = amount_of_strikes.max
		local num_distance_strikes

		seed, num_distance_strikes = math.next_random(seed, amount_of_strikes_min, amount_of_strikes_max)

		_add_lightning_strikes_close_to_position(context, data, settings, time_into_event, Vector3.zero(), distance_from_level_origo_min, distance_from_level_origo_max, num_distance_strikes, false, seed)

		data.seed = seed
	end,
	update = function (data, template, context, dt, t)
		local settings = template.settings
		local end_time = data.end_time

		if end_time then
			if end_time >= 0 then
				data.end_time = end_time - dt
			else
				data.end_time = nil
				data.done = true
			end

			return
		end

		local fx_system = Managers.state.extension:system("fx_system")
		local dynamic_unit_spawning = data.dynamic_unit_spawning

		if #dynamic_unit_spawning > 0 then
			local lightning_units = data.lightning_units

			for i = #dynamic_unit_spawning, 1, -1 do
				local dynamic_unit_data = dynamic_unit_spawning[i]
				local delayed_spawn_time = dynamic_unit_data.delayed_spawn_time

				if delayed_spawn_time <= 0 then
					local world = context.world
					local hit_position = dynamic_unit_data.hit_position:unbox()
					local lightning_unit_name = settings.lightning_unit_name
					local lightning_unit = World.spawn_unit_ex(world, lightning_unit_name, nil, hit_position)

					lightning_units[#lightning_units + 1] = lightning_unit

					if context.is_server then
						local strike_sound = settings.strike_sound

						if strike_sound then
							fx_system:trigger_wwise_event(strike_sound, hit_position)
						end
					end

					table.remove(dynamic_unit_spawning, i)
				else
					dynamic_unit_data.delayed_spawn_time = delayed_spawn_time - dt

					local position = dynamic_unit_data.boxed_position:unbox()
					local hit_position = dynamic_unit_data.hit_position:unbox()
				end
			end
		else
			data.end_time = settings.end_time or 1
		end
	end,
	done = function (data, template, context)
		return data.done
	end,
	destroy = function (data, template, context)
		local spawner_manager = Managers.state.unit_spawner
		local lightning_units = data.lightning_units

		if lightning_units then
			for i = 1, #lightning_units do
				local lightning_unit = lightning_units[i]

				if Unit.alive(lightning_unit) then
					spawner_manager:mark_for_deletion(lightning_unit)
				end
			end
		end
	end,
}
expedition_event_templates.lightning_strikes_naive = {
	settings = ExpeditionEventSettings.lightning_strikes_naive,
	init = function (data, template, context, time_into_event)
		local settings = template.settings

		data.dynamic_unit_spawning = {}
		data.lightning_units = {}

		local seed = data.seed

		time_into_event = time_into_event or 0

		local distance_from_level_origo = settings.distance_from_level_origo
		local distance_from_level_origo_min = distance_from_level_origo.min
		local distance_from_level_origo_max = distance_from_level_origo.max
		local amount_of_strikes = settings.amount_of_strikes
		local amount_of_strikes_min = amount_of_strikes.min
		local amount_of_strikes_max = amount_of_strikes.max
		local num_strikes

		seed, num_strikes = math.next_random(seed, amount_of_strikes_min, amount_of_strikes_max)

		_add_lightning_strikes_close_to_position(context, data, settings, time_into_event, Vector3.zero(), distance_from_level_origo_min, distance_from_level_origo_max, num_strikes, false, seed)

		data.seed = seed
	end,
	update = function (data, template, context, dt, t)
		local settings = template.settings
		local end_time = data.end_time

		if end_time then
			if end_time >= 0 then
				data.end_time = end_time - dt
			else
				data.end_time = nil
				data.done = true
			end

			return
		end

		local fx_system = Managers.state.extension:system("fx_system")
		local spawner_manager = Managers.state.unit_spawner
		local dynamic_unit_spawning = data.dynamic_unit_spawning

		if not table.is_empty(dynamic_unit_spawning) then
			local explosion_settings = settings.explosion_settings
			local impact_radius = settings.impact_radius
			local diameter = impact_radius * 2
			local lightning_units = data.lightning_units

			for i = #dynamic_unit_spawning, 1, -1 do
				local dynamic_unit_data = dynamic_unit_spawning[i]
				local delayed_spawn_time = dynamic_unit_data.delayed_spawn_time
				local deal_damage = dynamic_unit_data.deal_damage

				if delayed_spawn_time <= 0 then
					local world = context.world
					local physics_world = context.physics_world
					local hit_position = dynamic_unit_data.hit_position:unbox()
					local strike_sound = settings.strike_sound
					local lightning_unit_name = settings.lightning_unit_name
					local lightning_unit = World.spawn_unit_ex(world, lightning_unit_name, nil, hit_position)

					lightning_units[#lightning_units + 1] = lightning_unit

					if deal_damage then
						_destroy_lightning_fx(context.world, dynamic_unit_data, settings, context.is_server)
					end

					if context.is_server and deal_damage then
						_create_lightning_explosion(world, physics_world, explosion_settings, hit_position, lightning_unit)
					end

					if context.is_server and strike_sound then
						fx_system:trigger_wwise_event(strike_sound, hit_position)
					end

					table.remove(dynamic_unit_spawning, i)
				else
					_update_lightning_fx(context.world, dynamic_unit_data)

					dynamic_unit_data.delayed_spawn_time = delayed_spawn_time - dt
				end
			end
		else
			data.end_time = settings.end_time or 1
		end
	end,
	done = function (data, template, context)
		return data.done
	end,
	destroy = function (data, template, context)
		local settings = template.settings
		local spawner_manager = Managers.state.unit_spawner
		local dynamic_unit_spawning = data.dynamic_unit_spawning

		for _, dynamic_unit_data in ipairs(dynamic_unit_spawning) do
			_destroy_lightning_fx(context.world, dynamic_unit_data, settings, context.is_server)
		end

		local lightning_units = data.lightning_units

		if lightning_units then
			for i = 1, #lightning_units do
				local lightning_unit = lightning_units[i]

				if Unit.alive(lightning_unit) then
					spawner_manager:mark_for_deletion(lightning_unit)
				end
			end
		end
	end,
}
expedition_event_templates.lightning_strikes_targeted_random_player = {
	settings = ExpeditionEventSettings.lightning_strikes_targeted_random_player,
	init = function (data, template, context, time_into_event)
		local settings = template.settings

		data.dynamic_unit_spawning = {}
		data.lightning_units = {}

		local seed = data.seed

		time_into_event = time_into_event or 0

		local distance_from_each_player = settings.distance_from_each_player
		local distance_from_each_player_min = distance_from_each_player.min
		local distance_from_each_player_max = distance_from_each_player.max
		local amount_of_strikes = settings.amount_of_strikes
		local amount_of_strikes_min = amount_of_strikes.min
		local amount_of_strikes_max = amount_of_strikes.max
		local player_manager = Managers.player
		local human_players = player_manager:human_players()
		local num_human_players = player_manager:num_human_players()

		if num_human_players > 0 then
			local sorted_players = _get_sorted_player_list(human_players)
			local random_player_index

			seed, random_player_index = math.next_random(seed, 1, num_human_players)

			local target_player = sorted_players[random_player_index]

			if target_player then
				local player_unit = target_player.player_unit

				if player_unit and Unit.alive(player_unit) then
					local player_position = Unit.local_position(player_unit, 1)
					local player_slot = target_player:slot()
					local player_seed = seed + player_slot
					local num_strikes

					seed, num_strikes = math.next_random(seed, amount_of_strikes_min, amount_of_strikes_max)

					_add_lightning_strikes_close_to_position(context, data, settings, time_into_event, player_position, distance_from_each_player_min, distance_from_each_player_max, num_strikes, true, player_seed)
				end
			end

			data.seed = seed
		end
	end,
	update = function (data, template, context, dt, t)
		local settings = template.settings
		local end_time = data.end_time

		if end_time then
			if end_time >= 0 then
				data.end_time = end_time - dt
			else
				data.end_time = nil
				data.done = true
			end

			return
		end

		local fx_system = Managers.state.extension:system("fx_system")
		local dynamic_unit_spawning = data.dynamic_unit_spawning

		if #dynamic_unit_spawning > 0 then
			local explosion_settings = settings.explosion_settings
			local lightning_units = data.lightning_units

			for i = #dynamic_unit_spawning, 1, -1 do
				local dynamic_unit_data = dynamic_unit_spawning[i]
				local start_time = dynamic_unit_data.start_time

				if start_time < t then
					if not dynamic_unit_data.decal_unit then
						dynamic_unit_data.particle_id, dynamic_unit_data.decal_unit = _create_lightning_fx(context, settings, dynamic_unit_data.deal_damage, dynamic_unit_data.hit_position:unbox())
					end

					local delayed_spawn_time = dynamic_unit_data.delayed_spawn_time
					local deal_damage = dynamic_unit_data.deal_damage

					if delayed_spawn_time <= 0 then
						local world = context.world
						local physics_world = context.physics_world
						local hit_position = dynamic_unit_data.hit_position:unbox()
						local strike_sound = settings.strike_sound
						local lightning_unit_name = settings.lightning_unit_name
						local lightning_unit = World.spawn_unit_ex(world, lightning_unit_name, nil, hit_position)

						lightning_units[#lightning_units + 1] = lightning_unit

						if deal_damage then
							_destroy_lightning_fx(context.world, dynamic_unit_data, settings, context.is_server)
						end

						if context.is_server and deal_damage then
							_create_lightning_explosion(world, physics_world, explosion_settings, hit_position, lightning_unit)
						end

						if context.is_server and strike_sound then
							fx_system:trigger_wwise_event(strike_sound, hit_position)
						end

						table.remove(dynamic_unit_spawning, i)
					else
						_update_lightning_fx(context.world, dynamic_unit_data)

						dynamic_unit_data.delayed_spawn_time = delayed_spawn_time - dt
					end
				end
			end
		else
			data.end_time = settings.end_time or 1
		end
	end,
	done = function (data, template, context)
		return data.done
	end,
	destroy = function (data, template, context)
		local settings = template.settings
		local spawner_manager = Managers.state.unit_spawner
		local dynamic_unit_spawning = data.dynamic_unit_spawning

		for _, dynamic_unit_data in ipairs(dynamic_unit_spawning) do
			_destroy_lightning_fx(context.world, dynamic_unit_data, settings, context.is_server)
		end

		local lightning_units = data.lightning_units

		if lightning_units then
			for i = 1, #lightning_units do
				local lightning_unit = lightning_units[i]

				if Unit.alive(lightning_unit) then
					spawner_manager:mark_for_deletion(lightning_unit)
				end
			end
		end
	end,
}

local lightning_strikes_looping_generic = {
	server_only = true,
	settings = nil,
	init = function (data, template, context, time_into_event)
		local settings = template.settings
		local random_strikes = settings.additional_random_strikes
		local t = FixedFrame.get_latest_fixed_time()

		data.lightning_configs = {}
		data.lightning_configs[1] = {
			lightning_strike_frequency = settings.lightning_strike_frequency,
			event_to_trigger = settings.event_to_trigger,
			trigger_t = t + settings.lightning_strike_frequency,
		}

		if random_strikes then
			data.lightning_configs[2] = {
				lightning_strike_frequency = random_strikes.lightning_strike_frequency,
				event_to_trigger = random_strikes.event_to_trigger,
				trigger_t = t + random_strikes.lightning_strike_frequency,
			}
		end
	end,
	update = function (data, template, context, dt, t)
		local settings = template.settings
		local should_run, storm_sfx_event = _update_storm_state(data, settings)

		if context.is_server and storm_sfx_event then
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:trigger_wwise_event(storm_sfx_event)
		end

		if not should_run then
			return
		end

		for i = 1, #data.lightning_configs do
			local config = data.lightning_configs[i]

			if t > config.trigger_t then
				config.trigger_t = t + config.lightning_strike_frequency

				Managers.event:trigger("event_expedition_start_event", config.event_to_trigger)
			end
		end
	end,
	done = function (data, template, context, dt, t)
		return false
	end,
	destroy = function (data, template, context)
		return
	end,
}

local function _add_new_lightning_event(new_event_name, base_event_name)
	local new_event = table.clone(lightning_strikes_looping_generic)

	new_event.settings = ExpeditionEventSettings[new_event_name]
	expedition_event_templates[new_event_name] = new_event
end

_add_new_lightning_event("lightning_strikes_targeted_random_player_looping", "lightning_strikes_looping_generic")

return expedition_event_templates
