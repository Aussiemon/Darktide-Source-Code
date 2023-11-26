-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_quick_grenade_throw_action.lua

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

	self:_start_throwing(unit, t, scratchpad, action_data)

	local vo_event = action_data.vo_event

	if vo_event then
		Vo.enemy_generic_vo_event(unit, vo_event)
	end
end

BtQuickGrenadeThrowAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.throw_timing and scratchpad.start_drop_grenade_timing and t >= scratchpad.start_drop_grenade_timing then
		local dt = Managers.time:delta_time("gameplay")
		local throw_config = action_data.throw_config
		local unit_node = Unit.node(unit, throw_config.unit_node)
		local throw_position = Unit.world_position(unit, unit_node)
		local throw_direction = Vector3.up()
		local delta_position = Unit.delta_position(unit, unit_node)
		local node_velocity = delta_position / dt

		self:_throw_grenade(unit, action_data, "drop", throw_position, throw_direction, blackboard, t, node_velocity)
	end

	if scratchpad.global_effect_id then
		self:_stop_effect_template(scratchpad)
	end

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	if action_data.cooldown then
		local throw_grenade_component = Blackboard.write_component(blackboard, "throw_grenade")
		local cooldown = Managers.state.difficulty:get_table_entry_by_challenge(action_data.cooldown)

		throw_grenade_component.next_throw_at_t = t + cooldown
	end
end

BtQuickGrenadeThrowAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if scratchpad.throw_timing or scratchpad.next_throw_timing_index then
		self:_update_throw_timing(unit, t, blackboard, scratchpad, action_data)
	end

	local done = t > scratchpad.action_duration

	if done then
		return "done"
	end

	return "running"
end

