-- chunkname: @scripts/extension_systems/locomotion/player_unit_locomotion_extension.lua

local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local DodgeSettings = require("scripts/settings/dodge/dodge_settings")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local ForceTranslation = require("scripts/extension_systems/locomotion/utilities/force_translation")
local HubMovementLocomotion = require("scripts/extension_systems/locomotion/utilities/hub_movement_locomotion")
local Ladder = require("scripts/extension_systems/character_state_machine/character_states/utilities/ladder")
local MoverController = require("scripts/extension_systems/locomotion/utilities/mover_controller")
local PlayerDeath = require("scripts/utilities/player_death")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitLinker = require("scripts/extension_systems/locomotion/utilities/player_unit_linker")
local PlayerUnitStatus = require("scripts/utilities/attack/player_unit_status")
local Push = require("scripts/extension_systems/character_state_machine/character_states/utilities/push")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local ThirdPersonHubMovementDirectionAnimationControl = require("scripts/extension_systems/locomotion/third_person_hub_movement_direction_animation_control")
local PlayerUnitLocomotionExtension = class("PlayerUnitLocomotionExtension")
local Vector3_flat = Vector3.flat
local Quaternion_forward = Quaternion.forward
local Vector3_normalize = Vector3.normalize
local Vector3_dot = Vector3.dot
local Quaternion_look = Quaternion.look
local dodge_types = DodgeSettings.dodge_types
local PLAYER_RENDER_FRAME_POSITIONS = table.enum("interpolate", "extrapolate", "raw")
local EMPTY_TABLE = {}

PlayerUnitLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_component, game_object_component_or_game_session, game_object_id_or_nil)
	self._unit = unit
	self._world = extension_init_context.world
	self._physics_world = extension_init_context.physics_world
	self._is_server = extension_init_context.is_server

	local data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local loc_component = data_ext:write_component("locomotion")

	self._locomotion_component = loc_component

	local loc_steering_component = data_ext:write_component("locomotion_steering")

	self._locomotion_steering_component = loc_steering_component
	self._first_person_component = data_ext:read_component("first_person")
	self._movement_settings_component = data_ext:read_component("movement_settings")

	local inair_state_component = data_ext:write_component("inair_state")

	self._inair_state_component = inair_state_component

	local loc_force_rotation_component = data_ext:write_component("locomotion_force_rotation")

	self._locomotion_force_rotation_component = loc_force_rotation_component

	local loc_force_translation_component = data_ext:write_component("locomotion_force_translation")

	self._locomotion_force_translation_component = loc_force_translation_component

	local loc_push_component = data_ext:write_component("locomotion_push")

	self._locomotion_push_component = loc_push_component
	self._character_state_component = data_ext:read_component("character_state")
	self._ladder_character_state_component = data_ext:read_component("ladder_character_state")
	self._hub_jog_character_state_component = data_ext:read_component("hub_jog_character_state")
	self._movement_state_component = data_ext:write_component("movement_state")
	self._stamina_component = data_ext:read_component("stamina")
	self._sprint_character_state_component = data_ext:read_component("sprint_character_state")
	self._use_drag = true
	self._collision_filter = "filter_player_mover"
	self._last_fixed_t = extension_init_context.fixed_frame_t
	self._constants = extension_init_component.player_character_constants
	self._breed = extension_init_component.breed
	self._is_local_unit = extension_init_component.is_local_unit
	self._step_timer = 0
	self._step_anim_timer = 0

	local pos = Unit.local_position(unit, 1)
	local rot = Unit.local_rotation(unit, 1)

	loc_component.velocity_current = Vector3.zero()
	loc_steering_component.disable_push_velocity = false
	loc_steering_component.target_rotation = rot
	loc_steering_component.target_translation = Vector3.zero()
	loc_steering_component.rotation_based_on_wanted_velocity = true
	loc_steering_component.hub_active_stopping = false
	loc_component.position = pos
	loc_component.rotation = rot
	loc_component.parent_unit = nil
	loc_force_rotation_component.use_force_rotation = false
	loc_force_rotation_component.start_rotation = Quaternion.identity()
	loc_force_rotation_component.start_time = 0
	loc_force_rotation_component.end_time = 0
	loc_force_translation_component.use_force_translation = false
	loc_force_translation_component.start_translation = Vector3.zero()
	loc_force_translation_component.start_time = 0
	loc_force_translation_component.end_time = 0
	inair_state_component.on_ground = false
	inair_state_component.inair_entered_t = 0
	inair_state_component.fell_from_height = 0
	inair_state_component.flying_frames = 0
	inair_state_component.standing_frames = 0
	loc_push_component.velocity = Vector3.zero()
	loc_push_component.new_velocity = Vector3.zero()
	loc_push_component.time_to_apply = 0

	if self._is_server then
		game_object_component_or_game_session.position = pos

		local y, p, r = Quaternion.to_yaw_pitch_roll(rot)

		game_object_component_or_game_session.yaw = y
		game_object_component_or_game_session.pitch = p
		game_object_component_or_game_session.roll = r
		game_object_component_or_game_session.move_speed = 0
		game_object_component_or_game_session.parent_unit_id = NetworkConstants.invalid_level_unit_id
	end

	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._move_speed_anim_var = "anim_move_speed"
	self._climb_time_anim_var = "climb_time"
	self._active_stop_anim_var = "active_stop"
	self._mover_state = MoverController.create_mover_state()

	MoverController.set_active_mover(unit, self._mover_state, "default")

	self._ogryn_dodges = data_ext:archetype_name() == "ogryn"
	self._script_minion_collision = true

	local archetype = data_ext:archetype()

	self._base_stamina_template = archetype.stamina
	self._old_position = Vector3Box(pos)
	self._latest_simulated_position = Vector3Box(pos)
	self._player_unit_linker = PlayerUnitLinker:new(self._world, unit)
	self._network_max_mover_frames = NetworkConstants.max_mover_frames

	local out_of_bounds_manager = Managers.state.out_of_bounds
	local soft_cap_extents = out_of_bounds_manager:soft_cap_extents()
	local soft_cap_x, soft_cap_y, soft_cap_z = Vector3.to_elements(soft_cap_extents)

	self._soft_cap_x, self._soft_cap_y, self._soft_cap_z = soft_cap_x, soft_cap_y, soft_cap_z
	self._fixed_time_step = Managers.state.game_session.fixed_time_step
