-- chunkname: @scripts/managers/pacing/heat_pacing/heat_pacing.lua

local LoadedDice = require("scripts/utilities/loaded_dice")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local HeatPacing = class("HeatPacing")

HeatPacing.init = function (self, template, world, side_id, target_side_id)
	self._template = template
	self._world = world
	self._heat = 0
	self._picked_up_units = {}
	self._heat_drop_override = {}
	self._player_heat = {}
	self._last_special_injected_t = 0
	self._extraction_started = false
	self._frozen = 0
	self._frozen_staged_heat = 0

	local side_system = Managers.state.extension:system("side_system")
	local side_names = side_system:side_names()
	local side_name = side_names[side_id]

	self._side_id, self._side_name, self._target_side_id = side_id, side_name, target_side_id
	self._side_system = side_system

	if template.heat_settings then
		self._active = true
	end

	self._queued_vo = {}
	self._vo_interval = 5
end

HeatPacing.on_gameplay_post_init = function (self)
	if not self:active() then
		return
	end

	local template = self._template
	local heat_settings = template.heat_settings
	local max_heat = Managers.state.difficulty:get_table_entry_by_challenge(heat_settings.max_heat)

	self._max_heat = max_heat

	local heat_stages = Managers.state.difficulty:get_table_entry_by_challenge(heat_settings.heat_stages)

	self._heat_stages = heat_stages

	local heat_starting_stage = heat_settings.heat_starting_stage

	self._heat_starting_stage = heat_starting_stage
	self._current_stage_name = heat_starting_stage

	local current_stage_settings = self._heat_stages[self._heat_starting_stage]

	self._current_stage_settings = current_stage_settings

	local heat_stage_switch_order = heat_settings.heat_stage_orders[self._heat_starting_stage]

	self._heat_stage_switch_order = heat_stage_switch_order
	self._heat_stage_orders = heat_settings.heat_stage_orders

	local next_stage_name = self._heat_stage_switch_order.next_stage
	local next_stage_heat_settings = {
		next_stage = next_stage_name,
		threshold = self._heat_stages[next_stage_name].threshold,
	}

	self._next_stage_heat_settings = next_stage_heat_settings

	local default_heat_decay_rate = Managers.state.difficulty:get_table_entry_by_challenge(heat_settings.heat_decay_rate)

	self._default_heat_decay_rate = default_heat_decay_rate

	local default_player_heat_decay_rate = Managers.state.difficulty:get_table_entry_by_challenge(heat_settings.player_heat_decay_rate)

	self._default_player_heat_decay_rate = default_player_heat_decay_rate

	local lowest_decay_allowed = Managers.state.difficulty:get_table_entry_by_challenge(heat_settings.lowest_decay_allowed)

	self._lowest_decay_allowed = lowest_decay_allowed

	local heat_decay_update_frequency = heat_settings.heat_decay_update_frequency

	self._heat_decay_update_frequency = heat_decay_update_frequency

	local heat_lookups = heat_settings.heat_lookups

	self._heat_lookups = heat_lookups
	self._heat_stage_index = heat_settings.stage_index
	self._required_time_at_stage = 0
	self._heat_multiplier = heat_settings.heat_multiplier
	self._allowed_heat_generating_spawn_types = heat_settings.allowed_heat_generating_spawn_types
	self._trickle_horde_patrol_settings = heat_settings.trickle_patrol_settings

	self:set_trickle_horde_modifers()
	Managers.state.pacing:set_horde_pacing_rate_modifier(self._current_stage_settings.horde_rate_multiplier)
	Managers.state.pacing:set_horde_pacing_timer_modifier(self._current_stage_settings.horde_timer_multiplier)
	Managers.state.pacing:update_only_injected_slots(true)
	Managers.event:register(self, "monster_spawned", "_vo_monster_spawned")
	Managers.event:register(self, "trickle_horde_spawned", "_vo_trickle_horde_spawned")
	Managers.event:register(self, "horde_spawned", "_vo_horde_spawned")
	Managers.event:register(self, "coordinated_horde_spawned", "_vo_coordinated_horde_spawned")
	Managers.event:register(self, "loner_prevention_spawned", "_vo_loner_prevention")
	Managers.event:register(self, "in_safe_zone", "_vo_in_safe_zone")
	Managers.event:register(self, "left_safe_zone", "_vo_left_safe_zone")
	Managers.event:register(self, "expedition_extraction_music_trigger", "_expedition_extraction_started")
