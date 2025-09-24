-- chunkname: @scripts/extension_systems/behavior/nodes/actions/bt_companion_pounce_and_escape_action.lua

require("scripts/extension_systems/behavior/nodes/bt_node")

local Animation = require("scripts/utilities/animation")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local HitScan = require("scripts/utilities/attack/hit_scan")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local MinionMovement = require("scripts/utilities/minion_movement")
local NavQueries = require("scripts/utilities/nav_queries")
local Stagger = require("scripts/utilities/attack/stagger")
local proc_events = BuffSettings.proc_events
local BtCompanionTargetPounceAndEscapeAction = class("BtCompanionTargetPounceAndEscapeAction", "BtNode")

BtCompanionTargetPounceAndEscapeAction.enter = function (self, unit, breed, blackboard, scratchpad, action_data, t)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = "attacking"
	scratchpad.behavior_component = behavior_component

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	scratchpad.animation_extension = animation_extension

	local fx_system = Managers.state.extension:system("fx_system")

	scratchpad.fx_system = fx_system
	scratchpad.locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	scratchpad.navigation_extension = ScriptUnit.extension(unit, "navigation_system")
	scratchpad.start_position_boxed = Vector3Box(POSITION_LOOKUP[unit])

	local pounce_component = Blackboard.write_component(blackboard, "pounce")
	local pounce_target = pounce_component.pounce_target

	scratchpad.pounce_component = pounce_component

	local target_unit_data_extension = ScriptUnit.extension(pounce_target, "unit_data_system")
	local target_unit_breed = target_unit_data_extension:breed()
	local companion_pounce_setting = target_unit_breed.companion_pounce_setting

	scratchpad.companion_pounce_setting = companion_pounce_setting
	scratchpad.physics_world = blackboard.spawn.physics_world
	scratchpad.nav_world = scratchpad.navigation_extension:nav_world()
	scratchpad.traverse_logic = scratchpad.navigation_extension:traverse_logic()

	local target_blackboard = BLACKBOARDS[pounce_target]

	scratchpad.target_blackboard = target_blackboard
	scratchpad.target_death_component = target_blackboard.death
	scratchpad.target_stagger_component = target_blackboard.stagger

	self:_initial_set_up(unit, scratchpad, action_data, t)
	self:_handle_knock_away_enemy_stats(unit, breed, pounce_target, target_unit_breed)
	self:_trigger_knock_away_enemy_proc_event(unit, breed, pounce_target, target_unit_breed)
end

BtCompanionTargetPounceAndEscapeAction.init_values = function (self, blackboard)
	local pounce_component = Blackboard.write_component(blackboard, "pounce")

	pounce_component.pounce_target = nil
	pounce_component.pounce_cooldown = 0
	pounce_component.has_pounce_started = false
	pounce_component.has_jump_off_direction = true
	pounce_component.target_hit_zone_name = ""
	pounce_component.leap_node = ""
end

BtCompanionTargetPounceAndEscapeAction.leave = function (self, unit, breed, blackboard, scratchpad, action_data, t, reason, destroy)
	local pounce_component = scratchpad.pounce_component

	pounce_component.pounce_target = nil
	pounce_component.has_pounce_started = false
	pounce_component.target_hit_zone_name = ""
	pounce_component.leap_node = ""

	local companion_pounce_setting = scratchpad.companion_pounce_setting
	local hurt_effect_template = companion_pounce_setting.hurt_effect_template

	if hurt_effect_template and scratchpad.global_effect_id then
		local fx_system = scratchpad.fx_system

		fx_system:stop_template_effect(scratchpad.global_effect_id)
	end
end

local SPEED_THRESHOLD = 0.01