end

PlayerUnitLocomotionExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id

	local init_context = {
		is_husk = false,
		player_character_constants = self._constants,
		is_local_unit = self._is_local_unit,
		is_server = self._is_server,
		game_session = session,
		game_object_id = object_id,
	}

	self._movement_direction_animation_control = ThirdPersonHubMovementDirectionAnimationControl:new(self._unit, init_context)
end

PlayerUnitLocomotionExtension.destroy = function (self)
	Managers.state.out_of_bounds:unregister_soft_oob_unit(self._unit, self)
end

PlayerUnitLocomotionExtension._handle_oob = function (self, position, velocity)
	local x, y, z = Vector3.to_elements(position)
	local soft_x, soft_y, soft_z = self._soft_cap_x, self._soft_cap_y, self._soft_cap_z

	if soft_x <= math.abs(x) or soft_y <= math.abs(y) or soft_z <= math.abs(z) then
		self:_on_soft_oob()
		Vector3.set_xyz(position, math.clamp(x, -soft_x, soft_x), math.clamp(y, -soft_y, soft_y), math.clamp(z, -soft_z, soft_z))
		Vector3.set_xyz(velocity, 0, 0, 0)
	end
end

PlayerUnitLocomotionExtension._update_movement = function (self, unit, dt, t, locomotion_component, steering_component, inair_component)
	local old_on_ground = inair_component.on_ground
	local position = locomotion_component.position
	local mover = Unit.mover(unit)

	self._old_position:store(position)

	local move_method = steering_component.move_method
	local calculate_fall_velocity = steering_component.calculate_fall_velocity

	if move_method == "script_driven" then
		local on_ground = inair_component.on_ground

		position = self:_update_script_driven_movement(unit, dt, t, locomotion_component, steering_component, position, calculate_fall_velocity, on_ground, mover)
	elseif move_method == "script_driven_hub" then
		position = self:_update_script_driven_hub_movement(unit, dt, t, locomotion_component, steering_component, position, calculate_fall_velocity, mover)
	else
		ferror("Unknown move_method %s", move_method)
	end

	self._latest_simulated_position:store(position)

	local flying_frames, standing_frames, max_frames = Mover.flying_frames(mover), Mover.standing_frames(mover), self._network_max_mover_frames

	inair_component.flying_frames = math.min(flying_frames, max_frames)
	inair_component.standing_frames = math.min(standing_frames, max_frames)

	if old_on_ground then
		local radius = 0.3
		local height = 0.5
		local size = Vector3(radius, height, radius)
		local rotation = Quaternion.look(-Vector3.up())
		local physics_world = self._physics_world
		local _, num_hits = PhysicsWorld.immediate_overlap(physics_world, "shape", "capsule", "position", position, "rotation", rotation, "size", size, "collision_filter", self._collision_filter)
		local new_on_ground

		if num_hits > 0 then
			local time_flying = flying_frames * dt

			if Mover.collides_down(mover) and time_flying > self._constants.time_before_slope_protection then
				new_on_ground = false
			else
				new_on_ground = true
			end
		else
			new_on_ground = flying_frames == 0 and steering_component.velocity_wanted.z <= 0
		end

		inair_component.on_ground = new_on_ground

		if not new_on_ground then
			inair_component.inair_entered_t = t
		end
	else
		inair_component.on_ground = flying_frames == 0 and steering_component.velocity_wanted.z <= 0
	end
end

local BROADPHASE_RESULTS = {}

