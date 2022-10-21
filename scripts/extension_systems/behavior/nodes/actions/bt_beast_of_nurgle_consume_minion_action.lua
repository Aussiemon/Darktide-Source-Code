require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local Health = require("scripts/utilities/health")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtBeastOfNurgleConsumeMinionAction = class("BtBeastOfNurgleConsumeMinionAction", "BtNode")

BtBeastOfNurgleConsumeMinionAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	scratchpad.world = spawn_component.world
	scratchpad.perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.behavior_component.move_state = "attacking"
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.nav_world = scratchpad.navigation_extension:nav_world()
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.side_system = Managers.state.extension:system("side_system")
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.aim_component = Blackboard.write_component(blackboard, "aim")
	scratchpad.aim_component.controlled_aiming = true
	local original_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = original_rotation_speed
	scratchpad.broadphase_config = breed.nearby_units_broadphase_config
	local target_unit = self:_get_target(unit, scratchpad, action_data)
	scratchpad.target_unit = target_unit

	if target_unit then
		self:_start_tongue_out(unit, scratchpad, action_data, t)
	else
		scratchpad.state = "invalid_target_unit"
	end
end

BtBeastOfNurgleConsumeMinionAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.consume_minion_cooldown = 0
end

BtBeastOfNurgleConsumeMinionAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	scratchpad.behavior_component.consume_minion_cooldown = t + Managers.state.difficulty:get_table_entry_by_challenge(action_data.cooldown)
	local aim_component = scratchpad.aim_component
	aim_component.controlled_aiming = false

	scratchpad.navigation_extension:set_enabled(false)

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)

	GameSession.set_game_object_field(game_session, game_object_id, "consumed_minion_unit_id", NetworkConstants.invalid_game_object_id)
	self:_stop_effect_template(scratchpad)
end

BtBeastOfNurgleConsumeMinionAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "tongue_out" then
		self:_update_tongue_out(unit, scratchpad, action_data, t)
	elseif state == "tongue_in" then
		self:_update_tongue_in(unit, scratchpad, action_data, t)
	elseif state == "consuming" then
		self:_update_consuming(unit, scratchpad, action_data, t)
	elseif state == "done" or state == "invalid_target_unit" then
		return "done"
	end

	if state == "tongue_out" then
		self:_rotate_towards_target_unit(unit, scratchpad, action_data)
	end

	local variable_name = action_data.tongue_length_variable_name
	local percentage = scratchpad.initial_distance_to_target / action_data.max_tongue_length
	local variable_value = math.clamp(percentage, 0, 1)

	scratchpad.animation_extension:set_variable(variable_name, variable_value)

	return "running"
end

local BROADPHASE_RESULTS = {}

BtBeastOfNurgleConsumeMinionAction._get_target = function (self, unit, scratchpad, action_data)
	local broadphase_config = scratchpad.broadphase_config
	local broadphase_relation = broadphase_config.relation
	local radius = broadphase_config.radius
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local target_side_names = side:relation_side_names(broadphase_relation)
	local from = POSITION_LOOKUP[unit]
	local num_results = broadphase:query(from, radius, BROADPHASE_RESULTS, target_side_names)

	if num_results < 1 then
		return nil
	end

	local angle = broadphase_config.angle
	local rotation = Unit.world_rotation(unit, 1)
	local forward = Quaternion.forward(rotation)

	for i = 1, num_results do
		local hit_unit = BROADPHASE_RESULTS[i]

		if hit_unit ~= unit then
			local to = POSITION_LOOKUP[hit_unit]
			local direction = Vector3.normalize(to - from)
			local length_sq = Vector3.length_squared(direction)

			if length_sq ~= 0 then
				local angle_to_target = Vector3.angle(direction, forward)

				if angle_to_target < angle then
					local unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
					local breed = unit_data_extension:breed()

					if Breed.is_minion(breed) then
						local tags = breed.tags

						if tags and tags.horde then
							return hit_unit
						end
					end
				end
			end
		end
	end

	return nil
end

BtBeastOfNurgleConsumeMinionAction._start_tongue_out = function (self, unit, scratchpad, action_data, t)
	local target_unit = scratchpad.target_unit
	local tongue_out_anim = action_data.tongue_out_anim

	scratchpad.animation_extension:anim_event(tongue_out_anim)

	local tongue_out_durations = action_data.tongue_out_durations
	local tongue_in_t = tongue_out_durations[tongue_out_anim]
	scratchpad.tongue_in_t = t + tongue_in_t
	local from = POSITION_LOOKUP[unit]
	local to = POSITION_LOOKUP[target_unit]
	scratchpad.initial_distance_to_target = Vector3.distance(from, to)
	scratchpad.state = "tongue_out"
