require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BreedSettings = require("scripts/settings/breed/breed_settings")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local breed_types = BreedSettings.types
local BtPoxwalkerBomberApproachAction = class("BtPoxwalkerBomberApproachAction", "BtNode")

BtPoxwalkerBomberApproachAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = navigation_extension
	scratchpad.stagger_component = Blackboard.write_component(blackboard, "stagger")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = blackboard.perception
	scratchpad.nav_world = navigation_extension:nav_world()
	scratchpad.traverse_logic = navigation_extension:traverse_logic()

	navigation_extension:set_enabled(true, action_data.move_speed or breed.run_speed)

	if action_data.effect_template then
		local fx_system = Managers.state.extension:system("fx_system")
		scratchpad.fx_system = fx_system
	end

	scratchpad.move_to_cooldown = 0

	self:_update_move_to(t, scratchpad, action_data, scratchpad.perception_component.target_unit)
end

BtPoxwalkerBomberApproachAction.init_values = function (self, blackboard)
	local death_component = Blackboard.write_component(blackboard, "death")

	death_component.attack_direction:store(0, 0, 0)

	death_component.hit_zone_name = ""
	death_component.is_dead = false
	death_component.hit_during_death = false
	death_component.damage_profile_name = ""
	death_component.herding_template_name = ""
	death_component.killing_damage_type = ""
	death_component.force_instant_ragdoll = false
	death_component.staggered_during_lunge = false
	death_component.fuse_timer = 0
end

BtPoxwalkerBomberApproachAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.stagger_component.num_triggered_staggers > 0 and scratchpad.lunge_duration then
		local death_component = Blackboard.write_component(blackboard, "death")
		death_component.staggered_during_lunge = true
		local duration = scratchpad.stagger_component.duration
		scratchpad.stagger_component.duration = duration * action_data.stagger_duration_modifier_during_lunge
	end

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if scratchpad.stagger_duration then
		MinionMovement.stop_running_stagger(scratchpad)
	end

	scratchpad.navigation_extension:set_enabled(false)

	if scratchpad.global_effect_id then
		scratchpad.fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	scratchpad.stagger_component.immune_time = 0
end

BtPoxwalkerBomberApproachAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local perception_component = scratchpad.perception_component
	local target_unit = perception_component.target_unit
	local state = scratchpad.state

	if not scratchpad.move_during_lunge_duration or t < scratchpad.move_during_lunge_duration then
		self:_update_move_to(t, scratchpad, action_data, target_unit)
	end

	if state == "lunging" then
		self:_update_lunge(unit, scratchpad, action_data, dt, t, blackboard, breed)

		return "running"
	end

	local behavior_component = scratchpad.behavior_component

	if action_data.running_stagger_duration then
		local optional_reset_stagger_immune_time = true
		local done_with_running_stagger = MinionMovement.update_running_stagger(unit, t, dt, scratchpad, action_data, optional_reset_stagger_immune_time)

		if done_with_running_stagger then
			self:_start_move_anim(unit, breed, t, scratchpad, action_data)
			self:_update_move_to(t, scratchpad, action_data, target_unit)
		end
	end

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		elseif should_be_idling and scratchpad.state ~= nil then
			self:_rotate_towards_target_unit(unit, target_unit, scratchpad)
		end

		return "running"
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		self:_start_move_anim(unit, breed, t, scratchpad, action_data)
	end

	local is_anim_driven = scratchpad.is_anim_driven

	if is_anim_driven and scratchpad.start_rotation_timing and scratchpad.start_rotation_timing <= t then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)
	end

	if not is_anim_driven then
		if state == "walking" or state == "running" then
			local enter_lunge_distance = action_data.enter_lunge_distance
			local path_distance = scratchpad.navigation_extension:remaining_distance_from_progress_to_end_of_path()
			local nav_smart_object_component = blackboard.nav_smart_object
			local smart_object_id = nav_smart_object_component.id
			local smart_object_is_next = smart_object_id ~= -1

			if not smart_object_is_next and path_distance <= enter_lunge_distance then
				if scratchpad.stagger_duration then
					scratchpad.animation_extension:anim_event("stagger_finished")
				end

				self:_start_lunge(unit, blackboard, scratchpad, action_data, target_unit, t)
			end
		end

		if state == "walking" then
			self:_update_walking(unit, breed, dt, scratchpad, action_data, target_unit)
		elseif state == "running" then
			self:_update_running(unit, breed, dt, scratchpad, action_data, target_unit)
		end
	end

	local navigation_extension = scratchpad.navigation_extension

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			self:_set_state_max_speed(breed, scratchpad, action_data)
		end
	end

	local effect_template = action_data.effect_template

	if effect_template then
		self:_update_effect_template(unit, scratchpad, action_data, target_unit)
	end

	return "running"
