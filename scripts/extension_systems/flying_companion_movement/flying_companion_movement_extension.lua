-- chunkname: @scripts/extension_systems/flying_companion_movement/flying_companion_movement_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionFlyingMovement = require("scripts/utilities/companion/companion_flying_movement")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local Missions = require("scripts/settings/mission/mission_templates")
local PortableRandom = require("scripts/foundation/utilities/portable_random")
local FlyingCompanionMovementExtension = class("FlyingCompanionMovementExtension")
local servo_skull_states = CompanionServoSkullSettings.STATES
local servo_skull_flamethrower_types = CompanionServoSkullSettings.FLAMETHROWER_TYPES
local servo_skull_movement_state = CompanionServoSkullSettings.MOVEMENT_STATE
local companion_servo_skull_movement_settings = CompanionServoSkullSettings.movement_settings
local companion_servo_skull_hub_movement_settings = CompanionServoSkullSettings.hub_movement_settings
local distance_thresholds_sq = CompanionServoSkullSettings.distance_threshold_sq

FlyingCompanionMovementExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	self._physics_world = extension_init_context.physics_world
	self._world = extension_init_context.world
	self._unit = unit

	local companion_special_rule_id = game_object_data.companion_variant_special_rule_id

	self._companion_special_rule = NetworkLookup.companion_variant_special_rules[companion_special_rule_id]
	self._companion_number = extension_init_data.companion_number
	self._is_server = extension_init_context.is_server

	if self._is_server then
		local blackboard = BLACKBOARDS[unit]

		self:_init_blackboard_components(blackboard)

		self._blackboard = blackboard
	end

	local breed = extension_init_data.breed

	self._breed = breed

	local seed = extension_init_data.random_seed

	self._random_seed = seed

	local portable_random = PortableRandom:new(seed)

	self._random_number = portable_random:next_random()
	game_object_data.state = servo_skull_states.following
	game_object_data.flamethrower_type = servo_skull_flamethrower_types.circle
	self._randomize_movement_xy_cone_flame = CompanionServoSkullSettings.z_randomize_movement_cone_flamethrower_xy
	self._randomize_movement_z_cone_flame = CompanionServoSkullSettings.z_randomize_movement_cone_flamethrower_z
	self._aim_config = breed.aim_config
	self._old_position = Vector3Box(Vector3.zero())
	self._velocity = Vector3Box(Vector3.zero())
	self._acceleration = Vector3Box(Vector3.zero())
	self._current_movement_type = servo_skull_movement_state.rest
	self._previous_movement_type = servo_skull_movement_state.out_of_combat
	self._current_pitch = 0

	local mission_name = Managers.state.mission:mission_name()
	local mission_settings = Missions[mission_name]

	self._is_hub = mission_settings.is_hub or Managers.state.game_mode:is_social_hub() or Managers.state.game_mode:is_prologue_hub()
end

FlyingCompanionMovementExtension._init_blackboard_components = function (self, blackboard)
	local behavior_component = Blackboard.write_component(blackboard, "behavior")

	behavior_component.move_state = "idle"

	behavior_component.move_to_position:store(0, 0, 0)

	behavior_component.has_move_to_position = false

	behavior_component.target_rotation:store(Quaternion.identity())

	behavior_component.has_target_rotation = false
	behavior_component.current_state = "moving"
	behavior_component.max_speed = 10
	behavior_component.can_shoot = true
end

FlyingCompanionMovementExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
	self._game_object_initialized = true

	if self._allow_fx_template then
		self:_start_fx_template()
	end
end

