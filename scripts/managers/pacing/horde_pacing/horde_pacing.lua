local HordeSettings = require("scripts/settings/horde/horde_settings")
local HordeTemplates = require("scripts/managers/horde/horde_templates")
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
	local travel_distance_required_for_horde = template.travel_distance_required_for_horde
	self._required_travel_distance = math.random_range(travel_distance_required_for_horde[1], travel_distance_required_for_horde[2])

	self:_setup_next_horde(template, first_spawn_timer_modifer)

	self._trickle_hordes = {}

	self:add_trickle_horde(template)

	self._template = template
	self._current_wave = 0
	self._triggered_hordes = 0
end

HordePacing.update = function (self, dt, t, side_id, target_side_id)
	self:_update_horde_pacing(t, dt, side_id, target_side_id)
	self:_update_trickle_horde_pacing(t, dt, side_id, target_side_id)
end

local HORDE_FAILED_WAIT_TIME = 3

HordePacing._update_horde_pacing = function (self, t, dt, side_id, target_side_id)
	local horde_manager = Managers.state.horde
	local num_active_hordes = 0

	for horde_type, _ in pairs(HORDE_TYPES) do
		if horde_type ~= "trickle_horde" then
			num_active_hordes = num_active_hordes + horde_manager:num_active_hordes(horde_type)
		end
	end

	local template = self._template
	local max_active_hordes = template.max_active_hordes
	local total_minions_spawned = Managers.state.minion_spawn:num_spawned_minions()
	local minion_spawn_limit_reached = template.max_active_minions <= total_minions_spawned
	local hordes_allowed = not minion_spawn_limit_reached and (self._current_wave > 0 or Managers.state.pacing:spawn_type_enabled("hordes"))
	local main_path_manager = Managers.state.main_path
	local furthest_travel_distance = main_path_manager:furthest_travel_distance(target_side_id)
	local traveled_this_frame = furthest_travel_distance - self._old_furthest_travel_distance
	self._old_furthest_travel_distance = furthest_travel_distance
	local allowed_hordes_per_travel_distance = math.ceil(furthest_travel_distance / self._required_travel_distance) - self._triggered_hordes

	if hordes_allowed and num_active_hordes < max_active_hordes and allowed_hordes_per_travel_distance > 0 then
		local current_wave = self._current_wave
		self._horde_timer = self._horde_timer + dt + traveled_this_frame

		if self._next_horde_pre_stinger_at and self._next_horde_pre_stinger_at <= self._horde_timer then
			self:_trigger_pre_stinger(template)

			self._next_horde_pre_stinger_at = nil
		end

		if self._next_horde_at <= self._horde_timer then
			local success, horde_position, target_unit, group_id = self:_start_horde_wave(template, side_id, target_side_id)

			if success then
				self._current_wave = current_wave + 1

				if self._current_wave == 1 then
					self:_trigger_stinger(template, horde_position)

					local aggro_nearby_roamers_zone_range = template.aggro_nearby_roamers_zone_range

					if aggro_nearby_roamers_zone_range then
						Managers.state.pacing:aggro_roamer_zone_range(target_unit, aggro_nearby_roamers_zone_range)
					end

					local trigger_heard_dialogue = template.trigger_heard_dialogue

					if trigger_heard_dialogue and success then
						Vo.heard_horde(target_unit)
					end
				end

				local group_system = Managers.state.extension:system("group_system")
				local horde_group_sound_event_names = template.horde_group_sound_events[self._current_compositions.name]
				local start_event = horde_group_sound_event_names.start
				local stop_event = horde_group_sound_event_names.stop

				group_system:start_group_sfx(group_id, start_event, stop_event)

				local num_waves = template.num_waves[self._current_horde_type]

				if self._current_wave < num_waves then
					self._next_horde_at = template.time_between_waves
				else
					self._current_wave = 0

					self:_setup_next_horde(template)

					self._triggered_hordes = self._triggered_hordes + 1
				end
			else
				self._next_horde_at = HORDE_FAILED_WAIT_TIME
			end

			self._horde_timer = 0
		end
	end
end

HordePacing._start_horde_wave = function (self, template, side_id, target_side_id)
	local current_wave = self._current_wave
	local horde_template = self._current_horde_template
	local horde_type = self._current_horde_type
	local compositions = Managers.state.difficulty:get_table_entry_by_resistance(self._current_compositions)
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
	self._trickle_hordes[#self._trickle_hordes + 1] = trickle_horde
end

HordePacing.set_timer_modifier = function (self, modifier)
	self._timer_modifier = modifier
	self._next_horde_at = self._next_horde_at * modifier
	local pre_stinger_delay = self._template.pre_stinger_delays[self._current_horde_type]
	self._next_horde_pre_stinger_at = self._next_horde_at - pre_stinger_delay
end

HordePacing._trigger_pre_stinger = function (self, template)
	local stinger_sound_event = template.pre_stinger_sound_events[self._current_compositions.name]

	if not stinger_sound_event then
		return
	end

	self._fx_system:trigger_wwise_event(stinger_sound_event)
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

	for i = 1, #trickle_hordes, 1 do
		repeat
			local trickle_horde = trickle_hordes[i]
			local cooldown = trickle_horde.cooldown
			local template = trickle_horde.template
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

			local trickle_hordes_allowed = Managers.state.pacing:spawn_type_enabled("trickle_hordes")

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
				local success = false

				if trickle_hordes_allowed then
					local trickle_horde_template = HordeTemplates.trickle_horde
					local trickle_horde_compositions = template.horde_compositions.trickle_horde
					local current_faction = Managers.state.pacing:current_faction()
					local current_density_type = Managers.state.pacing:current_density_type()
					local faction_composition = trickle_horde_compositions[current_faction][current_density_type]
					local chosen_compositions = faction_composition[math.random(1, #faction_composition)]
					local resistance_scaled_composition = Managers.state.difficulty:get_table_entry_by_resistance(chosen_compositions)
					local optional_main_path_offset = template.optional_main_path_offset
					success = self:_spawn_horde(HORDE_TYPES.trickle_horde, trickle_horde_template, resistance_scaled_composition, side_id, target_side_id, optional_main_path_offset)
				end

				local trickle_horde_travel_distance_range = (success and template.trickle_horde_travel_distance_range) or FAILED_TRAVEL_RANGE
				local next_trickle_horde_at = math.random_range(trickle_horde_travel_distance_range[1], trickle_horde_travel_distance_range[2])
				trickle_horde.next_trickle_horde_travel_distance_trigger = next_trickle_horde_at
				trickle_horde.trickle_horde_travel_distance = 0
			end
		until true
	end
end

HordePacing._spawn_horde = function (self, horde_type, horde_template, composition, side_id, target_side_id, optional_main_path_offset)
	local main_path_available = Managers.state.main_path:is_main_path_available()

	if (horde_template.requires_main_path and main_path_available) or not horde_template.requires_main_path then
		local horde_manager = Managers.state.horde
		local towards_combat_vector = true
		local success, horde_position, target_unit, group_id = horde_manager:horde(horde_type, horde_template.name, side_id, target_side_id, composition, towards_combat_vector, optional_main_path_offset)

		return success, horde_position, target_unit, group_id
	end
end

return HordePacing
