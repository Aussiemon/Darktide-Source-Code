require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Assist = require("scripts/extension_systems/character_state_machine/character_states/utilities/assist")
local CharacterStateAssistSettings = require("scripts/settings/character_state/character_state_assist_settings")
local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local HangLedge = require("scripts/extension_systems/character_state_machine/character_states/utilities/hang_ledge")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Luggable = require("scripts/utilities/luggable")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local PlayerCharacterStateLedgeHanging = class("PlayerCharacterStateLedgeHanging", "PlayerCharacterStateBase")
local assist_anims = CharacterStateAssistSettings.anim_settings.ledge_hanging
local LEDGE_HANGING_STATES = table.enum("none", "ledge_start", "ledge_loop")
local IK_RAY_DISTANCE = 1
local HAND_IK_CONFIG = {
	right_transform_name = "j_right_hand_ik_transform",
	left_handle_name = "j_left_hand_ik_handle",
	ray_edge_offset = 0.05,
	right_handle_name = "j_right_hand_ik_handle",
	left_transform_name = "j_left_hand_ik_transform",
	hips_handle_name = "j_hips_handle",
	hand_length = {
		human = 0.05,
		ogryn = 0.1
	},
	hand_separation = {
		human = 0.428,
		ogryn = 0.896
	},
	hand_thickness = {
		human = 0.05,
		ogryn = 0.1
	},
	ray_distance = IK_RAY_DISTANCE,
	half_ray_distance = IK_RAY_DISTANCE * 0.5
}
local ENTER_ANIMATION_DURATION = 1
local SFX_SOURCE = "head"
local STINGER_ENTER_ALIAS = "disabled_enter"
local STINGER_EXIT_ALIAS = "disabled_exit"
local STINGER_PROPERTIES = {
	stinger_type = "hanging"
}
local _update_hand_ik_to_hanging = nil

PlayerCharacterStateLedgeHanging.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateLedgeHanging.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local ledge_hanging_character_state_component = unit_data_extension:write_component("ledge_hanging_character_state")
	ledge_hanging_character_state_component.hang_ledge_unit = nil
	ledge_hanging_character_state_component.start_time_position_transition = 0
	ledge_hanging_character_state_component.end_time_position_transition = 0
	ledge_hanging_character_state_component.position_pre_hanging = Vector3.zero()
	ledge_hanging_character_state_component.position_hanging = Vector3.zero()
	ledge_hanging_character_state_component.rotation_pre_hanging = Quaternion.identity()
	ledge_hanging_character_state_component.rotation_hanging = Quaternion.identity()
	ledge_hanging_character_state_component.time_to_fall_down = 0
	ledge_hanging_character_state_component.is_interactible = false
	self._ledge_hanging_character_state_component = ledge_hanging_character_state_component
	local constants = self._constants
	self._lerp_duration_to_hanging_position = constants.duration_to_hanging_position_from_hang_ledge
	self._time_until_fall_down = constants.time_until_fall_down_from_hang_ledge
	self._current_state = LEDGE_HANGING_STATES.none
	self._canceled_assist = false
	self._inventory_component = unit_data_extension:write_component("inventory")
	self._entered_state_t = nil
	self._time_disabled = nil
	local unit = self._unit
	local left_handle = Unit.node(unit, HAND_IK_CONFIG.left_handle_name)
	local left_transform_node = Unit.node(unit, HAND_IK_CONFIG.left_transform_name)
	local right_handle = Unit.node(unit, HAND_IK_CONFIG.right_handle_name)
	local right_transform_node = Unit.node(unit, HAND_IK_CONFIG.right_transform_name)
	local hips_handle = Unit.node(unit, HAND_IK_CONFIG.hips_handle_name)
	self._hands_ik_data = {
		left_ray_hit = false,
		right_ray_hit = false,
		left_handle = left_handle,
		left_transform_node = left_transform_node,
		right_handle = right_handle,
		right_transform_node = right_transform_node,
		hips_handle = hips_handle
	}
end