FlyingCompanionMovementExtension.extensions_ready = function (self, world, unit)
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	self._buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	self._locomotion_extension = locomotion_extension

	local owner = Managers.state.player_unit_spawn:owner(unit)
	local owner_unit = owner and owner.player_unit

	self._owner_unit = owner_unit
	self._is_local_unit = owner and not owner.remote

	local owner_unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._character_state_component = owner_unit_data_extension:read_component("character_state")
	self._sprint_character_state_component = owner_unit_data_extension:read_component("sprint_character_state")
	self._owner_first_person_component = owner_unit_data_extension:read_component("first_person")
	self._owner_unit_data_extension = owner_unit_data_extension

	local owner_locomotion_extension = ScriptUnit.extension(owner_unit, "locomotion_system")

	self._owner_locomotion_extension = owner_locomotion_extension

	local owner_attack_intensity_extension = ScriptUnit.has_extension(owner_unit, "attack_intensity_system")

	self._owner_attack_intensity_extension = owner_attack_intensity_extension

	local first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")

	self._first_person_extension = first_person_extension

	local animation_extension = ScriptUnit.extension(unit, "animation_system")

	self._animation_extension = animation_extension

	local special_rule_companion_servo_skull_movement_settings = self._is_hub and companion_servo_skull_hub_movement_settings[self._companion_special_rule] or companion_servo_skull_movement_settings[self._companion_special_rule]

	self._first_person_movement_settings = special_rule_companion_servo_skull_movement_settings.first_person
	self._third_person_movement_settings = special_rule_companion_servo_skull_movement_settings.third_person
	self._companion_position_offset = Vector3Box(self._third_person_movement_settings.position.out_of_combat)

	locomotion_extension:set_anim_driven(false)
	locomotion_extension:set_anim_rotation_scale(1)
	locomotion_extension:set_affected_by_gravity(false)
	locomotion_extension:set_movement_type("script_driven")
	locomotion_extension:use_lerp_rotation(true)
	locomotion_extension:set_wanted_velocity(Vector3.zero())
	locomotion_extension:set_wanted_rotation(Quaternion.identity())
	locomotion_extension:set_rotation_speed(0)

	self._last_target_unit_position = Vector3Box(Vector3.zero())
	self._last_target_forward = Vector3Box(Vector3.zero())
end

FlyingCompanionMovementExtension.destroy = function (self, unit)
	return
end