BtQuickGrenadeThrowAction._start_throwing = function (self, unit, t, scratchpad, action_data)
	local multiple_throw_chance = action_data.multiple_throw_chance
	local should_multiple_throw = multiple_throw_chance and multiple_throw_chance >= math.random()
	local aim_anim_events = should_multiple_throw and action_data.multiple_aim_anim_events or action_data.aim_anim_events
	local throw_event = Animation.random_event(aim_anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(throw_event)

	local throw_timing = action_data.throw_timing[throw_event]

	if type(throw_timing) == "table" then
		scratchpad.next_throw_timing = t + throw_timing[1]
		scratchpad.throw_timings = throw_timing
		scratchpad.next_throw_timing_index = 1
		scratchpad.start_t = t
	else
		scratchpad.throw_timing = t + throw_timing
	end

	local action_duration = action_data.action_durations[throw_event]

	scratchpad.action_duration = t + action_duration
	scratchpad.throw_event = throw_event

	local effect_template = action_data.effect_template

	if effect_template then
		local effect_template_timings = action_data.effect_template_timings
		local effect_template_timing = effect_template_timings[throw_event]

		scratchpad.effect_template_timing = t + effect_template_timing
		scratchpad.fx_system = Managers.state.extension:system("fx_system")
	end

	if action_data.start_drop_grenade_timing then
		local start_drop_grenade_timing = action_data.start_drop_grenade_timing[throw_event]

		scratchpad.start_drop_grenade_timing = t + start_drop_grenade_timing
	end
end

BtQuickGrenadeThrowAction._update_throw_timing = function (self, unit, t, blackboard, scratchpad, action_data)
	self:_aim_at_target(unit, scratchpad)

	if scratchpad.effect_template_timing and t > scratchpad.effect_template_timing and not scratchpad.global_effect_id then
		local global_effect_id = scratchpad.fx_system:start_template_effect(action_data.effect_template, unit)

		scratchpad.global_effect_id = global_effect_id
		scratchpad.effect_template_timing = nil
	end

	if scratchpad.throw_timings then
		if scratchpad.next_throw_timing and t >= scratchpad.next_throw_timing then
			scratchpad.override_unit_node = action_data.unit_nodes[scratchpad.throw_event][scratchpad.next_throw_timing_index]

			local throw_position, throw_direction = self:_throw_position_and_direction(unit, scratchpad, action_data)

			if throw_position and throw_direction then
				self:_throw_grenade(unit, action_data, "throw", throw_position, throw_direction, blackboard, t)

				scratchpad.throw_timing = nil

				self:_stop_effect_template(scratchpad)
			end

			local throw_timings = scratchpad.throw_timings
			local index = scratchpad.next_throw_timing_index + 1

			if index <= #throw_timings then
				scratchpad.next_throw_timing = scratchpad.start_t + throw_timings[index]
				scratchpad.next_throw_timing_index = index
			else
				scratchpad.next_throw_timing = nil
			end
		end
	elseif t > scratchpad.throw_timing then
		local throw_position, throw_direction = self:_throw_position_and_direction(unit, scratchpad, action_data)

		if throw_position and throw_direction then
			self:_throw_grenade(unit, action_data, "throw", throw_position, throw_direction, blackboard, t)

			scratchpad.throw_timing = nil

			self:_stop_effect_template(scratchpad)
		end
	end
end

local ABOVE, BELOW = 0.5, 3

BtQuickGrenadeThrowAction._throw_position_and_direction = function (self, unit, scratchpad, action_data)
	local target_unit = scratchpad.perception_component.target_unit
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	local nav_world = navigation_extension:nav_world()
	local last_los_position = scratchpad.perception_extension:last_los_position(target_unit)
	local random_throw_offset_config = action_data.random_throw_offset_config
	local throw_position

	if random_throw_offset_config and random_throw_offset_config[scratchpad.throw_event] then
		local config = random_throw_offset_config[scratchpad.throw_event]
		local offset_radius_range = config.offset_radius_range

		if offset_radius_range then
			local random_range = math.random_range(offset_radius_range[1], offset_radius_range[2])
			local radians = math.two_pi * math.random()
			local direction = Vector3(math.sin(radians), math.cos(radians), 0) * random_range
			local test_position = last_los_position + direction

			throw_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, test_position, ABOVE, BELOW)
			throw_position = throw_position or test_position + Vector3(0, 0, 0.1)
		end

		local fan_pattern = config.fan_pattern

		if fan_pattern then
			local to_target = Vector3.normalize(last_los_position - POSITION_LOOKUP[unit])
			local right = Vector3.cross(to_target, Vector3.up())
			local index = scratchpad.next_throw_timing_index

			last_los_position = last_los_position - right * math.floor(#scratchpad.throw_timings)

			local test_position = last_los_position + right * (index * config.offset)

			throw_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, test_position, ABOVE, BELOW)

			if not throw_position then
				throw_position = test_position + Vector3(0, 0, 0.1)
			end
		end
	else
		throw_position = NavQueries.position_on_mesh_with_outside_position(nav_world, nil, last_los_position, ABOVE, BELOW)
		throw_position = throw_position or POSITION_LOOKUP[target_unit] + Vector3(0, 0, 0.1)
	end

	local throw_config = action_data.throw_config
	local unit_node = Unit.node(unit, scratchpad.override_unit_node or throw_config.unit_node)
	local self_position = Unit.world_position(unit, unit_node)
	local projectile_template = throw_config.projectile_template
	local locomotion_template = projectile_template.locomotion_template
	local trajectory_parameters = locomotion_template.trajectory_parameters.throw
	local integrator_parameters = locomotion_template.integrator_parameters
	local speed, gravity, acceptable_accuracy = trajectory_parameters.speed_initial, integrator_parameters.gravity, throw_config.acceptable_accuracy
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
	local trajectory_parameters = locomotion_template.trajectory_parameters[throw_type]
	local speed = trajectory_parameters.speed_initial or trajectory_parameters.speed

	if optional_owner_velocity then
		local velocity = speed * throw_direction
		local inherit_owner_velocity_percentage = trajectory_parameters.inherit_owner_velocity_percentage
		local minion_velocity_contribution = optional_owner_velocity * inherit_owner_velocity_percentage
		local throw_velocity = minion_velocity_contribution + velocity

		throw_direction = Vector3.normalize(throw_velocity)
		speed = Vector3.length(throw_velocity)
	end

	local angular_velocity

	if trajectory_parameters.randomized_angular_velocity then
		local max = trajectory_parameters.randomized_angular_velocity

		angular_velocity = Vector3(math.random() * max.x, math.random() * max.y, math.random() * max.z)
	elseif trajectory_parameters.initial_angular_velocity then
		angular_velocity = trajectory_parameters.randomized_angular_velocity:unbox()
	else
		angular_velocity = Vector3.zero()
	end

	local item_name = throw_config.item
	local item_definitions = MasterItems.get_cached()
	local item = item_definitions[item_name]
	local grenade_unit_name, locomotion_state = item.base_unit, trajectory_parameters.locomotion_state
	local side_system = Managers.state.extension:system("side_system")
	local side = side_system.side_by_unit[unit]
	local is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil
	local owner_side = side and side:name()

	Managers.state.unit_spawner:spawn_network_unit(grenade_unit_name, "item_projectile", throw_position, nil, nil, item, projectile_template, locomotion_state, throw_direction, speed, angular_velocity, unit, is_critical_strike, origin_item_slot, charge_level, target_unit, target_position, weapon_item_or_nil, fuse_override_time_or_nil, owner_side)
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
