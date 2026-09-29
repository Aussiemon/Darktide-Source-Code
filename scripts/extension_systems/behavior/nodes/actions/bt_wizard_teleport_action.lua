-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_wizard_teleport_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local NavQueries = require("scripts/utilities/nav_queries")
local MainPathQueries = require("scripts/utilities/main_path_queries")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Vo = require("scripts/utilities/vo")
local BossPhaseUtilities = require("scripts/utilities/phases/boss_phase_utilities")
local BtWizardTeleportAction = class("BtWizardTeleportAction", "BtNode")
local teleport_types = table.enum("to_target_unit", "to_cover", "predefined", "flood")
local _set_toughness_unit_visability, _teleport_in_setup, _player_units, _execute_attack, _catapult
local KNOCKBACK_SFX = "wwise/events/minions/play_enemy_psyker_push"
local FLOAT_ABOVE, FLOAT_BELOW = 0.5, 2

local function _position_is_floating(navigation_extension, position)
	local nav_world = navigation_extension:nav_world()
	local traverse_logic = navigation_extension:traverse_logic()
	local on_mesh = NavQueries.position_on_mesh(nav_world, position, FLOAT_ABOVE, FLOAT_BELOW, traverse_logic)

	return on_mesh == nil
end

local function _set_anim_layer(unit, should_float)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")
	local event = should_float and "to_floating" or "to_combat"

	if animation_extension:has_anim_event(event) then
		animation_extension:anim_event(event)
	end
end

local function _try_snap_to_nav(unit, locomotion_extension, should_fly)
	local movement_type = locomotion_extension:get_movement_type()
end

local function _try_to_fly(unit, locomotion_extension, should_fly)
	local movement_type = locomotion_extension:get_movement_type()
end

BtWizardTeleportAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local teleport_out_anim_events = action_data.teleport_out_anim_events
	local teleport_out_anim_event = Animation.random_event(teleport_out_anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(teleport_out_anim_event)

	local teleport_timing = action_data.teleport_timings[teleport_out_anim_event]

	scratchpad.teleport_timing = t + teleport_timing
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.perception_component = blackboard.perception

	local teleport_directions = self:_calculate_randomized_teleport_directions(action_data)

	scratchpad.teleport_directions = teleport_directions
	scratchpad.state = "teleporting_in"
	scratchpad.teleport_direction_index = 1

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system

	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = "idle"

	_try_to_fly(unit, scratchpad.locomotion_extension, blackboard.teleport.should_fly)

	local entering_floating = _position_is_floating(scratchpad.navigation_extension, POSITION_LOOKUP[unit])

	_set_anim_layer(unit, entering_floating)

	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "teleport_unit_moved", false)
	GameSession.set_game_object_field(game_session, game_object_id, "teleport_position_reached", false)

	local effect_template_name = action_data.effect_template_name
	local effect_template = EffectTemplates[effect_template_name]

	scratchpad.global_effect_id = fx_system:start_template_effect(effect_template, unit)
	scratchpad.hit_players = {}

	local want_to_dive_bomb = GameSession.game_object_field(game_session, game_object_id, "want_to_dive_bomb")

	if want_to_dive_bomb then
		local vo_event = action_data.vo_event

		if vo_event then
			Vo.enemy_generic_vo_event(unit, vo_event, breed.name)
		end
	end
end

BtWizardTeleportAction.init_values = function (self, blackboard, action_data, node_data)
	local teleport_component = Blackboard.write_component(blackboard, "teleport")

	teleport_component.teleport_state = ""
	teleport_component.teleport_timings_t = 0
	teleport_component.teleport_allowed = false

	teleport_component.teleport_position:store(0, 0, 0)

	teleport_component.should_fly = false
end

BtWizardTeleportAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local teleport_component = Blackboard.write_component(blackboard, "teleport")

	teleport_component.teleport_state = ""
	teleport_component.teleport_allowed = false

	teleport_component.teleport_position:store(0, 0, 0)

	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "teleport_position_reached", false)
	GameSession.set_game_object_field(game_session, game_object_id, "teleport_unit_moved", false)

	if scratchpad.global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	_try_snap_to_nav(unit, scratchpad.locomotion_extension, blackboard.teleport.should_fly)
	BossPhaseUtilities.set_boss_invulnerability(unit, false)
