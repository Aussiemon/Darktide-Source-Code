require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local AttackIntensity = require("scripts/utilities/attack_intensity")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local Breed = require("scripts/utilities/breed")
local Catapulted = require("scripts/extension_systems/character_state_machine/character_states/utilities/catapulted")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local Health = require("scripts/utilities/health")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionMovement = require("scripts/utilities/minion_movement")
local MinionPerception = require("scripts/utilities/minion_perception")
local MinionPushFx = require("scripts/utilities/minion_push_fx")
local NavQueries = require("scripts/utilities/nav_queries")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Stagger = require("scripts/utilities/attack/stagger")
local StaggerSettings = require("scripts/settings/damage/stagger_settings")
local Trajectory = require("scripts/utilities/trajectory")
local attack_types = AttackSettings.attack_types
local BtMutantChargerChargeAction = class("BtMutantChargerChargeAction", "BtNode")
local ABOVE = 1
local BELOW = 2
local LATERAL = 2

BtMutantChargerChargeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local spawn_component = blackboard.spawn
	scratchpad.physics_world = spawn_component.physics_world
	local perception_component = Blackboard.write_component(blackboard, "perception")
	scratchpad.behavior_component = Blackboard.write_component(blackboard, "behavior")
	scratchpad.perception_component = perception_component
	scratchpad.record_state_component = Blackboard.write_component(blackboard, "record_state")
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.animation_extension = ScriptUnit.extension(unit, "animation_system")
	scratchpad.locomotion_extension = locomotion_extension
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.nav_world = scratchpad.navigation_extension:nav_world()
	scratchpad.buff_extension = ScriptUnit.extension(unit, "buff_system")
	scratchpad.broadphase_system = Managers.state.extension:system("broadphase_system")
	scratchpad.side_system = Managers.state.extension:system("side_system")
	scratchpad.pushed_minions = {}
	scratchpad.dodged_targets = {}
	scratchpad.fx_system = Managers.state.extension:system("fx_system")
	local throw_directions = self:_calculate_randomized_throw_directions(action_data)
	scratchpad.throw_directions = throw_directions

	MinionPerception.set_target_lock(unit, perception_component, true)

	scratchpad.velocity_stored = Vector3Box(0, 0, 0)
	local original_rotation_speed = locomotion_extension:rotation_speed()
	scratchpad.original_rotation_speed = original_rotation_speed

	self:_update_ray_can_go(unit, scratchpad)

	if not scratchpad.navmesh_ray_can_go then
		self:_start_navigating(unit, scratchpad, action_data, t)
	else
		self:_start_charging(unit, scratchpad, action_data, t)
	end
end

BtMutantChargerChargeAction.init_values = function (self, blackboard)
	local record_state_component = Blackboard.write_component(blackboard, "record_state")
	record_state_component.has_disabled_player = false
end

BtMutantChargerChargeAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local grabbed_target = scratchpad.grabbed_target

	if reason ~= "done" and ALIVE[grabbed_target] then
		local _, mutant_charging_unit = PlayerUnitStatus.is_mutant_charged(scratchpad.hit_unit_disabled_character_state_component)

		if mutant_charging_unit == unit then
			local target_locomotion_extension = ScriptUnit.extension(grabbed_target, "locomotion_system")

			target_locomotion_extension:set_parent_unit(nil)

			local disabled_state_input = scratchpad.hit_unit_disabled_state_input

			if disabled_state_input.disabling_unit == unit then
				disabled_state_input.trigger_animation = "none"
				disabled_state_input.disabling_unit = nil
			end
		end
	end

	scratchpad.navigation_extension:set_enabled(false)

	local locomotion_extension = scratchpad.locomotion_extension

	locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	MinionPerception.set_target_lock(unit, scratchpad.perception_component, false)

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	self:_stop_effect_template(scratchpad)
	self:_allow_gibbing(unit, action_data, true)
end

BtMutantChargerChargeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	self:_update_ray_can_go(unit, scratchpad)

	local state = scratchpad.state

	if state == "charging" then
		self:_update_charging(unit, breed, scratchpad, action_data, t, dt)
	elseif state == "navigating" then
		local result = self:_update_navigating(unit, scratchpad, action_data, t, dt, breed)

		if result == "done" then
			return "done"
		end

		self:_push_friendly_minions(unit, action_data, scratchpad, t)
	elseif state == "charged_past" then
		local done = self:_update_charged_past(unit, scratchpad, action_data, t, dt)

		if done then
			self:_stop_effect_template(scratchpad)

			return "done"
		end

		self:_push_friendly_minions(unit, action_data, scratchpad, t)
	elseif state == "grabbed_target" then
		if not ALIVE[scratchpad.grabbed_target] then
			return "failed"
		end

		self:_update_grabbed_target(unit, scratchpad, action_data, t, dt)
	elseif state == "throwing" then
		if not ALIVE[scratchpad.grabbed_target] then
			return "failed"
		end

		self:_update_throwing(unit, scratchpad, action_data, breed, t)
	elseif state == "done" then
		return "done"
	end

	return "running"
end

BtMutantChargerChargeAction._is_facing_target = function (self, unit, scratchpad)
	local target_unit = scratchpad.perception_component.target_unit
	local unit_position = POSITION_LOOKUP[unit]
	local target_position = POSITION_LOOKUP[target_unit]
	local forward = Quaternion.forward(Unit.local_rotation(unit, 1))
	local to_target_normalized = Vector3.normalize(Vector3.flat(target_position - unit_position))
	local dot = Vector3.dot(forward, to_target_normalized)
	local facing_target = dot > 0.5

	return facing_target
end

BtMutantChargerChargeAction._start_charging = function (self, unit, scratchpad, action_data, t)
	scratchpad.state = "charging"
	scratchpad.charge_started_at_t = t
	scratchpad.played_prepare_grab_anim = nil
	local navigation_extension = scratchpad.navigation_extension

	navigation_extension:set_enabled(false)

	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "attacking"
	scratchpad.target_dodged_during_attack = nil
	scratchpad.target_dodged_type = nil
	local not_facing_target = not self:_is_facing_target(unit, scratchpad)
	scratchpad.charge_aborted = not_facing_target
end

local MIN_DISTANCE_FOR_MOVE_TO = 3
local MOVE_FREQUENCY = 1

