local Footstep = require("scripts/utilities/footstep")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local PlayerCharacterStateBase = class("PlayerCharacterStateBase")

PlayerCharacterStateBase.init = function (self, character_state_init_context, name)
	self.name = name
	self._world = character_state_init_context.world
	self._physics_world = character_state_init_context.physics_world
	self._nav_world = character_state_init_context.nav_world
	self._wwise_world = character_state_init_context.wwise_world
	self._unit = character_state_init_context.unit
	self._player = character_state_init_context.player
	self._is_server = character_state_init_context.is_server
	self._is_local_unit = character_state_init_context.is_local_unit
	self._movement_settings_component = character_state_init_context.movement_settings_component
	self._locomotion_steering_component = character_state_init_context.locomotion_steering_component
	self._locomotion_component = character_state_init_context.locomotion_component
	self._movement_state_component = character_state_init_context.movement_state_component
	self._first_person_component = character_state_init_context.first_person_component
	self._first_person_mode_component = character_state_init_context.first_person_mode_component
	self._inair_state_component = character_state_init_context.inair_state_component
	self._locomotion_force_rotation_component = character_state_init_context.locomotion_force_rotation_component
	self._locomotion_force_translation_component = character_state_init_context.locomotion_force_translation_component
	self._ladder_character_state_component = character_state_init_context.ladder_character_state_component
	self._dodge_character_state_component = character_state_init_context.dodge_character_state_component
	self._lunge_character_state_component = character_state_init_context.lunge_character_state_component
	self._stunned_character_state_component = character_state_init_context.stunned_character_state_component
	self._weapon_action_component = character_state_init_context.weapon_action_component
	self._sprint_character_state_component = character_state_init_context.sprint_character_state_component
	self._inventory_component = character_state_init_context.inventory_component
	self._character_state_component = character_state_init_context.character_state_component
	self._interaction_component = character_state_init_context.interaction_component
	self._interactee_component = character_state_init_context.interactee_component
	self._alternate_fire_component = character_state_init_context.alternate_fire_component
	self._sway_component = character_state_init_context.sway_component
	self._action_sweep_component = character_state_init_context.action_sweep_component
	self._minigame_character_state_component = character_state_init_context.minigame_character_state_component
	self._ledge_finder_extension = character_state_init_context.ledge_finder_extension_or_nil
	self._unit_data_extension = character_state_init_context.unit_data
	self._constants = character_state_init_context.player_character_constants
	self._breed = character_state_init_context.breed
	self._archetype = character_state_init_context.archetype
	self._archetype_dodge_template = self._archetype.dodge
	self._game_session = character_state_init_context.game_session
	self._game_object_id = character_state_init_context.game_object_id
	self._footstep_time = 0
	self._feet_source_id = WwiseWorld.make_manual_source(self._wwise_world, self._unit, 1)
end

PlayerCharacterStateBase.extensions_ready = function (self, world, unit)
	self._action_input_extension = ScriptUnit.extension(unit, "action_input_system")
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._ability_extension = ScriptUnit.extension(unit, "ability_system")
	self._buff_extension = ScriptUnit.extension(unit, "buff_system")
	self._dialogue_system = ScriptUnit.extension(unit, "dialogue_system")
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._health_extension = ScriptUnit.extension(unit, "health_system")
	self._fx_extension = ScriptUnit.extension(unit, "fx_system")
	self._input_extension = ScriptUnit.extension(unit, "input_system")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	self._weapon_extension = ScriptUnit.extension(unit, "weapon_system")
	self._suppression_extension = ScriptUnit.extension(unit, "suppression_system")
	self._camera_extension = ScriptUnit.extension(unit, "camera_system")
	self._locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
	local first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._first_person_extension = first_person_extension
	local first_person_unit = first_person_extension:first_person_unit()
	self._foley_source_id = WwiseWorld.make_manual_source(self._wwise_world, first_person_unit, 1)
end

PlayerCharacterStateBase.game_object_initialized = function (self, game_session, game_object_id)
	self._game_session = game_session
	self._game_object_id = game_object_id
end

PlayerCharacterStateBase._air_movement = function (self, velocity_current, x, y, rotation, move_speed, player_speed_scale, dt)
	local local_move_direction = Vector3.normalize(Vector3(x, y, 0))
	local flat_rotation = Quaternion.look(Vector3.flat(Quaternion.forward(rotation)), Vector3.up())
	local world_move_direction = Quaternion.rotate(flat_rotation, local_move_direction)
	local velocity_current_flat = Vector3.flat(velocity_current)
	local current_speed = Vector3.length(velocity_current_flat)
	local move_angle = Vector3.angle(world_move_direction, velocity_current_flat, true)
	local constants = self._constants
	local air_directional_speed_scale_angle = constants.air_directional_speed_scale_angle
	local directional_speed_scale = math.min(move_angle / air_directional_speed_scale_angle, 1)
	local air_acceleration = constants.air_acceleration
	local speed_diff_scale = math.max(1 - current_speed / move_speed, 0)
	local speed_scale = math.max(directional_speed_scale, speed_diff_scale)
	local added_velocity = world_move_direction * move_speed * player_speed_scale * air_acceleration * speed_scale * dt
	local predicted_velocity_flat = velocity_current_flat + added_velocity
	local predicted_speed = Vector3.length(predicted_velocity_flat)
	local air_move_speed = move_speed * constants.air_move_speed_scale
	local use_drag = predicted_speed > air_move_speed
	local drag_scale = nil

	if use_drag then
		drag_scale = math.max(predicted_speed / air_move_speed, 1)
		local air_drag_angle = constants.air_drag_angle
		local angle_scale = math.min(move_angle, air_drag_angle) / air_drag_angle
		drag_scale = drag_scale * angle_scale
	else
		drag_scale = 0
	end

	local drag_velocity = -velocity_current_flat * drag_scale * dt
	local wanted_velocity = velocity_current + added_velocity + drag_velocity

	return wanted_velocity