PlayerCharacterStateLedgeHanging.extensions_ready = function (self, world, unit)
	PlayerCharacterStateLedgeHanging.super.extensions_ready(self, world, unit)

	local is_server = self._is_server
	local game_session_or_nil = self._game_session
	local game_object_id_or_nil = self._game_object_id
	self._assist = Assist:new(assist_anims, is_server, unit, game_session_or_nil, game_object_id_or_nil, "saved")
end

PlayerCharacterStateLedgeHanging.game_object_initialized = function (self, game_session, game_object_id)
	PlayerCharacterStateLedgeHanging.super.game_object_initialized(self, game_session, game_object_id)
	self._assist:game_object_initialized(game_session, game_object_id)
end

PlayerCharacterStateLedgeHanging.on_enter = function (self, unit, dt, t, previous_state, params)
	local hang_ledge_unit = params.hang_ledge_unit
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension

	Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)
	self:_initialize_position_transition(unit, hang_ledge_unit, t)
	self:_initialize_rotation_transition(unit, hang_ledge_unit, t)
	self:_initialize_hands_ik(unit)
	self:_initialize_force_rotation(unit, t)
	self:_reset_locomotion()
	self:_on_enter_animation(unit, t)
	FirstPersonView.exit(t, self._first_person_mode_component)

	self._ledge_hanging_character_state_component.time_to_fall_down = t + self._time_until_fall_down
	self._ledge_hanging_character_state_component.hang_ledge_unit = hang_ledge_unit
	self._ledge_hanging_character_state_component.is_interactible = false
	self._current_state = LEDGE_HANGING_STATES.ledge_start
	self._cancelled_assist = false
	local is_server = self._is_server
	self._entered_state_t = t
	self._time_disabled = is_server and 0 or nil

	if is_server then
		self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ENTER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)

		local data = {
			reason = "ledge_hanging"
		}

		Managers.telemetry_events:player_knocked_down(self._player, data)
	end

	Vo.player_ledge_hanging_event(unit)
	self._assist:reset()
end

PlayerCharacterStateLedgeHanging.on_exit = function (self, unit, t, next_state)
	local is_server = self._is_server

	if next_state and next_state ~= "ledge_hanging_falling" then
		if next_state ~= "dead" then
			PlayerUnitVisualLoadout.wield_previous_slot(self._inventory_component, unit, t)
		end

		local rewind_ms = LagCompensation.rewind_ms(is_server, self._is_local_unit, self._player)

		FirstPersonView.enter(t, self._first_person_mode_component, rewind_ms)
		ForceRotation.stop(self._locomotion_force_rotation_component)

		if is_server then
			local player_unit_spawn_manager = Managers.state.player_unit_spawn
			local player = player_unit_spawn_manager:owner(unit)
			local is_player_alive = player:unit_is_alive()

			if is_player_alive then
				local rescued_by_player = true
				local state_name = "ledge_hanging"
				local time_in_captivity = t - self._entered_state_t

				Managers.telemetry_events:player_exits_captivity(player, rescued_by_player, state_name, time_in_captivity)

				local stat_manager = Managers.stats

				if stat_manager.can_record_stats() then
					stat_manager:record_exit_disabled_character_state(state_name, self._time_disabled)
				end
			end

			self._entered_state_t = nil
			self._time_disabled = nil
		end
	end

	self._assist:stop()

	if is_server and next_state == "walking" then
		self._fx_extension:trigger_exclusive_gear_wwise_event(STINGER_EXIT_ALIAS, STINGER_PROPERTIES)
	end
end

PlayerCharacterStateLedgeHanging.update = function (self, unit, dt, t)
	self:_update_ledge_hanging(unit, t)
	self:_update_hands_ik_state(unit, t)
end

PlayerCharacterStateLedgeHanging.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local assist = self._assist
	local assist_done = assist:update(dt, t)
	local assist_in_progress = assist:in_progress()

	if assist_in_progress then
		local ledge_hanging_character_state = self._ledge_hanging_character_state_component
		local time_to_fall_down = ledge_hanging_character_state.time_to_fall_down
		ledge_hanging_character_state.time_to_fall_down = time_to_fall_down + dt
	end

	if self._is_server and not assist_in_progress then
		self._time_disabled = self._time_disabled + dt
	end

	return self:_check_transition(unit, t, next_state_params, assist_done)