BtMutantChargerChargeAction._start_navigating = function (self, unit, scratchpad, action_data, t)
	local navigation_extension = scratchpad.navigation_extension
	local speed = scratchpad.current_charge_speed or self:_get_min_charge_speed(scratchpad, action_data)

	navigation_extension:set_enabled(true, speed)

	scratchpad.state = "navigating"
	scratchpad.min_time_navigating = t + action_data.min_time_navigating

	scratchpad.locomotion_extension:set_rotation_speed(action_data.navigating_rotation_speed)

	scratchpad.move_to_timer = t
	local behavior_component = scratchpad.behavior_component
	behavior_component.move_state = "moving"
	scratchpad.target_dodged_during_attack = nil
	scratchpad.target_dodged_type = nil

	if scratchpad.started_charge_anim and not scratchpad.is_anim_driven and not scratchpad.anim_move_speed_duration then
		local navigating_anim_event = Animation.random_event(action_data.navigating_anim)

		scratchpad.animation_extension:anim_event(navigating_anim_event)
	end

	self:_start_effect_template(unit, scratchpad, action_data)
end

BtMutantChargerChargeAction._start_throwing_target = function (self, unit, scratchpad, action_data, t)
	local throw_direction = Quaternion.forward(scratchpad.throw_rotation:unbox())
	local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
	local right = Vector3.cross(fwd, Vector3.up())
	local relative_direction_name = MinionMovement.get_relative_direction_name(right, fwd, throw_direction)
	scratchpad.state = "throwing"
	local throw_anim = action_data.throw_anims[scratchpad.hit_unit_breed_name][relative_direction_name]

	scratchpad.animation_extension:anim_event(throw_anim)

	local disabled_state_input = scratchpad.hit_unit_disabled_state_input
	local locomotion_extension = scratchpad.locomotion_extension

	if relative_direction_name ~= "fwd" then
		MinionMovement.set_anim_driven(scratchpad, true)

		local anim_data = action_data.anim_data[throw_anim]
		local rotation_sign = anim_data.sign
		local rotation_radians = anim_data.rad
		local destination = POSITION_LOOKUP[unit] + throw_direction
		local rotation_scale = Animation.calculate_anim_rotation_scale(unit, destination, rotation_sign, rotation_radians)

		locomotion_extension:set_anim_rotation_scale(rotation_scale)

		disabled_state_input.trigger_animation = "throw_" .. relative_direction_name
	else
		disabled_state_input.trigger_animation = "throw"
	end

	scratchpad.throw_direction = Vector3Box(throw_direction)
	scratchpad.throw_at_t = t + action_data.throw_timing[scratchpad.hit_unit_breed_name]
	scratchpad.throw_duration = t + action_data.throw_duration[scratchpad.hit_unit_breed_name]
	scratchpad.throw_direction_name = relative_direction_name

	locomotion_extension:set_rotation_speed(action_data.rotation_speed)
	AttackIntensity.add_intensity(scratchpad.grabbed_target, action_data.attack_intensities)
end

local LAG_COMPENSATION_CHECK_RADIUS = 2