end

BtWizardTeleportAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state
	local teleport_state = blackboard.teleport.teleport_state
	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	if state == "teleporting_in" then
		local result = "none"

		if teleport_types.predefined == teleport_state then
			result = self:_verify_predefined_position(unit, scratchpad, action_data, blackboard)
		end

		if teleport_types.to_target_unit == teleport_state then
			result = self:_find_teleport_position_near_target_unit(unit, scratchpad, action_data)
		end

		if result == "failed" then
			return "done"
		end

		if t >= scratchpad.teleport_timing and not scratchpad.teleport_started then
			if scratchpad.teleport_position then
				self:_teleport(unit, scratchpad, blackboard, action_data, t)
			else
				return "done"
			end
		end
	elseif state == "teleporting_out" then
		local position_reached = GameSession.game_object_field(game_session, game_object_id, "teleport_position_reached")

		if position_reached then
			if not scratchpad.arrival_anim_layer_set then
				_set_anim_layer(unit, scratchpad.destination_floating)

				scratchpad.arrival_anim_layer_set = true
			end

			if not scratchpad.teleport_in_anim_played then
				local want_to_dive_bomb = GameSession.game_object_field(game_session, game_object_id, "want_to_dive_bomb")
				local is_exhausted = blackboard.abilites.current_ability == "exhausted"

				if want_to_dive_bomb then
					_teleport_in_setup(unit, breed, blackboard, scratchpad, action_data, dt, t, action_data.teleport_in_anim_events.dive_bomb)

					scratchpad.time_t_divebomb = action_data.dive_bomb_t + t
				elseif is_exhausted then
					_teleport_in_setup(unit, breed, blackboard, scratchpad, action_data, dt, t, action_data.teleport_in_anim_events.exhausted)

					local abilites_component = Blackboard.write_component(blackboard, "abilites")

					abilites_component.skip_exhaust_intro = true
				else
					_teleport_in_setup(unit, breed, blackboard, scratchpad, action_data, dt, t, action_data.teleport_in_anim_events.normal)
				end
			elseif t < scratchpad.teleport_in_anim_played then
				if scratchpad.time_t_divebomb and t > scratchpad.time_t_divebomb and not scratchpad.dive_bomb_finished then
					scratchpad.dive_bomb_finished = true

					_execute_attack(unit, POSITION_LOOKUP[unit], _player_units(), scratchpad)
				end
			elseif t > scratchpad.teleport_in_anim_played then
				return "done"
			end
		end
	end

	self:_look_at_target(unit, scratchpad)

	return "running"
end

local DEGREE_RANGE = 360

BtWizardTeleportAction._calculate_randomized_teleport_directions = function (self, action_data)
	local degree_per_direction = action_data.degree_per_direction
	local num_directions = DEGREE_RANGE / degree_per_direction
	local current_degree = -(DEGREE_RANGE / 2)
	local directions = {}

	for i = 1, num_directions do
		current_degree = current_degree + degree_per_direction

		local radians = math.degrees_to_radians(current_degree)
		local direction = Vector3(math.sin(radians), math.cos(radians), 0)

		directions[i] = Vector3Box(direction)
	end

	table.shuffle(directions)

	return directions
end

local MAX_TRIES = 10
local ABOVE, BELOW, LATERAL, DISTANCE_FROM_NAV_MESH = 3, 3, 1, 0

