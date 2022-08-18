require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionVisualLoadout = require("scripts/utilities/minion_visual_loadout")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local BtShootPatternAction = class("BtShootPatternAction", "BtNode")

BtShootPatternAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	behavior_component.move_state = "attacking"
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.perception_extension = ScriptUnit.extension(unit, "perception_system")
	local perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.aim_component = Blackboard.write_component(blackboard, "aim")
	scratchpad.perception_component = perception_component
	local spawn_component = blackboard.spawn
	scratchpad.world = spawn_component.world
	scratchpad.physics_world = spawn_component.physics_world

	MinionPerception.set_target_lock(unit, perception_component, true)

	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local weapon_item = visual_loadout_extension:slot_item(action_data.inventory_slot)
	scratchpad.weapon_item = weapon_item
	scratchpad.controlled_aim_position = Vector3Box()
	scratchpad.shots_fired = 0
	scratchpad.aim_node_name = breed.aim_config.node
	scratchpad.pattern_position = Vector3Box()
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	scratchpad.fx_extension = ScriptUnit.extension(unit, "fx_system")

	self:_start(unit, t, scratchpad, action_data)
end

BtShootPatternAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local aim_component = scratchpad.aim_component
	aim_component.controlled_aiming = false

	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)
	self:_stop_shooting(unit, scratchpad)
end

BtShootPatternAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local state = scratchpad.state

	if state == "starting" then
		local should_abort = self:_update_starting(unit, t, scratchpad, action_data)

		if should_abort then
			return "done"
		end
	elseif state == "shooting" then
		local done = self:_update_shooting(unit, t, dt, scratchpad, action_data)

		if done then
			return "done"
		end
	end

	return "running"
end

BtShootPatternAction._start = function (self, unit, t, scratchpad, action_data)
	local start_anim_events = action_data.start_anim_events or "aim"
	local start_event = Animation.random_event(start_anim_events)
	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	animation_extension:anim_event(start_event)

	scratchpad.current_aim_anim_event = start_event
	local start_durations = action_data.start_duration[start_event]
	local diff_start_durations = Managers.state.difficulty:get_table_entry_by_challenge(start_durations)
	local start_duration = math.random_range(diff_start_durations[1], diff_start_durations[2])
	scratchpad.state = "starting"
	scratchpad.start_duration = t + start_duration
end

BtShootPatternAction._update_starting = function (self, unit, t, scratchpad, action_data)
	self:_rotate_towards_target_unit(unit, scratchpad)

	local perception_component = scratchpad.perception_component
	local has_line_of_sight = perception_component.has_line_of_sight

	if scratchpad.start_duration < t then
		local perception_extension = scratchpad.perception_extension
		local target_unit = perception_component.target_unit
		local last_los_position = perception_extension:last_los_position(target_unit)

		if has_line_of_sight or last_los_position then
			self:_start_shooting(unit, t, scratchpad, action_data)

			return false
		else
			return true
		end
	end

	return false
end

BtShootPatternAction._start_shooting = function (self, unit, t, scratchpad, action_data)
	scratchpad.state = "shooting"
	local aim_component = scratchpad.aim_component
	aim_component.controlled_aiming = true
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local last_los_position = scratchpad.perception_extension:last_los_position(target_unit)

	aim_component.controlled_aim_position:store(last_los_position)
	scratchpad.controlled_aim_position:store(last_los_position)

	local pattern = action_data.pattern
	local num_pattern_points = #pattern
	scratchpad.num_pattern_points = num_pattern_points
	scratchpad.pattern = pattern
	scratchpad.pattern_index = 1
	local first_pattern_point = pattern[1]

	self:_setup_pattern_point(scratchpad, first_pattern_point, last_los_position)

	local has_line_of_sight = perception_component.has_line_of_sight

	if has_line_of_sight then
		AttackIntensity.add_intensity(target_unit, action_data.attack_intensities)
		AttackIntensity.set_attacked(target_unit)
	end
end