BtMutantChargerChargeAction._update_charging = function (self, unit, breed, scratchpad, action_data, t, dt)
	local locomotion_extension = scratchpad.locomotion_extension
	local current_speed = Vector3.length(locomotion_extension:current_velocity())
	local charge_started_at_t = scratchpad.charge_started_at_t
	local time_spent_charging = t - charge_started_at_t

	if not scratchpad.navmesh_ray_can_go and (not scratchpad.played_prepare_grab_anim or current_speed < 0.5) and action_data.min_time_spent_charging <= time_spent_charging then
		self:_start_navigating(unit, scratchpad, action_data, t)

		return
	end

	local target_unit = scratchpad.perception_component.target_unit
	local navigation_extension = scratchpad.navigation_extension
	local self_position = POSITION_LOOKUP[unit]
	local charge_speed_min = self:_get_min_charge_speed(scratchpad, action_data)
	local charge_speed_max = self:_get_max_charge_speed(scratchpad, action_data)
	local charge_max_speed_at = action_data.charge_max_speed_at
	local charge_scale = time_spent_charging / charge_max_speed_at
	local wanted_charge_speed = math.min(charge_speed_min + charge_scale * (charge_speed_max - charge_speed_min), charge_speed_max)
	local target_velocity = MinionMovement.target_velocity(target_unit)
	local target_position = POSITION_LOOKUP[target_unit]
	local extrapolated_position = target_position + target_velocity * action_data.target_extrapolation_length_scale
	local direction_to_target = Vector3.normalize(Vector3.flat(extrapolated_position - self_position))
	local true_direction_to_target = Vector3.normalize(Vector3.flat(target_position - self_position))
	local distance_to_extrapolated_position = Vector3.distance(self_position, extrapolated_position)
	local close_distance = action_data.close_distance
	local is_close = distance_to_extrapolated_position < close_distance
	local slowdown_percentage = self:_get_turn_slowdown_percentage(unit, direction_to_target, action_data)
	scratchpad.is_close = is_close

	navigation_extension:set_max_speed(wanted_charge_speed)

	local animation_charge_speed = action_data.animation_charge_speed
	local animation_variable = wanted_charge_speed / animation_charge_speed

	scratchpad.animation_extension:set_variable("anim_move_speed", math.clamp(animation_variable, action_data.min_animation_variable, action_data.max_animation_variable))

	scratchpad.current_charge_speed = wanted_charge_speed

	if scratchpad.anim_move_speed_duration then
		if t < scratchpad.anim_move_speed_duration then
			wanted_charge_speed = MinionMovement.get_animation_wanted_movement_speed(unit, dt, self:_get_max_charge_speed(scratchpad, action_data))
		else
			scratchpad.anim_move_speed_duration = nil
		end
	end

	local wanted_direction = Quaternion.forward(Unit.local_rotation(unit, 1))
	local new_velocity = wanted_direction * wanted_charge_speed

	locomotion_extension:set_wanted_velocity(new_velocity)
	scratchpad.velocity_stored:store(new_velocity)

	if scratchpad.current_lag_compensation_target_timing then
		if scratchpad.current_lag_compensation_target_timing <= t then
			local dodge_radius = action_data.dodge_collision_radius
			local hit_unit = scratchpad.current_lag_compensation_target
			local distance = Vector3.distance(POSITION_LOOKUP[unit], POSITION_LOOKUP[hit_unit])
			local is_dodging = Dodge.is_dodging(hit_unit)

			if is_dodging then
				if distance <= dodge_radius then
					self:_hit_target(unit, hit_unit, scratchpad, action_data, t)
				end
			elseif distance < LAG_COMPENSATION_CHECK_RADIUS then
				self:_hit_target(unit, hit_unit, scratchpad, action_data, t)
			end

			scratchpad.current_lag_compensation_target_timing = nil
			scratchpad.current_lag_compensation_target = nil

			return
		end
	elseif action_data.min_time_spent_charging <= time_spent_charging and scratchpad.start_colliding_with_players_timing and scratchpad.start_colliding_with_players_timing <= t then
		local colliding_unit = self:_check_colliding_players(unit, scratchpad, action_data)

		if colliding_unit then
			local player = Managers.state.player_unit_spawn:owner(colliding_unit)

			if player and player.remote then
				local lag_compensation_rewind = player:lag_compensation_rewind_s() * 0.5
				scratchpad.current_lag_compensation_target_timing = t + lag_compensation_rewind
				scratchpad.current_lag_compensation_target = colliding_unit
			else
				self:_hit_target(unit, colliding_unit, scratchpad, action_data, t)
			end

			return
		else
			local current_velocity_magnitude = Vector3.length(locomotion_extension:current_velocity())

			if current_velocity_magnitude < 0.5 then
				local distance_to_target = Vector3.distance(self_position, target_position)
				local z_diff = target_position.z - self_position.z

				if z_diff > 0 and distance_to_target < action_data.grab_close_up_distance then
					self:_hit_target(unit, target_unit, scratchpad, action_data, t)

					return
				end
			end
		end
	end

	if ALIVE[scratchpad.grabbed_target] then
		return
	end

	if not scratchpad.started_charge_anim then
		local fwd = Quaternion.forward(Unit.local_rotation(unit, 1))
		local right = Vector3.cross(fwd, Vector3.up())
		local relative_direction_name = MinionMovement.get_relative_direction_name(right, fwd, direction_to_target)
		local charge_anim_event = Animation.random_event(action_data.charge_anims[relative_direction_name])
		local start_effect_timings = action_data.start_effect_timing
		local start_effect_timing = start_effect_timings[charge_anim_event]
		scratchpad.start_effect_template_timing = t + start_effect_timing

		scratchpad.animation_extension:anim_event(charge_anim_event)

		scratchpad.started_charge_anim = true

		if relative_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local duration = action_data.anim_driven_charge_anim_durations[charge_anim_event]
			scratchpad.anim_driven_charge_anim_duration = t + duration
			local start_rotation_timing = action_data.start_rotation_timings[charge_anim_event]
			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.charge_anim_event_name = charge_anim_event
		else
			local anim_move_speed_duration = action_data.anim_move_speed_durations[charge_anim_event]
			scratchpad.anim_move_speed_duration = t + anim_move_speed_duration
		end

		local start_colliding_with_players_timing = action_data.start_colliding_with_players_timing[charge_anim_event]
		scratchpad.start_colliding_with_players_timing = t + start_colliding_with_players_timing
	end

	if scratchpad.start_effect_template_timing and scratchpad.start_effect_template_timing <= t then
		self:_start_effect_template(unit, scratchpad, action_data)
	end

	local has_started_charge = not scratchpad.is_anim_driven and not scratchpad.anim_move_speed_duration

	if has_started_charge then
		self:_push_friendly_minions(unit, action_data, scratchpad, t)
	end

	local rotation = Quaternion.look(direction_to_target)
	local threat_distance = action_data.aoe_bot_threat_distance
	local should_trigger_aoe_threat = has_started_charge and not scratchpad.triggered_aoe_threat and distance_to_extrapolated_position < threat_distance

	if should_trigger_aoe_threat then
		local aoe_bot_threat_size = action_data.aoe_bot_threat_size:unbox()
		local aoe_bot_threat_duration = action_data.aoe_bot_threat_duration
		local aoe_bot_threat_rotation = Unit.local_rotation(unit, 1)
		local side_system = scratchpad.side_system
		local side = side_system.side_by_unit[unit]
		local enemy_sides = side:relation_sides("enemy")
		local group_system = Managers.state.extension:system("group_system")
		local bot_groups = group_system:bot_groups_from_sides(enemy_sides)
		local num_bot_groups = #bot_groups

		for i = 1, num_bot_groups do
			local bot_group = bot_groups[i]

			bot_group:aoe_threat_created(target_position, "oobb", aoe_bot_threat_size, aoe_bot_threat_rotation, aoe_bot_threat_duration)
		end

		scratchpad.aoe_bot_threat_timing = nil
		scratchpad.triggered_aoe_threat = true
	end

	if is_close and has_started_charge then
		local is_dodging, dodge_type = Dodge.is_dodging(target_unit)

		if is_dodging and not scratchpad.target_dodged_during_attack then
			scratchpad.target_dodged_during_attack = true
			scratchpad.target_dodged_type = dodge_type
		end

		if not scratchpad.played_prepare_grab_anim then
			scratchpad.animation_extension:anim_event(action_data.prepare_grab_anim)

			scratchpad.played_prepare_grab_anim = true
		end

		local new_rotation_speed = (scratchpad.target_dodged_during_attack and action_data.dodge_rotation_speed or action_data.close_rotation_speed) * slowdown_percentage

		locomotion_extension:set_rotation_speed(new_rotation_speed)

		if action_data.min_time_spent_charging <= time_spent_charging or scratchpad.charge_aborted then
			local dot = Vector3.dot(wanted_direction, true_direction_to_target)
			local close_dodge = dot < 0.95 and scratchpad.target_dodged_during_attack and Vector3.distance(self_position, target_position) < 5

			if close_dodge or dot < action_data.charged_past_dot_threshold and not scratchpad.current_lag_compensation_target_timing then
				local miss_animation = Animation.random_event(action_data.miss_animations)

				scratchpad.animation_extension:anim_event(miss_animation)

				scratchpad.state = "charged_past"
				scratchpad.charged_past_duration = t + action_data.miss_durations[miss_animation]
				scratchpad.played_prepare_grab_anim = nil

				self:_stop_effect_template(scratchpad)

				if scratchpad.target_dodged_during_attack then
					dodge_type = scratchpad.target_dodged_type

					Dodge.sucessful_dodge(target_unit, unit, "melee", dodge_type, breed)
				end

				return
			end
		end
	else
		local new_rotation_speed = action_data.rotation_speed * slowdown_percentage

		locomotion_extension:set_rotation_speed(new_rotation_speed)
	end

	locomotion_extension:set_wanted_rotation(rotation)

	if scratchpad.is_anim_driven then
		if scratchpad.anim_driven_charge_anim_duration <= t then
			MinionMovement.set_anim_driven(scratchpad, false)
		end

		if scratchpad.start_rotation_timing and scratchpad.start_rotation_timing < t then
			local anim_data = action_data.anim_data[scratchpad.charge_anim_event_name]
			local rotation_sign = anim_data.sign
			local rotation_radians = anim_data.rad
			local destination = POSITION_LOOKUP[unit] + direction_to_target
			local rotation_scale = Animation.calculate_anim_rotation_scale(unit, destination, rotation_sign, rotation_radians)

			scratchpad.locomotion_extension:set_anim_rotation_scale(rotation_scale)

			scratchpad.start_rotation_timing = nil
		end
	end
