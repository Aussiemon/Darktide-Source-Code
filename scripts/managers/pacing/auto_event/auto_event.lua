-- chunkname: @scripts/managers/pacing/auto_event/auto_event.lua

local AutoEventsTemplates = require("scripts/managers/pacing/auto_event/templates/auto_event_templates")
local BreedQueries = require("scripts/utilities/breed_queries")
local LoadedDice = require("scripts/utilities/loaded_dice")
local NavQueries = require("scripts/utilities/nav_queries")
local PerceptionSettings = require("scripts/settings/perception/perception_settings")
local SpawnPointQueries = require("scripts/managers/main_path/utilities/spawn_point_queries")
local aggro_states = PerceptionSettings.aggro_states
local DEFAULT_PRE_STINGER_WWISE_EVENT = "wwise/events/minions/play_minion_horde_poxwalker_ambush_2d"
local DEFAULT_STINGER_WWISE_EVENT = "wwise/events/minions/play_minion_horde_poxwalker_ambush_3d"
local AutoEvent = class("AutoEvent")
local DEFAULT_NUM_WAVES = 3
local MAX_SPAWN_LOCATIONS = 10
local CAPTAIN_BREEDS = {
	cultist = "cultist_captain",
	renegade = "renegade_captain",
}
local TWIN_BREEDS = {
	"renegade_twin_captain",
	"renegade_twin_captain_two",
}
local _get_valid_player_target

AutoEvent._request_event_table = function (self)
	local event_data = {}

	return event_data
end

AutoEvent.init = function (self, nav_world, world, side_id, target_side_id, template_name)
	self._active = false
	self._fx_system = Managers.state.extension:system("fx_system")
	self._group_system = Managers.state.extension:system("group_system")
	self._groups = {}
	self._max_spawn_locations = MAX_SPAWN_LOCATIONS
	self._minion_spawner_radius_checks = {
		20,
		30,
		35,
		40,
	}
	self._minion_occluded_radius_checks = {
		4,
		8,
		12,
		15,
	}
	self._update_frequency_group_check = 3
	self._nav_world = nav_world
	self._physics_world = World.physics_world(world)

	local side_system = Managers.state.extension:system("side_system")
	local side_names = side_system:side_names()
	local side_name = side_names[side_id]

	self._side_id, self._side_name, self._target_side_id = side_id, side_name, target_side_id
	self._side_system = side_system
	self._target_side_id = target_side_id
	template_name = template_name or "dummy_auto_event_template"
	self._template = AutoEventsTemplates[template_name]
	self._active_events = {}
end

AutoEvent.auto_event_active = function (self)
	if not self._num_active_events then
		return false
	end

	local is_active = self._num_active_events > 0

	return is_active
end

AutoEvent.swap_auto_event_template = function (self, template_name)
	self._template = AutoEventsTemplates[template_name]
end