PlayerUnitLocomotionExtension._do_minion_collision = function (self, unit, dt, dragged_velocity, current_position)
	local check_dragged_velocity = Vector3.length(dragged_velocity)
	local fall_speed = dragged_velocity.z
	local flat_move_velocity = Vector3.flat(dragged_velocity)
	local flat_move_speed = Vector3.length(flat_move_velocity)
	local force_stop = false

	if flat_move_speed > 0.001 then
		local flat_move_direction = flat_move_velocity / flat_move_speed
		local player_radius = 0.7
		local broadphase_system = Managers.state.extension:system("broadphase_system")
		local broadphase = broadphase_system.broadphase
		local side_system = Managers.state.extension:system("side_system")
		local side = side_system.side_by_unit[unit]
		local enemy_side_names = side:relation_side_names("enemy")
		local flat_player_pos = Vector3.flat(current_position)
		local query_radius = 1
		local query_position = current_position + flat_move_direction * 0.5
		local num_results = broadphase.query(broadphase, query_position, query_radius, BROADPHASE_RESULTS, enemy_side_names)

		for i = 1, num_results do
			local minion_unit = BROADPHASE_RESULTS[i]
			local breed = ScriptUnit.extension(minion_unit, "unit_data_system"):breed()
			local minion_radius = breed.player_locomotion_constrain_radius

			if HEALTH_ALIVE[minion_unit] and breed.player_locomotion_constrain_radius ~= nil then
				local minion_pos = Unit.world_position(minion_unit, 1)
				local flat_minion_pos = Vector3.flat(minion_pos)
				local minion_offset = flat_minion_pos - flat_player_pos
				local minion_direction = Vector3.normalize(minion_offset)
				local move_vector_towards_factor = Vector3.dot(flat_move_direction, minion_direction)
				local wanted_delta_towards = move_vector_towards_factor * flat_move_speed * dt
				local minion_distance = math.max(Vector3.length(minion_offset) - player_radius - minion_radius, 0)
				local debug_alpha = 200
				local debug_color
				local needs_break = false

				if minion_distance < wanted_delta_towards then
					local right_vector = Vector3.cross(minion_direction, Vector3.up())
					local move_into_contact_factor = minion_distance / wanted_delta_towards
					local move_right_factor = Vector3.dot(flat_move_direction, right_vector)
					local move_right_delta = move_right_factor * move_into_contact_factor * flat_move_speed * dt
					local too_close = minion_distance <= 0

					if math.abs(move_right_delta) < player_radius + minion_radius then
						debug_color = Color.light_green(debug_alpha)

						local angle = math.asin(move_vector_towards_factor)

						if angle < math.pi / 4 then
							debug_color = Color.white()

							if move_right_factor > 0 then
								dragged_velocity = right_vector * move_right_factor * flat_move_speed + Vector3(0, 0, fall_speed)
							else
								dragged_velocity = right_vector * move_right_factor * flat_move_speed + Vector3(0, 0, fall_speed)
							end
						elseif too_close then
							dragged_velocity = Vector3(0, 0, fall_speed)
							needs_break = true
							self._locomotion_steering_component.local_move_x = 0
							self._locomotion_steering_component.local_move_y = 0
							force_stop = true
						else
							local factor_to_contact = (wanted_delta_towards - minion_distance) / wanted_delta_towards

							dragged_velocity = flat_move_velocity * factor_to_contact
							dragged_velocity.z = fall_speed
							self._locomotion_steering_component.local_move_x = 0
							self._locomotion_steering_component.local_move_y = 0
							flat_move_velocity = Vector3.flat(dragged_velocity)
							flat_move_speed = Vector3.length(flat_move_velocity)
							flat_move_direction = flat_move_velocity / flat_move_speed
							force_stop = true

							local speed_difference = Vector3.length(dragged_velocity) - check_dragged_velocity
						end
					else
						debug_color = Color.yellow(debug_alpha)
					end
				else
					debug_color = Color.red(debug_alpha)
				end

				if needs_break then
					break
				end
			end
		end
	end

	local speed_difference = Vector3.length(dragged_velocity) - check_dragged_velocity

	return dragged_velocity, force_stop
end

local function _check_minion_collision_constrained_pos(minion_unit, minion_position, check_position, minion_radius, minion_min_dist_sq, flat_player_pos, velocity_flat_normalized)
	local minion_dist_to_line_sq = Vector3.distance_squared(minion_position, check_position)
	local constrained_target
	local min_dot, max_dot = -1, 1

	if minion_dist_to_line_sq < minion_min_dist_sq then
		constrained_target = minion_position + Vector3.normalize(check_position - minion_position) * minion_radius * 2

		local dot = Vector3.dot(velocity_flat_normalized, Vector3.normalize(constrained_target - flat_player_pos))

		min_dot = math.max(min_dot, dot)
		max_dot = math.min(max_dot, dot)
	end

	return constrained_target, min_dot, max_dot
end