end

BtMutantChargerChargeAction._update_navigating = function (self, unit, scratchpad, action_data, t, dt, breed)
	local can_exit_navigating = not scratchpad.min_time_navigating or scratchpad.min_time_navigating < t

	if can_exit_navigating and scratchpad.navmesh_ray_can_go then
		self:_start_charging(unit, scratchpad, action_data, t)

		scratchpad.min_time_navigating = nil

		return
	end

	local navigation_extension = scratchpad.navigation_extension
	local target_unit = scratchpad.perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local destination = navigation_extension:destination()
	local distance = Vector3.distance(target_position, destination)
	local should_force_move = scratchpad.behavior_component.move_state ~= "moving" or navigation_extension:has_reached_destination()
	local min_distance = MIN_DISTANCE_FOR_MOVE_TO

	if (min_distance < distance or should_force_move) and scratchpad.move_to_timer <= t then
		self:_move_to_position(scratchpad, target_position)

		scratchpad.move_to_timer = t + MOVE_FREQUENCY
	end

	local should_start_idle, should_be_idling = MinionMovement.should_start_idle(scratchpad, scratchpad.behavior_component)

	if can_exit_navigating and (should_start_idle or should_be_idling) then
		if should_start_idle then
			MinionMovement.start_idle(scratchpad, scratchpad.behavior_component, action_data)

			scratchpad.started_charge_anim = nil
		end

		self:_add_threat_to_other_targets(unit, breed, scratchpad, target_unit)

		return
	end

	local is_following_path = navigation_extension:is_following_path()

	if not is_following_path then
		return
	end

	if not scratchpad.started_charge_anim then
		local relative_direction_name = MinionMovement.get_moving_direction_name(unit, scratchpad)
		local charge_anim_event = Animation.random_event(action_data.charge_anims[relative_direction_name])
		local start_effect_timings = action_data.start_effect_timing
		local start_effect_timing = start_effect_timings[charge_anim_event]
		scratchpad.start_effect_template_timing = t + start_effect_timing

		scratchpad.animation_extension:anim_event(charge_anim_event)

		scratchpad.started_charge_anim = true

		if relative_direction_name ~= "fwd" then
			MinionMovement.set_anim_driven(scratchpad, true)

			local duration = action_data.anim_driven_charge_anim_durations[charge_anim_event]
			scratchpad.anim_driven_charge_anim_duration = t + duration
			local start_rotation_timing = action_data.start_rotation_timings[charge_anim_event]
			scratchpad.start_rotation_timing = t + start_rotation_timing
			scratchpad.charge_anim_event_name = charge_anim_event
		else
			local anim_move_speed_duration = action_data.anim_move_speed_durations[charge_anim_event]
			scratchpad.anim_move_speed_duration = t + anim_move_speed_duration
		end

		local start_colliding_with_players_timing = action_data.start_colliding_with_players_timing[charge_anim_event]
		scratchpad.start_colliding_with_players_timing = t + start_colliding_with_players_timing
	end

	local wanted_node_index = 4
	local current_node, next_node_in_path = navigation_extension:current_and_wanted_node_position_in_path(wanted_node_index)

	if current_node == nil or next_node_in_path == nil then
		return
	end

	if scratchpad.is_anim_driven then
		if scratchpad.anim_driven_charge_anim_duration <= t then
			MinionMovement.set_anim_driven(scratchpad, false)
		end

		if scratchpad.start_rotation_timing and scratchpad.start_rotation_timing < t then
			local anim_data = action_data.anim_data[scratchpad.charge_anim_event_name]
			local rotation_sign = anim_data.sign
			local rotation_radians = anim_data.rad
			local rotation_scale = Animation.calculate_anim_rotation_scale(unit, next_node_in_path, rotation_sign, rotation_radians)

			scratchpad.locomotion_extension:set_anim_rotation_scale(rotation_scale)

			scratchpad.start_rotation_timing = nil
		end
	end

	local max_speed = scratchpad.current_charge_speed or self:_get_min_charge_speed(scratchpad, action_data)

	if scratchpad.anim_move_speed_duration then
		if t < scratchpad.anim_move_speed_duration then
			max_speed = MinionMovement.get_animation_wanted_movement_speed(unit, dt, self:_get_max_charge_speed(scratchpad, action_data))
		else
			scratchpad.anim_move_speed_duration = nil
		end
	end

	local nav_path_direction = Vector3.normalize(next_node_in_path - current_node)
	local slowdown_percentage = self:_get_turn_slowdown_percentage(unit, nav_path_direction, action_data)
	local new_max_speed = max_speed * slowdown_percentage

	navigation_extension:set_max_speed(new_max_speed)

	local animation_charge_speed = action_data.animation_charge_speed
	local animation_variable = new_max_speed / animation_charge_speed

	scratchpad.animation_extension:set_variable("anim_move_speed", math.clamp(animation_variable, action_data.min_animation_variable, action_data.max_animation_variable))
end

