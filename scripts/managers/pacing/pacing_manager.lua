local HordePacing = require("scripts/managers/pacing/horde_pacing/horde_pacing")
local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local MonsterPacing = require("scripts/managers/pacing/monster_pacing/monster_pacing")
local PacingTemplates = require("scripts/managers/pacing/pacing_templates")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local RoamerPacing = require("scripts/managers/pacing/roamer_pacing/roamer_pacing")
local SpecialsPacing = require("scripts/managers/pacing/specials_pacing/specials_pacing")
local PacingManager = class("PacingManager")

PacingManager.init = function (self, world, nav_world, level_name, level_seed)
	self._tension = 0
	self._total_challenge_rating = 0
	self._num_aggroed_minions = 0
	self._aggroed_minions = {}
	self._switch_state_conditions = {
		back = {},
		next = {}
	}
	self._world = world
	local template = PacingTemplates.default
	self._template = template
	self._roamer_pacing = RoamerPacing:new(nav_world, level_name, level_seed)
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
end

PacingManager.on_gameplay_post_init = function (self, level_name)
	local template = self._template
	local combat_state_settings = Managers.state.difficulty:get_table_entry_by_resistance(template.combat_state_settings)
	self._combat_state_settings = combat_state_settings
	local state_settings = Managers.state.difficulty:get_table_entry_by_resistance(template.state_settings)
	self._state_settings = state_settings
	local starting_state = template.starting_state
	self._next_state = starting_state
	self._state_orders = template.state_orders

	self:_change_state(0, starting_state)

	self._max_tension = Managers.state.difficulty:get_table_entry_by_resistance(template.max_tension)
	local challenge_rating_thresholds = {}

	for spawn_type, resistance_table in pairs(template.challenge_rating_thresholds) do
		challenge_rating_thresholds[spawn_type] = Managers.state.difficulty:get_table_entry_by_resistance(resistance_table)
	end

	self._challenge_rating_thresholds = challenge_rating_thresholds

	self._roamer_pacing:on_gameplay_post_init(level_name)

	local horde_resistance_templates = template.horde_pacing_template.resistance_templates
	local horde_pacing_template = Managers.state.difficulty:get_table_entry_by_resistance(horde_resistance_templates)

	self._horde_pacing:on_gameplay_post_init(level_name, horde_pacing_template)

	local monster_resistance_templates = template.monster_pacing_template.resistance_templates
	local monster_resistance_template = Managers.state.difficulty:get_table_entry_by_resistance(monster_resistance_templates)

	self._monster_pacing:on_gameplay_post_init(level_name, monster_resistance_template)

	local main_path_available = Managers.state.main_path:is_main_path_available()
	local cinematic_playing = Managers.state.cinematic:is_playing()
	local cinematic_scene_system = Managers.state.extension:system("cinematic_scene_system")
	self._disabled = not main_path_available or cinematic_playing or not cinematic_scene_system:intro_played()

	Managers.event:register(self, "intro_cinematic_started", "_event_intro_cinematic_started")
	Managers.event:register(self, "intro_cinematic_played", "_event_intro_cinematic_played")
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
	self._allowed_spawn_types = allowed_spawn_types
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

PacingManager.set_enabled = function (self, enabled)
	self._disabled = not enabled
end

PacingManager._event_intro_cinematic_started = function (self, cinematic_name)
	self._disabled = true
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
	local diff_table = MinionDifficultySettings.tension_to_add[tension_type]
	local value = Managers.state.difficulty:get_table_entry_by_challenge(diff_table)

	self:add_tension(value, attacked_unit, tension_type)
end

PacingManager.player_tension = function (self, unit)
	local settings = self._combat_state_settings
	local max_value = settings.max_value
	local tension = self._player_tension[unit] or 0
	local value = tension / max_value

	return value
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

PacingManager.player_unit_combat_state = function (self, player_unit)
	return self._player_combat_states[player_unit]
end

PacingManager.combat_state = function (self)
	return self._current_combat_state
end

PacingManager.state = function (self)
	return self._state
end

PacingManager.add_aggroed_minion = function (self, unit)
	local aggroed_minions = self._aggroed_minions

	if not aggroed_minions[unit] then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local challenge_rating = unit_data_extension:breed().challenge_rating

		if challenge_rating then
			self._total_challenge_rating = self._total_challenge_rating + challenge_rating
		end

		self._num_aggroed_minions = self._num_aggroed_minions + 1
		aggroed_minions[unit] = true

		self._side_system:add_aggroed_minion(unit)
	end
end

PacingManager.remove_aggroed_minion = function (self, unit)
	local aggroed_minions = self._aggroed_minions

	if aggroed_minions[unit] then
		local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
		local challenge_rating = unit_data_extension:breed().challenge_rating

		if challenge_rating then
			self._total_challenge_rating = self._total_challenge_rating - challenge_rating
		end

		self._num_aggroed_minions = self._num_aggroed_minions - 1
		aggroed_minions[unit] = nil

		self._side_system:remove_aggroed_minion(unit)
	end
end

PacingManager.total_challenge_rating = function (self)
	return self._total_challenge_rating
end

PacingManager.num_aggroed_minions = function (self)
	return self._num_aggroed_minions
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

PacingManager.add_pacing_modifiers = function (self, modify_settings)
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

	local monsters_per_travel_distance = modify_settings.monsters_per_travel_distance
	local monster_breed_name = modify_settings.monster_breed_name
	local monster_spawn_type = modify_settings.monster_spawn_type

	if monsters_per_travel_distance and monster_breed_name then
		self._monster_pacing:fill_spawns_by_travel_distance(monster_breed_name, monster_spawn_type, monsters_per_travel_distance)
	end

	local override_faction = modify_settings.override_faction

	if override_faction then
		self._roamer_pacing:override_faction(override_faction)
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

PacingManager.freeze_specials_pacing = function (self, enabled)
	self._specials_pacing:freeze(enabled)
end

PacingManager.roamer_traverse_logic = function (self)
	return self._roamer_pacing:traverse_logic()
end

return PacingManager