BtWizardTeleportAction._find_teleport_position_near_target_unit = function (self, unit, scratchpad, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world, traverse_logic = navigation_extension:nav_world(), navigation_extension:traverse_logic()
	local target_unit = scratchpad.perception_component.target_unit
	local target_navigation_extension = ScriptUnit.extension(target_unit, "navigation_system")
	local target_position_on_nav_mesh = target_navigation_extension:latest_position_on_nav_mesh()

	if not target_position_on_nav_mesh then
		local target_position = POSITION_LOOKUP[target_unit]

		target_position_on_nav_mesh = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW, LATERAL, DISTANCE_FROM_NAV_MESH)

		if not target_position_on_nav_mesh then
			return "failed"
		end
	end

	local teleport_distance = action_data.teleport_distance
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local first_person_component = target_unit_data_extension:read_component("first_person")
	local look_rotation = first_person_component.rotation
	local target_forward = Vector3.flat(Quaternion.forward(look_rotation))
	local position_in_front_of_target = target_position_on_nav_mesh + target_forward * -1 * teleport_distance
	local nav_mesh_position_in_front_of_target = NavQueries.position_on_mesh(nav_world, position_in_front_of_target, ABOVE, BELOW, traverse_logic)

	if nav_mesh_position_in_front_of_target then
		scratchpad.teleport_position = Vector3Box(nav_mesh_position_in_front_of_target)

		return "success"
	end

	local teleport_directions = scratchpad.teleport_directions

	for i = 1, MAX_TRIES do
		local teleport_direction_index = scratchpad.teleport_direction_index
		local teleport_direction = teleport_directions[teleport_direction_index]:unbox()
		local teleport_test_position = target_position_on_nav_mesh + teleport_direction * teleport_distance
		local teleport_nav_mesh_position = NavQueries.position_on_mesh(nav_world, teleport_test_position, ABOVE, BELOW, traverse_logic)
		local final_position

		if teleport_nav_mesh_position then
			local success, hit_position = GwNavQueries.raycast(nav_world, target_position_on_nav_mesh, teleport_nav_mesh_position, traverse_logic)

			final_position = success and teleport_nav_mesh_position or hit_position
		end

		if final_position then
			local distance_to_target = Vector3.distance(final_position, target_position_on_nav_mesh)
			local travel_distance = Vector3.distance(final_position, POSITION_LOOKUP[unit])
			local max_distance = action_data.max_distance

			if max_distance <= distance_to_target and max_distance <= travel_distance then
				if scratchpad.teleport_position then
					scratchpad.teleport_position:store(final_position)
				else
					scratchpad.teleport_position = Vector3Box(final_position)
				end

				return "success"
			else
				scratchpad.teleport_direction_index = teleport_direction_index + 1
			end
		else
			scratchpad.teleport_direction_index = teleport_direction_index + 1
		end

		if #teleport_directions == scratchpad.teleport_direction_index then
			return "failed"
		end
	end

	return "running"
end

BtWizardTeleportAction._verify_predefined_position = function (self, unit, scratchpad, action_data, blackboard)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world, traverse_logic = navigation_extension:nav_world(), navigation_extension:traverse_logic()
	local teleport_position = blackboard.teleport.teleport_position:unbox()
	local target_position_on_nav_mesh = NavQueries.position_on_mesh_guaranteed(nav_world, teleport_position, ABOVE, BELOW, traverse_logic)

	if scratchpad.teleport_position then
		scratchpad.teleport_position:store(target_position_on_nav_mesh)
	else
		scratchpad.teleport_position = Vector3Box(target_position_on_nav_mesh)
	end

	return "success"
end

local AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE = {
	25,
	50,
}

BtWizardTeleportAction._find_teleport_in_cover = function (self, unit, scratchpad, action_data)
	local main_path_manager = Managers.state.main_path
	local _, ahead_travel_distance = main_path_manager:ahead_unit(1)

	if not ahead_travel_distance then
		return
	end

	local random_offset = math.random_range(AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE[1], AHEAD_TRAVEL_DISTANCE_RANDOM_RANGE[2])
	local total_path_distance = MainPathQueries.total_path_distance()
	local wanted_distance = math.clamp(ahead_travel_distance + random_offset, 0, total_path_distance)
	local position = MainPathQueries.position_from_distance(wanted_distance)

	scratchpad.teleport_position = Vector3Box(position)

	return "success"
end