BtCompanionTargetPounceAndEscapeAction.run = function (self, unit, breed, blackboard, scratchpad, action_data, dt, t)
	local companion_pounce_setting = scratchpad.companion_pounce_setting

	if scratchpad.use_stick_attack then
		if scratchpad.lerping_position then
			local pounce_component = scratchpad.pounce_component
			local pounce_target = pounce_component.pounce_target

			if HEALTH_ALIVE[scratchpad.pounce_component.pounce_target] then
				local is_completed = self:_position_companion(unit, scratchpad, action_data, t, pounce_target)

				if is_completed then
					scratchpad.lerping_position = false
					scratchpad.unlink_time = t + companion_pounce_setting.on_target_hit.linking_time
					scratchpad.is_linked = true
				end

				return "running"
			else
				scratchpad.unlink_time = t + companion_pounce_setting.on_target_hit.linking_time
				scratchpad.is_linked = true
				scratchpad.lerping_position = false
			end
		end

		if t < scratchpad.unlink_time then
			if HEALTH_ALIVE[scratchpad.pounce_component.pounce_target] then
				local pounce_target_rotation = Unit.world_rotation(scratchpad.pounce_component.pounce_target, scratchpad.target_node)
				local pounce_target_position = Unit.world_position(scratchpad.pounce_component.pounce_target, scratchpad.target_node)

				Unit.set_local_position(unit, 1, pounce_target_position)
				Unit.set_local_rotation(unit, 1, pounce_target_rotation)

				return "running"
			else
				scratchpad.unlink_time = t
			end
		end

		if scratchpad.is_linked then
			scratchpad.is_linked = false

			local reset_rotation = true

			self:_jump_off_set_up(unit, scratchpad, action_data, t, companion_pounce_setting, reset_rotation)
			self:_free_token(unit, scratchpad)
		end
	elseif not scratchpad._is_jump_off_set_up then
		local reset_rotation = false

		self:_jump_off_set_up(unit, scratchpad, action_data, t, companion_pounce_setting, reset_rotation)
		self:_free_token(unit, scratchpad)

		scratchpad._is_jump_off_set_up = true
	end

	if not scratchpad.pounce_component.has_jump_off_direction then
		return "running"
	end

	if not scratchpad.land_anim_duration then
		if scratchpad.is_anim_driven and t > scratchpad.animation_driven_duration then
			MinionMovement.set_anim_driven(scratchpad, false)
		end

		local fx_system = scratchpad.fx_system
		local hurt_effect_template = companion_pounce_setting.hurt_effect_template

		if hurt_effect_template and not fx_system:has_running_template_of_name(unit, hurt_effect_template.name) then
			local global_effect_id = fx_system:start_template_effect(hurt_effect_template, unit)

			scratchpad.global_effect_id = global_effect_id
		end

		local mover = Unit.mover(unit)

		if not scratchpad.skip_mover_check and Mover.collides_down(mover) then
			local nav_world, traverse_logic = scratchpad.nav_world, scratchpad.traverse_logic
			local above, below, lateral = 0.2, 0.2, 0.3
			local has_nav_land_position = NavQueries.position_on_mesh_with_outside_position(nav_world, traverse_logic, POSITION_LOOKUP[unit], above, below, lateral)
			local locomotion_extension = scratchpad.locomotion_extension
			local velocity = Vector3.flat(locomotion_extension:current_velocity())
			local speed = Vector3.length(velocity)

			if has_nav_land_position then
				local land_anim_event = Animation.random_event(companion_pounce_setting.land_anim_events)

				scratchpad.animation_extension:anim_event(land_anim_event.name)
				MinionMovement.set_anim_driven(scratchpad, true)
				scratchpad.locomotion_extension:set_movement_type("snap_to_navmesh")

				scratchpad.land_anim_duration = t + land_anim_event.duration
			elseif speed < SPEED_THRESHOLD then
				scratchpad.behavior_component.is_out_of_bound = true

				return "failed"
			end
		end

		scratchpad.skip_mover_check = false

		if not scratchpad.land_anim_duration and not scratchpad.is_anim_driven then
			if not scratchpad.is_affected_by_gravity then
				scratchpad.locomotion_extension:set_gravity(nil)
				scratchpad.locomotion_extension:set_affected_by_gravity(true)

				scratchpad.is_affected_by_gravity = true
			end

			local fall_direction = Vector3.normalize(scratchpad.locomotion_extension:current_velocity())
			local magnitude = Vector3.length(scratchpad.locomotion_extension:current_velocity())
			local fall_velocity = Vector3(fall_direction.x * magnitude, fall_direction.y * magnitude, 0)

			scratchpad.locomotion_extension:set_wanted_velocity(fall_velocity)
		end
	end

	if scratchpad.land_anim_duration and t >= scratchpad.land_anim_duration then
		MinionMovement.set_anim_driven(scratchpad, false)
		scratchpad.locomotion_extension:set_affected_by_gravity(false)

		scratchpad.pounce_component.pounce_cooldown = t + action_data.leap_cooldown
		scratchpad.pounce_component.has_pounce_target = false
		scratchpad.pounce_component.has_pounce_started = false

		return "done"
	end

	return "running"
