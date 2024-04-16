local HordePacing = require("scripts/managers/pacing/horde_pacing/horde_pacing")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MonsterPacing = require("scripts/managers/pacing/monster_pacing/monster_pacing")
local PacingTemplates = require("scripts/managers/pacing/pacing_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local RoamerPacing = require("scripts/managers/pacing/roamer_pacing/roamer_pacing")
local SpecialsPacing = require("scripts/managers/pacing/specials_pacing/specials_pacing")
local PacingManager = class("PacingManager")

PacingManager.init = function (self, world, nav_world, level_name, level_seed, pacing_control)
	self._tension = 0
	self._total_challenge_rating = 0
	self._num_aggroed_minions = 0
	self._aggroed_minions = {}
	self._ramp_up_enabled = true
	self._switch_state_conditions = {
		back = {},
		next = {}
	}
	self._world = world
	local template = PacingTemplates.default
	self._template = template
	self._roamer_pacing = RoamerPacing:new(nav_world, level_name, level_seed, pacing_control)
	self._horde_pacing = HordePacing:new(nav_world)
	self._specials_pacing = SpecialsPacing:new(nav_world)
	self._monster_pacing = MonsterPacing:new(nav_world)
	self._side_system = Managers.state.extension:system("side_system")
	self._paused_spawn_types = {}
	self._pause_durations = {}
	self._player_tension = {}
	self._player_combat_states = {}
	self._current_combat_state = "low"
	self._disabled = false
	self._backend_pacing_control = pacing_control
	self._minions_listening_for_player_deaths = {}
	self._saved_challenge_ratings = {}
	self._ramp_duration_modifier = 1
	self._frozen_spawn_types = {}
end

PacingManager.on_gameplay_post_init = function (self, level_name)
	local template = self._template
	local combat_state_settings = Managers.state.difficulty:get_table_entry_by_challenge(template.combat_state_settings)
	self._combat_state_settings = combat_state_settings
	local state_settings = Managers.state.difficulty:get_table_entry_by_challenge(template.state_settings)
	self._state_settings = state_settings
	local starting_state = template.starting_state
	self._next_state = starting_state
	self._state_orders = template.state_orders

	self:_change_state(0, starting_state)

	self._max_tension = Managers.state.difficulty:get_table_entry_by_challenge(template.max_tension)
	self._ramp_up_frequency_settings = Managers.state.difficulty:get_table_entry_by_challenge(template.ramp_up_frequency_modifiers)
	self._ramp_up_frequency_modifiers = {}
	local challenge_rating_thresholds = {}

	for spawn_type, challenge_table in pairs(template.challenge_rating_thresholds) do
		challenge_rating_thresholds[spawn_type] = Managers.state.difficulty:get_table_entry_by_challenge(challenge_table)
	end

	self._challenge_rating_thresholds = challenge_rating_thresholds

	self._roamer_pacing:on_gameplay_post_init(level_name)

	local horde_resistance_templates = template.horde_pacing_template.resistance_templates
	local horde_pacing_template = Managers.state.difficulty:get_table_entry_by_resistance(horde_resistance_templates)

	self._horde_pacing:on_gameplay_post_init(level_name, horde_pacing_template)

	local monster_challenge_templates = template.monster_pacing_template.challenge_templates
	local monster_challenge_template = Managers.state.difficulty:get_table_entry_by_challenge(monster_challenge_templates)

	self._monster_pacing:on_gameplay_post_init(level_name, monster_challenge_template)

	local main_path_available = Managers.state.main_path:is_main_path_available()
	local cinematic_playing = Managers.state.cinematic:is_playing()
	local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
	self._disabled = not main_path_available or cinematic_playing or not cinematic_scene_system:intro_played()

	Managers.event:register(self, "intro_cinematic_started", "_event_intro_cinematic_started")
	Managers.event:register(self, "intro_cinematic_played", "_event_intro_cinematic_played")

	self._first_aggro = true
	local min_wound_tension_requirement = Managers.state.difficulty:get_table_entry_by_challenge(template.min_wound_tension_requirement)
	self._min_wound_tension_requirement = min_wound_tension_requirement
end

PacingManager.on_spawn_points_generated = function (self)
	local template = self._template
	local specials_resistance_templates = template.specials_pacing_template.resistance_templates
	local specials_pacing_template = Managers.state.difficulty:get_table_entry_by_resistance(specials_resistance_templates)

	self._specials_pacing:on_spawn_points_generated(specials_pacing_template)
end

PacingManager.destroy = function (self)
	Managers.event:unregister(self, "intro_cinematic_started")
	Managers.event:unregister(self, "intro_cinematic_played")
	self._roamer_pacing:delete()
	self._monster_pacing:delete()
end

PacingManager.update = function (self, dt, t)
	local side_id = 2
	local target_side_id = 1

	self:_update_player_combat_state(dt, target_side_id)

	local tension = self._tension
	local decay_tension_rate = self._decay_tension_rate
	local delay_duration = self._decay_tension_delay_duration

	if not delay_duration or delay_duration and delay_duration < t then
		local new_tension = math.clamp(tension - dt * decay_tension_rate, 0, self._max_tension)
		self._tension = new_tension
		self._is_decaying_tension = new_tension > 0
	else
		self._is_decaying_tension = false
	end

	local pause_durations = self._pause_durations

	for spawn_type, duration in pairs(pause_durations) do
		pause_durations[spawn_type] = duration - dt

		if pause_durations[spawn_type] <= 0 then
			if self._paused_spawn_types[spawn_type] then
				self:pause_spawn_type(spawn_type, false, "pause_duration_over")
			end

			pause_durations[spawn_type] = nil

			break
		end
	end

	if not self._disabled then
		self._roamer_pacing:update(dt, t, side_id, target_side_id)
		self._horde_pacing:update(dt, t, side_id, target_side_id)
		self._specials_pacing:update(dt, t, side_id, target_side_id)
		self._monster_pacing:update(dt, t, side_id, target_side_id)

		if self._ramp_up_enabled then
			self:_update_ramp_up_frequency(dt, t, target_side_id)
		end
	end

	local switch_state_conditions = self._switch_state_conditions
	local state_order = self._state_order

	for name, conditions in pairs(switch_state_conditions) do
		local duration = conditions.duration

		if duration and duration < t then
			local state_name = name == "next" and state_order.next_state or state_order.back_state

			self:_change_state(t, state_name)

			return
		end

		local tension_threshold = conditions.tension_threshold
		local tension_min_threshold = conditions.tension_min_threshold

		if tension_threshold and tension_threshold <= tension or tension_min_threshold and tension <= tension_min_threshold then
			local state_name = name == "next" and state_order.next_state or state_order.back_state

			self:_change_state(t, state_name)

			return
		end
	end
end

PacingManager._set_switch_state_condition = function (self, conditions, condition_identifier, t)
	local duration_end_condition = conditions.duration
	local tension_threshold = conditions.tension_threshold
	local tension_min_threshold = conditions.tension_min_threshold
	local switch_state_condition = self._switch_state_conditions[condition_identifier]

	if duration_end_condition then
		switch_state_condition.duration = t + math.random_range(duration_end_condition[1], duration_end_condition[2])
	else
		switch_state_condition.duration = nil
	end

	switch_state_condition.tension_threshold = tension_threshold
	switch_state_condition.tension_min_threshold = tension_min_threshold
end

PacingManager._change_state = function (self, t, state_name)
	local state_settings = self._state_settings
	local state_setting = state_settings[state_name]
	local next_conditions = state_setting.next_conditions
	local back_conditions = state_setting.back_conditions
	local switch_state_conditions = self._switch_state_conditions

	if next_conditions then
		self:_set_switch_state_condition(next_conditions, "next", t)
	else
		table.clear(switch_state_conditions.next)
	end

	if back_conditions then
		self:_set_switch_state_condition(back_conditions, "back", t)
	else
		table.clear(switch_state_conditions.back)
	end

	local allowed_spawn_types = state_setting.allowed_spawn_types
	local override_allowed_spawn_type_settings = self._override_allowed_spawn_type_settings

	if override_allowed_spawn_type_settings then
		allowed_spawn_types = override_allowed_spawn_type_settings[state_name]
	end

	self._allowed_spawn_types = allowed_spawn_types

	if not self._in_safe_zone and t > 0 then
		if self._state ~= state_name then
			self._state_entered_t = t
		end

		local is_already_in_low = self._state == "build_up_tension" or self._state == "build_up_tension_low"

		if not is_already_in_low then
			if not self._low_state_entered_t and (state_name == "build_up_tension" or state_name == "build_up_tension_low") then
				self._low_state_entered_t = t
			else
				self._low_state_entered_t = nil
			end
		end
	end

	self._state = state_name
	self._state_setting = state_setting
	self._state_order = self._state_orders[state_name]
	self._decay_tension_rate = state_setting.decay_tension_rate

	if state_setting.decay_tension_delay then
		self._decay_tension_delay = state_setting.decay_tension_delay
	else
		self._decay_tension_delay = nil
		self._decay_tension_delay_duration = nil
	end
end

PacingManager.pause_spawn_type = function (self, spawn_type, paused, reason, optional_duration)
	if spawn_type == "all" then
		for type, _ in pairs(self._allowed_spawn_types) do
			self._paused_spawn_types[type] = paused
		end
	else
		self._paused_spawn_types[spawn_type] = paused
	end

	if optional_duration then
		self._pause_durations[spawn_type] = optional_duration
	elseif self._pause_durations[spawn_type] then
		self._pause_durations[spawn_type] = nil
	end
end

PacingManager.override_allowed_spawn_types = function (self, override_settings)
	self._override_allowed_spawn_type_settings = override_settings
end

PacingManager.set_enabled = function (self, enabled)
	self._disabled = not enabled
end

PacingManager.set_in_safe_zone = function (self, in_safe_zone)
	self._in_safe_zone = in_safe_zone
end

PacingManager._event_intro_cinematic_started = function (self, cinematic_name)
	self._disabled = true
end

PacingManager.is_enabled = function (self)
	return not self._disabled
end

PacingManager._event_intro_cinematic_played = function (self, cinematic_name)
	if self._disabled then
		self._disabled = not Managers.state.main_path:is_main_path_available()
	end
end

PacingManager.spawn_type_enabled = function (self, spawn_type)
	if self._disabled then
		return false, "pacing_is_disabled"
	end

	local challenge_rating_thresholds = self._challenge_rating_thresholds
	local challenge_rating_threshold = challenge_rating_thresholds[spawn_type]
	local total_challenge_rating = self._total_challenge_rating

	if challenge_rating_threshold and challenge_rating_threshold < total_challenge_rating then
		return false, "disabled_by_challenge_rating"
	end

	if self._paused_spawn_types[spawn_type] then
		return false, "paused"
	end

	if not self._allowed_spawn_types or not self._allowed_spawn_types[spawn_type] then
		return false, "not_allowed"
	end

	return true
end

PacingManager.spawn_type_allowed = function (self, spawn_type)
	if not self._allowed_spawn_types or not self._allowed_spawn_types[spawn_type] then
		return false
	end

	return true
end

PacingManager.add_tension = function (self, tension, optional_player_unit, reason)
	local decay_tension_delay = self._decay_tension_delay

	if decay_tension_delay then
		local t = Managers.time:time("gameplay")
		self._decay_tension_delay_duration = t + decay_tension_delay
	end

	if self._tension_modifier then
		tension = tension * self._tension_modifier
	end

	self._tension = math.min(self._tension + tension, self._max_tension)

	if optional_player_unit then
		local settings = self._combat_state_settings
		local current_player_tension = self._player_tension[optional_player_unit] or 0
		local tension_modifier = settings.tension_modifier
		local max_value = settings.max_value
		self._player_tension[optional_player_unit] = math.min(current_player_tension + tension * tension_modifier, max_value)
	end
end

PacingManager.add_damage_tension = function (self, tension_type, damage, attacked_unit)
	local target_unit_data_extension = ScriptUnit.extension(attacked_unit, "unit_data_system")
	local character_state_component = target_unit_data_extension:read_component("character_state")
	local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)

	if is_disabled then
		return
	end

	local diff_table = MinionDifficultySettings.damage_tension_to_add[tension_type]
	local value = Managers.state.difficulty:get_table_entry_by_challenge(diff_table)
	local tension = damage * value
	local side_id = 1
	local side = self._side_system:get_side(side_id)
	local valid_player_units = side.valid_player_units
	local num_valid_player_units = #valid_player_units
	tension = tension / num_valid_player_units

	self:add_tension(tension, attacked_unit, tension_type)