end

HeatPacing.active = function (self)
	return self._active
end

HeatPacing.update_paused = function (self, should_pause)
	self._heat_update_paused = should_pause
end

HeatPacing.freeze = function (self, is_frozen, optional_frozen_time)
	self._frozen = is_frozen

	if optional_frozen_time then
		local t = Managers.time:time("gameplay")

		self._frozen_delay = t + optional_frozen_time
	end
end

local player_over_special_threshold = {}
local SUCCESS_SPECIAL_COOLDOWN_TIME = {
	25,
	35,
}
local FAILED_SPECIAL_COOLDOWN_TIME = {
	5,
	10,
}

HeatPacing._update_player_heat = function (self, dt, t)
	local heat_decay_rate = self._modified_player_heat_decay_rate or self._default_player_heat_decay_rate
	local template = self._template
	local heat_settings = template.heat_settings
	local special_config = heat_settings.special_config
	local player_heat = self._player_heat
	local side = self._side_system:get_side(self._target_side_id)
	local valid_player_units = side.valid_player_units
	local num_valid_player_units = #valid_player_units

	table.clear(player_over_special_threshold)

	for i = 1, num_valid_player_units do
		local player_unit = valid_player_units[i]
		local heat = player_heat[player_unit] or 0
		local new_heat = math.max(heat - dt * heat_decay_rate, 0)

		player_heat[player_unit] = new_heat

		if special_config and new_heat > special_config.threshold then
			player_over_special_threshold[#player_over_special_threshold + 1] = player_unit
		end
	end

	local ALIVE = ALIVE

	for unit, _ in pairs(player_heat) do
		if not ALIVE[unit] then
			player_heat[unit] = nil
		end
	end

	if special_config and #player_over_special_threshold > 0 then
		self:_update_special_injection(special_config, t)
	end
end

HeatPacing._get_target_player_heat = function (self, target_unit)
	if self._player_heat[target_unit] then
		return self._player_heat[target_unit]
	end
end

HeatPacing._update_special_injection = function (self, special_config, t)
	if #player_over_special_threshold > 0 then
		local random = math.random(1, #player_over_special_threshold)
		local target_player = player_over_special_threshold[random]
		local last_special_injected_t = self._last_special_injected_t
		local chance_for_special_injection = Managers.state.difficulty:get_table_entry_by_resistance(special_config.chance_for_special_injection)

		if chance_for_special_injection >= math.random() and last_special_injected_t <= t and target_player then
			local breeds = special_config.breeds
			local breed_name = breeds[math.random(1, #breeds)]
			local success = Managers.state.pacing:try_inject_special(breed_name, nil, target_player, nil)
			local cooldown

			if success then
				cooldown = math.random(SUCCESS_SPECIAL_COOLDOWN_TIME[1], SUCCESS_SPECIAL_COOLDOWN_TIME[2])
			else
				cooldown = math.random(FAILED_SPECIAL_COOLDOWN_TIME[1], FAILED_SPECIAL_COOLDOWN_TIME[2])
			end

			self._last_special_injected_t = cooldown + t
		end
	end
end

HeatPacing.delete = function (self)
	Managers.event:unregister(self, "monster_spawned")
	Managers.event:unregister(self, "trickle_horde_spawned")
	Managers.event:unregister(self, "horde_spawned")
	Managers.event:unregister(self, "in_safe_zone")
	Managers.event:unregister(self, "left_safe_zone")
	Managers.event:unregister(self, "coordinated_horde_spawned")
	Managers.event:unregister(self, "loner_prevention_spawned")
	Managers.event:unregister(self, "expedition_extraction_music_trigger")
end

HeatPacing.get_all_valid_player_heats = function (self)
	local valid_targets = {}
	local has_valid_units = false

	for player, heat in pairs(self._player_heat) do
		local target_unit_data_extension = ScriptUnit.extension(player, "unit_data_system")
		local character_state_component = target_unit_data_extension:read_component("character_state")
		local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)
		local player_data = Managers.state.player_unit_spawn:owner(player)
		local is_bot = player_data and not player_data:is_human_controlled()

		if not HEALTH_ALIVE[player] and not is_disabled and not is_bot then
			return
		end

		valid_targets[player] = heat
		has_valid_units = true
	end

	return valid_targets, has_valid_units
end

local indexed_players = {
	player_lookup = {},
	player_weights = {},
}

HeatPacing.get_random_heat_generating_player = function (self)
	table.clear(indexed_players.player_lookup)
	table.clear(indexed_players.player_weights)

	local index = 0
	local valid_players, has_valid_units = self:get_all_valid_player_heats()

	if not has_valid_units then
		return
	end

	for player, heat in pairs(valid_players) do
		index = index + 1
		indexed_players.player_lookup[index] = player
		indexed_players.player_lookup[player] = index
		indexed_players.player_weights[index] = heat
	end

	local prob, alias = LoadedDice.create(indexed_players.player_weights, false)
	local probabilities = {
		prob = prob,
		alias = alias,
	}
	local choosen_index = LoadedDice.roll(probabilities.prob, probabilities.alias)
	local selected_player_unit = indexed_players.player_lookup[choosen_index]

	return selected_player_unit
end

HeatPacing.update = function (self, dt, t, side_id, target_side_id)
	if not self:active() then
		return
	end

	if self._heat_update_paused then
		return
	end

	local override_heat_drop = self._heat_drop_override[self:current_stage_name()]
	local current_stage_settings = self._current_stage_settings
	local allowed_to_drop_stage = override_heat_drop or current_stage_settings.allowed_to_drop_stage
	local required_time_at_stage = self._required_time_at_stage
	local heat = self._heat
	local heat_decay_rate = self._modified_heat_decay_rate or self._default_heat_decay_rate
	local auto_event_active = Managers.state.pacing:auto_event_active()

	if auto_event_active then
		heat_decay_rate = 0
	end

	local heat_delay_duration = self._heat_delay_duration
	local template = self._template
	local heat_settings = template.heat_settings

	if heat_settings.record_heat_generation_per_player then
		self:_update_player_heat(dt, t)
	end

	if required_time_at_stage < t then
		if not heat_delay_duration or heat_delay_duration and heat_delay_duration < t then
			local new_heat = math.clamp(heat - dt * heat_decay_rate, 0, self._max_heat)
			local stage_threshold = current_stage_settings.threshold

			if allowed_to_drop_stage then
				self._heat = new_heat
				self._is_decaying_heat = new_heat > 0 and heat_decay_rate ~= 0
			elseif not allowed_to_drop_stage and stage_threshold <= new_heat then
				self._heat = new_heat
				self._is_decaying_heat = new_heat > 0 and heat_decay_rate ~= 0
			end
		end

		self._is_decaying_heat = false
	else
		self._is_decaying_heat = false
	end

	local next_stage_heat_settings = self._next_stage_heat_settings
	local next_stage, back_stage, threshold = next_stage_heat_settings.next_stage, next_stage_heat_settings.back_stage, next_stage_heat_settings.threshold
	local current_stage_name = self:current_stage_name()

	if threshold <= heat and current_stage_name ~= next_stage then
		self:_change_heat_condition(next_stage)
		self:_trigger_vo("rise")
	end

	local stage_threshold = current_stage_settings.threshold

	if heat < stage_threshold and back_stage then
		self:_change_heat_condition(back_stage)
		self:_trigger_vo("drop")
	end

	if self._queued_vo.reason then
		self._vo_interval = self._vo_interval - dt

		if self._vo_interval < 0 then
			local success = self:_trigger_vo(self._queued_vo.reason, self._queued_vo.sub_type)

			self._vo_interval = 5

			if success then
				self._queued_vo.reason = nil
				self._queued_vo.sub_type = nil
			end
		end
	end
end

HeatPacing._change_heat_condition = function (self, stage_name)
	local new_stage_settings = self._heat_stages[stage_name]

	self._current_stage_settings = new_stage_settings
	self._heat_stage_switch_order = self._heat_stage_orders[stage_name]

	local heat_stage_switch_order = self._heat_stage_switch_order

	self._current_stage_name = stage_name

	if heat_stage_switch_order.back_stage then
		self._next_stage_heat_settings.back_stage = self._heat_stage_switch_order.back_stage
	else
		self._next_stage_heat_settings.back_stage = nil
	end

	if heat_stage_switch_order.next_stage then
		self._next_stage_heat_settings.next_stage = self._heat_stage_switch_order.next_stage
		self._next_stage_heat_settings.threshold = self._heat_stages[self._next_stage_heat_settings.next_stage].threshold
	end

	Managers.state.pacing:update_only_injected_slots(new_stage_settings.specials_use_full_update)
	Managers.state.pacing:set_horde_pacing_rate_modifier(self._current_stage_settings.horde_rate_multiplier)
	Managers.state.pacing:set_horde_pacing_timer_modifier(self._current_stage_settings.horde_timer_multiplier)
	self:set_trickle_horde_modifers()

	local t = Managers.time:time("gameplay")
	local required_time_at_stage = t + new_stage_settings.required_time_at_stage

	self._required_time_at_stage = required_time_at_stage
end

HeatPacing._add_heat_generating_player = function (self, heat, player_unit)
	local current_player_heat = self._player_heat[player_unit] or 0

	self._player_heat[player_unit] = math.min(current_player_heat + heat, self:max_heat())
end

HeatPacing.is_currently_decaying_heat = function (self)
	return self._is_decaying_heat
end

HeatPacing.heat = function (self)
	return self._heat
end

HeatPacing.heat_settings = function (self)
	return self._template.heat_settings
end

HeatPacing.max_heat = function (self)
	return self._max_heat
end

HeatPacing._expedition_extraction_started = function (self)
	self._extraction_started = true
end

HeatPacing.expedition_extraction_status = function (self)
	return self._extraction_started
end

HeatPacing.disable_heat_decay = function (self)
	local template = self._template
	local heat_settings = template.heat_settings

	return heat_settings.should_disable_heat_on_timer_elapse
end

HeatPacing.set_heat_decay_rate = function (self, new_decay_rate)
	if not self._modified_heat_decay_rate then
		self._modified_heat_decay_rate = new_decay_rate
	elseif self._modified_heat_decay_rate and not not new_decay_rate then
		self._modified_heat_decay_rate = nil
	end
end

HeatPacing.request_extraction_wait_time = function (self, extraction_type)
	local current_stage_settings = self._current_stage_settings
	local extraction_wait_timings = current_stage_settings.extraction_wait_timings
	local wait_timings = extraction_wait_timings[extraction_type]
	local wait_time = math.random(wait_timings[1], wait_timings[2])

	return wait_time
end

HeatPacing.heat_horde_allowance = function (self)
	return math.clamp(self._max_heat - self._heat, 0, self._max_heat)
end

HeatPacing.current_stage_name = function (self)
	return self._current_stage_name or "none"
end

HeatPacing.current_stage_settings = function (self)
	return self._current_stage_settings
end

HeatPacing.get_table_entry_by_heat_stage = function (self, t)
	local current_stage_name = self._current_stage_name
	local i = self._heat_stage_index[current_stage_name]

	return t[math.min(#t, i)]
end

HeatPacing.set_trickle_horde_modifers = function (self)
	local params = {}
	local template = self._template
	local current_stage_trickle_settings = self._current_stage_settings.trickle_horde_overrides

	if not current_stage_trickle_settings then
		Log.debug("HeatPacing", "No trickle horde overrides in pacing template")

		return
	end

	if not self._trickle_horde_default_settings then
		self._trickle_horde_default_settings = {}

		local horde_resistance_templates = template.horde_pacing_template.resistance_templates
		local horde_pacing_template = Managers.state.difficulty:get_table_entry_by_resistance(horde_resistance_templates)

		self._trickle_horde_default_settings.trickle_horde_travel_distance_range = horde_pacing_template.trickle_horde_travel_distance_range
		self._trickle_horde_default_settings.num_trickle_hordes_active_for_cooldown = horde_pacing_template.num_trickle_hordes_active_for_cooldown
		self._trickle_horde_default_settings.trickle_horde_cooldown = horde_pacing_template.trickle_horde_cooldown
	end

	local default_trickle_horde_travel_distance_range = self._trickle_horde_default_settings.trickle_horde_travel_distance_range
	local trickle_horde_travel_distance_modifer = current_stage_trickle_settings.trickle_horde_travel_distance_range
	local trickle_horde_travel_distance_range = {
		default_trickle_horde_travel_distance_range[1] * trickle_horde_travel_distance_modifer,
		default_trickle_horde_travel_distance_range[2] * trickle_horde_travel_distance_modifer,
	}

	params.travel_distance_modifer = trickle_horde_travel_distance_range

	local default_trickle_horde_travel_cooldown = self._trickle_horde_default_settings.trickle_horde_cooldown
	local trickle_horde_coolddown_modifer = current_stage_trickle_settings.trickle_horde_cooldown
	local trickle_horde_cooldown = {
		default_trickle_horde_travel_cooldown[1] * trickle_horde_coolddown_modifer,
		default_trickle_horde_travel_cooldown[2] * trickle_horde_coolddown_modifer,
	}

	params.trickle_horde_cooldown_modifer = trickle_horde_cooldown

	local num_trickle_hordes_active_for_cooldown = self._trickle_horde_default_settings.num_trickle_hordes_active_for_cooldown
	local num_trickle_hordes_active_for_cooldown_modifer = num_trickle_hordes_active_for_cooldown + current_stage_trickle_settings.num_trickle_hordes_active_for_cooldown

	params.num_trickle_hordes_active_for_cooldown_modifer = num_trickle_hordes_active_for_cooldown_modifer

	Managers.state.pacing:set_trickle_horde_modifers(params)
end

HeatPacing.set_new_heat_stage = function (self, location_index)
	self._current_location_index = location_index

	local wanted_stage_name
	local heat_stage_per_location = self._heat_lookups.heat_stage_per_location

	for i = #heat_stage_per_location, 1, -1 do
		local current_stage_entry = heat_stage_per_location[i]
		local current_stage_entry_threshold = current_stage_entry.threshold
		local current_stage_entry_name = current_stage_entry.name

		if current_stage_entry_threshold <= location_index then
			wanted_stage_name = current_stage_entry_name

			break
		end
	end

	local wanted_stage_name_threshold = self._heat_stages[wanted_stage_name].threshold
	local current_heat = self._heat

	if wanted_stage_name_threshold < current_heat then
		self:_forced_heat_stage_swap(wanted_stage_name)

		self._heat_drop_override[wanted_stage_name] = false
	end
end

HeatPacing._forced_heat_stage_swap = function (self, new_stage)
	self._heat_update_paused = true

	local new_stage_settings = self._heat_stages[new_stage]

	self._heat = new_stage_settings.threshold

	self:_change_heat_condition(new_stage)

	self._heat_graph_annotation = "Manuel Stage Swap"
	self._heat_update_paused = nil
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

HeatPacing.add_heat_on_oppertunity = function (self, oppertunity_type, level, sub_type)
	local heat_lookups = self._heat_lookups
	local oppertunities_lookup = heat_lookups.opportunities
	local heat_value = oppertunities_lookup[oppertunity_type]

	if not heat_value then
		return
	end

	self:_add_heat(heat_value, nil, "oppertunity")
	self:_trigger_vo(oppertunity_type, sub_type)

	local template = self._template
	local heat_settings = template.heat_settings

	if heat_settings.record_heat_generation_per_player and level then
		local game_mode_manager = Managers.state.game_mode
		local game_mode = game_mode_manager:game_mode()
		local level_data = game_mode:get_level_data(level)
		local position = level_data.position:unbox()
		local tags = level_data.tags

		if tags then
			local radius, margin = self:_get_first_available_radius_by_tags(tags)
			local side = self._side_system:get_side(1)
			local valid_player_units = side.valid_player_units
			local num_valid_player_units = #valid_player_units

			for i = 1, num_valid_player_units do
				local target_unit = valid_player_units[i]
				local player_position = POSITION_LOOKUP[target_unit]
				local flattened_player_position = Vector3(player_position.x, player_position.y, 0)
				local flattened_level_position = Vector3(position.x, position.y, 0)
				local distance = Vector3.distance(flattened_level_position, flattened_player_position)

				if distance < radius + margin then
					self:_add_heat_generating_player(heat_value, target_unit)
				end
			end
		end
	end
end

HeatPacing._get_first_available_radius_by_tags = function (self, tags)
	for _, tag in ipairs(tags) do
		local radius, margin = RADIUS_BY_LEVEL_TAG[tag], MARGIN_BY_LEVEL_TAG[tag]

		if radius then
			return radius, margin
		end
	end
end

HeatPacing.add_heat_by_type = function (self, lookup_type, unit, reason, optional_player_unit)
	if not self:active() then
		return
	end

	local heat_lookups = self._heat_lookups
	local lookup_table = heat_lookups[reason]
	local heat_value = lookup_table[lookup_type]

	self:_add_heat(heat_value, nil, reason)

	local template = self._template
	local heat_settings = template.heat_settings

	if heat_settings.record_heat_generation_per_player and optional_player_unit then
		self:_add_heat_generating_player(heat_value, optional_player_unit)
	end
end

HeatPacing.add_on_aggro_heat = function (self, heat_type, unit)
	local allowed_types = self._allowed_heat_generating_spawn_types
	local blackboard = BLACKBOARDS[unit]
	local spawn_source = blackboard.spawn.spawn_source
	local current_stage_name = self:current_stage_name()
	local template = self._template
	local heat_settings = template.heat_settings
	local stage_heat_breed_multipliers = heat_settings.stage_heat_breed_multipliers
	local current_heat_multiplier = stage_heat_breed_multipliers[current_stage_name]

	if allowed_types[spawn_source] then
		local breed = ScriptUnit.extension(unit, "unit_data_system"):breed()
		local breed_heat_value = breed.heat * current_heat_multiplier

		if breed_heat_value > 0 then
			self:_add_heat(breed_heat_value, nil, "aggroed")

			if heat_settings.record_heat_generation_per_player then
				local perception_extension = ScriptUnit.extension(unit, "perception_system")
				local side = self._side_system:get_side(1)
				local valid_player_units = side.valid_player_units
				local num_valid_player_units = #valid_player_units

				for i = 1, num_valid_player_units do
					local target_unit = valid_player_units[i]
					local has_line_of_sight = perception_extension:has_line_of_sight(target_unit)

					if has_line_of_sight then
						self:_add_heat_generating_player(breed_heat_value, target_unit)
					end
				end
			end
		end
	end
end

HeatPacing._add_heat = function (self, new_heat, optional_player_unit, reason)
	local current_location_index = self._current_location_index or 1
	local multiplier

	if self._heat_multiplier[reason] then
		local chosen_multipler_lookup = self._heat_multiplier[reason]

		multiplier = chosen_multipler_lookup[math.min(#chosen_multipler_lookup, current_location_index)]
	else
		multiplier = 1
	end

	local heat = new_heat * multiplier
	local decay_heat_delay = self._decay_heat_delay

	if decay_heat_delay then
		local t = Managers.time:time("gameplay")

		self._heat_delay_duration = t + decay_heat_delay
	end

	self._heat = math.min(self._heat + heat, self._max_heat)
	self._heat_graph_annotation = reason
end

HeatPacing.lower_heat_on_oppertunity = function (self, heat_reduction_type)
	local heat_lookups = self._heat_lookups
	local heat_reduction_lookup = heat_lookups.lower_heat
	local heat_value = self:get_table_entry_by_heat_stage(heat_reduction_lookup[heat_reduction_type])

	if not heat_value then
		return
	end

	self:_lower_heat(heat_value, "Heat reduction")
end

HeatPacing._lower_heat = function (self, heat, reason)
	self._heat = math.min(self._heat - heat, self._max_heat)
	self._heat_graph_annotation = reason
end

HeatPacing._vo_monster_spawned = function (self)
	self:_trigger_vo("monster_spawn")
end

HeatPacing._vo_trickle_horde_spawned = function (self)
	self:_trigger_vo("trickle_horde_spawn")
end

HeatPacing._vo_horde_spawned = function (self)
	self:_trigger_vo("horde_spawn")
end

HeatPacing._vo_in_safe_zone = function (self)
	self:_trigger_vo("safe_room_entered")
end

HeatPacing._vo_left_safe_zone = function (self)
	self:_trigger_vo("safe_room_exited")
end

local ALLOWED_AMBUSH_VO_TYPES = {
	elite_captain_ambush = true,
}

HeatPacing._vo_coordinated_horde_spawned = function (self, horde_type)
	if ALLOWED_AMBUSH_VO_TYPES[horde_type] then
		self:_trigger_vo("captain_ambush")
	end
end

HeatPacing._vo_loner_prevention = function (self)
	self:_trigger_vo("loner_targeted")
end

HeatPacing.heat_trickle_should_patrol = function (self)
	if not self:active() then
		return nil
	end

	local should_patrol
	local trickle_horde_patrol_settings = self._trickle_horde_patrol_settings
	local chance_to_patrol = trickle_horde_patrol_settings[self._current_stage_name]

	should_patrol = chance_to_patrol < math.random() and true or false

	return should_patrol
end

HeatPacing._trigger_vo = function (self, reason, sub_type)
	local dialogue_system = Managers.state.extension:system("dialogue_system")
	local mission_giver_dialogue_playing = dialogue_system:is_mission_giver_dialogue_playing()
	local allowed = false

	if mission_giver_dialogue_playing then
		if reason ~= "loner_targeted" then
			self._queued_vo.reason = reason
			self._queued_vo.sub_type = sub_type
		end
	else
		local voice_profile = "dreg_report_a"
		local voice_profile_2 = "dreg_lector_a"

		allowed = true

		local heat_stage = self._current_stage_name
		local heat_lookups = self._heat_lookups
		local opportunities_lookup = heat_lookups.opportunities

		if reason ~= "escape_event" and opportunities_lookup[reason] then
			reason = "opportunity_started"
		elseif reason == "escape_event" and sub_type and sub_type == "safe_room_event" then
			reason = sub_type
		elseif reason == "safe_room_exited" then
			voice_profile_2 = "tech_priest_a"
		end

		Vo.mission_giver_heat_vo(voice_profile, heat_stage, reason)
		Vo.mission_giver_heat_vo(voice_profile_2, heat_stage, reason)
	end

	return allowed
end

local location_positions = {}

HeatPacing.exp_random_position_away_from_players = function (self, side_id)
	if not self._active then
		return nil
	end

	local game_mode_manager = Managers.state.game_mode
	local game_mode = game_mode_manager:game_mode()
	local current_location_index = game_mode:current_location_index()

	if not self._pos_location_index then
		self._pos_location_index = current_location_index
	end

	if current_location_index > self._pos_location_index then
		table.clear(location_positions)
	end

	local side_system = Managers.state.extension:system("side_system")
	local player_side = side_system:get_side(side_id)
	local valid_player_positions = player_side.valid_player_units_positions
	local main_path_manager = Managers.state.main_path
	local spawn_point_positions = main_path_manager:spawn_point_positions()

	if #location_positions == 0 then
		for i = 1, #spawn_point_positions do
			local spawn_group_positions = spawn_point_positions[i]

			for ii = 1, #spawn_group_positions do
				local triangle_group = spawn_group_positions[ii]

				for k = 1, #triangle_group do
					local position = triangle_group[k]

					location_positions[#location_positions + 1] = position
				end
			end
		end
	end

	local player_positions = {}

	for i = 1, #valid_player_positions do
		local player_position = valid_player_positions[i]

		player_positions[#player_positions + 1] = player_position
	end

	local vector3_distance_squared = Vector3.distance_squared
	local furthestPosition
	local maxTotalDistance = -math.huge

	for i = 1, #location_positions do
		local pos = location_positions[i]:unbox()
		local totalDistance = 0

		for ii = 1, #player_positions do
			local player_pos = player_positions[ii]
			local distance_sq = vector3_distance_squared(pos, player_pos)

			totalDistance = totalDistance + distance_sq
		end

		if maxTotalDistance < totalDistance then
			maxTotalDistance = totalDistance
			furthestPosition = pos
		end
	end

	return furthestPosition
end

return HeatPacing