PlayerUnitLocomotionExtension._update_script_driven_movement = function (self, unit, dt, t, locomotion_component, steering_component, current_position, calculate_fall_velocity, on_ground, mover)
	local velocity_current = locomotion_component.velocity_current
	local velocity_wanted = steering_component.velocity_wanted

	if calculate_fall_velocity then
		velocity_wanted.z = velocity_current.z
	end

	if locomotion_component.parent_unit ~= nil then
		Mover.set_position(mover, current_position)
	end

	velocity_wanted = self:_handle_push_velocity(velocity_wanted, on_ground, dt, t)

	local drag_koeff = self._use_drag and 0.00855 or 0
	local speed = Vector3.length(velocity_wanted)
	local drag_force = drag_koeff * speed * speed * Vector3.normalize(-velocity_wanted)
	local dragged_velocity = velocity_wanted + drag_force * dt

	if calculate_fall_velocity then
		local fall_speed = dragged_velocity.z - self._constants.gravity * dt

		dragged_velocity.z = fall_speed
	end

	local force_stop = false

	if self._script_minion_collision and not steering_component.disable_minion_collision then
		local box_minion_collision = false

		if box_minion_collision then
			dragged_velocity, force_stop = self:_do_minion_collision(unit, dt, dragged_velocity, current_position)
		else
			local dragged_velocity_magnitude = Vector3.length(dragged_velocity)
			local velocity_flat_normalized = Vector3.flat(dragged_velocity)
			local velocity_flat_length = Vector3.length(velocity_flat_normalized)

			if velocity_flat_length > 0.001 then
				velocity_flat_normalized = velocity_flat_normalized / velocity_flat_length

				local broadphase_system = Managers.state.extension:system("broadphase_system")
				local broadphase = broadphase_system.broadphase
				local side_system = Managers.state.extension:system("side_system")
				local side = side_system.side_by_unit[unit]
				local enemy_side_names = side:relation_side_names("enemy")
				local flat_player_pos = Vector3.flat(current_position)
				local constrained_target = Vector3(0, 0, 0)
				local min_dot, max_dot = -1, 1
				local query_radius = 0.75
				local query_position = current_position + velocity_flat_normalized * 0.5
				local num_constraints = 0
				local num_results = broadphase.query(broadphase, query_position, query_radius, BROADPHASE_RESULTS, enemy_side_names)

				for i = 1, num_results do
					local minion_unit = BROADPHASE_RESULTS[i]
					local breed = ScriptUnit.extension(minion_unit, "unit_data_system"):breed()
					local ignore_collision = false
					local should_ignore_collision_with_horde_minions = self:_should_ignore_collision_with_horde_minions(unit)

					if should_ignore_collision_with_horde_minions then
						local valid_breed = not breed or not breed.tags or not breed.tags.elite and not breed.tags.ogryn and not breed.tags.special and not breed.tags.monster

						ignore_collision = valid_breed
					end

					local collide_with_minions = HEALTH_ALIVE[minion_unit] and breed.player_locomotion_constrain_radius ~= nil

					collide_with_minions = collide_with_minions and not ignore_collision

					if collide_with_minions then
						local minion_radius = breed.player_locomotion_constrain_radius
						local minion_min_dist_sq = minion_radius * minion_radius * 2 * 2
						local minion_position = Vector3.flat(Unit.world_position(minion_unit, 1))
						local minion_point_on_line = flat_player_pos + velocity_flat_normalized * minion_radius
						local new_constrained_target, new_min_dot, new_max_dot = _check_minion_collision_constrained_pos(minion_unit, minion_position, minion_point_on_line, minion_radius, minion_min_dist_sq, flat_player_pos, velocity_flat_normalized)

						if new_constrained_target then
							num_constraints = num_constraints + 1

							if min_dot < new_min_dot then
								min_dot = new_min_dot
							end

							if new_max_dot < max_dot then
								max_dot = new_max_dot
							end

							constrained_target = constrained_target + new_constrained_target
						end
					end
				end

				if max_dot < min_dot or max_dot <= 0 then
					local fall_speed = dragged_velocity.z

					dragged_velocity = Vector3.zero()
					dragged_velocity.z = fall_speed
				elseif num_constraints > 0 then
					constrained_target = constrained_target / num_constraints

					local fall_speed = dragged_velocity.z

					dragged_velocity = constrained_target - flat_player_pos

					if Vector3.length(dragged_velocity) > 0.001 then
						dragged_velocity = Vector3.normalize(dragged_velocity) * dragged_velocity_magnitude * max_dot
					end

					dragged_velocity.z = fall_speed
				end
			end
		end
	end

	local delta = dragged_velocity * dt

	Mover.move(mover, delta, dt)

	local final_position = Mover.position(mover)
	local final_velocity = (final_position - current_position) / dt

	self:_decay_push_velocity(on_ground, dt, final_velocity)

	local mover_z_velocity = final_velocity.z
	local dragged_z_velocity = dragged_velocity.z
	local wanted_z_velocity = velocity_wanted.z

	if not (wanted_z_velocity > 0) then
		if mover_z_velocity > 0.01 then
			final_velocity.z = wanted_z_velocity
		end
	elseif mover_z_velocity > 0 and dragged_z_velocity >= 0 then
		final_velocity.z = math.min(mover_z_velocity, dragged_z_velocity)
	elseif mover_z_velocity < 0 and dragged_z_velocity <= 0 then
		final_velocity.z = math.max(mover_z_velocity, dragged_z_velocity)
	end

	self:_handle_oob(final_position, final_velocity)

	locomotion_component.position = final_position

	if force_stop then
		final_velocity.x = 0
		final_velocity.y = 0
	end

	locomotion_component.velocity_current = final_velocity

	local movement_state_component = self._movement_state_component

	if movement_state_component.is_crouching then
		movement_state_component.can_exit_crouch = Unit.mover_fits_at(unit, "default", final_position) ~= nil
	end

	return final_position
end