end

PacingManager.add_tension_type = function (self, tension_type, attacked_unit)
	local target_health_extension = ScriptUnit.has_extension(attacked_unit, "health_system")
	local num_wounds = 0

	if target_health_extension then
		num_wounds = target_health_extension:num_wounds()
	end

	local diff_table = MinionDifficultySettings.tension_to_add[tension_type]
	local value = Managers.state.difficulty:get_table_entry_by_challenge(diff_table)

	self:add_tension(value, attacked_unit, tension_type)

	if self._waiting_for_ramp_clear and (tension_type == "died" or num_wounds == 2 and tension_type == "knocked_down") then
		self._waiting_for_ramp_clear = nil
		self._clear_ramp = true
	end
end

local MAX_OUT_TENSION_BY_CHALLENGE = {
	{
		true,
		true,
		true,
		false
	},
	{
		true,
		true,
		true,
		false
	},
	{
		true,
		true,
		true,
		false
	},
	{
		true,
		true,
		false,
		false
	},
	{
		true,
		true,
		false,
		false
	}
}

PacingManager.player_died = function (self, player_unit)
	if self._waiting_for_ramp_clear then
		self._waiting_for_ramp_clear = nil
		self._clear_ramp = true
	end

	local player_manager = Managers.player
	local players = player_manager:players()
	local alive_players = 0

	for _, player in pairs(players) do
		local unit = player.player_unit

		if HEALTH_ALIVE[unit] then
			local unit_data_extension = ScriptUnit.has_extension(unit, "unit_data_system")
			local character_state_component = unit_data_extension and unit_data_extension:read_component("character_state")
			local hogtied = character_state_component and PlayerUnitStatus.is_hogtied(character_state_component)

			if not hogtied then
				alive_players = alive_players + 1
			end
		end
	end

	local has_auric_mutator = false
	local mutator_manager = Managers.state.mutator

	if mutator_manager:mutator("mutator_auric_tension_modifier") then
		has_auric_mutator = true
	end

	if not has_auric_mutator then
		local max_out_tension_table = Managers.state.difficulty:get_table_entry_by_challenge(MAX_OUT_TENSION_BY_CHALLENGE)
		local max_out_tension = max_out_tension_table[alive_players]

		if max_out_tension then
			self:add_tension(math.huge)
		end
	end
