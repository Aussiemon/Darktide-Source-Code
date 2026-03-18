-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_vortex_wander_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local NavQueries = require("scripts/utilities/nav_queries")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BtConditions = require("scripts/extension_systems/behavior/utilities/bt_conditions")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local VortexLocomotion = require("scripts/extension_systems/locomotion/utilities/vortex_locomotion")
local position_lookup = POSITION_LOOKUP
local BTVortexWanderAction = class("BTVortexWanderAction", "BtNode")

BTVortexWanderAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	scratchpad.vortex_component = Blackboard.write_component(blackboard, "vortex")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")

	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local minion_vortex_extension = ScriptUnit.extension(unit, "minion_vortex_system")

	scratchpad.minion_vortex_extension = minion_vortex_extension
	scratchpad.navigation_extension = navigation_extension

	local nav_world = navigation_extension:nav_world()

	scratchpad.nav_world = nav_world

	local speed = breed.run_speed

	navigation_extension:set_enabled(true, speed)

	local vortex_template = breed.vortex_template
	local new_target_wait_time = vortex_template and vortex_template.new_target_wait_time or 10

	scratchpad.new_target_wait_time = new_target_wait_time
	scratchpad.vortex_template = vortex_template
	self._world = Unit.world(unit)
	self._physics_world = World.physics_world(self._world)

	local vortex_component = scratchpad.vortex_component

	if not vortex_component.target_unit then
		local target_unit = self:_get_randomize_new_target_unit(unit, scratchpad, t)

		if target_unit then
			vortex_component.target_unit = target_unit
			vortex_component.new_target_time = t + scratchpad.new_target_wait_time
		end
	end
end

BTVortexWanderAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	scratchpad.new_target_wait_time = nil
	scratchpad.vortex_template = nil
end

BTVortexWanderAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local vortex_extension = scratchpad.minion_vortex_extension

	if vortex_extension and vortex_extension:is_active() then
		self:_wander_around(unit, t, dt, blackboard, scratchpad, action_data)
	end

	return "running"
end

local condition_names = {
	"at_jump_smart_object",
	"at_climb_smart_object",
	"at_teleport_smart_object",
}

BTVortexWanderAction._need_to_teleport = function (self, unit, blackboard, scratchpad, condition_args, action_data, is_running)
	for i = 1, #condition_names do
		local condition_name = condition_names[i]
		local condition = BtConditions[condition_name]

		if condition(unit, blackboard, scratchpad, condition_args, action_data, is_running) then
			return true
		end
	end
end