FlyingCompanionMovementExtension.post_update = function (self, unit, dt, t)
	if not ALIVE[unit] then
		return
	end

	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

	if not game_object_exists then
		return
	end

	local vertical_fov = Application.user_setting("render_settings", "vertical_fov") or GameParameters.vertical_fov

	self._fov_multiplier = vertical_fov / GameParameters.vertical_fov

	local is_in_first_person = self._first_person_extension:is_in_first_person_mode()
	local movement_settings = is_in_first_person and self._first_person_movement_settings or self._third_person_movement_settings
	local locomotion_extension = self._locomotion_extension
	local behavior_component = self._blackboard.behavior
	local first_person_extension = self._first_person_extension
	local first_person_unit = first_person_extension:first_person_unit()
	local owner_rotation = self._is_hub and Unit.local_rotation(self._owner_unit, 1) or first_person_extension:extrapolated_rotation()
	local first_person_position = Unit.world_position(first_person_unit, 1)
	local current_position = Unit.world_position(unit, 1)
	local target_position
	local has_move_to_position = behavior_component.has_move_to_position

	if has_move_to_position then
		local has_target_rotation = behavior_component.has_target_rotation

		if has_target_rotation then
			locomotion_extension:set_wanted_rotation(behavior_component.target_rotation:unbox())
		end

		self._initial_t_movement_offset = nil
		target_position = behavior_component.move_to_position:unbox()

		local state = GameSession.game_object_field(self._game_session, self._game_object_id, "state")
		local distance_to_target_sq = Vector3.distance_squared(current_position, target_position)
		local distance_threshold_sq = distance_thresholds_sq[servo_skull_states[state]] or 0.01
		local reached_destination = distance_to_target_sq <= distance_threshold_sq

		if reached_destination or self._position_already_reached then
			self._position_already_reached = true

			return
		end

		locomotion_extension:set_wanted_velocity(Vector3.normalize(target_position - current_position) * behavior_component.max_speed)

		return
	else
		local last_movement_type = self._current_movement_type
		local new_movement_type = self:_update_movement_state(self._owner_attack_intensity_extension, self._owner_locomotion_extension, t)

		if new_movement_type ~= last_movement_type then
			self._previous_movement_type = last_movement_type

			local anim_name = "to_" .. new_movement_type
			local animation_extension = self._animation_extension

			animation_extension:anim_event(anim_name)
		end

		self._current_movement_type = new_movement_type

		local owner_right_flat = Vector3.normalize(Vector3.flat(Quaternion.right(owner_rotation)))
		local owner_forward_flat = Vector3.normalize(Vector3.flat(Quaternion.forward(owner_rotation)))
		local target_companion_offset = movement_settings.position[self._current_movement_type]

		target_companion_offset = Vector3.multiply_elements(target_companion_offset, Vector3(self._fov_multiplier, 1, 1))

		local lerp_multiplier = movement_settings.position_lerp_multiplier[self._current_movement_type][self._previous_movement_type]
		local new_companion_position_offset = CompanionFlyingMovement.visual_smooth_position(unit, target_companion_offset, dt, lerp_multiplier, self._companion_position_offset:unbox())

		self._companion_position_offset = Vector3Box(new_companion_position_offset)
		target_position = first_person_position - owner_right_flat * new_companion_position_offset.x + owner_forward_flat * new_companion_position_offset.y
		target_position.z = target_position.z + new_companion_position_offset.z
		self._reached_position = nil
		self._initial_t_flame_offset = nil
		self._position_already_reached = false
	end

	local state = GameSession.game_object_field(self._game_session, self._game_object_id, "state")

	if state ~= servo_skull_states.following and state ~= servo_skull_states.following_shooting and state ~= servo_skull_states.following_shooting_ability then
		return
	end

	local blackboard = self._blackboard
	local behavior = blackboard.behavior
	local perception_component = blackboard.perception
	local whistle_component = blackboard.whistle
	local target_unit = perception_component.target_unit
	local aim_config = self._aim_config
	local unit_node_index = Unit.node(unit, aim_config.node) or 1
	local unit_node_position = Unit.world_position(unit, unit_node_index)

	if not behavior.can_shoot or not HEALTH_ALIVE[target_unit] then
		local target_forward = Vector3.normalize(Vector3.flat(Quaternion.forward(owner_rotation)))
		local world_rotation = Unit.world_rotation(unit, 1)
		local target_unit_position = first_person_position + target_forward

		if not self._left_combat_t then
			unit_node_position = Vector3.flat(unit_node_position)
			target_unit_position = Vector3.flat(target_unit_position)
		else
			unit_node_position = Vector3.flat(unit_node_position)
			target_unit_position = Vector3.flat(self._last_target_unit_position:unbox())
			target_forward = self._last_target_forward:unbox()
		end

		self._new_rotation, self._current_pitch = CompanionFlyingMovement.visual_smooth_rotation(unit, target_forward, dt, world_rotation, movement_settings, self._current_movement_type, target_unit_position, unit_node_position, self._current_pitch)

		if not self._left_combat_t then
			self._apply_side_tilt = true
		else
			self._apply_side_tilt = false
			self.current_roll = 0

			Unit.set_local_rotation(unit, 1, self._new_rotation)
		end

		if not behavior.can_shoot or not HEALTH_ALIVE[target_unit] and not whistle_component.current_target then
			GameSession.set_game_object_field(game_session, game_object_id, "state", servo_skull_states.following)
		end
	elseif behavior.can_shoot then
		local target_node = aim_config.target_node
		local node_index = target_node and Unit.node(target_unit, target_node) or 1
		local target_unit_position = Unit.world_position(target_unit, node_index)
		local target_forward = Vector3.normalize(Vector3.flat(target_unit_position - unit_node_position))
		local world_rotation = Unit.world_rotation(unit, 1)

		self._last_target_unit_position:store(target_unit_position)
		self._last_target_forward:store(target_forward)

		local new_rotation, current_pitch = CompanionFlyingMovement.visual_smooth_rotation(unit, target_forward, dt, world_rotation, movement_settings, self._current_movement_type, target_unit_position, unit_node_position, self._current_pitch)

		self._current_pitch = current_pitch
		self._old_target_unit = target_unit
		self._new_rotation = new_rotation
		self._apply_side_tilt = false
		self.current_roll = 0

		Unit.set_local_rotation(unit, 1, new_rotation)

		if state ~= servo_skull_states.following_shooting_ability then
			GameSession.set_game_object_field(game_session, game_object_id, "state", servo_skull_states.following_shooting)
		end
	end

	local visual_offset = self:_visual_offset(unit, owner_rotation, first_person_position, dt, movement_settings)
	local final_position = Vector3(visual_offset.x, visual_offset.y, target_position.z)
	local new_velocity = (final_position - self._old_position:unbox()) / dt

	self._velocity = Vector3Box(new_velocity)
	self._old_position = Vector3Box(final_position)

	CompanionFlyingMovement:set_up_animation_variables(self._animation_extension, new_velocity)

	if not self._initial_t_movement_offset then
		self._initial_t_movement_offset = t
	end

	Unit.set_local_position(unit, 1, final_position)
	World.update_unit_and_children(self._world, unit)
end

FlyingCompanionMovementExtension.allow_fx_template = function (self, value)
	self._allow_fx_template = value

	if self._game_object_initialized then
		self:_start_fx_template()
	end
end

FlyingCompanionMovementExtension._start_fx_template = function (self)
	local moving_template_name = CompanionServoSkullSettings.moving_template_name

	if moving_template_name then
		local effect_template = EffectTemplates[moving_template_name]
		local fx_system = Managers.state.extension:system("fx_system")
		local global_effect_id = fx_system:start_template_effect(effect_template, self._unit)

		self.global_effect_id = global_effect_id
	end