PlayerUnitLocomotionExtension._should_ignore_collision_with_horde_minions = function (self, unit)
	local buff_extension = self._buff_extension

	if not buff_extension then
		return false
	end

	local is_dodging, dodge_type = Dodge.is_dodging(unit)
	local is_dodging_not_sliding = is_dodging and dodge_type == dodge_types.dodge
	local disable_horde_minions_collision_during_dodge = buff_extension:has_keyword("disable_horde_minions_collision_during_dodge")

	if is_dodging_not_sliding and (self._ogryn_dodges or disable_horde_minions_collision_during_dodge) then
		local consecutive_dodges = Dodge.consecutive_dodges(unit)
		local first_dodge = consecutive_dodges == 1

		return first_dodge
	end

	local is_sprinting = Sprint.is_sprinting(self._sprint_character_state_component)
	local current_stamina, _ = Stamina.current_and_max_value(unit, self._stamina_component, self._base_stamina_template)
	local is_sprinting_with_stamina = is_sprinting and current_stamina > 0
	local has_disable_horde_minions_collision_during_sprint_keyword = buff_extension:has_keyword("disable_horde_minions_collision_during_sprint")

	if has_disable_horde_minions_collision_during_sprint_keyword and is_sprinting_with_stamina then
		return true
	end

	return false
end

PlayerUnitLocomotionExtension._update_script_driven_hub_movement = function (self, unit, dt, t, locomotion_component, steering_component, current_position, calculate_fall_velocity, mover)
	local velocity_wanted = steering_component.velocity_wanted
	local velocity_current = locomotion_component.velocity_current
	local hub_active_stopping = steering_component.hub_active_stopping
	local constants = self._constants
	local hub_jog_character_state_component = self._hub_jog_character_state_component
	local movement_settings = HubMovementLocomotion.fetch_movement_settings(unit, constants, hub_jog_character_state_component)
	local previous_move_state = hub_jog_character_state_component.previous_move_state
	local movement_settings_override = movement_settings.current_move_state.from_state_overrides[previous_move_state]

	if movement_settings_override then
		local duration = movement_settings_override.duration
		local move_state_start_t = hub_jog_character_state_component.move_state_start_t
		local time_in_state = t - move_state_start_t

		if duration < time_in_state then
			movement_settings_override = nil
		end
	end

	local position, velocity = HubMovementLocomotion.update_movement(mover, dt, velocity_current, velocity_wanted, current_position, calculate_fall_velocity, constants, movement_settings, movement_settings_override, hub_active_stopping)

	self:_handle_oob(position, velocity)

	locomotion_component.position = position
	locomotion_component.velocity_current = velocity

	return position
end

PlayerUnitLocomotionExtension._handle_push_velocity = function (self, velocity_wanted, on_ground, dt, t)
	self:_update_new_push_velocity(t)

	velocity_wanted = self:_apply_push_velocity(velocity_wanted, dt)

	return velocity_wanted
end

PlayerUnitLocomotionExtension._update_new_push_velocity = function (self, t)
	local locomotion_push = self._locomotion_push_component
	local new_velocity = locomotion_push.new_velocity

	if Vector3.length_squared(new_velocity) > 0 and t >= locomotion_push.time_to_apply then
		local current_velocity = locomotion_push.velocity

		locomotion_push.velocity = current_velocity + new_velocity
		locomotion_push.new_velocity = Vector3.zero()
	end
end

PlayerUnitLocomotionExtension._apply_push_velocity = function (self, velocity_wanted, dt)
	local locomotion_push = self._locomotion_push_component
	local push_velocity = locomotion_push.velocity
	local new_velocity

	if Vector3.length_squared(push_velocity) == 0 then
		new_velocity = velocity_wanted
	else
		local push_direction = Vector3.normalize(push_velocity)
		local push_length = Vector3.length(push_velocity)
		local velocity_to_push_comparison = Vector3.dot(push_direction, velocity_wanted)

		if push_length < velocity_to_push_comparison then
			new_velocity = velocity_wanted
		elseif velocity_to_push_comparison > 0 then
			new_velocity = velocity_wanted - push_direction * velocity_to_push_comparison + push_velocity
		else
			push_velocity = push_velocity + push_direction * velocity_to_push_comparison * dt

			local wanted_component = velocity_wanted - push_direction * velocity_to_push_comparison

			new_velocity = wanted_component + push_velocity
		end
	end

	return new_velocity
end

local SQUARED_PUSH_VELOCITY_EPSILON = 0.0001

PlayerUnitLocomotionExtension._decay_push_velocity = function (self, on_ground, dt, final_velocity)
	local locomotion_push = self._locomotion_push_component
	local push_velocity = locomotion_push.velocity

	if Vector3.length_squared(push_velocity) == 0 then
		return
	end

	if PlayerUnitStatus.is_disabled(self._character_state_component) then
		locomotion_push.velocity = Vector3.zero()

		return
	end

	local push_speed = Vector3.length(push_velocity)
	local push_dir = Vector3.normalize(push_velocity)
	local friction_speed = self._constants.push_friction_function(push_speed, on_ground)
	local friction = -push_dir * math.min(friction_speed * dt, push_speed)
	local new_push_velocity = push_velocity + friction

	if not on_ground then
		local final_velocity_dir = Vector3.normalize(final_velocity)
		local push_scale = math.max(Vector3.dot(push_dir, final_velocity_dir), 0)^2

		new_push_velocity = new_push_velocity * push_scale
	end

	if Vector3.length_squared(new_push_velocity) < SQUARED_PUSH_VELOCITY_EPSILON then
		new_push_velocity = Vector3.zero()
	end

	locomotion_push.velocity = new_push_velocity
end