end

local POWER_LEVEL = 500

BtCompanionTargetPounceAndEscapeAction._damage_target = function (self, unit, pounce_target, action_data, damage_profile)
	local jaw_node = Unit.node(unit, action_data.hit_position_node)
	local hit_position = Unit.world_position(unit, jaw_node)
	local attack_type = AttackSettings.attack_types.companion_dog
	local damage_type = action_data.damage_type

	return Attack.execute(pounce_target, damage_profile, "power_level", POWER_LEVEL, "hit_world_position", hit_position, "attack_type", attack_type, "attacking_unit", unit, "damage_type", damage_type, "instakill", damage_profile.instakill)
end

BtCompanionTargetPounceAndEscapeAction._initial_set_up = function (self, unit, scratchpad, action_data, t)
	local companion_pounce_setting = scratchpad.companion_pounce_setting
	local on_target_hit_settings = companion_pounce_setting.on_target_hit
	local pounce_component = scratchpad.pounce_component
	local pounce_target = pounce_component.pounce_target
	local damage_profile = companion_pounce_setting.damage_profile
	local damage_dealt, attack_result, damage_efficiency, stagger_result, _ = self:_damage_target(unit, pounce_target, action_data, damage_profile)
	local attack_direction = Vector3.normalize(Quaternion.forward(Unit.local_rotation(unit, 1)))
	local hit_position = Unit.world_position(unit, Unit.node(unit, pounce_component.leap_node))

	ImpactEffect.play(pounce_target, nil, damage_dealt, "companion_dog_pounce", pounce_component.target_hit_zone_name, attack_result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

	local target_current_stagger = scratchpad.target_stagger_component.type
	local force_stagger_settings = companion_pounce_setting.force_stagger_settings

	if force_stagger_settings and (stagger_result == "no_stagger" or target_current_stagger ~= force_stagger_settings.stagger_type) then
		Stagger.force_stagger(pounce_target, force_stagger_settings.stagger_type, attack_direction, force_stagger_settings.duration, force_stagger_settings.length_scale, force_stagger_settings.immune_time, unit)
	end

	local target_nodes = on_target_hit_settings.dog_target_nodes

	if target_nodes then
		scratchpad.use_stick_attack = true

		local target_node = Unit.node(pounce_target, target_nodes[1])
		local target_node_location = Unit.world_position(pounce_target, target_node)
		local unit_position = Unit.world_position(unit, 1)
		local target_distance = Vector3.distance(target_node_location, unit_position)

		for i = 2, #target_nodes do
			local temp_node = Unit.node(pounce_target, target_nodes[i])

			target_node_location = Unit.world_position(pounce_target, temp_node)

			local temp_distance = Vector3.distance(target_node_location, unit_position)

			if temp_distance < target_distance then
				target_distance = temp_distance
				target_node = temp_node
			end
		end

		scratchpad.target_node = target_node
		scratchpad.lerp_position_duration = t + 0.06666666666666667
		scratchpad.start_position_boxed = Vector3Box(unit_position)

		local stick_anim_event = on_target_hit_settings.anim_event_on_stick

		scratchpad.animation_extension:anim_event(stick_anim_event)

		scratchpad.lerping_position = true
	else
		scratchpad.use_stick_attack = false
	end

	pounce_component.has_pounce_started = true
end

BtCompanionTargetPounceAndEscapeAction._select_jump_off_direction = function (self, unit, action_data, scratchpad, pounce_target, trace_direction)
	local select_jump_off_direction_settings = action_data.select_jump_off_direction_settings
	local trace_direction_flat = Vector3.normalize(Vector3.flat(trace_direction))
	local estimated_animation_angle = math.degrees_to_radians(select_jump_off_direction_settings.estimated_animation_angle)
	local right_vector = Vector3.cross(Vector3.up(), trace_direction_flat)
	local estimated_animation_angle_rotation = Quaternion(right_vector, estimated_animation_angle)
	local base_trace = Vector3.normalize(Quaternion.rotate(estimated_animation_angle_rotation, trace_direction_flat))
	local angle_range = select_jump_off_direction_settings.angle_range / 2
	local numbers_of_checks = angle_range / select_jump_off_direction_settings.angle_frequency_check
	local random_initial_offset = math.random(1, numbers_of_checks)
	local max_distance_check = select_jump_off_direction_settings.max_distance_check
	local sweep_radius = select_jump_off_direction_settings.sweep_radius
	local above, below = 0.2, 0.2
	local valid_nav_angles = {}

	for i = 0, numbers_of_checks do
		local current_index = math.fmod(random_initial_offset + i, numbers_of_checks)
		local angle_trace_rotation = math.degrees_to_radians(select_jump_off_direction_settings.angle_frequency_check * current_index)
		local left_rotation = Quaternion(Vector3.up(), angle_trace_rotation)
		local right_rotation = Quaternion(Vector3.up(), -angle_trace_rotation)
		local left_trace = Vector3.normalize(Quaternion.rotate(left_rotation, base_trace))
		local right_trace = Vector3.normalize(Quaternion.rotate(right_rotation, base_trace))
		local left_hits = HitScan.sphere_sweep(scratchpad.physics_world, POSITION_LOOKUP[unit], left_trace, max_distance_check, "statics", "filter_simple_geometry", sweep_radius)
		local right_hits = HitScan.sphere_sweep(scratchpad.physics_world, POSITION_LOOKUP[unit], right_trace, max_distance_check, "statics", "filter_simple_geometry", sweep_radius)
		local nav_pos

		if left_hits and #left_hits > 0 then
			nav_pos = NavQueries.position_on_mesh(scratchpad.nav_world, left_hits[1].position, above, below, scratchpad.traverse_logic)

			if nav_pos then
				table.insert(valid_nav_angles, angle_trace_rotation)
			end
		end

		if right_hits and #right_hits > 0 then
			nav_pos = NavQueries.position_on_mesh(scratchpad.nav_world, right_hits[1].position, above, below, scratchpad.traverse_logic)

			if nav_pos then
				table.insert(valid_nav_angles, -angle_trace_rotation)
			end
		end

		local number_of_valid_angles = #valid_nav_angles

		if number_of_valid_angles > 0 then
			local random_angle_to_pick = math.random(1, number_of_valid_angles)
			local degree_angle = math.radians_to_degrees(valid_nav_angles[random_angle_to_pick])
			local animation_value = (degree_angle + angle_range) / angle_range

			scratchpad.animation_extension:set_variable(select_jump_off_direction_settings.animation_variable_name, animation_value)

			return true
		end
	end

	scratchpad.pounce_component.has_jump_off_direction = false

	return false
end

BtCompanionTargetPounceAndEscapeAction._position_companion = function (self, unit, scratchpad, action_data, t, pounce_target)
	local pounce_target_position = Unit.world_position(pounce_target, scratchpad.target_node)

	if t < scratchpad.lerp_position_duration then
		local lerp_position_time = 0.06666666666666667
		local start_position = scratchpad.start_position_boxed:unbox()
		local time_left = scratchpad.lerp_position_duration - t
		local percentage = 1 - time_left / lerp_position_time
		local new_position = Vector3.lerp(start_position, pounce_target_position, percentage)

		Unit.set_local_position(unit, 1, new_position)
	else
		Unit.set_local_position(unit, 1, pounce_target_position)

		return true
	end

	return false
end

BtCompanionTargetPounceAndEscapeAction._jump_off_set_up = function (self, unit, scratchpad, action_data, t, companion_pounce_setting, reset_rotation)
	local pounce_component = scratchpad.pounce_component
	local pounce_target = pounce_component.pounce_target
	local current_unit_rotation = Unit.world_rotation(unit, 1)

	if reset_rotation then
		local _, _, z, w = Quaternion.to_elements(current_unit_rotation)

		Quaternion.set_xyzw(current_unit_rotation, 0, 0, z, w)
		Unit.set_local_rotation(unit, 1, current_unit_rotation)
	end

	local forward = -Quaternion.forward(current_unit_rotation)
	local has_jump_off_direction = self:_select_jump_off_direction(unit, action_data, scratchpad, pounce_target, forward)

	if has_jump_off_direction then
		local on_target_hit_settings = companion_pounce_setting.on_target_hit
		local pounce_anim_event = on_target_hit_settings.anim_event

		scratchpad.animation_extension:anim_event(pounce_anim_event)
		scratchpad.locomotion_extension:set_movement_type("constrained_by_mover")

		scratchpad.skip_mover_check = true
		scratchpad.animation_driven_duration = t + on_target_hit_settings.animation_driven_duration

		MinionMovement.set_anim_driven(scratchpad, true)
	end
end

BtCompanionTargetPounceAndEscapeAction._free_token = function (self, unit, scratchpad)
	local pounce_component = scratchpad.pounce_component
	local pounce_target = pounce_component.pounce_target

	if pounce_target and HEALTH_ALIVE[pounce_target] then
		local token_extension = ScriptUnit.has_extension(pounce_target, "token_system")
		local required_token = scratchpad.companion_pounce_setting.required_token

		if token_extension and token_extension:is_token_free_or_mine(unit, required_token.name) then
			token_extension:free_token(required_token.name)
		end
	end
end

BtCompanionTargetPounceAndEscapeAction._has_companion_saved_owner_in_disabled_state = function (self, player_owner, pounced_unit)
	local player_unit = player_owner.player_unit
	local hit_unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
	local owner_disabled_state_component = hit_unit_data_extension and hit_unit_data_extension:read_component("disabled_state_input")

	if not owner_disabled_state_component then
		return false
	end

	local is_owner_disabled = owner_disabled_state_component.disabling_type ~= "none"
	local is_pounced_unit_disabling_owner = owner_disabled_state_component.disabling_unit == pounced_unit

	return is_owner_disabled and is_pounced_unit_disabling_owner
end

BtCompanionTargetPounceAndEscapeAction._trigger_knock_away_enemy_proc_event = function (self, companion_unit, companion_breed, pounced_unit, pounced_unit_breed)
	local player_owner = Managers.state.player_unit_spawn:owner(companion_unit)
	local player_unit_buff_extension = player_owner.player_unit and ScriptUnit.has_extension(player_owner.player_unit, "buff_system")
	local proc_event_param_table = player_unit_buff_extension and player_unit_buff_extension:request_proc_event_param_table()

	if proc_event_param_table then
		proc_event_param_table.owner_unit = player_owner.player_unit
		proc_event_param_table.companion_breed = companion_breed.name
		proc_event_param_table.companion_unit = companion_unit
		proc_event_param_table.target_unit_breed_name = pounced_unit_breed.name

		player_unit_buff_extension:add_proc_event(proc_events.on_player_companion_knock_away, proc_event_param_table)
	end
end

BtCompanionTargetPounceAndEscapeAction._handle_knock_away_enemy_stats = function (self, companion_unit, companion_breed, pounced_unit, pounced_unit_breed)
	local pounced_unit_behaviour_extension = ScriptUnit.has_extension(pounced_unit, "behavior_system")
	local previously_pounced = pounced_unit_behaviour_extension and pounced_unit_behaviour_extension.pounced_by_companion_before and pounced_unit_behaviour_extension:pounced_by_companion_before(companion_unit)
	local player_owner = Managers.state.player_unit_spawn:owner(companion_unit)
	local companion_breed_name = companion_breed.name
	local pounced_unit_breed_name = pounced_unit_breed.name
	local has_companion_saved_disabled_owner = self:_has_companion_saved_owner_in_disabled_state(player_owner, pounced_unit)

	if player_owner and has_companion_saved_disabled_owner and pounced_unit_breed_name == "chaos_hound" then
		Managers.achievements:unlock_achievement(player_owner, "adamant_saved_by_companion_from_disabling_hound")
	end

	if player_owner then
		Managers.stats:record_private("hook_adamant_companion_knock_enemy", player_owner, companion_unit, companion_breed_name, pounced_unit, pounced_unit_breed_name, previously_pounced, has_companion_saved_disabled_owner)
	end
end

return BtCompanionTargetPounceAndEscapeAction