end

PacingManager.player_tension = function (self, unit)
	local settings = self._combat_state_settings
	local max_value = settings.max_value
	local tension = self._player_tension[unit] or 0
	local value = tension / max_value

	return value
end

PacingManager.waiting_for_ramp_clear = function (self)
	return self._waiting_for_ramp_clear
end

PacingManager._update_player_combat_state = function (self, dt, side_id)
	local settings = self._combat_state_settings
	local combat_states = settings.combat_states
	local low_threshold = settings.low_threshold
	local medium_threshold = settings.medium_threshold
	local high_threshold = settings.high_threshold
	local max_value = settings.max_value
	local base_decay_rate = settings.base_decay_rate
	local player_combat_states = self._player_combat_states
	local player_tension = self._player_tension
	local decay_tension_rate = self._decay_tension_rate
	local total_challenge_rating = self._total_challenge_rating
	local side = self._side_system:get_side(side_id)
	local valid_player_units = side.valid_player_units
	local num_valid_player_units = #valid_player_units
	local num_low = 0
	local num_high = 0
	local num_medium = 0

	for i = 1, num_valid_player_units do
		local player_unit = valid_player_units[i]
		local tension = player_tension[player_unit] or 0
		local new_tension = math.max(tension - dt * (base_decay_rate + decay_tension_rate), 0)
		player_tension[player_unit] = new_tension
		local value = math.clamp(total_challenge_rating + new_tension, 0, max_value)
		local current_combat_state = nil

		if low_threshold <= value and value < medium_threshold then
			current_combat_state = combat_states.low
			num_low = num_low + 1
		elseif medium_threshold <= value and value < high_threshold then
			current_combat_state = combat_states.medium
			num_medium = num_medium + 1
		elseif high_threshold <= value then
			current_combat_state = combat_states.high
			num_high = num_high + 1
		end

		player_combat_states[player_unit] = current_combat_state
	end

	if num_high == num_valid_player_units then
		self._current_combat_state = combat_states.high
	elseif num_medium == num_valid_player_units then
		self._current_combat_state = combat_states.medium
	elseif num_low == num_valid_player_units then
		self._current_combat_state = combat_states.low
	end

	local ALIVE = ALIVE

	for unit, _ in pairs(player_tension) do
		if not ALIVE[unit] then
			player_tension[unit] = nil
		end
	end