BtMutantChargerChargeAction._update_charged_past = function (self, unit, scratchpad, action_data, t, dt)
	if scratchpad.charged_past_duration < t then
		return true
	end

	local charge_direction = Vector3.normalize(scratchpad.velocity_stored:unbox())
	local wanted_speed = MinionMovement.get_animation_wanted_movement_speed(unit, dt, self:_get_max_charge_speed(scratchpad, action_data))

	scratchpad.locomotion_extension:set_wanted_velocity(charge_direction * wanted_speed)

	local hit_wall = self:_check_wall_collision(unit, scratchpad, action_data)

	if hit_wall then
		local direction = -Quaternion.forward(Unit.local_rotation(unit, 1))
		local stun_time = action_data.wall_stun_time

		Stagger.force_stagger(unit, StaggerSettings.stagger_types.wall_collision, direction, stun_time, 1, stun_time)
	end
end

local SMASH_SPACE_NAV_ABOVE = 1
local SMASH_SPACE_NAV_BELOW = 1

BtMutantChargerChargeAction._update_grabbed_target = function (self, unit, scratchpad, action_data, t, dt)
	if scratchpad.grab_target_duration < t then
		self:_align_throwing(unit, scratchpad, action_data)

		scratchpad.grab_target_duration = nil

		self:_start_throwing_target(unit, scratchpad, action_data, t)

		return
	end

	local locomotion_extension = scratchpad.locomotion_extension

	if scratchpad.charge_with_target_t then
		local position = POSITION_LOOKUP[unit]
		local forward = Quaternion.forward(Unit.local_rotation(unit, 1))

		if scratchpad.charge_with_target_t < t then
			local nav_world = scratchpad.nav_world
			local check_position = position + forward
			local has_space_to_smash = NavQueries.position_on_mesh(nav_world, check_position, SMASH_SPACE_NAV_ABOVE, SMASH_SPACE_NAV_BELOW)

			if has_space_to_smash then
				self:_play_smash_anim(scratchpad, action_data, t)
				locomotion_extension:set_rotation_speed(scratchpad.original_rotation_speed)
				locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))

				scratchpad.charge_with_target_t = nil
			else
				scratchpad.skip_taunt = true
				scratchpad.grab_target_duration = 0

				return
			end
		else
			local from = position + Vector3.up()
			local fwd_hit = self:_ray_cast(scratchpad.physics_world, from, from + forward)

			if fwd_hit then
				locomotion_extension:set_wanted_velocity(Vector3(0, 0, 0))
			else
				local wanted_speed = MinionMovement.get_animation_wanted_movement_speed(unit, dt, self:_get_max_charge_speed(scratchpad, action_data))
				local velocity = Vector3.normalize(scratchpad.velocity_stored:unbox()) * wanted_speed

				locomotion_extension:set_wanted_velocity(velocity)

				local grabbed_target = scratchpad.grabbed_target
				local target_unit_data_extension = ScriptUnit.extension(grabbed_target, "unit_data_system")
				local disabled_character_state_component = target_unit_data_extension:write_component("disabled_character_state")
				disabled_character_state_component.target_drag_position = POSITION_LOOKUP[unit]
			end
		end
	elseif scratchpad.next_smash_anim_t < t then
		self:_play_smash_anim(scratchpad, action_data, t)
	end

	if scratchpad.next_damage_t and scratchpad.next_damage_t < t then
		local target = scratchpad.grabbed_target
		local damage_profile = action_data.damage_profile
		local damage_type = action_data.damage_type[scratchpad.hit_unit_breed_name]
		local power_level = Managers.state.difficulty:get_table_entry_by_challenge(action_data.power_level)
		local node = Unit.node(target, "j_head")
		local hit_position = Unit.world_position(target, node)
		local damage, result, damage_efficiency = Attack.execute(target, damage_profile, "power_level", power_level, "hit_world_position", hit_position, "attacking_unit", unit, "attack_type", attack_types.melee, "damage_type", damage_type)
		local attack_direction = Vector3.up()

		ImpactEffect.play(target, nil, damage, damage_type, nil, result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

		local damage_timings = action_data.smash_damage_timings[scratchpad.hit_unit_breed_name]
		local damage_index = scratchpad.smash_damage_timing_index + 1

		if damage_index <= #damage_timings then
			local next_damage_t = damage_timings[damage_index]
			scratchpad.next_damage_t = scratchpad.initial_smash_timing + next_damage_t
			scratchpad.smash_damage_timing_index = damage_index
		else
			scratchpad.next_damage_t = nil
		end
	end
end

local UP_POSITION_OFFSET = 1.5
local DOWN_POSITION_OFFSET = 0.5

BtMutantChargerChargeAction._align_throwing = function (self, unit, scratchpad, action_data)
	local throw_directions = scratchpad.throw_directions
	local position_up = POSITION_LOOKUP[unit] + Vector3.up() * UP_POSITION_OFFSET
	local position_down = POSITION_LOOKUP[unit] + Vector3.up() * DOWN_POSITION_OFFSET

	for i = 1, #throw_directions do
		local test_direction = throw_directions[i]:unbox()
		local up_throw_test_position = position_up + test_direction * action_data.throw_test_distance
		local down_throw_test_position = position_down + test_direction * action_data.throw_test_distance
		local up_hit = self:_ray_cast(scratchpad.physics_world, position_up, up_throw_test_position)
		local down_hit = self:_ray_cast(scratchpad.physics_world, position_down, down_throw_test_position)

		if not up_hit and not down_hit then
			local trajectory_is_ok, new_direction = self:_test_throw_trajectory(unit, scratchpad, action_data, test_direction, down_throw_test_position)

			if trajectory_is_ok then
				scratchpad.throw_rotation = QuaternionBox(Quaternion.look(new_direction or test_direction))

				return
			end
		end
	end

	local throw_rotation = Quaternion.inverse(Unit.local_rotation(unit, 1))
	scratchpad.throw_rotation = QuaternionBox(throw_rotation)
	local navigation_extension = scratchpad.navigation_extension
	local traverse_logic = navigation_extension:traverse_logic()
	local pos = POSITION_LOOKUP[unit] + Quaternion.forward(throw_rotation) * 2
	local fallback_throw_position = NavQueries.position_on_mesh_with_outside_position(scratchpad.nav_world, traverse_logic, pos, 1, 2, 2) or POSITION_LOOKUP[unit]
	scratchpad.fallback_throw_position = Vector3Box(fallback_throw_position)
	local target_unit = scratchpad.grabbed_target
	local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
	local disabled_character_state_component = target_unit_data_extension:write_component("disabled_character_state")
	disabled_character_state_component.target_drag_position = fallback_throw_position
end

BtMutantChargerChargeAction._play_smash_anim = function (self, scratchpad, action_data, t)
	local smash_anim = action_data.smash_anims[scratchpad.hit_unit_breed_name]

	scratchpad.animation_extension:anim_event(smash_anim)

	scratchpad.next_smash_anim_t = t + action_data.smash_anim_duration[scratchpad.hit_unit_breed_name]
	local next_damage_t = action_data.smash_damage_timings[scratchpad.hit_unit_breed_name][1]
	scratchpad.next_damage_t = t + next_damage_t
	scratchpad.smash_damage_timing_index = 1
	scratchpad.initial_smash_timing = t
	local disabled_state_input = scratchpad.hit_unit_disabled_state_input
	disabled_state_input.trigger_animation = "smash"
end

local THROW_TELEPORT_UP_OFFSET_HUMAN = 0.75
local THROW_TELEPORT_UP_OFFSET_OGRYN = 0

BtMutantChargerChargeAction._update_throwing = function (self, unit, scratchpad, action_data, breed, t)
	local throw_direction = scratchpad.throw_direction:unbox()
	local wanted_rotation = Quaternion.look(throw_direction)
	local throw_direction_name = scratchpad.throw_direction_name
	local locomotion_extension = scratchpad.locomotion_extension

	if throw_direction_name == "fwd" then
		locomotion_extension:set_wanted_rotation(wanted_rotation)
	end

	if scratchpad.throw_at_t and scratchpad.throw_at_t < t then
		scratchpad.throw_at_t = nil
		local hit_unit_disabled_state_input = scratchpad.hit_unit_disabled_state_input
		hit_unit_disabled_state_input.trigger_animation = "none"
		hit_unit_disabled_state_input.disabling_unit = nil
		local wants_catapult = not scratchpad.fallback_throw_position
		scratchpad.wants_catapult = wants_catapult

		if wants_catapult then
			local hit_unit_breed_name = scratchpad.hit_unit_breed_name
			local is_human = hit_unit_breed_name == "human"
			local disabling_unit_position = POSITION_LOOKUP[unit]
			local unit_rotation = Unit.local_rotation(unit, 1)
			local up = Vector3.up() * (is_human and THROW_TELEPORT_UP_OFFSET_HUMAN or THROW_TELEPORT_UP_OFFSET_OGRYN)
			local disabling_unit_forward = Quaternion.forward(unit_rotation)
			local teleport_position = disabling_unit_position + disabling_unit_forward + up
			local target_unit = scratchpad.grabbed_target
			local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
			local disabled_character_state_component = target_unit_data_extension:write_component("disabled_character_state")
			disabled_character_state_component.target_drag_position = teleport_position
		end
	else
		local disabled_character_state_component = scratchpad.hit_unit_disabled_character_state_component
		local is_disabled = disabled_character_state_component.is_disabled

		if scratchpad.wants_catapult and not is_disabled then
			local target_unit = scratchpad.grabbed_target
			local target_unit_data_extension = ScriptUnit.extension(target_unit, "unit_data_system")
			local catapult_force = action_data.catapult_force[scratchpad.hit_unit_breed_name]
			local catapult_z_force = action_data.catapult_z_force[scratchpad.hit_unit_breed_name]
			local direction = Vector3.normalize(throw_direction)
			local velocity = direction * catapult_force
			velocity.z = catapult_z_force
			local catapulted_state_input = target_unit_data_extension:write_component("catapulted_state_input")

			Catapulted.apply(catapulted_state_input, velocity)

			scratchpad.wants_catapult = nil
		end

		if scratchpad.throw_duration and scratchpad.throw_duration < t then
			MinionMovement.set_anim_driven(scratchpad, false)

			if scratchpad.skip_taunt then
				scratchpad.state = "done"
			else
				local after_throw_taunt_anim_event = Animation.random_event(action_data.after_throw_taunt_anim)

				scratchpad.animation_extension:anim_event(after_throw_taunt_anim_event)

				local after_throw_taunt_duration = action_data.after_throw_taunt_duration
				scratchpad.after_throw_taunt_duration = t + after_throw_taunt_duration
				scratchpad.throw_duration = nil

				self:_add_threat_to_other_targets(unit, breed, scratchpad, scratchpad.grabbed_target)
				self:_allow_gibbing(unit, action_data, true)
			end
		elseif scratchpad.after_throw_taunt_duration then
			local target_unit = scratchpad.perception_component.target_unit

			if target_unit then
				local flat_rotation = MinionMovement.rotation_towards_unit_flat(unit, target_unit)

				locomotion_extension:set_wanted_rotation(flat_rotation)

				if scratchpad.after_throw_taunt_duration <= t then
					scratchpad.state = "done"
				end
			end
		end
	end
end

BtMutantChargerChargeAction._update_ray_can_go = function (self, unit, scratchpad)
	local navigation_extension = scratchpad.navigation_extension
	local traverse_logic = navigation_extension:traverse_logic()
	local nav_world = scratchpad.nav_world
	local target_unit = scratchpad.perception_component.target_unit
	local target_position = POSITION_LOOKUP[target_unit]
	local navmesh_position = NavQueries.position_on_mesh_with_outside_position(scratchpad.nav_world, traverse_logic, target_position, ABOVE, BELOW, LATERAL)

	if navmesh_position then
		local ray_can_go = GwNavQueries.raycango(nav_world, POSITION_LOOKUP[unit], navmesh_position, traverse_logic)
		scratchpad.navmesh_ray_can_go = ray_can_go
	else
		scratchpad.navmesh_ray_can_go = false
	end
end

local MAX_STEPS = 20
local MAX_TIME = 0.8

BtMutantChargerChargeAction._test_throw_trajectory = function (self, unit, scratchpad, action_data, test_direction, to)
	local hit_unit_breed_name = scratchpad.hit_unit_breed_name
	local force = action_data.catapult_force[hit_unit_breed_name]
	local z_force = action_data.catapult_z_force[hit_unit_breed_name]
	local physics_world = scratchpad.physics_world
	local hit, segment_list, hit_position = Trajectory.test_throw_trajectory(unit, hit_unit_breed_name, physics_world, force, z_force, test_direction, to, PlayerCharacterConstants.gravity, THROW_TELEPORT_UP_OFFSET_HUMAN, THROW_TELEPORT_UP_OFFSET_OGRYN, MAX_STEPS, MAX_TIME)

	if hit then
		local navigation_extension = scratchpad.navigation_extension
		local nav_world = scratchpad.nav_world
		local traverse_logic = navigation_extension:traverse_logic()
		local navmesh_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, hit_position, 0.5, 0.5, 0.5)

		if navmesh_position then
			local ledge_find_radius = 2
			local _, num_actors = PhysicsWorld.immediate_overlap(physics_world, "position", navmesh_position, "size", ledge_find_radius, "shape", "sphere", "types", "both", "collision_filter", "filter_hang_ledge_collision")

			if num_actors and num_actors > 0 then
				return false
			else
				local new_direction = Vector3.normalize(Vector3.flat(navmesh_position - POSITION_LOOKUP[unit]))

				return true, new_direction
			end
		else
			return false
		end
	else
		return false
	end