AutoEvent.request_auto_event = function (self, params, debug_position)
	if not self._active_events[tostring(params.node_id)] then
		local param_table = self:_request_event_table()

		if debug_position then
			local ahead_unit, _ = Managers.state.main_path:ahead_unit(1)
			local ahead_position = POSITION_LOOKUP[ahead_unit]

			param_table.position = Vector3Box(ahead_position)
		else
			param_table.position = Vector3Box(params.worldposition)
		end

		local t = Managers.time:time("gameplay")
		local inital_cooldown_multiplier = 1
		local intial_cooldown_multiplier_value = params.intial_cooldown_multiplier_value

		if intial_cooldown_multiplier_value then
			if type(intial_cooldown_multiplier_value) == "string" then
				inital_cooldown_multiplier = self._template.inital_cooldown_types[intial_cooldown_multiplier_value]
			else
				inital_cooldown_multiplier = intial_cooldown_multiplier_value
			end
		end

		local waves_cooldown_by_resistance = Managers.state.difficulty:get_table_entry_by_resistance(self._template.waves_cooldown)
		local waves_cooldown = math.random(waves_cooldown_by_resistance[1], waves_cooldown_by_resistance[2])

		waves_cooldown = waves_cooldown * inital_cooldown_multiplier
		param_table.is_paused = false
		param_table.paused_check_t = 0
		param_table.wave_cooldown = waves_cooldown + t

		local pre_stinger_delay = waves_cooldown / 2 + t

		param_table.pre_stinger_delay = pre_stinger_delay
		param_table.groups = {}
		param_table.stop_requested = false
		param_table.waves_to_spawn = Managers.state.difficulty:get_table_entry_by_resistance(self._template.num_waves_by_resistance) or DEFAULT_NUM_WAVES
		param_table.tried_spawning_captain = false
		param_table.tried_spawning_monster = false
		param_table.tried_spawning_twin = false
		param_table.injection_spawn_table = {}
		param_table.last_special_injected_t = 0
		param_table.target_units = {}
		param_table.num_valid_targets = 0

		if self._template.optional_disallowed_positions then
			param_table.optional_disallowed_positions = {}
		end

		if params.level_reference and self._template.check_radius_to_players then
			param_table.level_reference = params.owning_level
		end

		local allowed_composition_types = self._template.composition
		local composition_type = params.composition_type

		if allowed_composition_types[composition_type] then
			param_table.composition_type = composition_type
		else
			param_table.composition_type = "default"
		end

		local allowed_size_types = self._template.size_multipliers
		local auto_event_size = params.size

		if allowed_size_types[auto_event_size] then
			param_table.size_multiplier = allowed_size_types[auto_event_size]
			param_table.size_name = auto_event_size
		else
			param_table.size_multiplier = allowed_size_types.default
			param_table.size_name = "default"
		end

		local should_force_inject_captain = params.inject_captain

		if should_force_inject_captain then
			param_table.should_force_inject_captain = should_force_inject_captain
		end

		local should_force_inject_monster = params.inject_monster

		if should_force_inject_monster then
			param_table.should_force_inject_monster = should_force_inject_monster
		end

		local should_force_inject_twin = params.inject_twin

		if should_force_inject_twin then
			param_table.should_force_inject_twin = should_force_inject_twin
		end

		local uuid = tostring(params.node_id)

		param_table.uuid = uuid
		self._active_events[uuid] = param_table

		return uuid
	elseif self._active_events[tostring(params.node_id)] then
		local event_data = self._active_events[tostring(params.node_id)]

		event_data.stop_requested = false

		return event_data.uuid
	end
end

AutoEvent.request_auto_event_end = function (self, uuid)
	if self._active_events[uuid] then
		local event_data = self._active_events[uuid]

		event_data.stop_requested = true
	end
end

AutoEvent.get_auto_event_data = function (self, uuid)
	return self._active_events[uuid]
end

AutoEvent.remove_all_active_events = function (self)
	for uuid, data in pairs(self._active_events) do
		data.stop_requested = true
	end
end

AutoEvent.highlight_remaining_enemies = function (self, uuid)
	if self._active_events[uuid] then
		local event_data = self._active_events[uuid]

		event_data.highlight_requested = true
	end
end

AutoEvent._highlight = function (self, data)
	for i = 1, #data.groups do
		local current_group_id = data.groups[i]
		local group = self._group_system:group_from_id(current_group_id)
		local current_member_unit = group.members[i]
		local outline_system = Managers.state.extension:system("outline_system")
		local has_outline = outline_system:has_outline(current_member_unit, "hordes_tagged_remaining_target")

		if not has_outline then
			outline_system:add_outline(current_member_unit, "hordes_tagged_remaining_target")
		end
	end
end

AutoEvent.kill_remaining_enemies = function (self, uuid)
	if self._active_events[uuid] then
		local event_data = self._active_events[uuid]

		event_data.kill_order_requested = true
	end
end

AutoEvent.update_auto_event_frame_tables = function (self)
	for uuid, data in pairs(self._active_events) do
		if self._template.check_radius_to_players then
			self:_check_players_in_radius(uuid, data)
		end
	end
end

AutoEvent.remove_unit_from_auto_event_frame_tables = function (self, unit)
	for uuid, data in pairs(self._active_events) do
		local target_units = data.target_units
		local idx = target_units[unit]

		if idx then
			local last_idx = #target_units
			local last_unit = target_units[last_idx]

			target_units[idx] = last_unit
			target_units[last_unit] = idx
			target_units[last_idx] = nil
			target_units[unit] = nil
		end
	end
end

local SUCCESS_SPECIAL_COOLDOWN_TIME = {
	15,
	25,
}
local FAILED_SPECIAL_COOLDOWN_TIME = {
	5,
	10,
}