end

PacingManager._update_ramp_up_frequency = function (self, dt, t, target_side_id)
	local state = self._state
	local ramp_up_frequency_settings = self._ramp_up_frequency_settings
	local ramp_up_frequency_modifiers = self._ramp_up_frequency_modifiers
	local ramp_modifiers = ramp_up_frequency_settings.ramp_modifiers
	local traveled_this_frame = self._horde_pacing:traveled_this_frame()
	local ramp_up_states = ramp_up_frequency_settings.ramp_up_states

	if not ramp_up_states[state] or self._in_safe_zone then
		if self._current_ramp_up_duration then
			for spawn_type, max_modifier in pairs(ramp_modifiers) do
				ramp_up_frequency_modifiers[spawn_type] = 1
			end
		end

		self._current_ramp_up_duration = nil
		self._max_ramp_up_duration = nil

		return
	end

	local ramp_duration = ramp_up_frequency_settings.ramp_duration * self._ramp_duration_modifier

	if not self._current_ramp_up_duration then
		self._current_ramp_up_duration = ramp_duration
	else
		local travel_change_pause_time = ramp_up_frequency_settings.travel_change_pause_time
		local time_since_forward_travel_changed = Managers.state.main_path:time_since_forward_travel_changed(target_side_id)

		if time_since_forward_travel_changed < travel_change_pause_time then
			self._current_ramp_up_duration = math.max(self._current_ramp_up_duration - (dt + traveled_this_frame), 0)
		end
	end

	local ramp_up_percentage = math.min(1 - self._current_ramp_up_duration / ramp_duration, 1)

	if ramp_up_percentage == 1 and not self._max_ramp_up_duration then
		local max_duration = ramp_up_frequency_settings.max_duration
		self._max_ramp_up_duration = max_duration
	elseif self._max_ramp_up_duration then
		self._max_ramp_up_duration = math.max(self._max_ramp_up_duration - (dt + traveled_this_frame), 0)

		if self._max_ramp_up_duration <= 0 then
			if ramp_up_frequency_settings.wait_for_ramp_clear then
				if self._waiting_for_ramp_clear and self._wait_for_ramp_clear_reset_t and self._wait_for_ramp_clear_reset_t <= t then
					self._clear_ramp = true
					self._wait_for_ramp_clear_reset_t = nil
				end

				if not self._waiting_for_ramp_clear then
					self._waiting_for_ramp_clear = true
					self._waiting_for_ramp_clear_t = t
					local wait_for_ramp_clear_reset_range = self._ramp_up_frequency_settings.wait_for_ramp_clear_reset
					self._wait_for_ramp_clear_reset_t = t + math.random_range(wait_for_ramp_clear_reset_range[1], wait_for_ramp_clear_reset_range[2])
				elseif self._clear_ramp then
					self._current_ramp_up_duration = ramp_duration
					self._max_ramp_up_duration = nil
					self._waiting_for_ramp_clear = nil
					self._clear_ramp = nil
					self._waiting_for_ramp_clear_t = nil
				end
			else
				self._current_ramp_up_duration = ramp_duration
				self._max_ramp_up_duration = nil
				self._waiting_for_ramp_clear = nil
				self._clear_ramp = nil
				self._waiting_for_ramp_clear_t = nil
			end
		end
	end

	for spawn_type, max_modifier in pairs(ramp_modifiers) do
		local diff = math.abs(1 - max_modifier)
		ramp_up_frequency_modifiers[spawn_type] = 1 + diff * ramp_up_percentage
	end
