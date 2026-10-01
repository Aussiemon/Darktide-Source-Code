-- chunkname: @scripts/utilities/stage_hazards/wizard_teeth_stage_hazard.lua

local LevelProps = require("scripts/settings/level_prop/level_props")
local Component = require("scripts/utilities/component")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local BotGroup = require("scripts/extension_systems/group/bot_group")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local WizardTeethStageHazard = {}
local MIN_RAISED_TEETH = {
	4,
	4,
	3,
	3,
	3,
}
local MAX_RAISED_TEETH = {
	6,
	5,
	4,
	3,
	3,
}
local MAX_ALLOWED_STREAK = 2
local SIDE_ID = 2
local PILLAR_EFFECT_TEMPLATE = EffectTemplates.renegade_wizard_pillar
local TOOTH_RISE_DELAY = PILLAR_EFFECT_TEMPLATE.rise_delay
local _update_bot_safe_spot_target, _get_closest_safe_spot_per_bot, _get_tooth_component, _start_pillar_vfx, _spawn_tooth_unit, _clear_pending_work

WizardTeethStageHazard.init = function (scratchpad)
	local side_system = Managers.state.extension:system("side_system")
	local side_names = side_system:side_names()
	local side_name = side_names[SIDE_ID]
	local side = side_system:get_side_from_name(side_name)

	scratchpad.teeth_hazard = {
		teeth_positions = {},
		is_raised = {},
		raised_streak = {},
		pending_spawns = {},
		group_system = Managers.state.extension:system("group_system"),
		enemy_sides = side:relation_sides("enemy"),
		safe_spot_per_bot = {},
	}
end

WizardTeethStageHazard.update = function (scratchpad, t)
	local hazard_data = scratchpad.teeth_hazard

	if not hazard_data then
		return
	end

	local pending_spawns = hazard_data.pending_spawns

	if pending_spawns then
		local i = 1

		while i <= #pending_spawns do
			local pending = pending_spawns[i]

			if t >= pending.spawn_t then
				_spawn_tooth_unit(scratchpad, pending.position:unbox(), pending.effect_id)
				table.remove(pending_spawns, i)
			else
				i = i + 1
			end
		end
	end
end

WizardTeethStageHazard.has_pending_spawns = function (scratchpad)
	local hazard_data = scratchpad.teeth_hazard
	local pending_spawns = hazard_data and hazard_data.pending_spawns

	return pending_spawns ~= nil and #pending_spawns > 0
end

WizardTeethStageHazard.exit = function (scratchpad)
	return
end

WizardTeethStageHazard.despawn = function (scratchpad)
	_clear_pending_work(scratchpad.teeth_hazard)

	local component_system = Managers.state.extension:system("component_system")
	local spillway_boss_tooths = component_system:get_units_from_component_name("SpillwayBossTooth")

	if spillway_boss_tooths then
		for i = 1, #spillway_boss_tooths do
			local tooth_unit = spillway_boss_tooths[i]
			local tooth_components = Component.get_components_by_name(tooth_unit, "SpillwayBossTooth")

			if tooth_components and tooth_components[1] then
				tooth_components[1]:despawn()
			end
		end
	end
end

local VERTICAL_OFFSET = 0.35

WizardTeethStageHazard.spawn_tooth = function (scratchpad, position)
	position = position + Vector3.up() * VERTICAL_OFFSET

	local effect_id = _start_pillar_vfx(nil, position)
	local pending_spawns = scratchpad.teeth_hazard.pending_spawns

	pending_spawns[#pending_spawns + 1] = {
		position = Vector3Box(position),
		effect_id = effect_id,
		spawn_t = Managers.time:time("gameplay") + TOOTH_RISE_DELAY,
	}
end

local BOT_TOOTH_DISTANCE_PADDING = 2
local BOT_SAFE_SPOT_DURATION = 15
local BOT_HOVER_TARGET_TOLERANCE = 0.5