end

PlayerCharacterStateLedgeHanging._check_transition = function (self, unit, t, next_state_params, assist_done)
	local unit_data_extension = self._unit_data_extension
	local ledge_hanging_character_state = self._ledge_hanging_character_state_component
	local should_fall_down = ledge_hanging_character_state.time_to_fall_down < t
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		if health_transition ~= "dead" then
			should_fall_down = true
		else
			return health_transition
		end
	end

	if should_fall_down then
		local constants = self._constants
		local distance_from_ledge = constants.ledge_hanging_to_ground_safe_distance
		local player_height = self._first_person_extension:default_height("default")
		local hang_ledge_unit = self._ledge_hanging_character_state_component.hang_ledge_unit
		local falling_start_position = HangLedge.calculate_falling_start_position(hang_ledge_unit, self._unit, distance_from_ledge, player_height)

		if self._is_server then
			local rotation = self._locomotion_component.rotation

			PlayerMovement.teleport_fixed_update(unit, falling_start_position, rotation)
		end

		local raycast_start = falling_start_position
		local raycast_direction = Vector3.down()
		local raycast_has_hit, _, _, _, _ = PhysicsWorld.raycast(self._physics_world, raycast_start, raycast_direction, player_height, "closest", "collision_filter", "filter_player_mover")

		if raycast_has_hit then
			return "falling"
		else
			next_state_params.falling_start_position = falling_start_position

			return "ledge_hanging_falling", next_state_params
		end
	end

	if assist_done then
		return "ledge_hanging_pull_up"
	end

	return nil
end

PlayerCharacterStateLedgeHanging._initialize_position_transition = function (self, unit, hang_ledge_unit, t)
	local player_current_position = Unit.local_position(unit, 1)
	local player_new_position, _ = HangLedge.calculate_new_position(hang_ledge_unit, player_current_position)
	self._ledge_hanging_character_state_component.position_pre_hanging = player_current_position
	self._ledge_hanging_character_state_component.position_hanging = player_new_position
	local distance = Vector3.distance(player_current_position, player_new_position)
	local lerp_duration = distance * self._lerp_duration_to_hanging_position
	lerp_duration = math.min(ENTER_ANIMATION_DURATION, lerp_duration)
	self._ledge_hanging_character_state_component.start_time_position_transition = t
	self._ledge_hanging_character_state_component.end_time_position_transition = t + lerp_duration
end

PlayerCharacterStateLedgeHanging._initialize_rotation_transition = function (self, unit, hang_ledge_unit, t)
	local player_current_rotation = Unit.local_rotation(unit, 1)
	local exit_rotation = HangLedge.calculate_hanging_rotation(hang_ledge_unit)
	self._ledge_hanging_character_state_component.rotation_pre_hanging = player_current_rotation
	self._ledge_hanging_character_state_component.rotation_hanging = exit_rotation
end

PlayerCharacterStateLedgeHanging._initialize_force_rotation = function (self, unit, t)
	local ledge_hanging_character_state_component = self._ledge_hanging_character_state_component
	local locomotion_force_rotation = self._locomotion_force_rotation_component
	local locomotion_steering = self._locomotion_steering_component
	local start_rotation = ledge_hanging_character_state_component.rotation_pre_hanging
	local end_rotation = ledge_hanging_character_state_component.rotation_hanging
	local start_time = t
	local duration = ledge_hanging_character_state_component.end_time_position_transition - t

	ForceRotation.start(locomotion_force_rotation, locomotion_steering, end_rotation, start_rotation, start_time, duration)
end

local function _hand_ik_goal_pose(physics_world, centered_raycast_origin, rotation_hanging_forward, rotation_hanging_left_or_right, hand_separation, ray_distance, offset_from_ray_pos)
	local hand_ik_raycast_origin = centered_raycast_origin + rotation_hanging_left_or_right * hand_separation * 0.5
	local hit, hit_pos, distance, normal = PhysicsWorld.raycast(physics_world, hand_ik_raycast_origin, Vector3.down(), ray_distance, "closest", "collision_filter", "filter_player_mover")
	local goal_pose = nil

	if hit then
		local goal_rot = Quaternion.look(rotation_hanging_forward, normal)
		local goal_pos = hit_pos - offset_from_ray_pos
		goal_pose = Matrix4x4Box(Matrix4x4.from_quaternion_position(goal_rot, goal_pos))
	end

	return hit, distance, goal_pose