end

PacingManager.get_ramp_up_frequency_modifier = function (self, spawn_type)
	return self._ramp_up_frequency_modifiers[spawn_type] or 1
end

PacingManager.player_unit_combat_state = function (self, player_unit)
	return self._player_combat_states[player_unit]
end

PacingManager.combat_state = function (self)
	return self._current_combat_state
end

PacingManager.state = function (self)
	return self._state
end

PacingManager._get_challenge_rating = function (self, unit)
	if self._saved_challenge_ratings[unit] then
		return self._saved_challenge_ratings[unit]
	end

	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()
	local challenge_rating = breed.challenge_rating

	if not challenge_rating then
		return
	end

	if breed.is_boss then
		local boss_extension = ScriptUnit.has_extension(unit, "boss_system")
		local is_weakened = boss_extension and boss_extension:is_weakened()

		if is_weakened then
			challenge_rating = challenge_rating * 0.2
		end
	end

	return challenge_rating
end

PacingManager.add_aggroed_minion = function (self, unit)
	local aggroed_minions = self._aggroed_minions

	if not aggroed_minions[unit] then
		local challenge_rating = self:_get_challenge_rating(unit)

		if challenge_rating then
			self._total_challenge_rating = math.max(math.round_with_precision(self._total_challenge_rating + challenge_rating, 2), 0)
			self._saved_challenge_ratings[unit] = challenge_rating
		end

		self._num_aggroed_minions = self._num_aggroed_minions + 1
		aggroed_minions[unit] = true

		self._side_system:add_aggroed_minion(unit)

		if self._in_safe_zone then
			self:pause_spawn_type("specials", false)
			self:pause_spawn_type("hordes", false)
			self:pause_spawn_type("trickle_hordes", false)
			self:set_in_safe_zone(false)
		end

		if self._first_aggro then
			local t = Managers.time:time("gameplay")
			self._state_entered_t = t
			self._low_state_entered_t = t
			self._first_aggro = nil
		end
	end
