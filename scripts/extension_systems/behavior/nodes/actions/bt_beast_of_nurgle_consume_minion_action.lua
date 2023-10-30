require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Health = require("scripts/utilities/health")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtBeastOfNurgleConsumeMinionAction = class("BtBeastOfNurgleConsumeMinionAction", "BtNode")

BtBeastOfNurgleConsumeMinionAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.world = spawn_component.world
	local aim_component = Blackboard.write_component(blackboard, "aim")
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.aim_component = aim_component
	scratchpad.behavior_component = behavior_component
	scratchpad.spawn_component = spawn_component
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	aim_component.controlled_aiming = true
	local target_unit, target_distance, target_behavior_extension = self:_get_target(unit, breed)

	if target_unit then
		self:_start_tongue_out(target_distance, scratchpad, action_data, t)

		scratchpad.target_behavior_extension = target_behavior_extension
		scratchpad.target_unit = target_unit
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
	scratchpad.aim_component.controlled_aiming = false
	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id

	GameSession.set_game_object_field(game_session, game_object_id, "consumed_minion_unit_id", NetworkConstants.invalid_game_object_id)
	self:_stop_effect_template(scratchpad)
end

BtBeastOfNurgleConsumeMinionAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local target_unit = scratchpad.target_unit

	if not HEALTH_ALIVE[target_unit] then
		scratchpad.state = "invalid_target_unit"
	end

	local state = scratchpad.state

	if state == "tongue_out" then
		self:_update_tongue_out(unit, scratchpad, action_data, t)
	elseif state == "tongue_in" then
		self:_update_tongue_in(unit, scratchpad, action_data, t)
	elseif state == "consuming" then
		self:_update_consuming(scratchpad, t)
	elseif state == "done" or state == "invalid_target_unit" then
		return "done"
	end

	if state == "tongue_out" then
		self:_rotate_towards_target_unit(unit, scratchpad, action_data)
	end

	return "running"
end

local BROADPHASE_RESULTS = {}

BtBeastOfNurgleConsumeMinionAction._get_target = function (self, unit, breed)
	local broadphase_config = breed.nearby_units_broadphase_config
	local broadphase_relation = broadphase_config.relation
	local radius = broadphase_config.radius
	local valid_breeds = broadphase_config.valid_breeds
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local target_side_names = side:relation_side_names(broadphase_relation)
	local from = POSITION_LOOKUP[unit]
	local num_results = broadphase:query(from, radius, BROADPHASE_RESULTS, target_side_names)

	if num_results < 1 then
		return nil, nil
	end

	local angle = broadphase_config.angle
	local rotation = Unit.world_rotation(unit, 1)
	local forward = Quaternion.forward(rotation)

	for i = 1, num_results do
		local hit_unit = BROADPHASE_RESULTS[i]

		if hit_unit ~= unit then
			local to = POSITION_LOOKUP[hit_unit]
			local direction, length = Vector3.direction_length(to - from)

			if length > 0.001 then
				local angle_to_target = Vector3.angle(direction, forward)

				if angle_to_target < angle then
					local unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
					local hit_breed_name = unit_data_extension:breed_name()

					if valid_breeds[hit_breed_name] then
						local hit_unit_behavior_extension = ScriptUnit.extension(hit_unit, "behavior_system")
						local hit_unit_brain = hit_unit_behavior_extension:brain()

						if hit_unit_brain:active() then
							return hit_unit, length, hit_unit_behavior_extension
						end
					end
				end
			end
		end
	end

	return nil, nil
end

BtBeastOfNurgleConsumeMinionAction._start_tongue_out = function (self, target_distance, scratchpad, action_data, t)
	local tongue_out_anim = action_data.tongue_out_anim
	local animation_extension = scratchpad.animation_extension

	animation_extension:anim_event(tongue_out_anim)

	local variable_name = action_data.tongue_length_variable_name
	local min_tongue_length = action_data.min_tongue_length
	local max_tongue_length = action_data.max_tongue_length
	local percentage = (target_distance - min_tongue_length) / (max_tongue_length - min_tongue_length)
	local variable_value = math.clamp(percentage, 0, 1)

	animation_extension:set_variable(variable_name, variable_value)

	local tongue_out_durations = action_data.tongue_out_durations
	local tongue_in_t = tongue_out_durations[tongue_out_anim]
	scratchpad.tongue_in_t = t + tongue_in_t
	scratchpad.behavior_component.move_state = "attacking"
	scratchpad.state = "tongue_out"
end

BtBeastOfNurgleConsumeMinionAction._update_tongue_out = function (self, unit, scratchpad, action_data, t)
	if scratchpad.tongue_in_t < t then
		local target_behavior_extension = scratchpad.target_behavior_extension
		local target_brain = target_behavior_extension:brain()

		if target_brain:active() then
			self:_start_tongue_in(unit, target_brain, scratchpad, action_data, t)
		else
			scratchpad.state = "invalid_target_unit"
		end

		scratchpad.tongue_in_t = nil
	end
end

BtBeastOfNurgleConsumeMinionAction._start_tongue_in = function (self, unit, target_brain, scratchpad, action_data, t)
	target_brain:shutdown_behavior_tree(t, true)
	target_brain:set_active(false)

	local target_unit = scratchpad.target_unit
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
	local spawn_component = scratchpad.spawn_component
	local game_session = spawn_component.game_session
	local game_object_id = spawn_component.game_object_id
	local target_unit_id = Managers.state.unit_spawner:game_object_id(target_unit)

	GameSession.set_game_object_field(game_session, game_object_id, "consumed_minion_unit_id", target_unit_id)
	self:_start_effect_template(unit, scratchpad, action_data)

	scratchpad.state = "tongue_in"
end

BtBeastOfNurgleConsumeMinionAction._update_tongue_in = function (self, unit, scratchpad, action_data, t)
	if scratchpad.consume_t < t then
		self:_start_consuming(scratchpad)

		scratchpad.consume_t = nil
	end

	if scratchpad.heal_t and scratchpad.heal_t < t then
		self:_heal(unit, action_data)

		scratchpad.heal_t = nil
	end
end

BtBeastOfNurgleConsumeMinionAction._start_consuming = function (self, scratchpad)
	local target_unit = scratchpad.target_unit
	local reset_scene_graph = true

	World.unlink_unit(scratchpad.world, target_unit, reset_scene_graph)
	Managers.state.minion_spawn:despawn(target_unit)

	scratchpad.state = "consuming"
end

BtBeastOfNurgleConsumeMinionAction._update_consuming = function (self, scratchpad, t)
	if scratchpad.exit_t < t then
		scratchpad.state = "done"

		return
	end
end

BtBeastOfNurgleConsumeMinionAction._heal = function (self, unit, action_data)
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
	local global_effect_id = scratchpad.fx_system:start_template_effect(effect_template, unit)
	scratchpad.global_effect_id = global_effect_id
end

BtBeastOfNurgleConsumeMinionAction._stop_effect_template = function (self, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		scratchpad.fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

return BtBeastOfNurgleConsumeMinionAction