BTVortexWanderAction._wander_around = function (self, unit, t, dt, blackboard, scratchpad, action_data)
	local behavior_component = scratchpad.behavior_component
	local vortex_component = scratchpad.vortex_component
	local vortex_template = scratchpad.vortex_template
	local wander_state = vortex_component.wander_state
	local num_players_inside = vortex_component.num_players_inside
	local navigation_extension = scratchpad.navigation_extension
	local is_following_path = navigation_extension:is_following_path()

	behavior_component.move_state = is_following_path and "moving" or "idle"

	local stop_and_process_player = false

	if stop_and_process_player and num_players_inside > 0 and wander_state ~= "wandering" then
		vortex_component.wander_state = "recalc_path"
		vortex_component.target_unit = nil

		navigation_extension:stop()
	elseif num_players_inside == 0 and vortex_component.wander_state == "standing_still" then
		vortex_component.wander_state = "recalc_path"
	end

	if wander_state == "wandering" then
		if navigation_extension:has_reached_destination(0.5) or t > vortex_component.wander_time then
			vortex_component.wander_state = "recalc_path"
		else
			local is_running = true
			local need_to_teleport = self:_need_to_teleport(unit, blackboard, scratchpad, nil, action_data, is_running)

			if need_to_teleport then
				vortex_component.wander_state = "teleport_to_smart_object"
			end
		end
	elseif wander_state == "calculating_path" then
		local is_computing_path = navigation_extension:is_computing_path()
		local has_path = navigation_extension:has_path()

		if not is_computing_path and (is_following_path or not has_path) then
			if has_path then
				vortex_component.wander_state = "wandering"
				vortex_component.wander_time = t + 5
			else
				vortex_component.wander_state = "no_path_found"
				vortex_component.idle_time = t + 2 + math.random()
			end
		end
	elseif wander_state == "recalc_random_path" then
		vortex_component.target_unit = nil

		local position = Unit.local_position(unit, 1)
		local nav_world = scratchpad.nav_world
		local minion_vortex_extension = scratchpad.minion_vortex_extension
		local traverse_logic = minion_vortex_extension:traverse_logic()
		local random_max_distance = 10
		local offset_x = -random_max_distance + math.random() * random_max_distance * 2
		local offset_y = -random_max_distance + math.random() * random_max_distance * 2
		local random_pos = position and NavQueries.position_on_mesh_guaranteed(nav_world, position + Vector3(offset_x, offset_y, 0), 5, 10, traverse_logic)
		local from_position = Unit.local_position(unit, 1)

		if random_pos and not VortexLocomotion.is_position_indoors(random_pos, self._physics_world, from_position) then
			navigation_extension:move_to(random_pos)

			vortex_component.wander_state = "calculating_path"
		else
			vortex_component.idle_time = t + 0.5
			vortex_component.wander_state = "no_path_found"
		end
	elseif wander_state == "recalc_path" then
		local target_unit = vortex_component.target_unit

		if not target_unit or t > vortex_component.new_target_time then
			vortex_component.new_target_time = t + scratchpad.new_target_wait_time

			local new_target_unit = self:_get_randomize_new_target_unit(unit, scratchpad, t)

			if new_target_unit then
				target_unit = new_target_unit
				vortex_component.target_unit = new_target_unit
				vortex_component.new_target_time = t + scratchpad.new_target_wait_time
			else
				target_unit = nil
			end
		end

		local nav_world = scratchpad.nav_world
		local position = Unit.local_position(unit, 1)
		local random_wander = not target_unit or vortex_template and vortex_template.random_wander

		if random_wander then
			vortex_component.wander_state = "recalc_random_path"
		elseif Unit.alive(target_unit) and position_lookup[target_unit] then
			local target_position = position_lookup[target_unit]
			local nav_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, target_position, 2, 1, 1)

			if nav_position then
				local target_distance_sq = Vector3.length_squared(nav_position - position)

				if target_distance_sq > 0.25 then
					navigation_extension:move_to(nav_position)

					vortex_component.wander_state = "calculating_path"
				end
			else
				vortex_component.idle_time = t + math.random() * 0.5
				vortex_component.wander_state = "no_path_found"
			end
		else
			vortex_component.idle_time = t + 2 + math.random()
			vortex_component.wander_state = "no_path_found"
		end
	elseif wander_state == "teleport_to_smart_object" then
		local nav_smart_object_component = blackboard.nav_smart_object
		local entrance_position = nav_smart_object_component.entrance_position:unbox()
		local exit_position = nav_smart_object_component.exit_position:unbox()

		Unit.set_local_position(unit, 1, exit_position)

		vortex_component.wander_state = "wandering"
	elseif wander_state == "no_path_found" then
		if t > vortex_component.idle_time then
			vortex_component.wander_state = "recalc_random_path"
		end
	elseif wander_state == "standing_still" then
		-- Nothing
	end

	local nav_smart_object_component = blackboard.nav_smart_object
	local entrance_position = nav_smart_object_component.entrance_position:unbox()
	local exit_position = nav_smart_object_component.exit_position:unbox()
end

BTVortexWanderAction._get_randomize_new_target_unit = function (self, unit, scratchpad, t)
	local player_manager = Managers.player
	local human_players = player_manager:human_players()
	local vortex_component = scratchpad.vortex_component
	local vortex_position = Unit.local_position(unit, 1)
	local target_unit
	local shortest_distance = math.huge

	for _, player in pairs(human_players) do
		local player_unit = player.player_unit

		if player_unit and Unit.alive(player_unit) and vortex_component.target_unit ~= player_unit then
			local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
			local disabled_character_state_component = unit_data_extension:read_component("disabled_character_state")
			local character_state_component = unit_data_extension:read_component("character_state")

			if not PlayerUnitStatus.is_vortex_grabbed(disabled_character_state_component) and not PlayerUnitStatus.is_disabled(character_state_component) then
				local player_position = Unit.local_position(player_unit, 1)
				local distance = Vector3.distance(vortex_position, player_position)

				if distance < shortest_distance then
					shortest_distance = distance
					target_unit = player_unit
				end
			end
		end
	end

	return target_unit
end