function _update_bot_safe_spot_target(scratchpad, t)
	local hazard_data = scratchpad.teeth_hazard

	if not hazard_data then
		return
	end

	local raised_teeth = WizardTeethStageHazard.get_raised_teeth(hazard_data)

	if table.is_empty(raised_teeth) then
		return
	end

	local positions = scratchpad.positions
	local center = positions and positions.center and positions.center:unbox()
	local bot_groups = hazard_data.group_system:bot_groups_from_sides(hazard_data.enemy_sides)

	for i = 1, #bot_groups do
		local bot_group = bot_groups[i]
		local bot_datas = bot_group:data()
		local safe_spot_per_bot = _get_closest_safe_spot_per_bot(bot_datas, hazard_data, raised_teeth)

		for bot_unit, tooth_pos in pairs(safe_spot_per_bot) do
			local data = bot_datas[bot_unit]

			if tooth_pos and center then
				local center_to_tooth = Vector3.flat(tooth_pos - center)
				local wanted_distance = Vector3.length(center_to_tooth) + BOT_TOOTH_DISTANCE_PADDING
				local dir = Vector3.normalize(center_to_tooth)
				local rotation = Quaternion.look(dir, Vector3.up())

				bot_group:set_position_to_hover(data, center, wanted_distance, BOT_HOVER_TARGET_TOLERANCE, false, BOT_SAFE_SPOT_DURATION, rotation, BotGroup.AVOIDANCE_TYPES.reposition_behind)
			end
		end
	end
end

local temp_distance = {}

function _get_closest_safe_spot_per_bot(bot_datas, hazard_data, teeth)
	local safe_spot_per_bot = hazard_data.safe_spot_per_bot

	table.clear(safe_spot_per_bot)

	for bot_unit, data in pairs(bot_datas) do
		temp_distance[bot_unit] = math.huge
	end

	for tooth_unit, position_boxed in pairs(hazard_data.teeth_positions) do
		local is_raised = hazard_data and hazard_data.is_raised
		local tooth_raised = not is_raised or is_raised[tooth_unit]

		if ALIVE[tooth_unit] and tooth_raised then
			for bot_unit, data in pairs(bot_datas) do
				local distance = Vector3.distance(Vector3.flat(POSITION_LOOKUP[bot_unit]), Vector3.flat(position_boxed:unbox()))

				if distance < temp_distance[bot_unit] then
					temp_distance[bot_unit] = distance
					safe_spot_per_bot[bot_unit] = position_boxed:unbox()
				end
			end
		end
	end

	table.clear(temp_distance)

	return safe_spot_per_bot
end

function _get_tooth_component(unit)
	local components = Component.get_components_by_name(unit, "SpillwayBossTooth")

	return components and components[1]
end

function _start_pillar_vfx(optional_tooth_unit, position)
	local fx_system = Managers.state.extension:system("fx_system")
	local tooth_component = optional_tooth_unit and _get_tooth_component(optional_tooth_unit)

	if tooth_component then
		tooth_component:stop_pillar_vfx()
	end

	local effect_id = fx_system:start_template_effect(PILLAR_EFFECT_TEMPLATE, nil, nil, position)

	if tooth_component then
		tooth_component:set_pillar_effect_id(effect_id)
	end

	return effect_id
end

function _spawn_tooth_unit(scratchpad, position, effect_id)
	local hazard_data = scratchpad.teeth_hazard
	local prop_settings = LevelProps.spillway_boss_tooth
	local name = prop_settings.unit_name
	local unit = Managers.state.unit_spawner:spawn_network_unit(name, "level_prop", position, Quaternion.identity(), nil, prop_settings)

	hazard_data.teeth_positions[unit] = Vector3Box(position)
	hazard_data.is_raised[unit] = true
	hazard_data.raised_streak[unit] = 0

	local tooth_component = _get_tooth_component(unit)

	if tooth_component then
		tooth_component:set_pillar_effect_id(effect_id)
	end

	_update_bot_safe_spot_target(scratchpad, Managers.time:time("gameplay"))
end