end

BtMutantChargerChargeAction._move_to_position = function (self, scratchpad, target_position)
	local navigation_extension = scratchpad.navigation_extension
	local nav_world = scratchpad.nav_world
	local traverse_logic = navigation_extension:traverse_logic()
	local goal_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, target_position, ABOVE, BELOW, LATERAL)

	if goal_position then
		navigation_extension:move_to(goal_position)

		scratchpad.behavior_component.move_state = "moving"
	end

	local success = goal_position ~= nil

	return success
end

BtMutantChargerChargeAction._check_wall_collision = function (self, unit, scratchpad, action_data)
	local wall_raycast_node_name = action_data.wall_raycast_node_name
	local wall_raycast_node = Unit.node(unit, wall_raycast_node_name)
	local from = Unit.world_position(unit, wall_raycast_node)
	local physics_world = scratchpad.physics_world
	local wall_raycast_distance = action_data.wall_raycast_distance
	local rotation = Unit.local_rotation(unit, 1)
	local direction = Vector3.flat(Quaternion.forward(rotation))
	local collision_filter = "filter_minion_shooting_geometry"
	local hit = PhysicsWorld.raycast(physics_world, from, direction, wall_raycast_distance, "closest", "collision_filter", collision_filter)

	if hit then
		return true
	end

	from = from - Vector3.up() * 0.25
	hit = PhysicsWorld.raycast(physics_world, from, direction, wall_raycast_distance, "closest", "collision_filter", collision_filter)

	if hit then
		return true
	else
		return false
	end