end

PlayerCharacterStateLedgeHanging._initialize_hands_ik = function (self, unit)
	local physics_world = self._physics_world
	local ledge_hanging_character_state_component = self._ledge_hanging_character_state_component
	local position_hanging = ledge_hanging_character_state_component.position_hanging
	local rotation_hanging = ledge_hanging_character_state_component.rotation_hanging
	local rotation_hanging_forward = Quaternion.forward(rotation_hanging)
	local rotation_hanging_right = Quaternion.right(rotation_hanging)
	local ray_distance = HAND_IK_CONFIG.ray_distance
	local half_ray_distance = HAND_IK_CONFIG.half_ray_distance
	local ray_edge_offset = HAND_IK_CONFIG.ray_edge_offset
	local centered_raycast_origin = position_hanging + rotation_hanging_forward * ray_edge_offset + Vector3.up() * half_ray_distance
	local breed_name = self._breed.name
	local hand_separation = HAND_IK_CONFIG.hand_separation[breed_name]
	local hand_length = HAND_IK_CONFIG.hand_length[breed_name]
	local hand_thickness = HAND_IK_CONFIG.hand_thickness[breed_name]
	local offset_from_ray_pos = rotation_hanging_forward * (ray_edge_offset + hand_thickness) + Vector3.up() * hand_length
	local left_ray_hit, left_distance, left_goal_pose = _hand_ik_goal_pose(physics_world, centered_raycast_origin, rotation_hanging_forward, -rotation_hanging_right, hand_separation, ray_distance, offset_from_ray_pos)

	if not left_ray_hit then
		Unit.set_local_pose(unit, self._hands_ik_data.left_handle, Matrix4x4.identity())
	end

	self._hands_ik_data.left_ray_hit = left_ray_hit
	self._hands_ik_data.left_goal_pose = left_goal_pose
	local right_ray_hit, right_distance, right_goal_pose = _hand_ik_goal_pose(physics_world, centered_raycast_origin, rotation_hanging_forward, rotation_hanging_right, hand_separation, ray_distance, offset_from_ray_pos)

	if not right_ray_hit then
		Unit.set_local_pose(unit, self._hands_ik_data.right_handle, Matrix4x4.identity())
	end

	self._hands_ik_data.right_ray_hit = right_ray_hit
	self._hands_ik_data.right_goal_pose = right_goal_pose

	if left_distance or right_distance then
		local smallest_distance = nil

		if not left_distance then
			smallest_distance = right_distance
		elseif not right_distance then
			smallest_distance = left_distance
		else
			smallest_distance = math.min(left_distance, right_distance)
		end

		if smallest_distance < half_ray_distance then
			local hips_pos = Vector3(0, 0, half_ray_distance - smallest_distance)
			self._hands_ik_data.hips_goal_pose = Matrix4x4Box(Matrix4x4.from_translation(hips_pos))
		else
			self._hands_ik_data.hips_goal_pose = nil

			Unit.set_local_pose(unit, self._hands_ik_data.hips_handle, Matrix4x4.identity())
		end
	else
		self._hands_ik_data.hips_goal_pose = nil

		Unit.set_local_pose(unit, self._hands_ik_data.hips_handle, Matrix4x4.identity())
	end
end

PlayerCharacterStateLedgeHanging._on_enter_animation = function (self, unit, t)
	Interrupt.ability_and_action(t, unit, "ledge_hanging", nil)
	PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)
	self._animation_extension:anim_event("ledge_enter")
end

PlayerCharacterStateLedgeHanging._reset_locomotion = function (self)
	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = false
	locomotion_steering.velocity_wanted = Vector3.zero()
	locomotion_steering.disable_velocity_rotation = true
end