AutoEvent._try_inject_special = function (self, event_data, t)
	local template = self._template
	local special_config = template.special_config

	if special_config then
		local success_cooldown = Managers.state.difficulty:get_table_entry_by_resistance(special_config.success_cooldown) or SUCCESS_SPECIAL_COOLDOWN_TIME
		local failed_cooldown = Managers.state.difficulty:get_table_entry_by_resistance(special_config.failed_cooldown) or FAILED_SPECIAL_COOLDOWN_TIME
		local last_special_injected_t = event_data.last_special_injected_t
		local chance_for_special_injection = Managers.state.difficulty:get_table_entry_by_resistance(special_config.chance_for_special_injection)
		local game_mode_name = Managers.state.game_mode:game_mode_name()

		if game_mode_name == "expedition" then
			local num_specials_allowed = math.round(Managers.state.pacing:max_num_specials() / self._num_active_events)
			local currently_spawned_by_event = Managers.state.pacing:get_num_specials_owned_by_auto_event(event_data.uuid)

			if num_specials_allowed <= currently_spawned_by_event then
				return
			end
		end

		if chance_for_special_injection >= math.random() and last_special_injected_t <= t then
			local breeds = special_config.breeds
			local breed_name = breeds[math.random(1, #breeds)]
			local target_unit = _get_valid_player_target(event_data.position)
			local success = Managers.state.pacing:try_inject_special(breed_name, nil, target_unit, nil, nil, nil, nil, event_data.uuid)
			local cooldown

			if success then
				cooldown = math.random(success_cooldown[1], success_cooldown[2])
			else
				cooldown = math.random(failed_cooldown[1], failed_cooldown[2])
			end

			event_data.last_special_injected_t = cooldown + t
		end
	end
end

AutoEvent._kill_remaining_enemies = function (self, data, t)
	for i = 1, #data.groups do
		local current_group_id = data.groups[i]
		local group = self._group_system:group_from_id(current_group_id)

		for j = 1, #group.members do
			local current_member_unit = group.members[j]
			local has_buff_extension = ScriptUnit.has_extension(current_member_unit, "buff_system")

			if has_buff_extension then
				local buff_extension = ScriptUnit.has_extension(current_member_unit, "buff_system")

				if not buff_extension:has_keyword("burning") then
					buff_extension:add_internally_controlled_buff("hit_by_common_enemy_flame_no_duration", t)
					buff_extension:_update_stat_buffs_and_keywords(t)
				end
			end
		end
	end
end

AutoEvent._check_num_events = function (self)
	self._num_active_events = 0

	for uuid, data in pairs(self._active_events) do
		if not data.stop_requested or not data.is_paused then
			self._num_active_events = self._num_active_events + 1
		end
	end
end

local RADIUS_BY_LEVEL_TAG = {
	level_size_16 = 8,
	level_size_32 = 16,
	level_size_48 = 24,
	level_size_64 = 32,
}
local MARGIN_BY_LEVEL_TAG = {
	level_size_16 = 10,
	level_size_32 = 10,
	level_size_48 = 10,
	level_size_64 = 10,
}

AutoEvent._get_first_available_radius_by_tags = function (self, tags)
	for _, tag in ipairs(tags) do
		local radius, margin = RADIUS_BY_LEVEL_TAG[tag], MARGIN_BY_LEVEL_TAG[tag]

		if radius then
			return radius, margin
		end
	end
end

AutoEvent._check_players_in_radius = function (self, uuid, data)
	table.clear(data.target_units)

	local level_reference = data.level_reference
	local tags, position

	if level_reference then
		local game_mode_manager = Managers.state.game_mode
		local game_mode = game_mode_manager:game_mode()
		local level_data = game_mode:get_level_data(data.level_reference)

		position = level_data.position:unbox()
		tags = level_data.tags
	else
		position = data.position:unbox()
	end

	local radius, margin

	if tags then
		radius, margin = self:_get_first_available_radius_by_tags(tags)
	else
		radius, margin = RADIUS_BY_LEVEL_TAG.level_size_32, MARGIN_BY_LEVEL_TAG.level_size_32
	end

	local side = self._side_system:get_side(self._side_id)
	local ai_target_units = side.ai_target_units
	local num_ai_target_units = #ai_target_units
	local num_valid = 0

	for i = 1, num_ai_target_units do
		local target_unit = ai_target_units[i]
		local player_position = POSITION_LOOKUP[target_unit]
		local flattened_player_position = Vector3(player_position.x, player_position.y, 0)
		local flattened_level_position = Vector3(position.x, position.y, 0)
		local distance = Vector3.distance(flattened_level_position, flattened_player_position)

		if distance < radius + margin and HEALTH_ALIVE[target_unit] then
			num_valid = num_valid + 1
			data.target_units[target_unit] = num_valid
			data.target_units[num_valid] = target_unit
		end
	end

	data.num_valid_targets = num_valid
end

AutoEvent.get_all_valid_units_in_event = function (self, uuid)
	local active_event = self._active_events[uuid]

	if active_event then
		return active_event.target_units, active_event.num_valid_targets
	else
		return nil
	end
end

AutoEvent._try_aggro_nearby_groups = function (self, data)
	local groups = data.groups

	for i = 1, #groups do
		local group_id = groups[i]
		local group_position = self._group_system:group_position(group_id)

		if group_position then
			Managers.state.pacing:aggro_all_within_radius(group_position, 10)
		end
	end
end

local FORCE_SKIP_CURRENT_WAVE_TIMING = 35
local MINIUM_AMOUNT_OF_ENEMIES_REQUIRED = 10
local DEFAULT_TOTAL_MINIONS_ALLOWED_HARDLIMIT = 165
local DEFAULT_TOTAL_MINIONS_ALLOWED_BEFORE_CUTOFF = 125
local PAUSE_TRICKLE_TIME = 5

AutoEvent.update = function (self, dt, t)
	self:_check_num_events()

	local total_minions_spawned_stop_threshold = DEFAULT_TOTAL_MINIONS_ALLOWED_HARDLIMIT
	local total_minions_spawned = Managers.state.minion_spawn:num_spawned_minions()
	local active_events = self._active_events

	for uuid, data in pairs(active_events) do
		if self._template.optional_aggro_all_within_range then
			self:_try_aggro_nearby_groups(data)
		end

		if self._template.check_radius_to_players and data.is_paused and t > data.paused_check_t then
			if data.num_valid_targets > 0 then
				data.is_paused = false
			else
				data.paused_check_t = data.paused_check_t + 1
			end
		end

		if t > data.pre_stinger_delay and not data.pre_stinger_played then
			data.pre_stinger_played = true

			local optional_ambisonics = true
			local pre_stinger = DEFAULT_PRE_STINGER_WWISE_EVENT
			local stinger_settings = self._template.stingers

			if stinger_settings and stinger_settings.pre_stingers then
				pre_stinger = stinger_settings.pre_stingers[data.size_name]
			end

			self._fx_system:trigger_wwise_event(pre_stinger, nil, nil, nil, nil, nil, optional_ambisonics)
		end

		if total_minions_spawned_stop_threshold <= total_minions_spawned then
			if t > data.wave_cooldown then
				data.wave_cooldown = t + PAUSE_TRICKLE_TIME
			end

			return
		end

		if t > data.wave_cooldown and data.waves_to_spawn >= 1 then
			if not data.stinger_played then
				data.stinger_played = true

				local stinger = DEFAULT_STINGER_WWISE_EVENT
				local stinger_settings = self._template.stingers

				if stinger_settings and stinger_settings.stingers then
					stinger = stinger_settings.stingers[data.size_name]
				end

				self._fx_system:trigger_wwise_event(stinger, data.position:unbox(), nil, nil, nil, nil, nil)
			end

			if not data.primary_wave_event_sent then
				data.primary_wave_event_sent = true

				Managers.event:trigger("auto_event_primary_wave_triggered")
			end

			local should_pause_pacing = self._template.pause_pacing_on_event

			if should_pause_pacing and not data.pacing_paused and self._num_active_events == 1 then
				data.pacing_paused = true

				for spawn_type, pause_duration_table in pairs(should_pause_pacing) do
					local pause_duration

					if pause_duration_table then
						pause_duration = Managers.state.difficulty:get_table_entry_by_resistance(pause_duration_table)
					end

					Managers.state.pacing:pause_spawn_type(spawn_type, true, "paused_by_auto_event", pause_duration)
				end
			end

			local nav_world = self._nav_world
			local physics_world = self._physics_world
			local side_system = Managers.state.extension:system("side_system")
			local side, target_side = side_system:get_side(self._side_id), side_system:get_side(self._target_side_id)

			self:execute(physics_world, nav_world, side, target_side, data.position:unbox(), data)

			local waves_cooldown_by_resistance = Managers.state.difficulty:get_table_entry_by_resistance(self._template.waves_cooldown)
			local waves_cooldown = math.random(waves_cooldown_by_resistance[1], waves_cooldown_by_resistance[2])

			data.wave_cooldown = waves_cooldown + t
			data.waves_to_spawn = data.waves_to_spawn - 1

			self:_try_inject_special(data, t)
		end

		if data.waves_to_spawn == 0 and data.frame_skipped then
			self:_try_inject_special(data, t)

			for i = 1, #data.groups do
				local current_group_id = data.groups[i]
				local group = self._group_system:group_from_id(current_group_id)

				if group and #group.members == 0 or not group then
					table.remove(data.groups, i)
				end
			end

			local current_groups = #data.groups

			if data.highlight_requested then
				self:_highlight(data)

				data.highlight_requested = false
			end

			if data.kill_order_requested then
				self:_kill_remaining_enemies(data, t)

				data.kill_order_requested = false
			end

			local force_next_wave = self:_forced_wave_check(data, t)

			if current_groups == 0 or force_next_wave then
				if data.stop_requested then
					local should_pause_pacing = self._template.pause_pacing_on_event

					if should_pause_pacing and self._num_active_events == 1 then
						for spawn_type, pause_duration_table in pairs(should_pause_pacing) do
							Managers.state.pacing:pause_spawn_type(spawn_type, false, "paused_by_auto_event", nil)
						end
					end

					self._active_events[data.uuid] = nil
				elseif not self._template.check_radius_to_players or self._template.check_radius_to_players and data.num_valid_targets > 0 then
					local cooldown_by_resistance = Managers.state.difficulty:get_table_entry_by_resistance(self._template.cooldown)
					local first_wave_cooldown = math.random(cooldown_by_resistance[1], cooldown_by_resistance[2])
					local pre_stinger_delay = first_wave_cooldown / 2 + t

					data.pre_stinger_delay = pre_stinger_delay
					data.wave_cooldown = first_wave_cooldown + t
					data.waves_to_spawn = Managers.state.difficulty:get_table_entry_by_resistance(self._template.num_waves_by_resistance) or DEFAULT_NUM_WAVES
					data.pre_stinger_played = nil
					data.stinger_played = false
					data.primary_wave_event_sent = false
					data.frame_skipped = nil
				elseif self._template.check_radius_to_players and data.num_valid_targets < 1 then
					data.is_paused = true
					data.paused_check_t = t + 1
				end
			end
		end

		if data.waves_to_spawn == 0 and not data.frame_skipped then
			data.frame_skipped = true
			data.force_skip_time = FORCE_SKIP_CURRENT_WAVE_TIMING + t
		end
	end
end

AutoEvent._forced_wave_check = function (self, data, t)
	local should_force_check = true

	if t < data.force_skip_time then
		should_force_check = false

		return should_force_check
	end

	local total_alive = 0

	for i = 1, #data.groups do
		local current_group_id = data.groups[i]
		local group = self._group_system:group_from_id(current_group_id)

		if group then
			local alive_members = #group.members or 0

			total_alive = total_alive + alive_members
		end
	end

	data.total_alive = total_alive

	if total_alive < MINIUM_AMOUNT_OF_ENEMIES_REQUIRED then
		return should_force_check
	else
		should_force_check = false

		return should_force_check
	end
end

AutoEvent.has_active_event = function (self)
	return self._is_currently_running
end

local breeds_to_spawn = {}
local SPAWN_SIDE_NAME = "villains"

AutoEvent._compose_spawn_list = function (self, event_data)
	local composition = {
		breeds = {},
	}
	local breed_packs = {}
	local template = self._template
	local template_compositions = template.composition
	local choosen_composition = template_compositions[event_data.composition_type]
	local total_minions_spawned = Managers.state.minion_spawn:num_spawned_minions()
	local total_minions_allowed_before_reduction = DEFAULT_TOTAL_MINIONS_ALLOWED_BEFORE_CUTOFF
	local points_base = template.points_base
	local resistance_multiplier = template.resistance_multiplier
	local point_pool

	if total_minions_allowed_before_reduction < total_minions_spawned then
		point_pool = template.conditional_function(points_base) * 0.5 / self._num_active_events
	else
		point_pool = template.conditional_function(points_base)
	end

	local multiplier = Managers.state.difficulty:get_table_entry_by_resistance(resistance_multiplier)
	local event_size = event_data.size_multiplier

	point_pool = math.round(point_pool * event_size * multiplier)

	local point_pool_length = point_pool

	for i = 1, #choosen_composition.breeds do
		local data = choosen_composition.breeds[i]
		local weight = Managers.state.difficulty:get_table_entry_by_resistance(data.weights)

		breed_packs[i] = template.conditional_function(weight)
	end

	local prob, alias = LoadedDice.create(breed_packs, false)
	local probabilities = {
		prob = prob,
		alias = alias,
	}

	for i = 1, point_pool_length do
		local choosen_type = LoadedDice.roll(probabilities.prob, probabilities.alias)
		local data = choosen_composition.breeds[choosen_type]

		data.points = data.points + 1
		point_pool = point_pool - 1
	end

	for i = 1, #choosen_composition.breeds do
		local breed_tags = choosen_composition.breeds[i].breed_tags
		local points = choosen_composition.breeds[i].points
		local excluded_breed_tags = choosen_composition.breeds[i].excluded_breed_tags
		local wanted_sub_faction = Managers.state.pacing:current_faction(SPAWN_SIDE_NAME)
		local breed_pool = BreedQueries.match_minions_by_tags(breed_tags, excluded_breed_tags, wanted_sub_faction)
		local breed, breed_amount = BreedQueries.pick_random_minion_by_points(breed_pool, points)

		if not breed then
			local game_mode_settings = Managers.state.game_mode:settings()
			local side_sub_faction_types = game_mode_settings.side_sub_faction_types
			local sub_faction_types = side_sub_faction_types[SPAWN_SIDE_NAME]

			for ii = 1, #sub_faction_types do
				local sub_faction = sub_faction_types[ii]

				if sub_faction ~= wanted_sub_faction then
					breed_pool = BreedQueries.match_minions_by_tags(breed_tags, excluded_breed_tags, sub_faction)
					breed, breed_amount = BreedQueries.pick_random_minion_by_points(breed_pool, points)

					if breed then
						break
					end
				end
			end
		end

		if breed then
			composition.breeds[#composition.breeds + 1] = {
				name = breed.name,
				amount = breed_amount,
			}
		end

		local data = choosen_composition.breeds[i]

		data.points = 0
	end

	table.clear_array(breeds_to_spawn, #breeds_to_spawn)

	local breeds = composition.breeds

	for i = 1, #breeds do
		local breed_data = breeds[i]
		local breed_name, amount = breed_data.name, breed_data.amount
		local num_to_spawn = amount

		for j = 1, num_to_spawn do
			breeds_to_spawn[#breeds_to_spawn + 1] = breed_name
		end
	end

	table.shuffle(breeds_to_spawn)

	return breeds_to_spawn, #breeds_to_spawn
end

AutoEvent._check_for_injection_spawn = function (self, event_data, nearby_spawners, nearby_occluded_positions, group_id, target_side_id, side_id)
	local template = self._template
	local captains_settings = template.captains_settings
	local require_toughness_setup

	if captains_settings and not event_data.tried_spawning_captain then
		local should_force_inject_captain = event_data.should_force_inject_captain
		local should_inject_captain = self._template.captains_settings.execute(should_force_inject_captain)

		if should_inject_captain then
			local current_faction = Managers.state.pacing:current_faction()
			local correct_captain = CAPTAIN_BREEDS[current_faction]

			event_data.injection_spawn_table[#event_data.injection_spawn_table + 1] = correct_captain

			Managers.event:trigger("coordinated_horde_spawned", "elite_captain_ambush")
		end

		event_data.tried_spawning_captain = true
	end

	local monster_settings = template.monster_settings

	if monster_settings and not event_data.tried_spawning_monster then
		local monster_breeds = self._template.monster_settings.monster_breeds
		local should_force_inject_monster = event_data.should_force_inject_monster
		local should_inject_monster = self._template.captains_settings.execute(should_force_inject_monster)

		if should_inject_monster then
			event_data.injection_spawn_table[#event_data.injection_spawn_table + 1] = monster_breeds[math.random(1, #monster_breeds)]
		end

		event_data.tried_spawning_monster = true
	end

	local twins_settings = template.twins_settings

	if twins_settings and not event_data.tried_spawning_twin then
		local should_force_inject_twin = event_data.should_force_inject_twin
		local should_inject_twins, num_twins = self._template.captains_settings.execute(should_force_inject_twin)

		if should_inject_twins then
			if num_twins == 1 then
				event_data.injection_spawn_table[#event_data.injection_spawn_table + 1] = TWIN_BREEDS[math.random(1, #TWIN_BREEDS)]
			else
				for i = 1, num_twins do
					event_data.injection_spawn_table[#event_data.injection_spawn_table + 1] = TWIN_BREEDS[i]
				end
			end
		end

		event_data.tried_spawning_twin = true
		require_toughness_setup = true
	end

	local injection_spawn_length = #event_data.injection_spawn_table

	if injection_spawn_length > 0 then
		local success = false
		local owning_auto_event_id

		if self._template.check_radius_to_players then
			owning_auto_event_id = event_data.uuid
		end

		local valid_spawners = {}

		for i = 1, #nearby_spawners do
			local current_spawner = nearby_spawners[i]

			if current_spawner._spawn_type == "default" then
				valid_spawners[#valid_spawners + 1] = current_spawner
			end
		end

		if #valid_spawners > 0 then
			local breed_list = {}
			local chosen_spawner = valid_spawners[math.random(1, #valid_spawners)]

			for ii = 1, injection_spawn_length do
				breed_list[#breed_list + 1] = event_data.injection_spawn_table[ii]
			end

			local param_table = chosen_spawner:request_param_table()

			param_table.target_side_id = target_side_id
			param_table.group_id = group_id

			if require_toughness_setup then
				param_table.optional_init_toughness = true
			end

			param_table.optional_owning_auto_event_id = owning_auto_event_id

			chosen_spawner:add_spawns(breed_list, side_id, param_table)

			success = true
		end

		if not success then
			for ii = 1, injection_spawn_length do
				local spawn_position = nearby_occluded_positions[math.random(1, #nearby_occluded_positions)]
				local minion_spawn_manager = Managers.state.minion_spawn
				local spawn_rotation = Quaternion.identity()

				if spawn_position then
					local breed_name = event_data.injection_spawn_table[ii]
					local queue_parameters = minion_spawn_manager:queue_minion_to_spawn(breed_name, spawn_position, spawn_rotation, side_id)

					queue_parameters.optional_aggro_state = aggro_states.aggroed
					queue_parameters.optional_group_id = group_id
					queue_parameters.optional_owning_auto_event_id = owning_auto_event_id

					if require_toughness_setup then
						queue_parameters.optional_init_toughness = true
					end
				end
			end
		end
	end

	table.clear(event_data.injection_spawn_table)
end

local MIN_DISTANCE_FROM_PLAYERS, MAX_DISTANCE_FROM_PLAYERS = 10, 60
local INITIAL_GROUP_OFFSET = 1
local nearby_spawners, nearby_occluded_positions = {}, {}

AutoEvent.execute = function (self, physics_world, nav_world, side, target_side, position, event_data)
	local target_side_id = target_side.side_id
	local side_id = side.side_id
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(target_side_id)

	if not ahead_travel_distance then
		Log.info("Auto Event", "Couldn't find a ahead unit, failing horde.")

		return
	end

	local nav_spawn_points = main_path_manager:nav_spawn_points()
	local num_groups = GwNavSpawnPoints.get_count(nav_spawn_points)
	local minion_spawner_radius_checks = self._minion_spawner_radius_checks
	local minion_occluded_radius_checks = self._minion_occluded_radius_checks
	local max_spawn_locations = self._max_spawn_locations
	local navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, position, 1, 1, 3, 5)

	if not navmesh_position then
		local closest_player_position, closest_distance_sq = nil, math.huge
		local Vector3_distance_squared = Vector3.distance_squared
		local player_positons = side.valid_enemy_player_units_positions
		local num_player_positons = #player_positons

		for j = 1, num_player_positons do
			local current_player_position = player_positons[j]
			local sqr_distance = Vector3_distance_squared(position, current_player_position)

			if sqr_distance < closest_distance_sq then
				closest_player_position, closest_distance_sq = current_player_position, sqr_distance
			end
		end

		navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, closest_player_position, 1, 1, 3, 5)

		if not navmesh_position then
			Log.info("Auto Event", "No valid navmesh postion found at specified position")

			return
		end
	end

	local spawn_list, num_to_spawn = self:_compose_spawn_list(event_data)
	local horde = {
		side = side,
		target_side = target_side,
	}

	table.clear(nearby_spawners)
	table.clear(nearby_occluded_positions)

	local num_spawn_locations = 0
	local minion_spawn_system = Managers.state.extension:system("minion_spawner_system")

	for i = 1, #minion_spawner_radius_checks do
		local radius = minion_spawner_radius_checks[i]
		local spawners = minion_spawn_system:spawners_in_range(navmesh_position, radius)

		if spawners then
			for j = 1, #spawners do
				nearby_spawners[#nearby_spawners + 1] = spawners[j]
				num_spawn_locations = num_spawn_locations + 1
			end

			if max_spawn_locations <= num_spawn_locations then
				break
			end
		end
	end

	local optional_disallowed_positions = event_data.optional_disallowed_positions

	if num_spawn_locations < max_spawn_locations then
		local spawn_locations_left = max_spawn_locations - num_spawn_locations

		for i = 1, #minion_occluded_radius_checks do
			local radius = minion_occluded_radius_checks[i]
			local occluded_positions, num_occluded_positions = SpawnPointQueries.get_occluded_positions(nav_world, nav_spawn_points, navmesh_position, side.valid_enemy_player_units_positions, radius, num_groups, MIN_DISTANCE_FROM_PLAYERS, MAX_DISTANCE_FROM_PLAYERS, INITIAL_GROUP_OFFSET, optional_disallowed_positions)

			if occluded_positions then
				if optional_disallowed_positions then
					table.clear(optional_disallowed_positions)

					for ii = 1, num_occluded_positions do
						optional_disallowed_positions[#optional_disallowed_positions + 1] = Vector3Box(occluded_positions[ii])
					end
				end

				for j = 1, num_occluded_positions do
					local occluded_position = occluded_positions[j]

					nearby_occluded_positions[#nearby_occluded_positions + 1] = occluded_position
					spawn_locations_left = spawn_locations_left - 1
					num_spawn_locations = math.min(num_spawn_locations + 1, max_spawn_locations)

					if spawn_locations_left == 0 then
						break
					end
				end
			end
		end
	end

	if num_spawn_locations == 0 then
		Log.info("Auto Event", "\t\t for ambush horde! Failed")

		return
	end

	local group_system = Managers.state.extension:system("group_system")
	local group_id = group_system:generate_group_id()

	event_data.groups[#event_data.groups + 1] = group_id

	local owning_auto_event_id

	if self._template.check_radius_to_players then
		owning_auto_event_id = event_data.uuid
	end

	local num_spawned = 0

	if num_spawn_locations <= num_to_spawn then
		local spawns_per_location = math.floor(num_to_spawn / num_spawn_locations)

		for i = 1, #nearby_spawners do
			local spawner = nearby_spawners[i]
			local breed_list = {}

			for j = 1, spawns_per_location do
				local breed_name = spawn_list[num_spawned + 1]

				num_spawned = num_spawned + 1
				breed_list[#breed_list + 1] = breed_name
			end

			local param_table = spawner:request_param_table()

			param_table.target_side_id = target_side_id
			param_table.group_id = group_id
			param_table.optional_owning_auto_event_id = owning_auto_event_id

			spawner:add_spawns(breed_list, side_id, param_table)
		end
	end

	local spawns_left = num_to_spawn - num_spawned

	if spawns_left > 0 and #nearby_occluded_positions > 0 then
		local spawn_rotation = Quaternion.identity()
		local minion_spawn_manager = Managers.state.minion_spawn

		for i = 1, spawns_left do
			local spawn_position = nearby_occluded_positions[math.random(1, #nearby_occluded_positions)]

			if spawn_position then
				local breed_name = spawn_list[i]
				local queue_parameters = minion_spawn_manager:queue_minion_to_spawn(breed_name, spawn_position, spawn_rotation, side_id)

				queue_parameters.optional_aggro_state = aggro_states.aggroed
				queue_parameters.optional_group_id = group_id
				queue_parameters.optional_owning_auto_event_id = owning_auto_event_id
				num_spawned = num_spawned + 1
			end
		end
	end

	self:_check_for_injection_spawn(event_data, nearby_spawners, nearby_occluded_positions, group_id, target_side_id, side_id)
	Log.info("Auto Event", "Managed to spawn %d/%d horde enemies.", num_spawned, num_to_spawn)

	return horde, navmesh_position
end

function _get_valid_player_target(position)
	local side_system = Managers.state.extension:system("side_system")
	local side_name = side_system:get_default_player_side_name()
	local side = side_system:get_side_from_name(side_name)
	local valid_player_units = side.valid_player_units
	local target_position = position:unbox()
	local distance_to_all_players = {}

	for i = 1, #valid_player_units do
		local target_unit = valid_player_units[i]
		local player_position = POSITION_LOOKUP[target_unit]
		local distance_to_target_sq = Vector3.distance_squared(target_position, player_position)

		distance_to_all_players[i] = {
			distance_to_target_sq,
			target_unit,
		}
	end

	local min = 0
	local target_player

	for i = 1, #distance_to_all_players do
		local player_data = distance_to_all_players[i]
		local player_distance_sq = player_data[1]
		local player_unit = player_data[2]

		if min < player_distance_sq and min then
			min = player_distance_sq
			target_player = player_unit
		end
	end

	return target_player
end

return AutoEvent