end

PacingManager.remove_aggroed_minion = function (self, unit)
	local aggroed_minions = self._aggroed_minions

	if aggroed_minions[unit] then
		local challenge_rating = self:_get_challenge_rating(unit)

		if challenge_rating then
			self._total_challenge_rating = math.max(math.round_with_precision(self._total_challenge_rating - challenge_rating, 2), 0)
		end

		self._num_aggroed_minions = self._num_aggroed_minions - 1
		aggroed_minions[unit] = nil
		self._saved_challenge_ratings[unit] = nil

		self._side_system:remove_aggroed_minion(unit)
	end

	self._minions_listening_for_player_deaths[unit] = nil
end

PacingManager.total_challenge_rating = function (self)
	return self._total_challenge_rating
end

PacingManager.num_aggroed_minions = function (self)
	return self._num_aggroed_minions
end

PacingManager.aggroed_minions = function (self)
	return self._aggroed_minions
end

PacingManager.num_aggroed_monsters = function (self)
	return self._monster_pacing:num_aggroed_monsters()
end

PacingManager.tension = function (self)
	return self._tension
end

PacingManager.add_monster_spawn_point = function (self, unit, position, path_position, travel_distance, section, spawn_type)
	local success = self._monster_pacing:add_spawn_point(unit, position, path_position, travel_distance, section, spawn_type)

	return success
end

PacingManager.add_trickle_horde = function (self, template)
	self._horde_pacing:add_trickle_horde(template)
end

PacingManager.set_horde_rate_modifier = function (self, horde_rate_modifier)
	self._horde_pacing:set_rate_modifier(horde_rate_modifier)
end

PacingManager.set_travel_distance_spawning_override = function (self, travel_distance_spawning)
	self._specials_pacing:set_travel_distance_spawning_override(travel_distance_spawning)
end