BtWizardTeleportAction._teleport_to_flood_filled_position = function (self, unit, scratchpad, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = navigation_extension:nav_world()
	local flood_fill_positions = {}
	local below, above = 2, 2
	local position = POSITION_LOOKUP[unit]
	local num_to_spawn = 50
	local num_positions = GwNavQueries.flood_fill_from_position(nav_world, position, above, below, num_to_spawn, flood_fill_positions)
	local random_position = math.random(1, num_positions)

	scratchpad.teleport_position = Vector3Box(flood_fill_positions[random_position])

	return "success"
end

BtWizardTeleportAction._teleport = function (self, unit, scratchpad, blackboard, action_data, t)
	scratchpad.teleport_started = true

	local locomotion_extension = scratchpad.locomotion_extension
	local should_fly = blackboard.teleport.should_fly
	local offset = should_fly and Vector3.up() * 5.5 or Vector3.zero()
	local teleport_position = scratchpad.teleport_position:unbox() + offset

	scratchpad.destination_floating = _position_is_floating(scratchpad.navigation_extension, teleport_position)

	local position = POSITION_LOOKUP[unit]
	local spawn_component = blackboard.spawn
	local game_session, game_object_id = spawn_component.game_session, spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "from_position", position)
	GameSession.set_game_object_field(game_session, game_object_id, "to_position", teleport_position)
	locomotion_extension:teleport_to(teleport_position)
	GameSession.set_game_object_field(game_session, game_object_id, "teleport_unit_moved", true)

	scratchpad.state = "teleporting_out"
end

BtWizardTeleportAction._look_at_target = function (self, unit, scratchpad)
	local locomotion_extension = scratchpad.locomotion_extension
	local target_unit = scratchpad.perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit] or Vector3(0, 0, 0)
	local direction = Vector3.normalize(target_position - POSITION_LOOKUP[unit])
	local rotation = Quaternion.look(Vector3.flat(direction))

	locomotion_extension:set_wanted_rotation(rotation)
end

function _teleport_in_setup(unit, breed, blackboard, scratchpad, action_data, dt, t, event)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(event)

	local teleport_timing = action_data.teleport_timings[event]

	scratchpad.teleport_in_anim_played = teleport_timing + t
end

function _player_units()
	local side_system = Managers.state.extension:system("side_system")
	local player_side = side_system:get_side(1)

	return player_side.valid_player_units
end

local CATAPULT_Z_FORCE = 5
local CATAPULT_FORCE = 25
local LAST_PHASE_CATAPULT_Z_FORCE = 3
local LAST_PHASE_CATAPULT_FORCE = 14

function _catapult(unit, distance, to_vector, target_unit_data_extension, is_last_phase)
	local z_v = CATAPULT_Z_FORCE
	local v = CATAPULT_FORCE

	if is_last_phase then
		z_v = LAST_PHASE_CATAPULT_Z_FORCE
		v = LAST_PHASE_CATAPULT_FORCE
	end

	local velocity = to_vector * v

	velocity.z = z_v

	local catapulted_state_input = target_unit_data_extension:write_component("catapulted_state_input")

	Catapulted.apply(catapulted_state_input, velocity)
end

local ATTACK_RANGE = 10
local vfx = "content/fx/particles/weapons/force_staff/force_staff_explosion"

function _execute_attack(unit, unit_position, player_units, scratchpad)
	local player_position, distance, target_unit_data_extension, player_unit
	local fx_position = unit_position + Vector3(0, 0, 2)

	scratchpad.fx_system:trigger_vfx(vfx, fx_position)
	scratchpad.fx_system:trigger_wwise_event(KNOCKBACK_SFX, fx_position)

	local is_last_phase
	local range = ATTACK_RANGE

	for i = 1, #player_units do
		player_unit = player_units[i]

		if not scratchpad.hit_players[player_unit] then
			player_position = POSITION_LOOKUP[player_unit]
			distance = Vector3.distance(unit_position, player_position)
			target_unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

			if distance < range and target_unit_data_extension then
				_catapult(player_unit, distance, Vector3.normalize(player_position - unit_position), target_unit_data_extension, is_last_phase)

				scratchpad.hit_players[player_unit] = true
			end
		end
	end
end

return BtWizardTeleportAction