end

BtMutantChargerChargeAction._check_colliding_players = function (self, unit, scratchpad, action_data)
	if scratchpad.anim_move_speed_duration or scratchpad.is_anim_driven then
		return
	end

	local pos = POSITION_LOOKUP[unit]
	local physics_world = scratchpad.physics_world
	local radius = action_data.collision_radius
	local dodge_radius = action_data.dodge_collision_radius
	local hit_actors, actor_count = PhysicsWorld.immediate_overlap(physics_world, "shape", "sphere", "position", pos, "size", radius, "types", "dynamics", "collision_filter", "filter_player_detection")

	for i = 1, actor_count do
		repeat
			local hit_actor = hit_actors[i]
			local hit_unit = Actor.unit(hit_actor)

			if scratchpad.dodged_targets[hit_unit] then
				break
			end

			local is_dodging = Dodge.is_dodging(hit_unit)

			if is_dodging then
				local distance = Vector3.distance(pos, POSITION_LOOKUP[hit_unit])
			else
				local target_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
				local character_state_component = target_unit_data_extension:read_component("character_state")
				local is_disabled = PlayerUnitStatus.is_disabled(character_state_component)
				local is_enemy = scratchpad.side_system:is_enemy(unit, hit_unit)

				if not is_disabled and is_enemy then
					return hit_unit
				end
			end
		until true
	end
end

BtMutantChargerChargeAction._hit_target = function (self, unit, hit_unit, scratchpad, action_data, t)
	local hit_unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
	local disabled_state_input = hit_unit_data_extension:write_component("disabled_state_input")
	local hit_unit_breed_name = hit_unit_data_extension:breed().name
	disabled_state_input.wants_disable = true
	disabled_state_input.disabling_unit = unit
	disabled_state_input.disabling_type = "mutant_charged"
	local disabled_character_state_component = hit_unit_data_extension:write_component("disabled_character_state")
	disabled_character_state_component.target_drag_position = Unit.world_position(unit, 1)
	scratchpad.hit_unit_disabled_state_input = disabled_state_input
	scratchpad.state = "grabbed_target"
	scratchpad.hit_unit_breed_name = hit_unit_breed_name
	scratchpad.charge_with_target_t = t + action_data.grab_anim_duration[hit_unit_breed_name]
	scratchpad.grabbed_target = hit_unit
	scratchpad.grab_target_duration = t + action_data.grab_anim_duration[hit_unit_breed_name] + action_data.smash_anim_duration[hit_unit_breed_name]
	local hit_unit_disabled_character_state_component = hit_unit_data_extension:read_component("disabled_character_state")
	scratchpad.hit_unit_disabled_character_state_component = hit_unit_disabled_character_state_component
	local grab_anim = action_data.grab_anims[hit_unit_breed_name]

	scratchpad.animation_extension:anim_event(grab_anim)

	if scratchpad.is_anim_driven then
		MinionMovement.set_anim_driven(scratchpad, false)
	end

	AttackIntensity.add_intensity(hit_unit, action_data.attack_intensities)

	local target = scratchpad.grabbed_target
	local damage_profile = action_data.damage_profile
	local damage_type = action_data.damage_type[scratchpad.hit_unit_breed_name]
	local power_level = Managers.state.difficulty:get_table_entry_by_challenge(action_data.grab_power_level)
	local node = Unit.node(target, "j_head")
	local hit_position = Unit.world_position(target, node)

	Attack.execute(target, damage_profile, "power_level", power_level, "hit_world_position", hit_position, "attacking_unit", unit, "attack_type", attack_types.melee, "damage_type", damage_type)
	self:_stop_effect_template(scratchpad)
	self:_allow_gibbing(unit, action_data, false)

	local is_player_unit = Managers.state.player_unit_spawn:is_player_unit(hit_unit)

	if is_player_unit then
		local record_state_component = scratchpad.record_state_component
		record_state_component.has_disabled_player = true
	end
end

local COLLISION_FILTER = "filter_player_mover"

BtMutantChargerChargeAction._ray_cast = function (self, physics_world, from, to)
	local to_target = to - from
	local direction = Vector3.normalize(to_target)
	local distance = Vector3.length(to_target)
	local result, hit_position, hit_distance, normal, _ = PhysicsWorld.raycast(physics_world, from, direction, distance, "closest", "collision_filter", COLLISION_FILTER)

	return result, hit_position, hit_distance, normal
