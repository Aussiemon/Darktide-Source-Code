-- chunkname: @scripts/utilities/phases/boss_phase_utilities.lua

local boss_phase_uilities = {}
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local NavQueries = require("scripts/utilities/nav_queries")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local CURRENT_POSITIONS = {}
local radius, min_distance = 20, 8
local RANDOM_POSITION_ABOVE, RANDOM_POSITION_BELOW = 30, 30
local RANDOM_POSITION_HORIZONTAL_SEARCH = 8
local DEFAULT_PHASE_DAMAGE_OVERSHOOT = 0.1
local DEFAULT_OVERDAMAGE_SOFT_MULTIPLIER = 0.05
local _check_distance_against_optional_targets

boss_phase_uilities.get_random_position_in_radius = function (scratchpad, optional_dissalow_postion_near_players, optional_disallowed_positions, optional_min_distance)
	local boss_unit = scratchpad.boss_unit
	local boss_position = POSITION_LOOKUP[boss_unit]
	local center_position = scratchpad.positions.center:unbox()

	if min_distance >= radius + Vector3.distance(center_position, boss_position) then
		return nil
	end

	local navigation_extension = ScriptUnit.extension(boss_unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()

	if optional_dissalow_postion_near_players then
		table.clear(CURRENT_POSITIONS)

		local side_system = Managers.state.extension:system("side_system")
		local player_side = side_system:get_side(1)
		local valid_player_positions = player_side.valid_player_units_positions

		for i = 1, #valid_player_positions do
			local player_position = valid_player_positions[i]

			CURRENT_POSITIONS[#CURRENT_POSITIONS + 1] = player_position
		end

		CURRENT_POSITIONS[#CURRENT_POSITIONS + 1] = boss_position
	end

	local max_attempts = 50
	local attempts = 0

	while attempts < max_attempts do
		attempts = attempts + 1

		local r = radius * math.sqrt(math.random())
		local theta = math.random() * math.two_pi
		local offset_x = r * math.cos(theta)
		local offset_y = r * math.sin(theta)
		local new_position = Vector3(center_position.x + offset_x, center_position.y + offset_y, center_position.z)
		local position_valid

		if optional_dissalow_postion_near_players or optional_disallowed_positions then
			local positions_to_check = optional_dissalow_postion_near_players and CURRENT_POSITIONS or optional_disallowed_positions

			position_valid = _check_distance_against_optional_targets(new_position, positions_to_check, optional_min_distance)
		else
			local dist_sq = Vector3.distance_squared(new_position, boss_position)
			local min_dist_sq = min_distance * min_distance

			position_valid = min_dist_sq <= dist_sq
		end

		if position_valid then
			local position_on_navmesh = NavQueries.position_on_mesh_guaranteed(nav_world, new_position, RANDOM_POSITION_ABOVE, RANDOM_POSITION_BELOW, traverse_logic, RANDOM_POSITION_HORIZONTAL_SEARCH)

			if position_on_navmesh then
				return position_on_navmesh
			end
		end
	end

	return nil
end

local function _increment_phase(scratchpad, optional_reset_invulnerability)
	local abilities_component = scratchpad.abilities_component

	abilities_component.current_ability = ""
	scratchpad.phase = scratchpad.phase + 1

	scratchpad.boss_handler:_phase_change()

	if optional_reset_invulnerability then
		boss_phase_uilities.set_boss_invulnerability(scratchpad.boss_unit, optional_reset_invulnerability)
	end
end

boss_phase_uilities.check_for_next_phase_conditions_met = function (scratchpad, phase_data, current_phase_settings, t, conditions, optional_reset_invulnerability, force_transition)
	local boss_unit = scratchpad.boss_unit

	if conditions.time then
		if not phase_data.forced_t_until_next_phase then
			phase_data.forced_t_until_next_phase = t + current_phase_settings.wait_timings_until_force_phase_change
		end

		if t > phase_data.forced_t_until_next_phase then
			_increment_phase(scratchpad, optional_reset_invulnerability)

			return true
		end
	end

	if conditions.health then
		local health_extension = ScriptUnit.has_extension(boss_unit, "health_system")

		if not health_extension then
			return false
		end

		local min_duration = current_phase_settings.minimum_time_required_in_phase

		if min_duration then
			local time_in_phase = t - scratchpad.phase_start_t

			if time_in_phase < min_duration then
				return false
			end
		end

		local current_health_percent = health_extension:current_health_percent()

		if current_health_percent < current_phase_settings.next_phase_health_percentage or current_health_percent <= 0 then
			_increment_phase(scratchpad, optional_reset_invulnerability)

			return true
		end
	end

	if force_transition then
		_increment_phase(scratchpad, optional_reset_invulnerability)

		return true
	end
end

boss_phase_uilities.teleport = function (scratchpad, position_or_nil, teleport_state, should_fly, is_forced, is_queued)
	local abilities_component = scratchpad.abilities_component
	local can_teleport = not abilities_component.in_basic_attack

	if not can_teleport and not is_forced then
		if is_queued then
			return false
		else
			if #scratchpad._queued_teleports == 0 then
				scratchpad._queued_teleports[#scratchpad._queued_teleports + 1] = {
					position_or_nil = position_or_nil,
					teleport_state = teleport_state,
					should_fly = should_fly,
				}
			end

			return
		end
	end

	local teleport_component = scratchpad.teleport_component
	local positions = scratchpad.positions

	if position_or_nil and teleport_state == "predefined" then
		local teleport_position

		if type(position_or_nil) == "string" and position_or_nil == "random" then
			teleport_position = boss_phase_uilities.get_random_position_in_radius(scratchpad, true)

			if not teleport_position then
				teleport_position = positions.center:unbox()
			end
		elseif type(position_or_nil) == "string" then
			teleport_position = positions[position_or_nil]:unbox()
		elseif type(position_or_nil) == "userdata" or type(position_or_nil) == "light_userdata" then
			teleport_position = position_or_nil
		end

		teleport_component.teleport_position:store(teleport_position)

		teleport_component.should_fly = should_fly
	end

	teleport_component.teleport_state = teleport_state
	teleport_component.teleport_allowed = true

	return true
end

boss_phase_uilities.set_boss_invulnerability = function (boss_unit, invulnerable)
	local health_extension = ScriptUnit.has_extension(boss_unit, "health_system")

	health_extension:set_invulnerable(invulnerable)
end

boss_phase_uilities.begin_health_escape = function (scratchpad, t, optional_min_time)
	local health_extension = ScriptUnit.has_extension(scratchpad.boss_unit, "health_system")
	local start_health = health_extension and health_extension:current_health_percent() or 1
	local min_t = optional_min_time and t + optional_min_time or nil

	return start_health, min_t
end

boss_phase_uilities.health_escape_triggered = function (scratchpad, start_health, min_t, escape_step, t)
	if not escape_step then
		return false
	end

	if min_t and t <= min_t then
		return false
	end

	local health_extension = ScriptUnit.has_extension(scratchpad.boss_unit, "health_system")
	local current_health_percent = health_extension and health_extension:current_health_percent() or 1
	local health_lost = (start_health or current_health_percent) - current_health_percent

	return escape_step <= health_lost
end

boss_phase_uilities.update_overdamage_protection = function (scratchpad, current_phase_settings)
	local health_extension = ScriptUnit.has_extension(scratchpad.boss_unit, "health_system")

	if not health_extension then
		return
	end

	local next_gate = current_phase_settings.next_phase_health_percentage

	if not next_gate or next_gate <= 0 then
		health_extension:set_overdamage_protection(nil)

		return
	end

	local overshoot = current_phase_settings.phase_damage_overshoot or DEFAULT_PHASE_DAMAGE_OVERSHOOT
	local multiplier = current_phase_settings.overdamage_soft_multiplier or DEFAULT_OVERDAMAGE_SOFT_MULTIPLIER
	local max_health = health_extension:max_health()

	health_extension:set_overdamage_protection({
		soft_start = next_gate * max_health,
		floor = math.max(next_gate - overshoot, 0) * max_health,
		multiplier = multiplier,
	})
end

boss_phase_uilities.start_terror_event = function (terror_event)
	local terror_event_manager = Managers.state.terror_event

	if terror_event_manager then
		terror_event_manager:start_event(terror_event)
	end
end

boss_phase_uilities.stop_terror_event = function (scratchpad, terror_event)
	local terror_event_manager = Managers.state.terror_event

	if terror_event_manager then
		terror_event_manager:stop_event(terror_event)
	end
end

local TEMP_POSITIONS = {}
local ABOVE, BELOW, HORIZONTAL = 2, 2.5, 2

boss_phase_uilities.get_valid_positions_around_target = function (unit, target_position, num_positions, offset, spacing)
	table.clear(TEMP_POSITIONS)

	local clamp_val = math.min(spacing / (2 * offset), 1)
	local step_radians = 2 * math.asin(clamp_val)
	local current_radians = -((num_positions - 1) * step_radians / 2)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()

	for i = 1, num_positions do
		local direction = Vector3(math.sin(current_radians), math.cos(current_radians), 0)
		local position = target_position + direction * offset
		local position_on_navmesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, position, ABOVE, BELOW, HORIZONTAL)

		if position_on_navmesh then
			TEMP_POSITIONS[#TEMP_POSITIONS + 1] = position_on_navmesh
		end

		current_radians = current_radians + step_radians
	end

	if #TEMP_POSITIONS > 0 then
		return TEMP_POSITIONS
	else
		return nil
	end
end

boss_phase_uilities.check_for_num_non_disabled_players = function ()
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(1)
	local target_units = side.valid_player_units
	local num_target_units = #target_units
	local num_non_disabled_players = 0

	for i = 1, num_target_units do
		local player_unit = target_units[i]
		local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
		local character_state_component = unit_data_extension:read_component("character_state")
		local requires_help = PlayerUnitStatus.requires_help(character_state_component)

		if not requires_help then
			num_non_disabled_players = num_non_disabled_players + 1
		end
	end

	return num_non_disabled_players
end

boss_phase_uilities.get_spillway_psyker_dance_variables = function (action_data, t)
	local event = action_data.anim_event[1]
	local delay = action_data.delay + t
	local attack_timing = action_data.anim_damage_timings[event] + delay
	local attack_duration = action_data.num_attacks * action_data.anim_duration[event] + action_data.num_attacks * action_data.delay + t
	local anim_duration = action_data.anim_duration[event] + delay

	return delay, attack_timing, attack_duration, anim_duration, event
end

boss_phase_uilities.is_havoc_difficulty_and_current_rank = function ()
	local havoc_extension = Managers.state.game_mode:game_mode():extension("havoc")

	if havoc_extension then
		return true, havoc_extension:get_current_rank()
	else
		return false, 0
	end
end

boss_phase_uilities.setup_hazard_indicator_vfx = function (scratchpad, name, duration, unit, t)
	if scratchpad.hazard_indicator then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:stop_template_effect(scratchpad.hazard_indicator.global_id)

		scratchpad.hazard_indicator = nil
	end

	local effect_template = EffectTemplates[name]
	local start_effect_template = effect_template

	if start_effect_template then
		local fx_system = Managers.state.extension:system("fx_system")
		local id = fx_system:start_template_effect(start_effect_template, unit)

		scratchpad.hazard_indicator = {
			duration = duration,
			global_id = id,
		}
	end
end

boss_phase_uilities.update_hazard_indicator_vfx = function (scratchpad, t, forced_stop)
	local hazard_indicator = scratchpad.hazard_indicator

	if not hazard_indicator then
		return
	end

	local global_id = hazard_indicator.global_id
	local duration = hazard_indicator.duration

	if forced_stop or duration < t and global_id then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:stop_template_effect(global_id)

		scratchpad.hazard_indicator = nil
	end
end

local function _safe_unbox(position)
	local meta_table = getmetatable(position)
	local name = meta_table._name

	if name and name == "Vector3Box" then
		return position:unbox()
	end

	return position
end

function _check_distance_against_optional_targets(new_position, positions, optional_min_distance)
	local position_valid_or_not = true
	local dist_sq, min_dist_sq

	for i = 1, #positions do
		local position = _safe_unbox(positions[i])

		dist_sq = Vector3.distance_squared(new_position, position)
		min_dist_sq = optional_min_distance and optional_min_distance * optional_min_distance or min_distance * min_distance

		if dist_sq <= min_dist_sq then
			position_valid_or_not = false
		end
	end

	return position_valid_or_not
end

return boss_phase_uilities
