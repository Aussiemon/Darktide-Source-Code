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
	self._old_furthest_travel_distance = 0
end

HordePacing.on_gameplay_post_init = function (self, level, template)
	local template_first_spawn_timer_modifer = math.random_range(template.first_spawn_timer_modifer[1], template.first_spawn_timer_modifer[2])
	local first_spawn_timer_modifer = template_first_spawn_timer_modifer and self._timer_modifier * template_first_spawn_timer_modifer
	self._horde_timer = 0

	self:_setup_next_horde(template, first_spawn_timer_modifer)

	self._trickle_hordes = {}

	self:add_trickle_horde(template)

	self._template = template
	self._current_wave = 0
	self._triggered_hordes = 0
	self._total_num_long_hordes = 0

	if template.long_horde_settings then
		local num_long_hordes_allowed = template.long_horde_settings.total_num_long_hordes_allowed
		self._total_num_long_hordes_allowed = math.random(num_long_hordes_allowed[1], num_long_hordes_allowed[2])
	end
end

HordePacing.update = function (self, dt, t, side_id, target_side_id)
	self:_update_horde_pacing(t, dt, side_id, target_side_id)
	self:_update_trickle_horde_pacing(t, dt, side_id, target_side_id)
end

local HORDE_FAILED_WAIT_TIME = 3
local TRAVEL_DISTANCE_CHANGE_ALLOWANCE_MIN = 5
local TRAVEL_DISTANCE_CHANGE_ALLOWANCE_MAX = 8

HordePacing._update_horde_pacing = function (self, t, dt, side_id, target_side_id)
	local horde_manager = Managers.state.horde
	local num_active_hordes = 0

	for horde_type, _ in pairs(HORDE_TYPES) do
		if horde_type ~= "trickle_horde" then
			num_active_hordes = num_active_hordes + horde_manager:num_active_hordes(horde_type)
		end
	end

	local template = self._template
	local max_active_hordes = type(template.max_active_hordes) == "table" and template.max_active_hordes[self._current_horde_type] or template.max_active_hordes
	local total_minions_spawned = Managers.state.minion_spawn:num_spawned_minions()
	local minion_spawn_limit_reached = template.max_active_minions <= total_minions_spawned
	local main_path_manager = Managers.state.main_path
	local pacing_manager = Managers.state.pacing
	local furthest_travel_distance = main_path_manager:furthest_travel_distance(target_side_id)
	local allowed_hordes_per_travel_distance = math.ceil(furthest_travel_distance / self._required_travel_distance) - self._triggered_hordes
	local num_hordes_limit_reached = max_active_hordes <= num_active_hordes
	local hordes_enabled = pacing_manager:spawn_type_enabled("hordes") and allowed_hordes_per_travel_distance > 0 and not num_hordes_limit_reached
	local time_since_forward_travel_changed = main_path_manager:time_since_forward_travel_changed(target_side_id)
	local travel_distance_allowed = time_since_forward_travel_changed < TRAVEL_DISTANCE_CHANGE_ALLOWANCE_MIN or TRAVEL_DISTANCE_CHANGE_ALLOWANCE_MAX < time_since_forward_travel_changed
	local triggered_pre_stinger = self._triggered_pre_stinger
	local current_wave = self._current_wave
	local horde_started = triggered_pre_stinger or current_wave > 0
	local hordes_allowed = not num_hordes_limit_reached and horde_started or not minion_spawn_limit_reached and hordes_enabled and travel_distance_allowed
	local traveled_this_frame = furthest_travel_distance - self._old_furthest_travel_distance
	self._old_furthest_travel_distance = furthest_travel_distance

	if not hordes_allowed then
		return
	end

	local ramp_up_timer_modifier = pacing_manager:_get_ramp_up_frequency_modifier("hordes")
	local has_monster_active = pacing_manager:num_aggroed_monsters() > 0
	local has_travel_distance_spawn_mutator = not has_monster_active and (template.travel_distance_spawning or Managers.state.mutator:mutator("mutator_travel_distance_spawning_hordes"))

	if has_travel_distance_spawn_mutator and not horde_started then
		self._horde_timer = self._horde_timer + traveled_this_frame * ramp_up_timer_modifier
	else
		self._horde_timer = self._horde_timer + dt * ramp_up_timer_modifier
	end

	if self._next_horde_pre_stinger_at and self._next_horde_pre_stinger_at <= self._horde_timer then
		self:_trigger_pre_stinger(template, target_side_id)

		self._next_horde_pre_stinger_at = nil
		self._triggered_pre_stinger = true
	end

	if self._next_horde_at <= self._horde_timer then
		local success, horde_position, target_unit, group_id = self:_start_horde_wave(template, side_id, target_side_id)

		if success then
			self._current_wave = current_wave + 1

			if self._current_wave == 1 then
				self:_trigger_stinger(template, horde_position)

				local aggro_nearby_roamers_zone_range = template.aggro_nearby_roamers_zone_range

				if aggro_nearby_roamers_zone_range then
					pacing_manager:aggro_roamer_zone_range(target_unit, aggro_nearby_roamers_zone_range)
				end

				local trigger_heard_dialogue = template.trigger_heard_dialogue

				if trigger_heard_dialogue and success then
					Vo.heard_horde(target_unit, self._current_horde_type)
				end

				local long_horde_settings = template.long_horde_settings
				local long_horde_chance = long_horde_settings and long_horde_settings.chances[self._current_horde_type]

				if long_horde_chance then
					local total_num_long_hordes = self._total_num_long_hordes

					if total_num_long_hordes < self._total_num_long_hordes_allowed and math.random() < long_horde_chance then
						self._long_horde = true
						self._total_num_long_hordes = self._total_num_long_hordes + 1
					else
						self._long_horde = false
					end
				end
			end

			local group_system = Managers.state.extension:system("group_system")
			local group = group_system:group_from_id(group_id)
			local horde_group_sound_event_names = template.horde_group_sound_events[self._current_compositions.name]
			local start_event = horde_group_sound_event_names.start
			local stop_event = horde_group_sound_event_names.stop
			group.group_start_sound_event = start_event
			group.group_stop_sound_event = stop_event
			local num_waves = nil

			if self._long_horde then
				local long_horde_waves = template.long_horde_settings.num_waves[self._current_horde_type]
				num_waves = math.random(long_horde_waves[1], long_horde_waves[2])
			else
				num_waves = template.num_waves[self._current_horde_type]
			end

			if self._current_wave < num_waves then
				self._next_horde_at = template.time_between_waves
			else
				self._current_wave = 0

				self:_setup_next_horde(template)

				self._triggered_pre_stinger = nil
				self._triggered_hordes = self._triggered_hordes + 1
			end
		else
			self._next_horde_at = HORDE_FAILED_WAIT_TIME
		end

		self._horde_timer = 0
	end