end

BtPoxwalkerBomberApproachAction._start_move_anim = function (self, unit, breed, t, scratchpad, action_data)
	local navigation_extension = scratchpad.navigation_extension
	local distance_to_destination = navigation_extension:distance_to_destination()
	local enter_walk_distance = action_data.enter_walk_distance

	if distance_to_destination < enter_walk_distance then
		scratchpad.state = "walking"
	else
		scratchpad.state = "running"
	end

	local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
	scratchpad.moving_direction_name = moving_direction_name
	local start_move_event = nil
	local state = scratchpad.state

	if state == "walking" then
		start_move_event = self:_start_walk_anim(scratchpad, action_data, moving_direction_name)
	else
		local using_anim_driven = false

		if action_data.start_move_anim_events and action_data.start_move_anim_events[state] then
			local start_move_anim_events = action_data.start_move_anim_events[state]
			start_move_event = Animation.random_event(start_move_anim_events[moving_direction_name])
			using_anim_driven = true
		end

		scratchpad.animation_extension:anim_event(start_move_event or action_data.run_anim_event)

		if using_anim_driven and moving_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local start_move_rotation_timings = action_data.start_move_rotation_timings
			local start_rotation_timing = start_move_rotation_timings[start_move_event]
			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = start_move_event
		else
			scratchpad.start_rotation_timing = nil
			scratchpad.move_start_anim_event_name = nil
		end
	end

	self:_set_state_max_speed(breed, scratchpad, action_data)

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
	end

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
end

local function _calculate_distances(unit, scratchpad, target_unit, dt)
	local target_position, target_current_velocity = MinionMovement.target_position_with_velocity(unit, target_unit)
	local self_position = POSITION_LOOKUP[unit]
	local distance_to_target = Vector3.distance(self_position, target_position)
	local navigation_extension = scratchpad.navigation_extension
	local destination = navigation_extension:destination() + target_current_velocity * dt
	local distance_to_destination = Vector3.distance(self_position, destination)

	return distance_to_destination, distance_to_target
end

BtPoxwalkerBomberApproachAction._update_walking = function (self, unit, breed, dt, scratchpad, action_data, target_unit)
	self:_rotate_towards_target_unit(unit, target_unit, scratchpad)

	local leave_walk_distance = action_data.leave_walk_distance
	local distance_to_destination, distance_to_target = _calculate_distances(unit, scratchpad, target_unit, dt)
	local should_leave_walk = leave_walk_distance < distance_to_destination and leave_walk_distance < distance_to_target

	if should_leave_walk then
		self:_change_state(unit, breed, scratchpad, action_data, "running")
	elseif action_data.start_move_anim_events then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)

		if moving_direction_name ~= scratchpad.moving_direction_name then
			self:_start_walk_anim(scratchpad, action_data, moving_direction_name)
			self:_set_state_max_speed(breed, scratchpad, action_data)
		end

		scratchpad.moving_direction_name = moving_direction_name
	end
end

BtPoxwalkerBomberApproachAction._update_running = function (self, unit, breed, dt, scratchpad, action_data, target_unit)
	local enter_walk_distance = action_data.enter_walk_distance

	if not enter_walk_distance then
		return
	end

	local distance_to_destination, distance_to_target = _calculate_distances(unit, scratchpad, target_unit, dt)
	local should_leave_running = distance_to_destination < enter_walk_distance and distance_to_target < enter_walk_distance

	if should_leave_running then
		self:_change_state(unit, breed, scratchpad, action_data, "walking")
	end
end

BtPoxwalkerBomberApproachAction._start_walk_anim = function (self, scratchpad, action_data, optional_moving_direction_name)
	local start_move_anim_events = action_data.start_move_anim_events
	local walking_anim_event = nil

	if start_move_anim_events then
		local start_walking_anim_events = start_move_anim_events.walking
		walking_anim_event = Animation.random_event(start_walking_anim_events[optional_moving_direction_name])
	else
		walking_anim_event = action_data.walk_anim_event
	end

	scratchpad.animation_extension:anim_event(walking_anim_event)

	scratchpad.current_walk_anim_event = walking_anim_event

	return walking_anim_event
end

BtPoxwalkerBomberApproachAction._change_state = function (self, unit, breed, scratchpad, action_data, wanted_state)
	if wanted_state == "walking" then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)

		self:_start_walk_anim(scratchpad, action_data, moving_direction_name)

		scratchpad.moving_direction_name = moving_direction_name
	elseif wanted_state == "running" then
		local run_anim = action_data.run_anim_event

		scratchpad.animation_extension:anim_event(run_anim)
	end

	scratchpad.state = wanted_state

	self:_set_state_max_speed(breed, scratchpad, action_data)