BtShootPatternAction._stop_shooting = function (self, unit, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if scratchpad.state ~= "shooting" or not global_effect_id then
		return
	end

	local fx_system = scratchpad.fx_system

	fx_system:stop_template_effect(global_effect_id)

	scratchpad.global_effect_id = nil
end

BtShootPatternAction._update_shooting = function (self, unit, t, dt, scratchpad, action_data)
	local done = self:_update_controlled_aiming(unit, scratchpad, action_data, dt, t)

	if done then
		return true
	end

	if scratchpad.next_shoot_timing and scratchpad.next_shoot_timing < t then
		local time_per_shot = action_data.time_per_shot
		local diff_time_per_shot = Managers.state.difficulty:get_table_entry_by_challenge(time_per_shot)
		time_per_shot = math.random_range(diff_time_per_shot[1], diff_time_per_shot[2])

		self:_shoot(unit, scratchpad, action_data)

		scratchpad.next_shoot_timing = t + time_per_shot
	end
end

BtShootPatternAction._shoot = function (self, unit, scratchpad, action_data)
	local weapon_item = scratchpad.weapon_item
	local controlled_aim_position = scratchpad.controlled_aim_position:unbox()
	local shoot_template = action_data.shoot_template
	local fx_source_name = action_data.fx_source_name
	local target_unit = scratchpad.perception_component.target_unit
	local world = scratchpad.world
	local physics_world = scratchpad.physics_world
	local end_position = MinionAttack.shoot_hit_scan(world, physics_world, unit, target_unit, weapon_item, fx_source_name, controlled_aim_position, shoot_template)

	MinionAttack.trigger_shoot_sfx_and_vfx(unit, scratchpad, action_data, end_position)

	if not scratchpad.global_effect_id then
		local fx_system = scratchpad.fx_system
		local effect_template = shoot_template.effect_template
		local global_effect_id = fx_system:start_template_effect(effect_template, unit)
		scratchpad.global_effect_id = global_effect_id
	end

	local fx_extension = scratchpad.fx_extension
	local shoot_event_name = shoot_template.shoot_sound_event
	local inventory_slot_name = action_data.inventory_slot

	if shoot_event_name then
		local is_ranged_attack = true

		scratchpad.fx_extension:trigger_inventory_wwise_event(shoot_event_name, inventory_slot_name, fx_source_name, target_unit, is_ranged_attack)
	end

	local shoot_vfx_name = shoot_template.shoot_vfx_name

	if shoot_vfx_name then
		fx_extension:trigger_inventory_vfx(shoot_vfx_name, inventory_slot_name, fx_source_name)
	end
end

BtShootPatternAction._setup_pattern_point = function (self, scratchpad, pattern_point, position)
	scratchpad.pattern_duration = pattern_point.time
	scratchpad.pattern_timer = 0

	scratchpad.pattern_position:store(position)

	if pattern_point.start_shooting then
		scratchpad.next_shoot_timing = 0
	end
end

BtShootPatternAction._get_pattern_goal_position = function (self, self_position, target_position, pattern_point)
	local to_target_direction = Vector3.normalize(Vector3.flat(target_position - self_position))
	local angle = pattern_point.angle
	local to_target_rotation = Quaternion.look(to_target_direction)
	local angled_rotation = Quaternion.axis_angle(Vector3.forward(), angle)
	local multiplied_rotation = Quaternion.multiply(to_target_rotation, angled_rotation)
	local pattern_direction = Quaternion.up(multiplied_rotation)
	local distance = pattern_point.distance
	local goal_pattern_position = target_position + pattern_direction * distance
	local right = Quaternion.right(multiplied_rotation)

	return goal_pattern_position, right
end

BtShootPatternAction._sin_cos_offset = function (self, position, offset_dir, distance, sin_modifier, cos_modifier, t)
	local offset_pos = position + offset_dir * (math.sin(t * distance) * sin_modifier + math.cos(t * distance) * cos_modifier)

	return offset_pos
end

BtShootPatternAction._update_controlled_aiming = function (self, unit, scratchpad, action_data, dt, t)
	local target_unit = scratchpad.perception_component.target_unit
	local perception_extension = scratchpad.perception_extension
	local last_los_position = perception_extension:last_los_position(target_unit)

	if not last_los_position then
		return
	end

	local attachment_unit, node = MinionVisualLoadout.attachment_unit_and_node_from_node_name(scratchpad.weapon_item, action_data.fx_source_name)
	local unit_position = Unit.world_position(attachment_unit, node)
	local pattern = scratchpad.pattern
	local num_pattern_points = scratchpad.num_pattern_points
	local pattern_index = scratchpad.pattern_index
	local pattern_point = pattern[pattern_index]
	local pattern_goal_position, pattern_right = self:_get_pattern_goal_position(unit_position, last_los_position, pattern_point)
	local pattern_duration = scratchpad.pattern_duration
	local pattern_timer = scratchpad.pattern_timer
	local pattern_timer_percentage = pattern_timer / pattern_duration
	local pattern_position = scratchpad.pattern_position:unbox()
	local new_pattern_position = Vector3.lerp(pattern_position, pattern_goal_position, pattern_timer_percentage)
	new_pattern_position = self:_sin_cos_offset(new_pattern_position, pattern_right, pattern_point.distance, pattern_point.sin or 0, pattern_point.cos or 0, t)
	local aim_component = scratchpad.aim_component

	aim_component.controlled_aim_position:store(new_pattern_position)
	scratchpad.controlled_aim_position:store(new_pattern_position)

	local flat_to_new_pattern_position = Vector3.flat(Vector3.normalize(new_pattern_position - unit_position))
	local unit_rotation = Unit.local_rotation(unit, 1)
	local unit_forward = Quaternion.forward(unit_rotation)
	local dot = Vector3.dot(unit_forward, flat_to_new_pattern_position)

	if dot < math.inverse_sqrt_2 then
		local wanted_rotation = Quaternion.look(flat_to_new_pattern_position)

		scratchpad.locomotion_extension:set_wanted_rotation(wanted_rotation)
	end

	if pattern_duration <= pattern_timer and pattern_index == num_pattern_points then
		return true
	elseif pattern_duration <= pattern_timer then
		scratchpad.pattern_index = scratchpad.pattern_index + 1
		pattern_index = scratchpad.pattern_index
		pattern_point = pattern[pattern_index]

		self:_setup_pattern_point(scratchpad, pattern_point, new_pattern_position)
	else
		scratchpad.pattern_timer = scratchpad.pattern_timer + dt
	end
end

BtShootPatternAction._rotate_towards_target_unit = function (self, unit, scratchpad)
	local target_unit = scratchpad.perception_component.target_unit
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)

	return flat_rotation
end

return BtShootPatternAction