PlayerUnitLocomotionExtension.visual_link = function (self, parent_unit, parent_node_name, node_name)
	self._player_unit_linker:link(parent_unit, parent_node_name, node_name)

	if self._is_server then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local owner_player = player_unit_spawn_manager:owner(self._unit)
		local game_object_id = self._game_object_id
		local parent_node = Unit.node(parent_unit, parent_node_name)
		local node = Unit.node(self._unit, node_name)
		local _, parent_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(parent_unit)

		Managers.state.game_session:send_rpc_clients_except("rpc_set_player_link", owner_player:channel_id(), game_object_id, node, parent_unit_id, parent_node)
	end
end

PlayerUnitLocomotionExtension.visual_unlink = function (self)
	self._player_unit_linker:unlink()

	if self._is_server then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local owner_player = player_unit_spawn_manager:owner(self._unit)
		local game_object_id = self._game_object_id

		Managers.state.game_session:send_rpc_clients_except("rpc_player_unlink", owner_player:channel_id(), game_object_id)
	end
end

PlayerUnitLocomotionExtension.hot_join_sync = function (self, unit, sender, _)
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local linker_component = unit_data_extension:read_component("player_unit_linker")
	local linked = linker_component.linked

	if linked then
		local channel = Managers.state.game_session:peer_to_channel(sender)
		local game_object_id = self._game_object_id
		local parent_unit = linker_component.parent_unit
		local _, parent_unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(parent_unit)
		local parent_node_name = linker_component.parent_node
		local parent_node = Unit.node(parent_unit, parent_node_name)
		local node_name = linker_component.node
		local node = Unit.node(unit, node_name)

		RPC.rpc_set_player_link(channel, game_object_id, node, parent_unit_id, parent_node)
	end
end

PlayerUnitLocomotionExtension.fixed_update = function (self, unit, dt, t, frame)
	local locomotion_component = self._locomotion_component
	local steering_component = self._locomotion_steering_component

	if steering_component.move_method == "script_driven_hub" then
		self._movement_direction_animation_control:update(dt, t)
	end

	local inair_component = self._inair_state_component
	local force_rotation_component = self._locomotion_force_rotation_component

	self:_update_movement(unit, dt, t, locomotion_component, steering_component, inair_component)
	self:_update_rotation(unit, dt, t, locomotion_component, steering_component, force_rotation_component)

	self._last_fixed_t = t
end

PlayerUnitLocomotionExtension._update_rotation = function (self, unit, dt, t, locomotion_component, steering_component, force_rotation_component)
	local look_rotation = self._first_person_component.rotation
	local current_rotation = locomotion_component.rotation
	local new_rotation, new_target_rotation = self:_calculate_rotation(unit, dt, t, locomotion_component, steering_component, force_rotation_component, look_rotation, steering_component.velocity_wanted, locomotion_component.velocity_current, current_rotation, steering_component.target_rotation)

	steering_component.target_rotation = new_target_rotation
	locomotion_component.rotation = new_rotation
end

PlayerUnitLocomotionExtension.update = function (self, unit, dt, t)
	local locomotion_component = self._locomotion_component
	local anim_extension = self._animation_extension
	local remainder_t = t - self._last_fixed_t
	local var = anim_extension:anim_variable_id(self._move_speed_anim_var)
	local old_speed = Unit.animation_get_variable(unit, var)
	local new_speed = Vector3.length(locomotion_component.velocity_current)

	if self._is_local_unit then
		Profiler.record_statistics("move_x", self._locomotion_steering_component.local_move_x)
		Profiler.record_statistics("move_y", self._locomotion_steering_component.local_move_y)
	end

	local anim_move_speed = math.lerp(old_speed, new_speed, dt * 10)
	local clamped_anim_move_speed = math.clamp(anim_move_speed, 0, 19.9)

	Unit.animation_set_variable(unit, var, clamped_anim_move_speed)

	local ladder_character_state_component = self._ladder_character_state_component
	local ladder_unit_id = ladder_character_state_component.ladder_unit_id

	if ladder_unit_id ~= NetworkConstants.invalid_level_unit_id then
		local climb_time_anim_var = anim_extension:anim_variable_id(self._climb_time_anim_var)
		local is_level_unit = true
		local ladder_unit = Managers.state.unit_spawner:unit(ladder_unit_id, is_level_unit)
		local new_time_in_ladder_animation = Ladder.time_in_ladder_anim(unit, ladder_unit, self._breed)

		Unit.animation_set_variable(unit, climb_time_anim_var, new_time_in_ladder_animation)
	end

	local look_rotation = self._first_person_extension:extrapolated_rotation()
	local current_velocity = self._locomotion_steering_component.velocity_wanted
	local target_rotation = self._locomotion_steering_component.target_rotation
	local current_rotation = locomotion_component.rotation
	local extrapolated_rot = self:_calculate_rotation(unit, remainder_t, t, locomotion_component, self._locomotion_steering_component, self._locomotion_force_rotation_component, look_rotation, current_velocity, locomotion_component.velocity_current, current_rotation, target_rotation)

	Unit.set_local_rotation(unit, 1, extrapolated_rot)

	local locomotion_steering_component = self._locomotion_steering_component

	if locomotion_steering_component.move_method == "script_driven_hub" then
		local current_active_stop = locomotion_steering_component.hub_active_stopping and 1 or 0
		local active_stop_anim_var_id = Unit.animation_find_variable(unit, self._active_stop_anim_var)
		local old_anim_var_id = Unit.animation_get_variable(unit, active_stop_anim_var_id)
		local active_stop = math.clamp(math.lerp(old_anim_var_id, current_active_stop, dt * 5), 0, 1)

		Unit.animation_set_variable(unit, active_stop_anim_var_id, active_stop)
	end
