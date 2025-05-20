-- chunkname: @scripts/managers/pacing/horde_pacing/horde_pacing.lua

local HordeSettings = require("scripts/settings/horde/horde_settings")
local HordeTemplates = require("scripts/managers/horde/horde_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Vo = require("scripts/utilities/vo")
local HordePacing = class("HordePacing")
local HORDE_TYPES = HordeSettings.horde_types

HordePacing.init = function (self, nav_world)
	self._nav_world = nav_world
	self._horde_timer = math.huge
	self._trickle_horde_travel_distance = math.huge
	self._fx_system = Managers.state.extension:system("fx_system")
	self._timer_modifier = 1
	self._rate_modifier = 1
	self._old_furthest_travel_distance = 0
end

HordePacing.on_gameplay_post_init = function (self, level, template)
	local template_first_spawn_timer_modifer = math.random_range(template.first_spawn_timer_modifer[1], template.first_spawn_timer_modifer[2])
	local first_spawn_timer_modifer = template_first_spawn_timer_modifer and self._timer_modifier * template_first_spawn_timer_modifer
	local template_override = Managers.state.pacing:get_horde_pacing_override_tempate()

	if template_override then
		template = template_override
	end

	self._coordinated_horde_strikes = {}

	self:_init_coordinated_horde_strikes(template)

	self._horde_timer = 0

	self:_setup_next_horde(template, first_spawn_timer_modifer)

	self._trickle_hordes = {}

	self:add_trickle_horde(template)

	self._template = template
	self._current_wave = 0
	self._triggered_hordes = 0
end

HordePacing.update = function (self, dt, t, side_id, target_side_id)
	local hordes_allowed = self:_update_horde_allowance(t, dt, side_id, target_side_id)

	if hordes_allowed then
		self:_update_horde_pacing(t, dt, side_id, target_side_id)
	end

	self:_update_trickle_horde_pacing(t, dt, side_id, target_side_id)
end

local HORDE_FAILED_WAIT_TIME = 3
local TRAVEL_DISTANCE_CHANGE_ALLOWANCE_MIN = 5
local TRAVEL_DISTANCE_CHANGE_ALLOWANCE_MAX = 8
local TIME_SINCE_FORWARD_TRAVEL_CHANGE_MOVE_TIMER_OVERRIDE = {
	60,
	60,
	60,
	30,
	30,
}
local CHALLENGE_RATING_FOR_NO_MOVE_TIMER_OVERRIDE = 0
local TIME_SINCE_FORWARD_TRAVEL_CHANGE_MOVE_TIMER_OVERRIDE = {
	60,
	60,
	60,
	15,
	10,
}
local CHALLENGE_RATING_FOR_NO_MOVE_TIMER_OVERRIDE = 0

HordePacing._update_horde_allowance = function (self, t, dt, side_id, target_side_id)
	local main_path_manager = Managers.state.main_path
	local pacing_manager = Managers.state.pacing
	local template = self._template
	local total_minions_spawned = Managers.state.minion_spawn:num_spawned_minions()
	local minion_spawn_limit_reached = total_minions_spawned >= template.max_active_minions
	local furthest_travel_distance = main_path_manager:furthest_travel_distance(target_side_id)
	local time_since_forward_travel_changed = main_path_manager:time_since_forward_travel_changed(target_side_id)
	local allowed_hordes_per_travel_distance = math.ceil(furthest_travel_distance / self._required_travel_distance) - self._triggered_hordes
	local hordes_enabled = pacing_manager:spawn_type_enabled("hordes") and allowed_hordes_per_travel_distance > 0
	local travel_distance_allowed = time_since_forward_travel_changed < TRAVEL_DISTANCE_CHANGE_ALLOWANCE_MIN or time_since_forward_travel_changed > TRAVEL_DISTANCE_CHANGE_ALLOWANCE_MAX
	local triggered_pre_stinger = self._triggered_pre_stinger
	local current_wave = self._current_wave
	local horde_started = triggered_pre_stinger or current_wave > 0
	local hordes_allowed = not minion_spawn_limit_reached and horde_started or not minion_spawn_limit_reached and hordes_enabled and travel_distance_allowed
	local traveled_this_frame = furthest_travel_distance - self._old_furthest_travel_distance

	self._old_furthest_travel_distance = furthest_travel_distance
	self._time_since_forward_travel_changed = time_since_forward_travel_changed
	self._traveled_this_frame = traveled_this_frame
	self._horde_started = horde_started

	return hordes_allowed
end

HordePacing._update_horde_pacing = function (self, t, dt, side_id, target_side_id)
	local template = self._template
	local traveled_this_frame = self._traveled_this_frame
	local pacing_manager = Managers.state.pacing
	local time_since_forward_travel_changed = self._time_since_forward_travel_changed
	local ramp_up_timer_modifier = pacing_manager:get_ramp_up_frequency_modifier("hordes")
	local has_monster_active = pacing_manager:num_aggroed_monsters() > 0
	local total_challenge_rating = pacing_manager:total_challenge_rating()
	local high_challenge_rating = total_challenge_rating > CHALLENGE_RATING_FOR_NO_MOVE_TIMER_OVERRIDE
	local move_timer_override = not high_challenge_rating and time_since_forward_travel_changed >= Managers.state.difficulty:get_table_entry_by_resistance(TIME_SINCE_FORWARD_TRAVEL_CHANGE_MOVE_TIMER_OVERRIDE)
	local has_travel_distance_spawn_mutator = not move_timer_override and not has_monster_active and (template.travel_distance_spawning or Managers.state.mutator:mutator("mutator_travel_distance_spawning_hordes"))
	local horde_started = self._horde_started

	if has_travel_distance_spawn_mutator and not horde_started then
		self._horde_timer = self._horde_timer + traveled_this_frame * ramp_up_timer_modifier * self._rate_modifier
	else
		self._horde_timer = self._horde_timer + dt * ramp_up_timer_modifier * self._rate_modifier
	end

	local current_wave = self._current_wave

	if self._next_horde_pre_stinger_at and self._horde_timer >= self._next_horde_pre_stinger_at then
		self:_start_horde(t, dt, side_id, target_side_id, template)
	end

	if self._coordinated_horde_strike_active then
		self:_update_coordinated_horde_strike(t, dt, side_id, target_side_id, template)
	elseif self._horde_timer >= self._next_horde_at then
		local horde_template = self._current_horde_template
		local horde_type = self._current_horde_type
		local compositions = self._current_compositions
		local success, horde_position, target_unit, group_id = self:_spawn_horde_wave(template, side_id, target_side_id, current_wave, horde_type, horde_template, compositions)

		if success then
			self._current_wave = current_wave + 1

			if self._current_wave == 1 then
				self:_first_horde_wave_spawn(template, horde_position, target_unit)
			end

			if group_id then
				self:_set_horde_wave_group_sounds(template, group_id)
			end

			local num_waves = self._override_num_waves

			num_waves = num_waves or template.num_waves[self._current_horde_type]

			if num_waves > self._current_wave then
				self._next_horde_at = template.time_between_waves
			else
				self._current_wave = 0

				self:_setup_next_horde(template)

				self._triggered_pre_stinger = nil
				self._triggered_hordes = self._triggered_hordes + 1
				self._override_num_waves = nil
			end
		else
			self._next_horde_at = HORDE_FAILED_WAIT_TIME
		end

		self._horde_timer = 0
	end
end

HordePacing.traveled_this_frame = function (self)
	return self._traveled_this_frame
end

HordePacing._init_coordinated_horde_strikes = function (self, template)
	local coordinated_horde_strike_settings = template.coordinated_horde_strike_settings

	if not coordinated_horde_strike_settings then
		return
	end

	self._coordinated_horde_strikes_total_num_allowed = {}
	self._coordinated_horde_strike_eval_prio = {}

	for setting_name, setting in pairs(coordinated_horde_strike_settings) do
		local total_num_allowed = setting.total_num_allowed

		if total_num_allowed then
			self._coordinated_horde_strikes_total_num_allowed[setting_name] = math.random(total_num_allowed[1], total_num_allowed[2])
		end
	end
end

local TEMP_SETTINGS = {}

HordePacing._evaluate_coordinated_horde_strike = function (self, target_side_id)
	local template = self._template
	local coordinated_horde_strike_settings = template.coordinated_horde_strike_settings

	if not coordinated_horde_strike_settings then
		return
	end

	table.clear(TEMP_SETTINGS)

	local chosen_setting

	for setting_name, setting in pairs(coordinated_horde_strike_settings) do
		repeat
			local num_allowed = self._coordinated_horde_strikes_total_num_allowed[setting_name]

			if num_allowed <= 0 then
				Log.info("HordePacing", "Coordinated horde condition not allowed")

				break
			end

			local conditions = setting.conditions
			local passed_conditions = true

			for j = 1, #conditions do
				passed_conditions = conditions[j](target_side_id)

				if not passed_conditions then
					Log.info("HordePacing", "Coordinated horde condition %s failed..", setting.name)

					break
				end
			end

			if not passed_conditions then
				break
			end

			TEMP_SETTINGS[#TEMP_SETTINGS + 1] = setting
		until true
	end

	table.shuffle(TEMP_SETTINGS)

	for i = 1, #TEMP_SETTINGS do
		local setting = TEMP_SETTINGS[i]
		local high_chance_conditions = setting.high_chance_conditions
		local high_chance

		if high_chance_conditions then
			local passed_high_chance_conditions = true

			for j = 1, #high_chance_conditions do
				passed_high_chance_conditions = high_chance_conditions[j](target_side_id)

				if not passed_high_chance_conditions then
					break
				end
			end

			if passed_high_chance_conditions then
				high_chance = setting.high_chance
			end
		end

		local chance = high_chance or setting.chance

		if chance > math.random() then
			chosen_setting = setting

			break
		end
	end

	if not chosen_setting then
		return
	end

	Log.info("HordePacing", "Coordinated horde strike! %s", chosen_setting.name)

	return chosen_setting
end

HordePacing._start_coordinated_horde_strike = function (self, setting, target_side_id)
	local horde_setup = setting.horde_setup

	for i = 1, #horde_setup do
		local setup = horde_setup[i]
		local horde_type = setup.horde_type
		local num_waves = setup.num_waves

		if type(num_waves) == "table" then
			num_waves = math.random(num_waves[1], num_waves[2])
		end

		local time_between_waves = setup.time_between_waves

		if type(time_between_waves) == "table" then
			time_between_waves = math.random(time_between_waves[1], time_between_waves[2])
		end

		local composition = setup.composition
		local faction_composition = setup.faction_composition
		local time_to_next_wave = setup.time_to_first_wave

		if type(time_to_next_wave) == "table" then
			time_to_next_wave = math.random(time_to_next_wave[1], time_to_next_wave[2])
		end

		local prefered_direction = setup.prefered_direction
		local stinger = setup.stinger
		local random_targets = setup.random_targets
		local optional_skip_spawners = setup.skip_spawners
		local two_waves_ahead_and_behind = setup.two_waves_ahead_and_behind

		if two_waves_ahead_and_behind then
			prefered_direction = "ahead"
			self._coordinated_horde_strikes[#self._coordinated_horde_strikes + 1] = {
				current_wave = 1,
				time_between_waves = 1,
				horde_type = horde_type,
				num_waves = num_waves,
				composition = composition,
				faction_composition = faction_composition,
				time_to_next_wave = time_to_next_wave,
				prefered_direction = prefered_direction,
				stinger = stinger,
				random_targets = random_targets,
				optional_skip_spawners = optional_skip_spawners,
				two_waves_ahead_and_behind = two_waves_ahead_and_behind,
				two_waves_time_between_waves = time_between_waves,
			}
		else
			self._coordinated_horde_strikes[#self._coordinated_horde_strikes + 1] = {
				current_wave = 1,
				horde_type = horde_type,
				num_waves = num_waves,
				composition = composition,
				faction_composition = faction_composition,
				time_between_waves = time_between_waves,
				time_to_next_wave = time_to_next_wave,
				prefered_direction = prefered_direction,
				stinger = stinger,
				random_targets = random_targets,
				optional_skip_spawners = optional_skip_spawners,
			}
		end

		local trigger_special_coordinated_attack_on_first_wave = setup.trigger_special_coordinated_attack_on_first_wave

		if trigger_special_coordinated_attack_on_first_wave then
			local trigger_special_coordinated_attack_num_breeds = setup.trigger_special_coordinated_attack_num_breeds
			local trigger_special_coordinated_attack_timer_offset = setup.trigger_special_coordinated_attack_timer_offset

			Managers.state.pacing:force_coordinated_special_strike(time_to_next_wave + trigger_special_coordinated_attack_timer_offset, trigger_special_coordinated_attack_num_breeds)
		end
	end

	self._coordinated_horde_strikes_total_num_allowed[setting.name] = self._coordinated_horde_strikes_total_num_allowed[setting.name] - 1
	self._coordinated_horde_strike_active = true
	self._override_max_active_hordes = setting.max_active_hordes
end

HordePacing._update_coordinated_horde_strike = function (self, t, dt, side_id, target_side_id, template)
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(target_side_id)
	local target_units = side.valid_player_units
	local num_target_units = #target_units
	local coordinated_horde_strikes = self._coordinated_horde_strikes

	for i = #coordinated_horde_strikes, 1, -1 do
		repeat
			local strike = coordinated_horde_strikes[i]

			if strike.time_to_next_wave > 0 then
				strike.time_to_next_wave = strike.time_to_next_wave - dt

				break
			end

			local current_wave = strike.current_wave
			local horde_type = strike.horde_type
			local horde_template = HordeTemplates[horde_type]
			local composition = strike.composition
			local faction_composition = strike.faction_composition

			if faction_composition then
				local current_faction = Managers.state.pacing:current_faction()
				local compositions = faction_composition[current_faction]

				composition = compositions[math.random(1, #compositions)]
			end

			local prefered_direction = strike.prefered_direction
			local optional_target_unit
			local random_targets = strike.random_targets

			if random_targets then
				optional_target_unit = target_units[math.random(1, num_target_units)]
			end

			local optional_skip_spawners = strike.optional_skip_spawners
			local success, horde_position, target_unit, group_id = self:_spawn_horde_wave(template, side_id, target_side_id, current_wave, horde_type, horde_template, composition, nil, nil, nil, nil, prefered_direction, optional_target_unit, optional_skip_spawners)

			if success then
				strike.current_wave = strike.current_wave + 1

				if strike.stinger and current_wave == 1 then
					local stinger = strike.stinger

					self:_first_horde_wave_spawn(template, horde_position, target_unit, stinger, horde_type)
				end

				if group_id then
					self:_set_horde_wave_group_sounds(template, group_id)
				end

				do
					local num_waves = strike.num_waves

					if num_waves > strike.current_wave then
						do
							local two_waves_ahead_and_behind = strike.two_waves_ahead_and_behind

							if two_waves_ahead_and_behind then
								prefered_direction = strike.prefered_direction == "ahead" and "behind" or "ahead"
								strike.prefered_direction = prefered_direction
								strike.time_between_waves = current_wave % 2 == 0 and strike.two_waves_time_between_waves or 1
							end

							strike.time_to_next_wave = strike.time_between_waves
						end

						break
					end

					strike.current_wave = 0

					table.remove(self._coordinated_horde_strikes, i)

					if #self._coordinated_horde_strikes == 0 then
						self:_setup_next_horde(template)

						self._triggered_pre_stinger = nil
						self._triggered_hordes = self._triggered_hordes + 1
						self._override_num_waves = nil
						self._coordinated_horde_strike_active = false
						self._override_max_active_hordes = nil
					end

					break
				end

				break
			end

			strike.time_to_next_wave = HORDE_FAILED_WAIT_TIME
		until true
	end

	self._horde_timer = 0
end

HordePacing._start_horde = function (self, t, dt, side_id, target_side_id, template)
	local coordinated_horde_strike_setting = self:_evaluate_coordinated_horde_strike(target_side_id)

	if coordinated_horde_strike_setting then
		self:_start_coordinated_horde_strike(coordinated_horde_strike_setting, target_side_id)

		local pre_stinger = coordinated_horde_strike_setting.pre_stinger

		self:_trigger_pre_stinger(template, target_side_id, pre_stinger)

		self._next_horde_pre_stinger_at = nil
		self._triggered_pre_stinger = true
	else
		self:_trigger_pre_stinger(template, target_side_id)

		self._next_horde_pre_stinger_at = nil
		self._triggered_pre_stinger = true
	end
end

HordePacing._spawn_horde_wave = function (self, template, side_id, target_side_id, current_wave, horde_type, horde_template, compositions, optional_main_path_offset, optional_num_tries, optional_disallowed_positions, optional_spawn_max_health_modifier, optional_prefered_direction, optional_target_unit, optional_skip_spawners)
	local challenge_scaled_compositions = Managers.state.difficulty:get_table_entry_by_challenge(compositions)
	local success, horde_position, target_unit, group_id, spawned_direction = self:_spawn_horde(horde_type, horde_template, challenge_scaled_compositions, side_id, target_side_id, optional_main_path_offset, optional_num_tries, optional_disallowed_positions, optional_spawn_max_health_modifier, optional_prefered_direction, optional_target_unit, optional_skip_spawners)

	if success then
		Managers.server_metrics:add_annotation("start_horde_wave", {
			horde_type = horde_type,
			current_wave = current_wave + 1,
			num_weaves = template.num_waves[horde_type],
		})
	end

	return success, horde_position, target_unit, group_id, spawned_direction
end

HordePacing._spawn_horde = function (self, horde_type, horde_template, composition, side_id, target_side_id, optional_main_path_offset, optional_num_tries, optional_disallowed_positions, optional_spawn_max_health_modifier, optional_prefered_direction, optional_target_unit, optional_skip_spawners)
	local main_path_available = Managers.state.main_path:is_main_path_available()

	if horde_template.requires_main_path and main_path_available or not horde_template.requires_main_path then
		local horde_manager = Managers.state.horde
		local towards_combat_vector = true
		local success, horde_position, target_unit, group_id, spawned_direction = horde_manager:horde(horde_type, horde_template.name, side_id, target_side_id, composition, towards_combat_vector, optional_main_path_offset, optional_num_tries, optional_disallowed_positions, optional_spawn_max_health_modifier, optional_prefered_direction, optional_target_unit, optional_skip_spawners)

		return success, horde_position, target_unit, group_id, spawned_direction
	end
end

HordePacing._setup_next_horde = function (self, template, optional_timer_modifier)
	local templates = template.horde_templates
	local horde_compositions = template.horde_compositions
	local total_minions_spawned = Managers.state.minion_spawn:num_spawned_minions()
	local limit_reached_for_ambush_horde = total_minions_spawned >= template.max_active_minions_for_ambush
	local horde_template

	if limit_reached_for_ambush_horde then
		horde_template = HordeTemplates.far_vector_horde
	else
		horde_template = templates[math.random(1, #templates)]
	end

	local horde_type = horde_template.name or self._current_horde_type
	local horde_type_compositions = horde_compositions[horde_type]
	local chosen_compositions = horde_type_compositions[math.random(1, #horde_type_compositions)]

	self._current_compositions = chosen_compositions
	self._current_horde_type = horde_type
	self._current_horde_template = horde_template

	local horde_timer_range = template.horde_timer_range
	local next_horde_at = math.random_range(horde_timer_range[1], horde_timer_range[2])

	self._next_horde_at = next_horde_at * (optional_timer_modifier or self._timer_modifier)

	local pre_stinger_delay = template.pre_stinger_delays[horde_type]
	local decreased_stinger = Managers.state.mutator:mutator("mutator_decreased_horde_pacing_stinger")

	if decreased_stinger then
		pre_stinger_delay = pre_stinger_delay * 0.5
	end

	self._next_horde_pre_stinger_at = self._next_horde_at - pre_stinger_delay

	local travel_distance_required_for_horde = template.travel_distance_required_for_horde

	self._required_travel_distance = self._override_required_travel_distance or math.random_range(travel_distance_required_for_horde[1], travel_distance_required_for_horde[2])
end

HordePacing.add_trickle_horde = function (self, template)
	local trickle_horde = {}
	local trickle_horde_travel_distance_range = template.trickle_horde_travel_distance_range
	local next_trickle_horde_travel_distance_range = math.random_range(trickle_horde_travel_distance_range[1], trickle_horde_travel_distance_range[2])

	trickle_horde.trickle_horde_travel_distance = 0
	trickle_horde.cooldown = 0
	trickle_horde.next_trickle_horde_travel_distance_trigger = next_trickle_horde_travel_distance_range
	trickle_horde.template = template
	trickle_horde.current_travel_distance = 0
	trickle_horde.pause_pacing_on_spawn = template.pause_pacing_on_spawn
	self._trickle_hordes[#self._trickle_hordes + 1] = trickle_horde
end

HordePacing.set_rate_modifier = function (self, modifier)
	self._rate_modifier = modifier
end

HordePacing.set_timer_modifier = function (self, modifier)
	self._timer_modifier = modifier

	if self._next_horde_at then
		self._next_horde_at = self._next_horde_at * modifier
	end

	if self._next_horde_pre_stinger_at then
		local pre_stinger_delay = self._template.pre_stinger_delays[self._current_horde_type]

		self._next_horde_pre_stinger_at = self._next_horde_at - pre_stinger_delay
	end
end

HordePacing.set_override_required_travel_distance = function (self, required_travel_distance)
	self._override_required_travel_distance = required_travel_distance
end

HordePacing.override_trickle_horde_compositions = function (self, compositions)
	self._override_trickle_horde_compositions = compositions
end

HordePacing._trigger_pre_stinger = function (self, template, side_id, optional_stinger_event_name)
	local stinger_sound_event = optional_stinger_event_name or template.pre_stinger_sound_events[self._current_compositions.name]

	if not stinger_sound_event then
		return
	end

	local optional_ambisonics = true

	self._fx_system:trigger_wwise_event(stinger_sound_event, nil, nil, nil, nil, nil, optional_ambisonics)
end

HordePacing.force_next_horde = function (self)
	local horde_started = self._horde_started

	if horde_started then
		return
	end

	local target_side_id = 1
	local pacing_manager = Managers.state.pacing
	local main_path_manager = Managers.state.main_path
	local furthest_travel_distance = main_path_manager:furthest_travel_distance(target_side_id)
	local time_since_forward_travel_changed = main_path_manager:time_since_forward_travel_changed(target_side_id)
	local allowed_hordes_per_travel_distance = math.ceil(furthest_travel_distance / self._required_travel_distance) - self._triggered_hordes

	if allowed_hordes_per_travel_distance == 0 then
		self._triggered_hordes = self._triggered_hordes - 1
	end

	self._next_horde_at = 5
end

HordePacing._trigger_stinger = function (self, template, position, optional_stinger_override)
	local stinger_sound_event = optional_stinger_override or template.stinger_sound_events[self._current_compositions.name]

	if not stinger_sound_event then
		return
	end

	self._fx_system:trigger_wwise_event(stinger_sound_event, position)
end

local FAILED_TRAVEL_RANGE = {
	10,
	20,
}

HordePacing._update_trickle_horde_pacing = function (self, t, dt, side_id, target_side_id)
	local pacing_manager = Managers.state.pacing
	local main_path_manager = Managers.state.main_path
	local furthest_travel_distance = main_path_manager:furthest_travel_distance(target_side_id)
	local trickle_hordes = self._trickle_hordes
	local ramp_up_timer_modifier = pacing_manager:get_ramp_up_frequency_modifier("trickle_hordes") or 1

	for i = 1, #trickle_hordes do
		repeat
			local trickle_horde = trickle_hordes[i]

			if trickle_horde.stinger_duration and t < trickle_horde.stinger_duration then
				break
			end

			local template = trickle_horde.template

			if trickle_horde.num_waves then
				if t > trickle_horde.next_wave_at_t then
					local optional_main_path_offset = template.optional_main_path_offset
					local optional_num_tries = template.optional_num_tries
					local success, horde_position = self:_spawn_trickle_horde_wave(side_id, target_side_id, optional_main_path_offset, optional_num_tries, template, trickle_horde, t)

					trickle_horde.num_waves = trickle_horde.num_waves - 1

					if trickle_horde.num_waves > 0 then
						trickle_horde.next_wave_at_t = t + math.random_range(template.time_between_waves[1], template.time_between_waves[2])

						if success then
							local disallow_spawning_too_close_to_other_spawn = template.disallow_spawning_too_close_to_other_spawn

							if disallow_spawning_too_close_to_other_spawn then
								trickle_horde.disallowed_spawn_positions[#trickle_horde.disallowed_spawn_positions + 1] = Vector3Box(horde_position)
							end
						end

						break
					end

					trickle_horde.num_waves = nil
					trickle_horde.next_wave_at_t = nil
					trickle_horde.disallowed_spawn_positions = nil
				end

				break
			end

			local cooldown = trickle_horde.cooldown
			local horde_manager = Managers.state.horde
			local num_active_trickle_hordes = horde_manager:num_active_hordes(HORDE_TYPES.trickle_horde)
			local should_trigger_cooldown = num_active_trickle_hordes >= template.num_trickle_hordes_active_for_cooldown

			if should_trigger_cooldown and t < cooldown then
				break
			elseif should_trigger_cooldown then
				trickle_horde.cooldown = t + math.random(template.trickle_horde_cooldown[1], template.trickle_horde_cooldown[2])

				break
			elseif not should_trigger_cooldown then
				trickle_horde.cooldown = 0
			end

			local trickle_hordes_allowed = (Managers.state.pacing:spawn_type_enabled("trickle_hordes") or template.ignore_disallowance) and (not template.not_during_terror_events or Managers.state.terror_event:num_active_events() == 0)

			if furthest_travel_distance > trickle_horde.current_travel_distance then
				local diff = furthest_travel_distance - trickle_horde.current_travel_distance

				trickle_horde.current_travel_distance = furthest_travel_distance

				if not template.cant_be_ramped then
					diff = diff * ramp_up_timer_modifier
				end

				if trickle_hordes_allowed then
					trickle_horde.trickle_horde_travel_distance = trickle_horde.trickle_horde_travel_distance + diff
				else
					trickle_horde.trickle_horde_travel_distance = trickle_horde.trickle_horde_travel_distance + diff
					trickle_horde.next_trickle_horde_travel_distance_trigger = trickle_horde.next_trickle_horde_travel_distance_trigger + diff
				end
			end

			if trickle_horde.trickle_horde_travel_distance >= trickle_horde.next_trickle_horde_travel_distance_trigger then
				local success, horde_position, target_unit, group_id

				if template.min_players_alive and not trickle_horde.num_waves then
					local side_system = Managers.state.extension:system("side_system")
					local side = side_system:get_side(target_side_id)
					local target_units = side.valid_player_units
					local num_target_units = #target_units
					local num_non_disabled_players = 0

					for j = 1, num_target_units do
						local player_unit = target_units[j]
						local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
						local character_state_component = unit_data_extension:read_component("character_state")
						local requires_help = PlayerUnitStatus.requires_help(character_state_component)

						if not requires_help then
							num_non_disabled_players = num_non_disabled_players + 1
						end
					end

					trickle_hordes_allowed = num_non_disabled_players >= template.min_players_alive
				end

				if trickle_hordes_allowed then
					local trickle_horde_template = HordeTemplates.trickle_horde
					local trickle_horde_compositions = self._override_trickle_horde_compositions or template.horde_compositions.trickle_horde
					local current_faction = Managers.state.pacing:current_faction()
					local current_density_type = Managers.state.pacing:current_density_type()
					local waiting_for_ramp_clear = Managers.state.pacing:waiting_for_ramp_clear()
					local faction_compositions = trickle_horde_compositions[current_faction]
					local faction_composition = faction_compositions[current_density_type]

					if waiting_for_ramp_clear and faction_compositions.waiting_for_ramp_clear then
						faction_composition = faction_compositions.waiting_for_ramp_clear
					end

					local chosen_compositions = faction_composition[math.random(1, #faction_composition)]
					local resistance_scaled_composition = Managers.state.difficulty:get_table_entry_by_challenge(chosen_compositions)
					local optional_main_path_offset = template.optional_main_path_offset
					local optional_num_tries = template.optional_num_tries
					local stinger = template.stinger

					if stinger and not trickle_horde.stinger_duration then
						local stinger_duration = template.stinger_duration
						local can_spawn = self:_can_spawn(HORDE_TYPES.trickle_horde, trickle_horde_template, resistance_scaled_composition, side_id, target_side_id, optional_main_path_offset, optional_num_tries)

						if can_spawn then
							trickle_horde.stinger_duration = t + stinger_duration

							self:_trigger_pre_stinger(template, target_side_id, stinger)

							break
						else
							Log.info("HordePacing", "Failed starting trickle horde stinger")
						end
					else
						success, horde_position, target_unit, group_id = self:_spawn_trickle_horde_wave(side_id, target_side_id, optional_main_path_offset, optional_num_tries, template, trickle_horde, t)

						if success then
							local num_trickle_waves = template.num_trickle_waves

							if num_trickle_waves then
								if type(num_trickle_waves[1] == "table") then
									num_trickle_waves = Managers.state.difficulty:get_table_entry_by_challenge(num_trickle_waves)
								end

								trickle_horde.num_waves = math.random(num_trickle_waves[1], num_trickle_waves[2]) - 1
								trickle_horde.next_wave_at_t = t + math.random_range(template.time_between_waves[1], template.time_between_waves[2])

								local disallow_spawning_too_close_to_other_spawn = template.disallow_spawning_too_close_to_other_spawn

								if disallow_spawning_too_close_to_other_spawn then
									trickle_horde.disallowed_spawn_positions = {
										Vector3Box(horde_position),
									}
								end
							end
						end
					end
				end

				local trickle_horde_travel_distance_range = success and template.trickle_horde_travel_distance_range or FAILED_TRAVEL_RANGE
				local next_trickle_horde_at = math.random_range(trickle_horde_travel_distance_range[1], trickle_horde_travel_distance_range[2])

				trickle_horde.next_trickle_horde_travel_distance_trigger = next_trickle_horde_at
				trickle_horde.trickle_horde_travel_distance = 0
			end
		until true
	end
end

HordePacing._spawn_trickle_horde_wave = function (self, side_id, target_side_id, optional_main_path_offset, optional_num_tries, template, trickle_horde, t)
	local trickle_horde_template = HordeTemplates.trickle_horde
	local trickle_horde_compositions = self._override_trickle_horde_compositions or template.horde_compositions.trickle_horde
	local current_faction = Managers.state.pacing:current_faction()
	local current_density_type = Managers.state.pacing:current_density_type()
	local waiting_for_ramp_clear = Managers.state.pacing:waiting_for_ramp_clear()
	local faction_compositions = trickle_horde_compositions[current_faction]
	local faction_composition = faction_compositions[current_density_type]

	if waiting_for_ramp_clear and faction_compositions.waiting_for_ramp_clear then
		faction_composition = faction_compositions.waiting_for_ramp_clear
	end

	local chosen_compositions = faction_composition[math.random(1, #faction_composition)]
	local resistance_scaled_composition = Managers.state.difficulty:get_table_entry_by_resistance(chosen_compositions)
	local optional_disallowed_positions = trickle_horde.disallowed_spawn_positions
	local spawn_max_health_modifier = template.spawn_max_health_modifier
	local success, horde_position, target_unit, group_id = self:_spawn_horde(HORDE_TYPES.trickle_horde, trickle_horde_template, resistance_scaled_composition, side_id, target_side_id, optional_main_path_offset, optional_num_tries, optional_disallowed_positions, spawn_max_health_modifier)

	if success then
		local horde_group_sound_event_names = template.group_sound_event_names
		local group_system = Managers.state.extension:system("group_system")
		local group = group_system:group_from_id(group_id)

		if horde_group_sound_event_names then
			local start_event, stop_event = horde_group_sound_event_names.start, horde_group_sound_event_names.stop

			group.group_start_sound_event = start_event
			group.group_stop_sound_event = stop_event

			if start_event and not group.sfx and not group.group_sound_event_started then
				group_system:start_group_sfx(group_id, start_event, stop_event)
			end
		end

		if trickle_horde.pause_pacing_on_spawn then
			local pause_pacing_on_spawn = trickle_horde.pause_pacing_on_spawn

			if type(pause_pacing_on_spawn) == "table" then
				pause_pacing_on_spawn = Managers.state.difficulty:get_table_entry_by_challenge(pause_pacing_on_spawn)
			end

			for spawn_type, duration in pairs(pause_pacing_on_spawn) do
				Managers.state.pacing:pause_spawn_type(spawn_type, true, "trickle_horde", duration)
			end
		end
	end

	trickle_horde.stinger_duration = nil

	return success, horde_position, target_unit, group_id
end

HordePacing._can_spawn = function (self, horde_type, horde_template, composition, side_id, target_side_id, optional_main_path_offset, optional_num_tries)
	local horde_manager = Managers.state.horde
	local towards_combat_vector = true
	local can_spawn = horde_manager:can_spawn(horde_type, horde_template.name, side_id, target_side_id, composition, towards_combat_vector, optional_main_path_offset, optional_num_tries)

	return can_spawn
end

HordePacing._set_horde_wave_group_sounds = function (self, template, group_id)
	local group_system = Managers.state.extension:system("group_system")
	local group = group_system:group_from_id(group_id)
	local horde_group_sound_event_names = template.horde_group_sound_events[self._current_compositions.name]
	local start_event, stop_event = horde_group_sound_event_names.start, horde_group_sound_event_names.stop

	group.group_start_sound_event = start_event
	group.group_stop_sound_event = stop_event
end

HordePacing._first_horde_wave_spawn = function (self, template, horde_position, target_unit, optional_stinger_override, optional_horde_type_override)
	self:_trigger_stinger(template, horde_position, optional_stinger_override)

	local aggro_nearby_roamers_zone_range = template.aggro_nearby_roamers_zone_range

	if aggro_nearby_roamers_zone_range then
		Managers.state.pacing:aggro_roamer_zone_range(target_unit, aggro_nearby_roamers_zone_range)
	end

	local trigger_heard_dialogue = template.trigger_heard_dialogue

	if trigger_heard_dialogue and target_unit then
		Vo.heard_horde(target_unit, optional_horde_type_override or self._current_horde_type)
	end
end

HordePacing.reset_traveled_this_frame = function (self)
	self._next_frame_traveled_distance = 0
end

return HordePacing