end

FlyingCompanionMovementExtension.current_velocity = function (self)
	return self._velocity
end

FlyingCompanionMovementExtension.angle_between_velocity_and_player_forward = function (self)
	local first_person_extension = self._first_person_extension
	local owner_rotation = first_person_extension:extrapolated_rotation()
	local flat_velocity = Vector3.normalize(Vector3.flat(self._velocity:unbox()))
	local player_forward_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(owner_rotation)))
	local angle

	angle = Vector3.equal(flat_velocity, Vector3.zero()) and 0 or math.radians_to_degrees(Vector3.angle(player_forward_direction, flat_velocity))

	return angle
end

FlyingCompanionMovementExtension._visual_offset = function (self, unit, owner_rotation, first_person_position, dt, movement_settings)
	local forward = Vector3.normalize(Vector3.flat(Quaternion.forward(owner_rotation)))
	local smoothed_forward = self.smoothed_forward and self.smoothed_forward:unbox() or forward
	local old_forward = smoothed_forward
	local responsiveness = movement_settings.side_responsiveness[self._current_movement_type]
	local alpha = 1 - math.exp(-responsiveness * dt)

	smoothed_forward = Vector3.normalize(smoothed_forward + (forward - smoothed_forward) * alpha)
	self.smoothed_forward = Vector3Box(smoothed_forward)

	local smoothed_right = -Vector3.normalize(Vector3.cross(Vector3.up(), smoothed_forward))
	local companion_offset = self._companion_position_offset:unbox()
	local new_target_position = first_person_position - smoothed_right * companion_offset.x + smoothed_forward * companion_offset.y

	if self._apply_side_tilt then
		self:_visual_rotation_tilt(unit, old_forward, smoothed_forward, dt, movement_settings)
	end

	return new_target_position
end

FlyingCompanionMovementExtension._visual_rotation_tilt = function (self, unit, old_forward, smoothed_forward, dt, movement_settings)
	local visual_tilt_params = movement_settings.tilt
	local turn_amount = Vector3.cross(old_forward, smoothed_forward).z
	local max_roll = visual_tilt_params.max_roll
	local roll_sensitivity = visual_tilt_params.roll_sensitivity
	local roll_target = math.clamp(turn_amount * roll_sensitivity, -max_roll, max_roll)
	local current_roll = self.current_roll or 0
	local responsiveness = visual_tilt_params.responsiveness
	local alpha = 1 - math.exp(-responsiveness * dt)

	current_roll = current_roll + (roll_target - current_roll) * alpha
	self.current_roll = current_roll

	local current_rotation = self._new_rotation
	local roll_rotation = Quaternion.axis_angle(-Quaternion.forward(current_rotation), current_roll)
	local final_rotation = Quaternion.multiply(roll_rotation, current_rotation)

	Unit.set_local_rotation(unit, 1, final_rotation)
end

FlyingCompanionMovementExtension._update_movement_state = function (self, owner_attack_intensity_extension, owner_locomotion_extension, t)
	local game_session = self._game_session
	local game_object_id = self._game_object_id
	local game_object_exists = GameSession.game_object_exists(game_session, game_object_id)

	if not game_object_exists then
		return servo_skull_movement_state.out_of_combat
	end

	local last_movement_type = self._current_movement_type
	local blackboard = self._blackboard
	local perception_component = blackboard and blackboard.perception
	local target_unit = perception_component and perception_component.target_unit

	if HEALTH_ALIVE[target_unit] then
		self._left_combat_t = nil

		GameSession.set_game_object_field(self._game_session, self._game_object_id, "in_combat", true)

		return servo_skull_movement_state.in_combat
	end

	if not self._left_combat_t and last_movement_type == servo_skull_movement_state.in_combat then
		self._left_combat_t = t + CompanionServoSkullSettings.in_combat_timeout

		return servo_skull_movement_state.in_combat
	end

	local left_combat_t = self._left_combat_t

	if left_combat_t then
		if t < left_combat_t then
			return servo_skull_movement_state.in_combat
		end

		self._left_combat_t = nil

		GameSession.set_game_object_field(self._game_session, self._game_object_id, "in_combat", false)
	end

	local is_rest = Vector3.length(owner_locomotion_extension:current_velocity()) < 0.1

	if is_rest then
		return servo_skull_movement_state.rest
	end

	return servo_skull_movement_state.out_of_combat
end

return FlyingCompanionMovementExtension