end

PlayerUnitLocomotionExtension.post_update = function (self, unit, dt, t)
	local locomotion_component = self._locomotion_component
	local locomotion_steering_component = self._locomotion_steering_component
	local force_translation_component = self._locomotion_force_translation_component
	local abs_pos = self._latest_simulated_position:unbox()
	local remainder_t = t - self._last_fixed_t
	local simulated_pos

	if force_translation_component.use_force_translation then
		simulated_pos = ForceTranslation.get_translation(force_translation_component, locomotion_steering_component, t)
	else
		local mode = PLAYER_RENDER_FRAME_POSITIONS.interpolate

		if mode == "extrapolate" then
			local extrapolation = locomotion_component.velocity_current * remainder_t

			simulated_pos = abs_pos + extrapolation
		elseif mode == "interpolate" then
			local old_pos = self._old_position:unbox()
			local t_value = remainder_t / self._fixed_time_step

			simulated_pos = Vector3.lerp(old_pos, abs_pos, math.min(t_value, 1))
		elseif mode == "raw" then
			simulated_pos = abs_pos
		else
			ferror("Invalid DevParameters.player_render_frame_position %q.", mode)
		end
	end

	local parent_unit = locomotion_component.parent_unit
	local moveable_platform_extension = parent_unit and ScriptUnit.has_extension(parent_unit, "moveable_platform_system")

	if moveable_platform_extension then
		simulated_pos = simulated_pos + moveable_platform_extension:movement_since_last_fixed_update()
	end

	Unit.set_local_position(unit, 1, simulated_pos)
	World.update_unit_and_children(self._world, unit)
	self._first_person_extension:update_unit_position(unit, dt, t)
	self._visual_loadout_extension:update_unit_position(unit, dt, t)

	if self._is_local_unit then
		-- Nothing
	end

	if self._is_server then
		local game_object_id = self._game_object_id
		local game_session = self._game_session
		local movement_speed = Vector3.length(locomotion_component.velocity_current)

		GameSession.set_game_object_field(game_session, game_object_id, "move_speed", math.clamp(movement_speed, 0, 20))

		local sync_pos, sync_rot
		local abs_rot = locomotion_component.rotation

		if parent_unit then
			sync_rot, sync_pos = PlayerMovement.calculate_relative_rotation_position(parent_unit, abs_rot, abs_pos)
		else
			sync_rot = abs_rot
			sync_pos = abs_pos
		end

		GameSession.set_game_object_field(game_session, game_object_id, "position", sync_pos)

		local y, p, r = Quaternion.to_yaw_pitch_roll(sync_rot)

		GameSession.set_game_object_field(game_session, game_object_id, "yaw", y)
		GameSession.set_game_object_field(game_session, game_object_id, "pitch", p)
		GameSession.set_game_object_field(game_session, game_object_id, "roll", r)
	end
end

local HUB_MOVEMENT_ROTATION_EPS = 0.3
local HUB_MOVEMENT_ROTATION_EPS_SQ = HUB_MOVEMENT_ROTATION_EPS * HUB_MOVEMENT_ROTATION_EPS

PlayerUnitLocomotionExtension._calculate_rotation = function (self, unit, dt, t, data, steering_component, force_rotation_component, look_rotation, velocity_wanted, velocity_current, current_rotation, current_target_rotation)
	local final_rotation
	local current_unnormalized_direction_flat = Vector3_flat(Quaternion_forward(look_rotation))
	local flat_look_rotation = Quaternion_look(current_unnormalized_direction_flat)
	local target_rotation = steering_component.target_rotation

	if force_rotation_component.use_force_rotation then
		final_rotation = ForceRotation.get_rotation(force_rotation_component, steering_component, t)
	elseif steering_component.disable_velocity_rotation then
		final_rotation = flat_look_rotation
		target_rotation = final_rotation
	elseif steering_component.rotation_based_on_wanted_velocity then
		local flat_current_velocity = Vector3_flat(velocity_wanted)

		if Vector3.length_squared(flat_current_velocity) == 0 then
			local current_flat_direction = Vector3_normalize(current_unnormalized_direction_flat)
			local target_direction_flat = Vector3_normalize(Vector3_flat(Quaternion_forward(target_rotation)))
			local dot = Vector3_dot(current_flat_direction, target_direction_flat)

			if dot < 0 then
				target_rotation = flat_look_rotation
			end

			final_rotation = PlayerMovement.calculate_final_unit_rotation(current_rotation, target_rotation, target_rotation, dt * 5)
		else
			target_rotation = flat_look_rotation

			local velocity_dot = Vector3_dot(flat_current_velocity, current_unnormalized_direction_flat)

			if velocity_dot < -0.01 then
				flat_current_velocity = -flat_current_velocity
			end

			final_rotation = PlayerMovement.calculate_final_unit_rotation(current_rotation, Quaternion_look(flat_current_velocity), target_rotation, dt * 5)
		end
	else
		local movement_settings = HubMovementLocomotion.fetch_movement_settings(unit, self._constants, self._hub_jog_character_state_component)
		local movement_settings_move_state = movement_settings.current_move_state
		local flat_current_velocity = Vector3_flat(velocity_current)
		local speed_sq = Vector3.length_squared(flat_current_velocity)

		if speed_sq < HUB_MOVEMENT_ROTATION_EPS_SQ then
			local turn_in_place_rot_speed_multiplier = movement_settings.shared.turn_in_place_rot_speed_multiplier

			final_rotation = math.quat_rotate_towards(current_rotation, current_target_rotation, movement_settings_move_state.rotation_speed_rad * dt * turn_in_place_rot_speed_multiplier)
		else
			target_rotation = Quaternion.normalize(Quaternion_look(flat_current_velocity))

			local shared_movement_settings = movement_settings.shared
			local animation_rotation_correction_weight = shared_movement_settings.animation_rotation_correction_weight
			local rotation_correction = 0

			if animation_rotation_correction_weight > 0 then
				local angle_to_target = math.abs(math.quat_angle(current_target_rotation, target_rotation))

				if angle_to_target < shared_movement_settings.animation_rotation_correction_threshold then
					rotation_correction = angle_to_target * animation_rotation_correction_weight
				end
			end

			final_rotation = math.quat_rotate_towards(current_rotation, target_rotation, movement_settings_move_state.rotation_speed_rad * dt + rotation_correction)
		end
	end

	return final_rotation, target_rotation