end

PlayerCharacterStateBase._is_colliding_with_gameplay_collision_box = function (self, unit, collision_filter, capsule_radius, vertical_offset, use_world_up)
	local physics_world = self._physics_world
	local locomotion_component = self._locomotion_component
	local locomotion_position = PlayerMovement.locomotion_position(locomotion_component)
	local position = locomotion_position
	local unit_rotation = Unit.world_rotation(unit, 1)
	local rotation = Quaternion.look(Vector3.up(unit_rotation))

	if use_world_up then
		rotation = Quaternion.look(Vector3.up())
	end

	local mover = Unit.mover(unit)
	local radius = capsule_radius or Mover.radius(mover)

	if vertical_offset then
		local offset = Vector3(0, 0, vertical_offset)
		position = position + offset
	end

	local player_height = self._first_person_component.height
	local min_capsule_height = radius * 1.01
	local capsule_half_height = math.max(player_height * 0.5, min_capsule_height)
	local size = Vector3(radius, capsule_half_height, radius)
	local actors = PhysicsWorld.immediate_overlap(physics_world, "shape", "capsule", "position", position, "rotation", rotation, "size", size, "collision_filter", collision_filter)
	local collided_actor = actors and actors[1]
	local colliding = false
	local collided_unit = nil

	if collided_actor then
		colliding = true
		collided_unit = Actor.unit(collided_actor)
	end

	return colliding, collided_unit
end

local LADDER_COLLISION_FILTER = "filter_ladder_climb_collision"
local DEFAULT_CLIMB_STATE = "ladder_climbing"
local ENTER_TOP_CLIMB_STATE = "ladder_top_entering"
local LADDER_TOP_NODE = "node_top"
local LADDER_BOTTOM_NODE = "node_bottom"

PlayerCharacterStateBase._should_climb_ladder = function (self, unit, t)
	if t < self._ladder_character_state_component.ladder_cooldown then
		return false
	end

	if PlayerUnitVisualLoadout.wielded_slot_disallows_ladders(self._visual_loadout_extension, self._inventory_component) then
		return false
	end

	local colliding, ladder_unit = self:_is_colliding_with_gameplay_collision_box(unit, LADDER_COLLISION_FILTER)

	if not colliding then
		return false
	end

	local top_node = Unit.node(ladder_unit, LADDER_TOP_NODE)
	local ladder_top_pos = Unit.world_position(ladder_unit, top_node)
	local bottom_node = Unit.node(ladder_unit, LADDER_BOTTOM_NODE)
	local ladder_bottom_pos = Unit.world_position(ladder_unit, bottom_node)
	local locomotion_component = self._locomotion_component
	local locomotion_position = PlayerMovement.locomotion_position(locomotion_component)
	local position = locomotion_position
	local rotation = self._first_person_component.rotation
	local player_forward_direction = Quaternion.forward(rotation)
	local player_flat_forward_direction = Vector3.normalize(Vector3.flat(player_forward_direction))
	local climb_line_pos = Geometry.closest_point_on_line(position, ladder_bottom_pos, ladder_top_pos)
	local to_climb_line_dir = Vector3.normalize(climb_line_pos - position)
	local facing_ladder = Vector3.dot(player_flat_forward_direction, to_climb_line_dir) > 0.7

	if not facing_ladder then
		return false
	end

	local distance_epsilon = self._breed.ladder_max_distance_allow_climb
	local distance_to_ladder = Vector3.length_squared(climb_line_pos - position)

	if distance_epsilon < distance_to_ladder then
		return false
	end

	local velocity_current = locomotion_component.velocity_current
	local velocity_direction = Vector3.normalize(velocity_current)
	local moving_towards_ladder = Vector3.dot(to_climb_line_dir, velocity_direction) > 0

	if not moving_towards_ladder then
		return false
	end

	local climb_state = DEFAULT_CLIMB_STATE
	local z_diff = math.abs(ladder_top_pos.z - position.z)
	local Z_DIFF_EPSILON = 0.05

	if z_diff < Z_DIFF_EPSILON then
		climb_state = ENTER_TOP_CLIMB_STATE
	end

	local is_looking_down = Vector3.dot(player_forward_direction, Vector3.down()) > 0.95

	if climb_state ~= ENTER_TOP_CLIMB_STATE and is_looking_down and Mover.collides_down(Unit.mover(unit)) then
		return false
	end

	return true, ladder_unit, climb_state
