require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MasterItems = require("scripts/backend/master_items")
local MinionPerception = require("scripts/utilities/minion_perception")
local NavQueries = require("scripts/utilities/nav_queries")
local Trajectory = require("scripts/utilities/trajectory")
local Vo = require("scripts/utilities/vo")
local BtQuickGrenadeThrowAction = class("BtQuickGrenadeThrowAction", "BtNode")

BtQuickGrenadeThrowAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = "attacking"
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	local perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.perception_component = perception_component

	MinionPerception.set_target_lock(unit, perception_component, true)

	if action_data.attack_intensities then
		AttackIntensity.add_intensity(perception_component.target_unit, action_data.attack_intensities)
	end

	self:_start_aiming(unit, t, scratchpad, action_data)

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event)
	end
end

BtQuickGrenadeThrowAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.aim_duration then
		local dt = Managers.time:delta_time("gameplay")
		local throw_config = action_data.throw_config
		local unit_node = Unit.node(unit, throw_config.unit_node)
		local throw_position = Unit.world_position(unit, unit_node)
		local throw_direction = Vector3.up()
		local delta_position = Unit.delta_position(unit, unit_node)
		local node_velocity = delta_position / dt

		self:_throw_grenade(unit, action_data, "drop", throw_position, throw_direction, blackboard, t, node_velocity)
		self:_stop_effect_template(scratchpad)
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
end

BtQuickGrenadeThrowAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.aim_duration then
		self:_update_aiming(unit, t, blackboard, scratchpad, action_data)
	end

	local done = scratchpad.action_duration < t

	if done then
		return "done"
	end

	return "running"
end

BtQuickGrenadeThrowAction._start_aiming = function (self, unit, t, scratchpad, action_data)
	local aim_anim_events = action_data.aim_anim_events
	local aim_event = Animation.random_event(aim_anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(aim_event)

	local aim_duration = action_data.aim_duration[aim_event]
	scratchpad.aim_duration = t + aim_duration
	local action_duration = action_data.action_durations[aim_event]
	scratchpad.action_duration = t + action_duration
	local effect_template = action_data.effect_template

	if effect_template then
		local effect_template_timings = action_data.effect_template_timings
		local effect_template_timing = effect_template_timings[aim_event]
		scratchpad.effect_template_timing = t + effect_template_timing
		scratchpad.fx_system = Managers.state.extension:system("fx_system")
	end
end

BtQuickGrenadeThrowAction._update_aiming = function (self, unit, t, blackboard, scratchpad, action_data)
	self:_aim_at_target(unit, scratchpad)

	if scratchpad.effect_template_timing and scratchpad.effect_template_timing < t then
		local global_effect_id = scratchpad.fx_system:start_template_effect(action_data.effect_template, unit)
		scratchpad.global_effect_id = global_effect_id
		scratchpad.effect_template_timing = nil
	end

	if scratchpad.aim_duration < t then
		local throw_position, throw_direction = self:_throw_position_and_direction(unit, scratchpad, action_data)

		if throw_position and throw_direction then
			self:_throw_grenade(unit, action_data, "throw", throw_position, throw_direction, blackboard, t)

			scratchpad.aim_duration = nil

			self:_stop_effect_template(scratchpad)
		end
	end
end

local ABOVE = 0.5
local BELOW = 3

BtQuickGrenadeThrowAction._throw_position_and_direction = function (self, unit, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()
	local last_los_position = scratchpad.perception_extension:last_los_position(target_unit)
	local throw_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, last_los_position, ABOVE, BELOW)
	throw_position = throw_position or POSITION_LOOKUP[target_unit] + Vector3(0, 0, 0.1)
	local throw_config = action_data.throw_config
	local unit_node = Unit.node(unit, throw_config.unit_node)
	local self_position = Unit.world_position(unit, unit_node)
	local projectile_template = throw_config.projectile_template
	local locomotion_template = projectile_template.locomotion_template
	local throw_parameters = locomotion_template.throw_parameters.throw
	local integrator_parameters = locomotion_template.integrator_parameters
	local speed = throw_parameters.speed_inital
	local gravity = integrator_parameters.gravity
	local acceptable_accuracy = throw_config.acceptable_accuracy
	local target_velocity = Vector3(0, 0, 0)
	local angle_to_hit_target, estimated_position = Trajectory.angle_to_hit_moving_target(self_position, throw_position, speed, target_velocity, gravity, acceptable_accuracy)

	if angle_to_hit_target == nil then
		return nil, nil
	end

	local velocity = Trajectory.get_trajectory_velocity(self_position, estimated_position, gravity, speed, angle_to_hit_target)

	return self_position, Vector3.normalize(velocity)
end

BtQuickGrenadeThrowAction._throw_grenade = function (self, unit, action_data, throw_type, throw_position, throw_direction, blackboard, t, optional_owner_velocity)
	local throw_config = action_data.throw_config
	local projectile_template = throw_config.projectile_template
	local locomotion_template = projectile_template.locomotion_template
	local throw_parameters = locomotion_template.throw_parameters[throw_type]
	local speed = throw_parameters.speed_inital or throw_parameters.speed

	if optional_owner_velocity then
		local velocity = speed * throw_direction
		local inherit_owner_velocity_percentage = throw_parameters.inherit_owner_velocity_percentage
		local minion_velocity_contribution = optional_owner_velocity * inherit_owner_velocity_percentage
		local throw_velocity = minion_velocity_contribution + velocity
		throw_direction = Vector3.normalize(throw_velocity)
		speed = Vector3.length(throw_velocity)
	end

	local momentum = nil

	if throw_parameters.randomized_momentum then
		local max = throw_parameters.randomized_momentum
		momentum = Vector3(math.random() * max.x, math.random() * max.y, math.random() * max.z)
	elseif throw_parameters.momentum then
		momentum = throw_parameters.momentum:unbox()
	else
		momentum = Vector3.zero()
	end

	local item_name = throw_config.item
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local grenade_unit_name = item.base_unit
	local locomotion_state = throw_parameters.locomotion_state

	Managers.state.unit_spawner:spawn_network_unit(grenade_unit_name, "item_projectile", throw_position, nil, nil, item, projectile_template, locomotion_state, throw_direction, speed, momentum, unit)

	if action_data.cooldown then
		local throw_grenade_component = Blackboard.write_component(blackboard, "throw_grenade")
		local cooldown = Managers.state.difficulty:get_table_entry_by_challenge(action_data.cooldown)
		throw_grenade_component.next_throw_at_t = t + cooldown
	end
end

BtQuickGrenadeThrowAction._aim_at_target = function (self, unit, scratchpad)
	local perception_component = scratchpad.perception_component

	if not perception_component.has_line_of_sight then
		return
	end

	local target_unit = perception_component.target_unit
	local last_los_position = scratchpad.perception_extension:last_los_position(target_unit)
	local unit_position = POSITION_LOOKUP[unit]
	local to_target = last_los_position - unit_position
	local to_target_direction = Vector3.normalize(to_target)
	local flat_to_target_direction = Vector3.flat(to_target_direction)
	local wanted_rotation = Quaternion.look(flat_to_target_direction)

	scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)
end

BtQuickGrenadeThrowAction._stop_effect_template = function (self, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		scratchpad.fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

return BtQuickGrenadeThrowAction