end

BtBeastOfNurgleConsumeMinionAction._update_tongue_out = function (self, unit, scratchpad, action_data, t)
	if scratchpad.tongue_in_t < t then
		self:_start_tongue_in(unit, scratchpad, action_data, t)

		scratchpad.tongue_in_t = nil
	end
end

BtBeastOfNurgleConsumeMinionAction._start_tongue_in = function (self, unit, scratchpad, action_data, t)
	local target_unit = scratchpad.target_unit

	if not ALIVE[target_unit] or not HEALTH_ALIVE[target_unit] then
		scratchpad.state = "invalid_target_unit"

		return
	end

	local target_behavior_extension = ScriptUnit.extension(target_unit, "behavior_system")
	local target_brain = target_behavior_extension:brain()

	target_brain:shutdown_behavior_tree(t, true)
	target_brain:set_active(false)

	local consumed_minion_anim = action_data.consumed_minion_anim
	local target_animation_extension = ScriptUnit.extension(target_unit, "animation_system")

	target_animation_extension:anim_event(consumed_minion_anim)

	local target_health_extension = ScriptUnit.extension(target_unit, "health_system")

	target_health_extension:set_invulnerable(true)

	local tongue_in_anim = action_data.tongue_in_anim

	scratchpad.animation_extension:anim_event(tongue_in_anim)

	local exit_duration = action_data.tongue_in_durations[tongue_in_anim]
	scratchpad.exit_t = t + exit_duration
	local consume_duration = action_data.consume_durations[tongue_in_anim]
	scratchpad.consume_t = t + consume_duration
	local heal_duration = action_data.heal_durations[tongue_in_anim]
	scratchpad.heal_t = t + heal_duration
	local game_session = Managers.state.game_session:game_session()
	local game_object_id = Managers.state.unit_spawner:game_object_id(unit)
	local target_unit_id = Managers.state.unit_spawner:game_object_id(target_unit)

	GameSession.set_game_object_field(game_session, game_object_id, "consumed_minion_unit_id", target_unit_id)
	self:_start_effect_template(unit, scratchpad, action_data)

	scratchpad.state = "tongue_in"
end

BtBeastOfNurgleConsumeMinionAction._update_tongue_in = function (self, unit, scratchpad, action_data, t)
	if scratchpad.consume_t < t then
		self:_start_consuming(unit, scratchpad, action_data, t)

		scratchpad.consume_t = nil
	end
end

BtBeastOfNurgleConsumeMinionAction._start_consuming = function (self, unit, scratchpad, action_data, t)
	if ALIVE[unit] then
		World.unlink_unit(scratchpad.world, scratchpad.target_unit, true)

		local minion_spawn_manager = Managers.state.minion_spawn

		minion_spawn_manager:despawn(scratchpad.target_unit)
	end

	scratchpad.state = "consuming"
end

BtBeastOfNurgleConsumeMinionAction._update_consuming = function (self, unit, scratchpad, action_data, t)
	if scratchpad.exit_t < t then
		scratchpad.state = "done"

		return
	end

	if scratchpad.heal_t and scratchpad.heal_t < t then
		self:_heal(unit, scratchpad, action_data)

		scratchpad.heal_t = nil
	end
end

BtBeastOfNurgleConsumeMinionAction._heal = function (self, unit, scratchpad, action_data)
	local heal_amount = Managers.state.difficulty:get_table_entry_by_challenge(action_data.heal_amount)
	local heal_type = nil

	Health.add(unit, heal_amount, heal_type)
end

BtBeastOfNurgleConsumeMinionAction._rotate_towards_target_unit = function (self, unit, scratchpad, action_data)
	local target_unit = scratchpad.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	local target_aim_node = action_data.target_aim_node or "j_head"
	local node = Unit.node(target_unit, target_aim_node)
	local aim_position = Unit.world_position(target_unit, node)

	scratchpad.aim_component.controlled_aim_position:store(aim_position)
end

BtBeastOfNurgleConsumeMinionAction._start_effect_template = function (self, unit, scratchpad, action_data)
	local effect_template = action_data.effect_template
	local fx_system = scratchpad.fx_system
	local global_effect_id = fx_system:start_template_effect(effect_template, unit)
	scratchpad.global_effect_id = global_effect_id
end

BtBeastOfNurgleConsumeMinionAction._stop_effect_template = function (self, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

return BtBeastOfNurgleConsumeMinionAction