end

PlayerCharacterStateBase._should_hang_on_ledge = function (self, unit, t)
	local collision_filter = "filter_hang_ledge_collision"
	local player_height = self._first_person_component.height
	local radius = PlayerCharacterConstants.hang_ledge_collision_capsule_radius
	local use_world_up = true
	local offset = player_height * 0.5 + radius
	local colliding, hang_ledge_unit = self:_is_colliding_with_gameplay_collision_box(unit, collision_filter, radius, offset, use_world_up)

	if not colliding then
		return false
	end

	return true, hang_ledge_unit
end

local DEVICE_SLOT_NAME = "slot_device"

PlayerCharacterStateBase._is_wielding_minigame_device = function (self)
	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot == DEVICE_SLOT_NAME then
		local visual_loadout_extension = self._visual_loadout_extension
		local weapon_template = visual_loadout_extension:weapon_template_from_slot(DEVICE_SLOT_NAME)

		if weapon_template and weapon_template.require_minigame then
			return true
		end
	end

	return false
end

PlayerCharacterStateBase._update_move_method = function (self, movement_state_component, velocity_current, moving_backwards, wants_move, stopped, anim_extension, previous_frame_state)
	local EPSILON_SQUARED_MOVEMENT_SPEED_TO_IDLE_ANIM = 0.0025000000000000005
	local old_method = movement_state_component.method
	local velocity = Vector3.length_squared(velocity_current)
	local move_vector = self._input_extension:get("move")
	local move = Vector3.length_squared(move_vector)
	local move_method = nil

	if (velocity < EPSILON_SQUARED_MOVEMENT_SPEED_TO_IDLE_ANIM or move == 0) and (old_method == "idle" or not wants_move) then
		move_method = "idle"
	elseif stopped then
		local velocity_flat_direction = Vector3.flat(Vector3.normalize(velocity_current))
		local unit_direction = Quaternion.forward(self._locomotion_component.rotation)
		local dot = Vector3.dot(velocity_flat_direction, unit_direction)

		if dot > 0 then
			move_method = "move_fwd"
		else
			move_method = "move_bwd"
		end
	elseif moving_backwards then
		move_method = "move_bwd"
	else
		move_method = "move_fwd"
	end

	if previous_frame_state == "falling" or previous_frame_state == "stunned" then
		movement_state_component.method = move_method

		anim_extension:anim_event_1p(move_method)
	elseif move_method ~= old_method then
		anim_extension:anim_event(move_method)

		movement_state_component.method = move_method

		anim_extension:anim_event_1p(move_method)
	end
end

PlayerCharacterStateBase._update_footsteps_and_foley = function (self, t, footstep_sound_alias, ...)
	local velocity_current = self._locomotion_component.velocity_current

	if Vector3.length_squared(velocity_current) < 0.01 then
		return
	end

	if self._footstep_time < t then
		local weapon_template = WeaponTemplate.current_weapon_template(self._weapon_action_component)

		if not weapon_template then
			return
		end

		local breed_footstep_intervals = weapon_template.breed_footstep_intervals
		local footstep_intervals = (breed_footstep_intervals and breed_footstep_intervals[self._breed.name]) or weapon_template.footstep_intervals

		if footstep_intervals then
			local character_state_name = self._character_state_component.state_name
			local is_crouching = self._movement_state_component.is_crouching
			local interval = (is_crouching and footstep_intervals.crouch_walking) or footstep_intervals[character_state_name]

			if interval then
				self:_trigger_footstep_and_foley(footstep_sound_alias, ...)

				self._footstep_time = t + interval
			end
		end
	end
end

PlayerCharacterStateBase._trigger_footstep_and_foley = function (self, footstep_sound_alias, ...)
	local is_camera_follow_target = self._first_person_extension:is_camera_follow_target()

	if is_camera_follow_target then
		local wwise_world = self._wwise_world
		local unit = self._unit
		local query_from = POSITION_LOOKUP[unit] + Vector3(0, 0, 0.5)
		local query_to = query_from + Vector3(0, 0, -1)

		Footstep.trigger_material_footstep(footstep_sound_alias, wwise_world, self._physics_world, self._feet_source_id, unit, 1, query_from, query_to, true, true)

		local foley_source_id = self._foley_source_id

		if foley_source_id then
			local num_args = select("#", ...)

			for i = 1, num_args, 1 do
				local sound_alias = select(i, ...)
				local move_speed = self._locomotion_extension:move_speed()

				WwiseWorld.set_source_parameter(wwise_world, foley_source_id, "foley_speed", move_speed)
				WwiseWorld.set_source_parameter(wwise_world, foley_source_id, "first_person_mode", 1)
				self._fx_extension:trigger_gear_wwise_event(sound_alias, nil, foley_source_id)
			end
		end
	end
end

return PlayerCharacterStateBase
