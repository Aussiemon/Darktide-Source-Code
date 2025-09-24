-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_move_to_position_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionDogLocomotionSettings = require("scripts/settings/companion/companion_dog_locomotion_settings")
local CompanionFollow = require("scripts/utilities/companion_follow")
local MinionAttack = require("scripts/utilities/minion_attack")
local MinionMovement = require("scripts/utilities/minion_movement")
local BtCompanionMoveToPositionAction = class("BtCompanionMoveToPositionAction", "BtNode")
local lean_settings = CompanionDogLocomotionSettings.leaning
local ARRIVED_AT_POSITION_THRESHOLD_SQ = 0.1

BtCompanionMoveToPositionAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local navigation_extension = ScriptUnit.extension(unit, "navigation_system")

	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = navigation_extension

	local speed = breed.run_speed

	navigation_extension:set_enabled(true, speed)

	local behavior_component = Blackboard.write_component(blackboard, "behavior")
	local move_to_position = behavior_component.move_to_position:unbox()

	navigation_extension:move_to(move_to_position)

	scratchpad.move_to_position = Vector3Box(move_to_position)
	scratchpad.behavior_component = behavior_component

	local follow_component = Blackboard.write_component(blackboard, "follow")

	scratchpad.follow_component = follow_component

	if action_data.follow_aim then
		local aim_component = Blackboard.write_component(blackboard, "aim")

		scratchpad.aim_component = aim_component
	end

	local owner_unit = behavior_component.owner_unit

	if owner_unit then
		local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
		local movement_state_component = unit_data_extension:read_component("movement_state")
		local hub_jog_character_state_component = unit_data_extension:read_component("hub_jog_character_state")

		scratchpad.owner_movement_state_component = movement_state_component
		scratchpad.owner_hub_jog_character_state_component = hub_jog_character_state_component
	end

	if action_data.adapt_speed then
		scratchpad.current_speed_timer = 0

		local arrived_at_distance_threshold_sq = action_data.arrived_at_distance_threshold_sq or ARRIVED_AT_POSITION_THRESHOLD_SQ
		local speed_threshold = arrived_at_distance_threshold_sq

		MinionMovement.smooth_speed_based_on_distance(unit, scratchpad, 0, action_data, breed, false, speed_threshold, false, true)
	end

	if action_data.effect_template then
		local fx_system = Managers.state.extension:system("fx_system")
		local global_effect_id = fx_system:start_template_effect(action_data.effect_template, unit)

		scratchpad.global_effect_id = global_effect_id
	end

	local nav_world = navigation_extension:nav_world()

	scratchpad.nav_world = nav_world
	scratchpad.pushed_enemies = {}
end

BtCompanionMoveToPositionAction.init_values = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_to_position:store(0, 0, 0)

	behavior_component.has_move_to_position = false
	behavior_component.current_state = "idle"
	behavior_component.move_state = "idle"
	behavior_component.should_skip_start_anim = false

	local follow_component = Blackboard.write_component(blackboard, "follow")

	follow_component.last_referenced_vector:store(0, 0, 0)

	follow_component.speed_reference = 0
	follow_component.current_owner_cooldown = -1
	follow_component.last_owner_cooldown_time = -1
	follow_component.current_position_cooldown = -1
	follow_component.current_movement_type = "none"
	follow_component.current_movement_animation = "none"
	follow_component.current_adaptive_angle_check_left = 0
	follow_component.current_adaptive_angle_check_right = 0
	follow_component.adaptive_angle_enlarge_t = 0
end

BtCompanionMoveToPositionAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	if action_data.enable_disable_locomotion_speed then
		scratchpad.navigation_extension:set_enabled(false)
	end

	if action_data.effect_template then
		local fx_system = Managers.state.extension:system("fx_system")

		fx_system:stop_template_effect(scratchpad.global_effect_id)
	end

	local behavior_component = scratchpad.behavior_component

	behavior_component.has_move_to_position = false
end

BtCompanionMoveToPositionAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	if action_data.push_enemies_damage_profile then
		MinionAttack.push_nearby_enemies(unit, scratchpad, action_data, unit, nil, action_data.push_ignored_breeds)
	end

	MinionMovement.update_ground_normal_rotation(unit, scratchpad, nil, 0.7)

	local behavior_component = scratchpad.behavior_component
	local self_position, move_to_position = POSITION_LOOKUP[unit], scratchpad.move_to_position:unbox()
	local arrived_at_distance_threshold_sq = action_data.arrived_at_distance_threshold_sq or ARRIVED_AT_POSITION_THRESHOLD_SQ
	local distance_sq = Vector3.distance_squared(self_position, move_to_position)

	if action_data.stop_at_target_position and not scratchpad.is_anim_driven and distance_sq <= arrived_at_distance_threshold_sq or scratchpad.navigation_extension:is_following_path() and scratchpad.navigation_extension:has_reached_destination() then
		behavior_component.has_move_to_position = false

		return "done"
	end

	if action_data.follow_aim then
		local owner_unit_position = POSITION_LOOKUP[behavior_component.owner_unit]
		local follow_aim_entry = CompanionFollow.follow_aim_entry(scratchpad, action_data, Vector3.zero())
		local aim_target_position = follow_aim_entry == "player" and owner_unit_position or move_to_position

		CompanionFollow.set_up_aim_target(unit, scratchpad, aim_target_position)
	end

	scratchpad.move_to_position = scratchpad.behavior_component.move_to_position
	move_to_position = scratchpad.behavior_component.move_to_position:unbox()

	scratchpad.navigation_extension:move_to(move_to_position)

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, behavior_component)

	if should_start_idle or should_be_idling then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, behavior_component, action_data)
		end

		return "running"
	end

	if scratchpad.start_move_event_anim_speed_duration then
		if t < scratchpad.start_move_event_anim_speed_duration then
			local navigation_extension = scratchpad.navigation_extension

			MinionMovement.apply_animation_wanted_movement_speed(unit, navigation_extension, dt)
		else
			if not action_data.adapt_speed then
				scratchpad.navigation_extension:set_max_speed(action_data.speed)
			end

			scratchpad.start_move_event_anim_speed_duration = nil
		end
	end

	local move_state = behavior_component.move_state

	if move_state ~= "moving" then
		local owner_movement_state_component = scratchpad.owner_movement_state_component
		local is_crouching = owner_movement_state_component and owner_movement_state_component.is_crouching or false

		if not not action_data.skip_start_anim or action_data.skip_start_animation_on_crouch and is_crouching or behavior_component.should_skip_start_anim then
			behavior_component.move_state = "moving"

			scratchpad.animation_extension:anim_event(action_data.skip_start_animation_event)

			behavior_component.should_skip_start_anim = false
		else
			self:_start_move_anim(unit, t, behavior_component, scratchpad, action_data)
		end
	end

	if scratchpad.is_anim_driven and (not scratchpad.start_rotation_timing or scratchpad.start_rotation_timing and t >= scratchpad.start_rotation_timing) then
		MinionMovement.update_anim_driven_start_rotation(unit, scratchpad, action_data, t)

		if not scratchpad.is_anim_driven then
			local navigation_extension = scratchpad.navigation_extension

			navigation_extension:set_max_speed(Vector3.length(scratchpad.locomotion_extension:current_velocity()))
		end
	end

	if not scratchpad.is_anim_driven and not scratchpad.start_move_event_anim_speed_duration and action_data.adapt_speed then
		local owner_movement_state_component = scratchpad.owner_movement_state_component
		local owner_hub_jog_character_state_component = scratchpad.owner_hub_jog_character_state_component
		local is_crouching = owner_movement_state_component and owner_movement_state_component.is_crouching or false
		local is_walking_in_hub = self:_is_in_hub() and owner_hub_jog_character_state_component and owner_hub_jog_character_state_component.move_state == "walk" or false
		local follow_config = CompanionFollow.follow_config(blackboard, action_data)
		local adapt_threshold_multiplier

		if is_crouching or is_walking_in_hub then
			adapt_threshold_multiplier = follow_config and follow_config.crouch_adapt_threshold_multiplier or action_data.crouch_adapt_threshold_multiplier or 0
		else
			adapt_threshold_multiplier = follow_config and follow_config.adapt_threshold_multiplier or action_data.adapt_threshold_multiplier or 0
		end

		local speed_threshold = arrived_at_distance_threshold_sq * adapt_threshold_multiplier

		MinionMovement.smooth_speed_based_on_distance(unit, scratchpad, dt, action_data, breed, is_crouching, speed_threshold)
	end

	local animation_speed_thresholds = breed.get_animation_speed_thresholds and breed.get_animation_speed_thresholds() or breed.animation_speed_thresholds

	if not scratchpad.is_anim_driven and animation_speed_thresholds then
		MinionMovement.companion_select_movement_animation(unit, scratchpad, dt, action_data, breed)
	end

	local is_following_path = scratchpad.navigation_extension:is_following_path()

	if is_following_path then
		self:_update_anim_lean_variable(unit, scratchpad, action_data, dt)
	end

	return "running"
end

BtCompanionMoveToPositionAction._start_move_anim = function (self, unit, t, behavior_component, scratchpad, action_data)
	local animation_extension = scratchpad.animation_extension
	local start_move_anim_events = action_data.start_move_anim_events
	local start_move_event

	if start_move_anim_events then
		local moving_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)

		start_move_event = start_move_anim_events[moving_direction_name]

		animation_extension:anim_event(start_move_event)

		if moving_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local start_rotation_timing = action_data.start_move_rotation_timings and action_data.start_move_rotation_timings[start_move_event] or 0

			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.move_start_anim_event_name = start_move_event
		else
			scratchpad.start_rotation_timing = nil
			scratchpad.move_start_anim_event_name = nil
		end
	elseif action_data.move_anim_event then
		start_move_event = action_data.move_anim_event

		animation_extension:anim_event(start_move_event)
	end

	local start_move_event_anim_speed_duration = action_data.start_move_event_anim_speed_durations and action_data.start_move_event_anim_speed_durations[start_move_event]

	if start_move_event_anim_speed_duration then
		scratchpad.start_move_event_anim_speed_duration = t + start_move_event_anim_speed_duration
	end

	behavior_component.move_state = "moving"
end

BtCompanionMoveToPositionAction._update_anim_lean_variable = function (self, unit, scratchpad, action_data, dt)
	local lean_value = MinionMovement.get_lean_animation_variable_value(unit, scratchpad, lean_settings, dt)

	if lean_value then
		local lean_variable_name = lean_settings.lean_variable_name

		scratchpad.animation_extension:set_variable(lean_variable_name, lean_value)
	end
end

BtCompanionMoveToPositionAction._is_in_hub = function (self)
	local game_mode_name = Managers.state.game_mode:game_mode_name()
	local is_in_hub = game_mode_name == "hub"

	return is_in_hub
end

return BtCompanionMoveToPositionAction