end

HordePacing._start_horde_wave = function (self, template, side_id, target_side_id)
	local current_wave = self._current_wave
	local horde_template = self._current_horde_template
	local horde_type = self._current_horde_type
	local compositions = Managers.state.difficulty:get_table_entry_by_challenge(self._current_compositions)
	local success, horde_position, target_unit, group_id = self:_spawn_horde(horde_type, horde_template, compositions, side_id, target_side_id)

	if success then
		Managers.server_metrics:add_annotation("start_horde_wave", {
			horde_type = horde_type,
			current_wave = current_wave + 1,
			num_weaves = template.num_waves[horde_type]
		})
	end

	return success, horde_position, target_unit, group_id
end

HordePacing._setup_next_horde = function (self, template, optional_timer_modifier)
	local templates = template.horde_templates
	local horde_compositions = template.horde_compositions
	local total_minions_spawned = Managers.state.minion_spawn:num_spawned_minions()
	local limit_reached_for_ambush_horde = template.max_active_minions_for_ambush <= total_minions_spawned
	local horde_template = nil

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

HordePacing._trigger_stinger = function (self, template, position)
	local stinger_sound_event = template.stinger_sound_events[self._current_compositions.name]

	if not stinger_sound_event then
		return
	end

	self._fx_system:trigger_wwise_event(stinger_sound_event, position)
end

local FAILED_TRAVEL_RANGE = {
	10,
	20
}