function _clear_pending_work(hazard_data)
	if not hazard_data then
		return
	end

	local pending_spawns = hazard_data.pending_spawns

	if pending_spawns then
		local fx_system = Managers.state.extension:system("fx_system")

		for i = 1, #pending_spawns do
			local effect_id = pending_spawns[i].effect_id

			if effect_id then
				local is_running = fx_system:has_running_template_effect_with_global_effect_id(effect_id)

				if is_running then
					fx_system:stop_template_effect(effect_id)
				end
			end
		end

		table.clear(pending_spawns)
	end
end

local _player_positions = {}

local function _get_non_disabled_player_positions()
	local player_positions = _player_positions

	table.clear(player_positions)

	local side_system = Managers.state.extension:system("side_system")
	local side = side_system:get_side(1)
	local player_units = side.valid_player_units

	for i = 1, #player_units do
		local player_unit = player_units[i]
		local unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

		if unit_data_extension then
			local character_state_component = unit_data_extension:read_component("character_state")

			if not PlayerUnitStatus.requires_help(character_state_component) then
				player_positions[#player_positions + 1] = Vector3.flat(POSITION_LOOKUP[player_unit])
			end
		end
	end

	return player_positions
end

local function _nearest_player_distance(tooth_pos_flat, player_positions)
	local num_players = #player_positions

	if num_players == 0 then
		return nil
	end

	local nearest = math.huge

	for i = 1, num_players do
		local dist = Vector3.distance(tooth_pos_flat, player_positions[i])

		if dist < nearest then
			nearest = dist
		end
	end

	return nearest
end

local function _weighted_pick(candidates, weights, total_weight)
	local roll = math.random() * total_weight
	local acc = 0

	for i = 1, #candidates do
		acc = acc + weights[i]

		if roll <= acc then
			return candidates[i]
		end
	end

	return candidates[#candidates]
end

local function _pick_lowest_streak(alive_teeth, raise_index, raised_streak, start_index)
	local num_teeth = #alive_teeth
	local best_index
	local best_streak = math.huge

	for offset = 0, num_teeth - 1 do
		local index = (start_index + offset - 1) % num_teeth + 1

		if not raise_index[index] then
			local streak = raised_streak[alive_teeth[index].unit] or 0

			if streak < best_streak then
				best_streak = streak
				best_index = index
			end
		end
	end

	return best_index
end

local raised_teeth = {}

WizardTeethStageHazard.get_raised_teeth = function (hazard_data)
	table.clear(raised_teeth)

	local teeth_positions = hazard_data.teeth_positions
	local is_raised = hazard_data.is_raised

	for tooth_unit, _ in pairs(teeth_positions) do
		if ALIVE[tooth_unit] and is_raised[tooth_unit] then
			raised_teeth[#raised_teeth + 1] = tooth_unit
		end
	end

	return raised_teeth
end

WizardTeethStageHazard.lower_all_teeth = function (scratchpad)
	local teeth_hazard = scratchpad.teeth_hazard

	_clear_pending_work(teeth_hazard)

	local teeth_positions = teeth_hazard.teeth_positions
	local alive_teeth = {}

	for tooth_unit, position_boxed in pairs(teeth_positions) do
		if ALIVE[tooth_unit] then
			alive_teeth[#alive_teeth + 1] = {
				unit = tooth_unit,
			}
		end
	end

	local num_teeth = #alive_teeth

	if num_teeth == 0 then
		return
	end

	for i = 1, num_teeth do
		local entry = alive_teeth[i]
		local tooth_component = _get_tooth_component(entry.unit)

		if tooth_component then
			tooth_component:set_raised(false)
		end
	end
end

local candidates = {}
local candidate_weights = {}

WizardTeethStageHazard.randomize_teeth = function (scratchpad)
	local teeth_hazard = scratchpad.teeth_hazard

	if not teeth_hazard then
		return
	end

	local teeth_positions = teeth_hazard.teeth_positions
	local is_raised = teeth_hazard.is_raised
	local raised_streak = teeth_hazard.raised_streak
	local positions = scratchpad.positions
	local center = positions and positions.center and positions.center:unbox()
	local player_positions = _get_non_disabled_player_positions()
	local alive_teeth = {}

	for tooth_unit, position_boxed in pairs(teeth_positions) do
		if ALIVE[tooth_unit] then
			local pos = position_boxed:unbox()
			local pos_flat = Vector3.flat(pos)
			local angle = 0

			if center then
				angle = math.atan2(pos.y - center.y, pos.x - center.x)
			end

			local nearest_player_dist = _nearest_player_distance(pos_flat, player_positions)
			local proximity_weight = nearest_player_dist and 1 / (1 + nearest_player_dist) or 1

			alive_teeth[#alive_teeth + 1] = {
				unit = tooth_unit,
				angle = angle,
				proximity_weight = proximity_weight,
			}
		end
	end

	local num_teeth = #alive_teeth

	if num_teeth == 0 then
		return
	end

	table.sort(alive_teeth, function (a, b)
		return a.angle < b.angle
	end)

	local min_raised = math.min(Managers.state.difficulty:get_table_entry_by_challenge(MIN_RAISED_TEETH), num_teeth)
	local max_raised = math.clamp(Managers.state.difficulty:get_table_entry_by_challenge(MAX_RAISED_TEETH), min_raised, num_teeth)
	local num_to_raise = math.random(min_raised, max_raised)
	local raise_index = {}
	local start_offset = math.random() * num_teeth

	for i = 0, num_to_raise - 1 do
		local arc_start = math.floor(start_offset + i * num_teeth / num_to_raise)
		local arc_end = math.floor(start_offset + (i + 1) * num_teeth / num_to_raise)

		if arc_end <= arc_start then
			arc_end = arc_start + 1
		end

		table.clear(candidates)
		table.clear(candidate_weights)

		local total_weight = 0

		for slot = arc_start, arc_end - 1 do
			local index = slot % num_teeth + 1

			if not raise_index[index] then
				local entry = alive_teeth[index]
				local streak = raised_streak[entry.unit] or 0
				local over_streak = streak >= MAX_ALLOWED_STREAK
				local streak_falloff = 1 / (1 + streak)
				local weight = over_streak and 0 or entry.proximity_weight * streak_falloff

				candidates[#candidates + 1] = index
				candidate_weights[#candidates] = weight
				total_weight = total_weight + weight
			end
		end

		local index

		if #candidates > 0 and total_weight > 0 then
			index = _weighted_pick(candidates, candidate_weights, total_weight)
		else
			index = _pick_lowest_streak(alive_teeth, raise_index, raised_streak, arc_start % num_teeth + 1)
		end

		if index then
			raise_index[index] = true
		end
	end

	for i = 1, num_teeth do
		local entry = alive_teeth[i]
		local raised = raise_index[i] == true

		is_raised[entry.unit] = raised
		raised_streak[entry.unit] = raised and (raised_streak[entry.unit] or 0) + 1 or 0

		local tooth_component = _get_tooth_component(entry.unit)

		if tooth_component then
			if raised and not tooth_component:is_raised() then
				local tooth_pos = teeth_positions[entry.unit]:unbox()

				_start_pillar_vfx(entry.unit, tooth_pos)
			end

			tooth_component:set_raised(raised)
		end
	end

	_update_bot_safe_spot_target(scratchpad, Managers.time:time("gameplay"))
end

WizardTeethStageHazard.cleanup = function (scratchpad)
	_clear_pending_work(scratchpad.teeth_hazard)

	local component_system = Managers.state.extension:system("component_system")
	local spillway_boss_tooths = component_system:get_units_from_component_name("SpillwayBossTooth")

	if spillway_boss_tooths then
		for i = 1, #spillway_boss_tooths do
			local spillway_boss_tooth = spillway_boss_tooths[i]
			local tooth_components = Component.get_components_by_name(spillway_boss_tooth, "SpillwayBossTooth")

			if tooth_components and tooth_components[1] then
				local already_marked_for_deletion = tooth_components[1].already_marked_for_deletion

				if not already_marked_for_deletion then
					tooth_components[1]:mark_for_deletion()
				end
			end
		end
	end
end

return WizardTeethStageHazard