end

PlayerUnitLocomotionExtension.get_parent_unit = function (self)
	return self._locomotion_component.parent_unit
end

PlayerUnitLocomotionExtension.set_parent_unit = function (self, unit)
	local locomotion_component = self._locomotion_component
	local unit_id = NetworkConstants.invalid_level_unit_id
	local is_level_unit

	if unit then
		is_level_unit, unit_id = Managers.state.unit_spawner:game_object_id_or_level_index(unit)
	end

	if unit_id == NetworkConstants.invalid_level_unit_id then
		locomotion_component.parent_unit = nil
	else
		locomotion_component.parent_unit = unit
	end

	if self._is_server then
		local game_object_id = self._game_object_id
		local game_session = self._game_session
		local position = locomotion_component.position
		local rotation = locomotion_component.rotation

		if unit then
			rotation, position = PlayerMovement.calculate_relative_rotation_position(unit, rotation, position)
		end

		GameSession.set_game_object_field(game_session, game_object_id, "position", position)

		local y, p, r = Quaternion.to_yaw_pitch_roll(rotation)

		GameSession.set_game_object_field(game_session, game_object_id, "yaw", y)
		GameSession.set_game_object_field(game_session, game_object_id, "pitch", p)
		GameSession.set_game_object_field(game_session, game_object_id, "roll", r)

		if is_level_unit then
			GameSession.set_game_object_field(game_session, game_object_id, "parent_unit_id", unit_id + 65535)
		else
			GameSession.set_game_object_field(game_session, game_object_id, "parent_unit_id", unit_id)
		end
	end
end

PlayerUnitLocomotionExtension.extensions_ready = function (self, world, unit)
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")

	local component_system = Managers.state.extension:system("component_system")
	local components = component_system:get_components(unit, "FootIk")

	self._foot_ik_script_component = components[1]

	if not self._is_server then
		local init_context = {
			is_husk = false,
			player_character_constants = self._constants,
			is_local_unit = self._is_local_unit,
			is_server = self._is_server,
		}

		self._movement_direction_animation_control = ThirdPersonHubMovementDirectionAnimationControl:new(unit, init_context)
	end
end

PlayerUnitLocomotionExtension.server_correction_occurred = function (self, unit, from_frame)
	self._last_fixed_t = from_frame * self._fixed_time_step

	local mover = Unit.mover(unit)
	local position = self._locomotion_component.position
	local inair_state_component = self._inair_state_component
	local flying_frames, standing_frames = inair_state_component.flying_frames, inair_state_component.standing_frames

	Mover.set_state(mover, position, flying_frames, standing_frames)
	self._player_unit_linker:mispredict_happened()
end

PlayerUnitLocomotionExtension.set_mover_disable_reason = function (self, reason, state)
	error("set_mover_disable_reason() can't be used for player locomotion!")
end

PlayerUnitLocomotionExtension.set_active_mover = function (self, active_mover)
	MoverController.set_active_mover(self._unit, self._mover_state, active_mover)
end

PlayerUnitLocomotionExtension.move_speed = function (self)
	local velocity_current = self._locomotion_component.velocity_current

	return Vector3.length(Vector3.flat(velocity_current))
end

PlayerUnitLocomotionExtension.move_speed_squared = function (self)
	local velocity_current = self._locomotion_component.velocity_current

	return Vector3.length_squared(Vector3.flat(velocity_current))
end

PlayerUnitLocomotionExtension.mover_radius = function (self)
	local mover = Unit.mover(self._unit)

	return Mover.radius(mover)
end

PlayerUnitLocomotionExtension.current_velocity = function (self)
	local data_extension = ScriptUnit.extension(self._unit, "unit_data_system")
	local loc_component = data_extension:read_component("locomotion")

	return loc_component.velocity_current
end

PlayerUnitLocomotionExtension._on_soft_oob = function (self)
	self._locomotion_component.velocity_current = Vector3.zero()

	PlayerDeath.die(self._unit, 0, nil, "oob")
end

return PlayerUnitLocomotionExtension