HordePacing._update_trickle_horde_pacing = function (self, t, dt, side_id, target_side_id)
	local main_path_manager = Managers.state.main_path
	local furthest_travel_distance = main_path_manager:furthest_travel_distance(target_side_id)
	local trickle_hordes = self._trickle_hordes

	for i = 1, #trickle_hordes do
		repeat
			local trickle_horde = trickle_hordes[i]

			if trickle_horde.stinger_duration and t < trickle_horde.stinger_duration then
				break
			end

			local template = trickle_horde.template

			if trickle_horde.num_waves then
				if trickle_horde.next_wave_at_t < t then
					local optional_main_path_offset = template.optional_main_path_offset
					local optional_num_tries = template.optional_num_tries

					self:_spawn_trickle_horde_wave(side_id, target_side_id, optional_main_path_offset, optional_num_tries, template, trickle_horde, t)

					trickle_horde.num_waves = trickle_horde.num_waves - 1

					if trickle_horde.num_waves > 0 then
						trickle_horde.next_wave_at_t = t + math.random_range(template.time_between_waves[1], template.time_between_waves[2])
					else
						trickle_horde.num_waves = nil
						trickle_horde.next_wave_at_t = nil
					end
				end
			else
				local cooldown = trickle_horde.cooldown
				local horde_manager = Managers.state.horde
				local num_active_trickle_hordes = horde_manager:num_active_hordes(HORDE_TYPES.trickle_horde)
				local should_trigger_cooldown = template.num_trickle_hordes_active_for_cooldown <= num_active_trickle_hordes

				if should_trigger_cooldown and t < cooldown then
					break
				elseif should_trigger_cooldown then
					trickle_horde.cooldown = t + math.random(template.trickle_horde_cooldown[1], template.trickle_horde_cooldown[2])

					break
				elseif not should_trigger_cooldown then
					trickle_horde.cooldown = 0
				end

				local trickle_hordes_allowed = (Managers.state.pacing:spawn_type_enabled("trickle_hordes") or template.ignore_disallowance) and (not template.not_during_terror_events or Managers.state.terror_event:num_active_events() == 0)

				if trickle_horde.current_travel_distance < furthest_travel_distance then
					local diff = furthest_travel_distance - trickle_horde.current_travel_distance
					trickle_horde.current_travel_distance = furthest_travel_distance

					if trickle_hordes_allowed then
						trickle_horde.trickle_horde_travel_distance = trickle_horde.trickle_horde_travel_distance + diff
					else
						trickle_horde.trickle_horde_travel_distance = trickle_horde.trickle_horde_travel_distance + diff
						trickle_horde.next_trickle_horde_travel_distance_trigger = trickle_horde.next_trickle_horde_travel_distance_trigger + diff
					end
				end

				if trickle_horde.next_trickle_horde_travel_distance_trigger <= trickle_horde.trickle_horde_travel_distance then
					local success, horde_position, target_unit, group_id = nil

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

						trickle_hordes_allowed = template.min_players_alive <= num_non_disabled_players
					end

					if trickle_hordes_allowed then
						local trickle_horde_template = HordeTemplates.trickle_horde
						local trickle_horde_compositions = self._override_trickle_horde_compositions or template.horde_compositions.trickle_horde
						local current_faction = Managers.state.pacing:current_faction()
						local current_density_type = Managers.state.pacing:current_density_type()
						local faction_composition = trickle_horde_compositions[current_faction][current_density_type]
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
								end
							end
						end
					end

					local trickle_horde_travel_distance_range = success and template.trickle_horde_travel_distance_range or FAILED_TRAVEL_RANGE
					local next_trickle_horde_at = math.random_range(trickle_horde_travel_distance_range[1], trickle_horde_travel_distance_range[2])
					trickle_horde.next_trickle_horde_travel_distance_trigger = next_trickle_horde_at
					trickle_horde.trickle_horde_travel_distance = 0
				end
			end
		until true
	end
end

HordePacing._spawn_horde = function (self, horde_type, horde_template, composition, side_id, target_side_id, optional_main_path_offset, optional_num_tries)
	local main_path_available = Managers.state.main_path:is_main_path_available()

	if horde_template.requires_main_path and main_path_available or not horde_template.requires_main_path then
		local horde_manager = Managers.state.horde
		local towards_combat_vector = true
		local success, horde_position, target_unit, group_id = horde_manager:horde(horde_type, horde_template.name, side_id, target_side_id, composition, towards_combat_vector, optional_main_path_offset, optional_num_tries)

		return success, horde_position, target_unit, group_id
	end
end

HordePacing._spawn_trickle_horde_wave = function (self, side_id, target_side_id, optional_main_path_offset, optional_num_tries, template, trickle_horde, t)
	local trickle_horde_template = HordeTemplates.trickle_horde
	local trickle_horde_compositions = self._override_trickle_horde_compositions or template.horde_compositions.trickle_horde
	local current_faction = Managers.state.pacing:current_faction()
	local current_density_type = Managers.state.pacing:current_density_type()
	local faction_composition = trickle_horde_compositions[current_faction][current_density_type]
	local chosen_compositions = faction_composition[math.random(1, #faction_composition)]
	local resistance_scaled_composition = Managers.state.difficulty:get_table_entry_by_resistance(chosen_compositions)
	local success, horde_position, target_unit, group_id = self:_spawn_horde(HORDE_TYPES.trickle_horde, trickle_horde_template, resistance_scaled_composition, side_id, target_side_id, optional_main_path_offset, optional_num_tries)

	if success then
		local horde_group_sound_event_names = template.group_sound_event_names
		local group_system = Managers.state.extension:system("group_system")
		local group = group_system:group_from_id(group_id)

		if horde_group_sound_event_names then
			local start_event = horde_group_sound_event_names.start
			local stop_event = horde_group_sound_event_names.stop
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

		local spawn_max_health_modifier = template.spawn_max_health_modifier

		if spawn_max_health_modifier then
			local members = group.members

			for j = 1, #members do
				local unit = members[j]
				local spawned_unit_health_extension = ScriptUnit.extension(unit, "health_system")
				local max_health = spawned_unit_health_extension:max_health()

				spawned_unit_health_extension:add_damage(max_health * spawn_max_health_modifier)
			end
		end

		local stimmed_config = self._stimmed_config

		if stimmed_config then
			local chance_to_stim = stimmed_config.chance_to_stim

			if math.random() < chance_to_stim then
				local stim_buff_name = stimmed_config.buff_name
				local members = group.members

				for j = 1, #members do
					local unit = members[j]
					local buff_extension = ScriptUnit.extension(unit, "buff_system")

					if not buff_extension:has_keyword("stimmed") then
						buff_extension:add_internally_controlled_buff(stim_buff_name, t)
					end
				end
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

HordePacing.set_stimmed_config = function (self, stimmed_config)
	self._stimmed_config = stimmed_config
end

return HordePacing