end

local DEGREE_RANGE = 360

BtMutantChargerChargeAction._calculate_randomized_throw_directions = function (self, action_data)
	local degree_per_direction = action_data.degree_per_throw_direction
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

local BROADPHASE_RESULTS = {}

BtMutantChargerChargeAction._push_friendly_minions = function (self, unit, action_data, scratchpad, t)
	local broadphase_system = scratchpad.broadphase_system
	local broadphase = broadphase_system.broadphase
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local broadphase_relation = action_data.push_minions_side_relation
	local target_side_names = side:relation_side_names(broadphase_relation)
	local radius = action_data.push_minions_radius
	local from = POSITION_LOOKUP[unit]
	local num_results = broadphase:query(from, radius, BROADPHASE_RESULTS, target_side_names)

	if num_results < 1 then
		return
	end

	local push_minions_fx_template = action_data.push_minions_fx_template
	local power_level = action_data.push_minions_power_level
	local damage_profile = action_data.push_minions_damage_profile
	local damage_type = action_data.push_minions_damage_type
	local pushed_minions = scratchpad.pushed_minions
	local push_minions_ignored_breeds = action_data.push_minions_ignored_breeds

	for i = 1, num_results do
		local hit_unit = BROADPHASE_RESULTS[i]

		if hit_unit ~= unit and not pushed_minions[hit_unit] then
			local to = POSITION_LOOKUP[hit_unit]
			local direction = Vector3.normalize(to - from)

			if Vector3.length_squared(direction) == 0 then
				local current_rotation = Unit.local_rotation(unit, 1)
				direction = Quaternion.forward(current_rotation)
			end

			local unit_data_extension = ScriptUnit.extension(hit_unit, "unit_data_system")
			local hit_unit_breed = unit_data_extension:breed()

			if Breed.is_minion(hit_unit_breed) then
				local hit_unit_breed_name = hit_unit_breed.name
				local should_ignore = push_minions_ignored_breeds and push_minions_ignored_breeds[hit_unit_breed_name]
				local tags = hit_unit_breed.tags

				if not tags.monster and not should_ignore then
					Attack.execute(hit_unit, damage_profile, "power_level", power_level, "attacking_unit", unit, "attack_direction", direction, "hit_zone_name", "torso", "damage_type", damage_type)

					pushed_minions[hit_unit] = true

					if not scratchpad.push_minions_fx_cooldown or scratchpad.push_minions_fx_cooldown <= t then
						MinionPushFx.play_fx(unit, hit_unit, push_minions_fx_template)

						scratchpad.push_minions_fx_cooldown = t + math.random_range(action_data.push_minions_fx_cooldown[1], action_data.push_minions_fx_cooldown[2])
					end
				end
			end
		end
	end
end

BtMutantChargerChargeAction._get_turn_slowdown_percentage = function (self, unit, direction, action_data)
	local current_rotation = Unit.local_rotation(unit, 1)
	local forward = Quaternion.forward(current_rotation)
	local dot = Vector3.dot(forward, direction)
	local angle = math.radians_to_degrees(math.acos(dot))
	local min_slowdown_angle = action_data.min_slowdown_angle
	local max_slowdown_angle = action_data.max_slowdown_angle

	if dot > 1 or angle <= min_slowdown_angle then
		return 1
	end

	local slowdown_angle_percentage = math.min((angle - min_slowdown_angle) / max_slowdown_angle, 1)
	local max_slowdown_percentage = action_data.max_slowdown_percentage
	local wanted_slowdown_percentage = 1 - slowdown_angle_percentage * max_slowdown_percentage

	return wanted_slowdown_percentage
end

BtMutantChargerChargeAction._start_effect_template = function (self, unit, scratchpad, action_data)
	local effect_template = action_data.effect_template

	if not scratchpad.global_effect_id then
		local fx_system = scratchpad.fx_system
		local global_effect_id = fx_system:start_template_effect(effect_template, unit)
		scratchpad.global_effect_id = global_effect_id
	end
end

BtMutantChargerChargeAction._stop_effect_template = function (self, scratchpad)
	local global_effect_id = scratchpad.global_effect_id

	if global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(global_effect_id)

		scratchpad.global_effect_id = nil
	end
end

BtMutantChargerChargeAction._allow_gibbing = function (self, unit, action_data, allowed)
	local disallowed_hit_zones_for_gibbing = action_data.disallowed_hit_zones_for_gibbing

	if disallowed_hit_zones_for_gibbing then
		local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")

		for i = 1, #disallowed_hit_zones_for_gibbing do
			local disallowed_hit_zone = disallowed_hit_zones_for_gibbing[i]

			visual_loadout_extension:allow_gib_for_hit_zone(disallowed_hit_zone, allowed)
		end
	end
end

BtMutantChargerChargeAction._add_threat_to_other_targets = function (self, unit, breed, scratchpad, excluded_target)
	local side_system = scratchpad.side_system
	local side = side_system.side_by_unit[unit]
	local valid_enemy_player_units = side.valid_enemy_player_units
	local num_enemies = #valid_enemy_player_units
	local perception_extension = ScriptUnit.extension(unit, "perception_system")
	local max_threat = breed.threat_config.max_threat

	for i = 1, num_enemies do
		local target_unit = valid_enemy_player_units[i]

		if target_unit ~= excluded_target then
			perception_extension:add_threat(target_unit, max_threat)
		end
	end
end

BtMutantChargerChargeAction._get_min_charge_speed = function (self, scratchpad, action_data)
	local min_speed = action_data.charge_speed_min
	local buff_extension = scratchpad.buff_extension
	local stat_buffs = buff_extension:stat_buffs()
	local movement_speed = stat_buffs.movement_speed or 1
	min_speed = min_speed * movement_speed

	return min_speed
end

BtMutantChargerChargeAction._get_max_charge_speed = function (self, scratchpad, action_data)
	local max_speed = action_data.charge_speed_max
	local buff_extension = scratchpad.buff_extension
	local stat_buffs = buff_extension:stat_buffs()
	local movement_speed = stat_buffs.movement_speed or 1
	max_speed = max_speed * movement_speed

	return max_speed
end

return BtMutantChargerChargeAction