PacingManager.add_pacing_modifiers = function (self, modify_settings)
	local set_resistance = modify_settings.set_resistance

	if set_resistance then
		Managers.state.difficulty:set_resistance(set_resistance)
	end

	local set_challenge = modify_settings.set_challenge

	if set_challenge then
		Managers.state.difficulty:set_challenge(set_challenge)
	end

	local modify_resistance = modify_settings.modify_resistance

	if modify_resistance then
		Managers.state.difficulty:modify_resistance(modify_resistance)
	end

	local modify_challenge = modify_settings.modify_challenge

	if modify_challenge then
		Managers.state.difficulty:modify_challenge(modify_challenge)
	end

	local modify_challenge_resistance_scale = modify_settings.modify_challenge_resistance_scale

	if modify_challenge_resistance_scale then
		local challenge = Managers.state.difficulty:get_challenge()
		local new_challenge = modify_challenge_resistance_scale[challenge][1]
		local new_resistance = modify_challenge_resistance_scale[challenge][2]

		Managers.state.difficulty:set_challenge(new_challenge)
		Managers.state.difficulty:set_resistance(new_resistance)
	end

	local horde_timer_modifier = modify_settings.horde_timer_modifier

	if horde_timer_modifier then
		self._horde_pacing:set_timer_modifier(horde_timer_modifier)
	end

	local required_horde_travel_distance = modify_settings.required_horde_travel_distance

	if required_horde_travel_distance then
		self._horde_pacing:set_override_required_travel_distance(required_horde_travel_distance)
	end

	local specials_timer_modifier = modify_settings.specials_timer_modifier

	if specials_timer_modifier then
		self._specials_pacing:set_timer_modifier(specials_timer_modifier)
	end

	local max_alive_specials_multiplier = modify_settings.max_alive_specials_multiplier

	if max_alive_specials_multiplier then
		self._specials_pacing:set_max_alive_specials_multiplier(max_alive_specials_multiplier)
	end

	local chance_of_coordinated_strike = modify_settings.chance_of_coordinated_strike

	if chance_of_coordinated_strike then
		self._specials_pacing:set_chance_of_coordinated_strike(chance_of_coordinated_strike)
	end

	local specials_always_move_timer = modify_settings.specials_always_move_timer

	if specials_always_move_timer then
		self._specials_pacing:set_always_move_timer(specials_always_move_timer)
	end

	local specials_move_timer_when_challenge_rating_above = modify_settings.specials_move_timer_when_challenge_rating_above

	if specials_move_timer_when_challenge_rating_above then
		self._specials_pacing:set_move_timer_when_challenge_rating_above(specials_move_timer_when_challenge_rating_above)
	end

	local max_of_same_override = modify_settings.max_of_same_override

	if max_of_same_override then
		self._specials_pacing:set_max_of_same_override(max_of_same_override)
	end

	local monsters_per_travel_distance = modify_settings.monsters_per_travel_distance
	local monster_breed_name = modify_settings.monster_breed_name
	local monster_spawn_type = modify_settings.monster_spawn_type

	if monsters_per_travel_distance and monster_breed_name then
		self._monster_pacing:fill_spawns_by_travel_distance(monster_breed_name, monster_spawn_type, monsters_per_travel_distance)
	end

	local boss_patrols_per_travel_distance = modify_settings.boss_patrols_per_travel_distance

	if boss_patrols_per_travel_distance then
		self._monster_pacing:fill_boss_patrols_by_travel_distance(boss_patrols_per_travel_distance)
	end

	local override_faction = modify_settings.override_faction

	if override_faction then
		self._roamer_pacing:override_faction(override_faction)
	end

	local num_encampments_override = modify_settings.num_encampments_override
	local encampments_override_chance = modify_settings.encampments_override_chance

	if num_encampments_override and encampments_override_chance then
		self._roamer_pacing:num_encampments_override(num_encampments_override, encampments_override_chance)
	end

	local override_all_roamer_packs = modify_settings.override_all_roamer_packs

	if override_all_roamer_packs then
		self._roamer_pacing:override_all_roamer_packs(override_all_roamer_packs)
	end

	local override_num_roamer_range = modify_settings.override_num_roamer_range

	if override_num_roamer_range then
		self._roamer_pacing:override_num_roamer_range(override_num_roamer_range)
	end

	local override_roamer_packs = modify_settings.override_roamer_packs

	if override_roamer_packs then
		self._roamer_pacing:override_roamer_packs(override_roamer_packs)
	end

	local monster_health_modifier = modify_settings.monster_health_modifier

	if monster_health_modifier then
		self._monster_pacing:set_health_modifier(monster_health_modifier)
	end

	local override_trickle_horde_compositions = modify_settings.override_trickle_horde_compositions

	if override_trickle_horde_compositions then
		self._horde_pacing:override_trickle_horde_compositions(override_trickle_horde_compositions)
	end

	local replace_terror_event_tags = modify_settings.replace_terror_event_tags

	if replace_terror_event_tags then
		Managers.state.terror_event:replace_terror_event_tags(replace_terror_event_tags)
	end

	local specials_required_challenge_rating = modify_settings.specials_required_challenge_rating

	if specials_required_challenge_rating then
		self._specials_pacing:set_required_challenge_rating(specials_required_challenge_rating)
	end

	local specials_monster_spawn_config = modify_settings.specials_monster_spawn_config

	if specials_monster_spawn_config then
		self._specials_pacing:set_monster_spawn_config(specials_monster_spawn_config)
	end

	local num_monsters_override = modify_settings.num_monsters_override

	if num_monsters_override then
		self._monster_pacing:set_num_monsters_override(num_monsters_override)
	end

	local num_witches_override = modify_settings.num_witches_override

	if num_witches_override then
		self._monster_pacing:set_num_witches_override(num_witches_override)
	end

	local num_boss_patrol_override = modify_settings.num_boss_patrol_override

	if num_boss_patrol_override then
		self._monster_pacing:set_num_boss_patrol_override(num_boss_patrol_override)
	end

	local tag_limit_bonus = modify_settings.tag_limit_bonus

	if tag_limit_bonus then
		self:set_roamer_tag_limit_bonus(tag_limit_bonus)
	end

	local terror_event_point_multiplier = modify_settings.terror_event_point_multiplier

	if terror_event_point_multiplier then
		Managers.state.terror_event:set_terror_event_point_modifier(terror_event_point_multiplier)
	end

	local override_allowed_spawn_types = modify_settings.override_allowed_spawn_types

	if override_allowed_spawn_types then
		self:override_allowed_spawn_types(override_allowed_spawn_types)
	end

	local tension_modifier = modify_settings.tension_modifier

	if tension_modifier then
		self._tension_modifier = tension_modifier
	end

	local ramp_duration_modifier = modify_settings.ramp_duration_modifier

	if ramp_duration_modifier then
		self._ramp_duration_modifier = ramp_duration_modifier
	end

	local is_auric = modify_settings.is_auric

	if is_auric then
		self._is_auric = is_auric
	end