end

BtPoxwalkerBomberApproachAction._set_state_max_speed = function (self, breed, scratchpad, action_data)
	local state = scratchpad.state
	local new_speed = nil

	if state == "walking" then
		local walk_speeds = action_data.walk_speeds
		new_speed = walk_speeds and walk_speeds[scratchpad.current_walk_anim_event] or action_data.walk_speed or breed.walk_speed
	elseif state == "running" then
		new_speed = action_data.move_speed or breed.run_speed
	end

	scratchpad.navigation_extension:set_max_speed(new_speed)

	scratchpad.start_move_event_anim_speed_duration = nil
end

BtPoxwalkerBomberApproachAction._update_effect_template = function (self, unit, scratchpad, action_data, target_unit)
	local self_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[target_unit]
	local distance = Vector3.distance(self_position, target_position)
	local fx_system = scratchpad.fx_system

	if scratchpad.global_effect_id then
		local stop_distance = action_data.effect_template_stop_distance

		if stop_distance <= distance then
			fx_system:stop_template_effect(scratchpad.global_effect_id)

			scratchpad.global_effect_id = nil
		end
	else
		local start_distance = action_data.effect_template_start_distance

		if distance <= start_distance then
			scratchpad.global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)
		end
	end
end

BtPoxwalkerBomberApproachAction._rotate_towards_target_unit = function (self, unit, target_unit, scratchpad)
	local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

	scratchpad.locomotion_extension:set_wanted_rotation(flat_rotation)
end

local TARGET_NAV_MESH_ABOVE = 1
local TARGET_NAV_MESH_BELOW = 2
local TARGET_NAV_MESH_LATERAL = 2
local TARGET_DISTANCE_FROM_NAV_MESH = 0.5

BtPoxwalkerBomberApproachAction._update_move_to = function (self, t, scratchpad, action_data, target_unit)
	local navigation_extension = scratchpad.navigation_extension
	local destination = navigation_extension:destination()
	local target_position = POSITION_LOOKUP[target_unit]
	local distance_to_destination = Vector3.distance(destination, target_position)

	if scratchpad.move_to_cooldown <= t and action_data.move_to_distance < distance_to_destination then
		local nav_world = scratchpad.nav_world
		local traverse_logic = scratchpad.traverse_logic
		local wanted_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, TARGET_NAV_MESH_ABOVE, TARGET_NAV_MESH_BELOW, TARGET_NAV_MESH_LATERAL, TARGET_DISTANCE_FROM_NAV_MESH)

		if wanted_position then
			navigation_extension:move_to(wanted_position)

			scratchpad.move_to_cooldown = t + action_data.move_to_cooldown
		end
	end
end

local AOE_THREAT_SIZE = 7

BtPoxwalkerBomberApproachAction._start_lunge = function (self, unit, blackboard, scratchpad, action_data, target_unit, t)
	local lunge_anim_event = action_data.lunge_anim_event

	scratchpad.animation_extension:anim_event(lunge_anim_event)

	scratchpad.state = "lunging"
	scratchpad.lunge_duration = t + action_data.lunge_duration
	scratchpad.move_during_lunge_duration = t + action_data.move_during_lunge_duration
	local stagger_component = Blackboard.write_component(blackboard, "stagger")
	stagger_component.immune_time = 0
	local death_component = Blackboard.write_component(blackboard, "death")
	death_component.fuse_timer = t + action_data.fuse_timer
	local group_extension = ScriptUnit.extension(target_unit, "group_system")
	local bot_group = group_extension:bot_group()
	local unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local should_create_aoe_threat = unit_data_extension:breed().breed_type == breed_types.player

	if should_create_aoe_threat then
		local shape = "sphere"
		local rotation = Unit.local_rotation(unit, 1)
		local fwd = Quaternion.forward(rotation)
		local position = POSITION_LOOKUP[unit] + fwd * 2

		bot_group:aoe_threat_created(position, shape, AOE_THREAT_SIZE, rotation, action_data.lunge_duration)
	end
end

BtPoxwalkerBomberApproachAction._update_lunge = function (self, unit, scratchpad, action_data, dt, t, blackboard, breed)
	local navigation_extension = scratchpad.navigation_extension

	MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)

	if t < scratchpad.lunge_duration then
		return
	end

	scratchpad.lunge_duration = nil

	Attack.execute(unit, DamageProfileTemplates.default, "attacking_unit", unit, "instakill", true)
end

return BtPoxwalkerBomberApproachAction