PlayerCharacterStateLedgeHanging._update_ledge_hanging = function (self, unit, t)
	if self._current_state == LEDGE_HANGING_STATES.ledge_start then
		self:_update_transition_to_hanging(unit, t)

		if self._ledge_hanging_character_state_component.end_time_position_transition <= t then
			self._current_state = LEDGE_HANGING_STATES.ledge_loop
			self._ledge_hanging_character_state_component.is_interactible = true
		end
	end
end

PlayerCharacterStateLedgeHanging._update_hands_ik_state = function (self, unit, t)
	local hands_ik_data = self._hands_ik_data
	local left_ray_hit = hands_ik_data.left_ray_hit
	local right_ray_hit = hands_ik_data.right_ray_hit

	if not right_ray_hit and not left_ray_hit then
		return
	end

	local right_transform_node = hands_ik_data.right_transform_node
	local left_transform_node = hands_ik_data.left_transform_node
	local right_handle = hands_ik_data.right_handle
	local left_handle = hands_ik_data.left_handle
	local hips_handle = hands_ik_data.hips_handle
	local ik_weight = nil

	if self._current_state == LEDGE_HANGING_STATES.ledge_start then
		local start_time = self._ledge_hanging_character_state_component.start_time_position_transition
		local end_time = self._ledge_hanging_character_state_component.end_time_position_transition
		ik_weight = math.smoothstep(t, start_time, end_time)
	end

	_update_hand_ik_to_hanging(hands_ik_data.left_goal_pose, unit, left_handle, left_transform_node, left_ray_hit, ik_weight)
	_update_hand_ik_to_hanging(hands_ik_data.right_goal_pose, unit, right_handle, right_transform_node, right_ray_hit, ik_weight)

	local boxed_hips_goal_pose = hands_ik_data.hips_goal_pose

	if boxed_hips_goal_pose then
		local hips_goal_pose = Matrix4x4Box.unbox(boxed_hips_goal_pose)

		if ik_weight then
			local hips_lerp_pose = Matrix4x4.lerp(Matrix4x4.identity(), hips_goal_pose, ik_weight)

			Unit.set_local_pose(unit, hips_handle, hips_lerp_pose)
		end
	end
end

PlayerCharacterStateLedgeHanging._update_transition_to_hanging = function (self, unit, t)
	local ledge_hanging_character_state_component = self._ledge_hanging_character_state_component
	local end_time_position_transition = ledge_hanging_character_state_component.end_time_position_transition

	if t < end_time_position_transition then
		local start_time = ledge_hanging_character_state_component.start_time_position_transition
		local end_time = end_time_position_transition
		local alpha = math.smoothstep(t, start_time, end_time)
		local start_position = ledge_hanging_character_state_component.position_pre_hanging
		local end_position = ledge_hanging_character_state_component.position_hanging
		local start_rotation = ledge_hanging_character_state_component.rotation_pre_hanging
		local end_rotation = ledge_hanging_character_state_component.rotation_hanging
		local new_position = math.lerp(start_position, end_position, alpha)
		local new_rotation = Quaternion.lerp(start_rotation, end_rotation, alpha)

		if self._is_server then
			PlayerMovement.teleport_fixed_update(unit, new_position, new_rotation)
		else
			local pitch = Quaternion.pitch(new_rotation)
			local yaw = Quaternion.yaw(new_rotation)

			self._player:set_orientation(yaw, pitch, 0)
		end
	end
end

function _update_hand_ik_to_hanging(boxed_goal_pose, unit, handle_node, transform_node, ray_hit, weight)
	if boxed_goal_pose and ray_hit then
		local goal_pose = Matrix4x4Box.unbox(boxed_goal_pose)
		local origin_pose = Unit.world_pose(unit, transform_node)
		local local_pose = Matrix4x4.multiply(goal_pose, Matrix4x4.inverse(origin_pose))
		local new_pose = nil

		if weight then
			new_pose = Matrix4x4.lerp(Matrix4x4.identity(), local_pose, weight)
		else
			new_pose = local_pose
		end

		Unit.set_local_pose(unit, handle_node, new_pose)
	end
end

return PlayerCharacterStateLedgeHanging