end

PacingManager.aggro_roamer_zone_range = function (self, target_unit, range)
	self._roamer_pacing:aggro_zone_range(target_unit, range)
end

PacingManager.allow_nav_tag_layer = function (self, layer_name, layer_allowed)
	local roamer_pacing = self._roamer_pacing

	if roamer_pacing:is_traverse_logic_initialized() then
		roamer_pacing:allow_nav_tag_layer(layer_name, layer_allowed)
	end
end

PacingManager.start_terror_trickle = function (self, template_name, spawner_group)
	self._horde_pacing:start_terror_trickle(template_name, spawner_group)
end

PacingManager.is_decaying_tension = function (self)
	return self._is_decaying_tension
end

PacingManager.current_faction = function (self)
	return self._roamer_pacing:current_faction()
end

PacingManager.current_density_type = function (self)
	return self._roamer_pacing:current_density_type()
end

PacingManager.try_inject_special = function (self, breed_name, optional_prefered_spawn_direction, optional_target_unit, optional_spawner_group)
	self._specials_pacing:try_inject_special(breed_name, optional_prefered_spawn_direction, optional_target_unit, optional_spawner_group)
end

PacingManager.refund_special_slot = function (self)
	return self._specials_pacing:refund_special_slot()
end

PacingManager.freeze_specials_pacing = function (self, enabled)
	self._specials_pacing:freeze(enabled)

	self._frozen_spawn_types.specials = enabled
end

PacingManager.roamer_traverse_logic = function (self)
	return self._roamer_pacing:traverse_logic()
end

PacingManager.set_roamer_tag_limit_bonus = function (self, tag_limit_bonus)
	return self._roamer_pacing:set_tag_limit_bonus(tag_limit_bonus)
end

PacingManager.get_backend_pacing_control_flag = function (self, flag)
	return self._backend_pacing_control and self._backend_pacing_control[flag]
end

PacingManager.activate_hard_mode = function (self)
	self._hard_mode = true

	Managers.telemetry_events:hard_mode_activated()
end

PacingManager.has_hard_mode = function (self)
	return self._hard_mode
end

PacingManager.is_auric = function (self)
	return self._is_auric
end

PacingManager.set_minion_listening_for_player_deaths = function (self, unit, statistics_component, set)
	if set then
		self._minions_listening_for_player_deaths[unit] = statistics_component
	else
		self._minions_listening_for_player_deaths[unit] = nil
	end
end

PacingManager.get_minions_listening_for_player_deaths = function (self)
	return self._minions_listening_for_player_deaths
end

PacingManager.set_specials_timing_multiplier = function (self, modifier)
	return self._specials_pacing:set_timer_multiplier(modifier)
end

PacingManager.set_specials_force_move_timer = function (self, should_force_move_timer)
	return self._specials_pacing:set_force_move_timer(should_force_move_timer)
end

PacingManager.set_ramp_up_enabled = function (self, is_enabled)
	self._ramp_up_enabled = is_enabled
end

PacingManager.force_coordinated_special_strike = function (self, timer, num_breeds)
	self._specials_pacing:force_coordinated_strike(timer, num_breeds)
end

PacingManager.state_duration = function (self)
	if not self._state_entered_t then
		return 0
	end

	local t = Managers.time:time("gameplay")
	local state_duration = t - self._state_entered_t

	return state_duration
end

PacingManager.low_state_duration = function (self)
	if not self._low_state_entered_t then
		return 0
	end

	local t = Managers.time:time("gameplay")
	local state_duration = t - self._low_state_entered_t

	return state_duration
end

PacingManager.set_specials_pacing_spawner_groups = function (self, spawner_groups)
	self._specials_pacing:set_spawner_groups(spawner_groups)
end

PacingManager.reset_specials_pacing_spawner_groups = function (self)
	self._specials_pacing:set_spawner_groups(nil)
end

PacingManager.remove_monsters_behind_pos = function (self, pos)
	self._monster_pacing:remove_monsters_behind_pos(pos)
end

PacingManager.reset_traveled_this_frame = function (self)
	self._horde_pacing:reset_traveled_this_frame()
	self._specials_pacing:reset_traveled_this_frame()
end

return PacingManager
