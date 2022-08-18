local Ladder = require("scripts/extension_systems/character_state_machine/character_states/utilities/ladder")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ThirdPersonHubMovementDirectionAnimationControl = require("scripts/extension_systems/locomotion/third_person_hub_movement_direction_animation_control")
local PlayerHuskLocomotionExtension = class("PlayerHuskLocomotionExtension")
local RPCS = {
	"rpc_set_player_link",
	"rpc_player_unlink"
}

PlayerHuskLocomotionExtension.init = function (self, extension_init_context, unit, extension_init_data, game_session, game_object_id, owner_id)
	self._world = extension_init_context.world
	self._unit = unit
	self._game_object_id = game_object_id
	self._game_session = game_session
	self._player = extension_init_data.player
	self._breed = extension_init_data.breed
	local position = GameSession.game_object_field(game_session, game_object_id, "position")
	local rotation = self:_get_rotation(game_session, game_object_id)
	self._old_lerp_position = Vector3Box(position)
	self._old_lerp_rotation = QuaternionBox(rotation)
	self._animation_extension = ScriptUnit.extension(unit, "animation_system")
	self._move_speed_variable = "anim_move_speed"
	self._climb_time_anim_var = "climb_time"
	self._active_stop_anim_var = "active_stop"
	local data_ext = ScriptUnit.extension(unit, "unit_data_system")
	local loc_component = data_ext:read_component("locomotion")
	self._loc_component = loc_component
	self._locomotion_steering_component = data_ext:read_component("locomotion_steering")
	self._old_parent_unit = nil
	local move_speed = GameSession.game_object_field(game_session, game_object_id, "move_speed")
	self._move_speed = move_speed
	self._move_speed_squared = move_speed * move_speed
	local network_event_delegate = extension_init_context.network_event_delegate

	network_event_delegate:register_session_unit_events(self, self._game_object_id, unpack(RPCS))

	self._network_event_delegate = network_event_delegate
end

PlayerHuskLocomotionExtension.destroy = function (self)
	self._network_event_delegate:unregister_unit_events(self._game_object_id, unpack(RPCS))
end

PlayerHuskLocomotionExtension.extensions_ready = function (self, world, unit)
	local init_context = {
		is_local_unit = false,
		is_husk = true,
		is_server = false,
		player_character_constants = PlayerCharacterConstants,
		game_session = self._game_session,
		game_object_id = self._game_object_id
	}
	self._movement_direction_animation_control = ThirdPersonHubMovementDirectionAnimationControl:new(unit, init_context)
	self._first_person_extension = ScriptUnit.extension(unit, "first_person_system")
	self._visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
end

PlayerHuskLocomotionExtension._get_rotation = function (self, session, id)
	local yaw = GameSession.game_object_field(session, id, "yaw")
	local pitch = GameSession.game_object_field(session, id, "pitch")
	local roll = GameSession.game_object_field(session, id, "roll")

	return Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
end

PlayerHuskLocomotionExtension._get_aim_direction = function (self, session, id)
	local aim_direction = GameSession.game_object_field(session, id, "aim_direction")

	return aim_direction
end

PlayerHuskLocomotionExtension.update = function (self, unit, dt, t)
	local session = self._game_session
	local id = self._game_object_id
	local parent_unit = self._loc_component.parent_unit
	local new_position = GameSession.game_object_field(session, id, "position")
	local new_rotation = self:_get_rotation(session, id)
	local old_position = self._old_lerp_position:unbox()
	local old_rotation = self._old_lerp_rotation:unbox()

	if self._old_parent_unit ~= parent_unit then
		local rotation = Unit.local_rotation(unit, 1)
		local position = Unit.local_position(unit, 1)
		old_rotation, old_position = PlayerMovement.calculate_relative_rotation_position(parent_unit, rotation, position)
		self._old_parent_unit = parent_unit
	end

	local lerp_speed = PlayerCharacterConstants.husk_position_lerp_speed
	local lerp_t = math.min(dt * lerp_speed, 1)
	local lerp_position = Vector3.lerp(old_position, new_position, lerp_t)
	local aim_direction = Vector3.normalize(Vector3.flat(self:_get_aim_direction(session, id)))
	local aim_rotation = Quaternion.look(aim_direction, Vector3.forward())
	local lerp_rotation = PlayerMovement.calculate_final_unit_rotation(old_rotation, new_rotation, aim_rotation, lerp_t, true)

	self._old_lerp_position:store(lerp_position)
	self._old_lerp_rotation:store(lerp_rotation)

	local final_rotation, final_position = PlayerMovement.calculate_absolute_rotation_position(parent_unit, lerp_rotation, lerp_position)

	Unit.set_local_position(unit, 1, final_position)
	Unit.set_local_rotation(unit, 1, final_rotation)

	local first_person_extension = self._first_person_extension

	if first_person_extension:is_in_first_person_mode() then
		World.update_unit_and_children(self._world, unit)
		first_person_extension:update_unit_position_and_rotation(final_position, true)
	end

	local visual_loadout_extension = self._visual_loadout_extension

	visual_loadout_extension:update_unit_position(unit, dt, t)

	local animation_extension = self._animation_extension
	local move_speed = GameSession.game_object_field(session, id, "move_speed")
	self._move_speed = move_speed
	self._move_speed_squared = move_speed * move_speed
	local move_speed_var_id = animation_extension:anim_variable_id(self._move_speed_variable)
	local old_speed = Unit.animation_get_variable(unit, move_speed_var_id)
	local anim_move_speed = math.lerp(old_speed, move_speed, dt * 10)
	local clamped_anim_move_speed = math.clamp(anim_move_speed, 0, 19.9)

	Unit.animation_set_variable(unit, move_speed_var_id, clamped_anim_move_speed)

	local ladder_unit_id = GameSession.game_object_field(session, id, "ladder_unit_id")

	if ladder_unit_id ~= NetworkConstants.invalid_level_unit_id then
		local ladder_unit = Managers.state.unit_spawner:unit(ladder_unit_id, true)
		local new_time_in_ladder_animation = Ladder.time_in_ladder_anim(unit, ladder_unit, self._breed)
		local climb_time_var_id = animation_extension:anim_variable_id(self._climb_time_anim_var)

		Unit.animation_set_variable(unit, climb_time_var_id, new_time_in_ladder_animation)
	end

	local locomotion_steering_component = self._locomotion_steering_component

	if locomotion_steering_component.move_method == "script_driven_hub" then
		local current_active_stop = (locomotion_steering_component.hub_active_stopping and 1) or 0
		local active_stop_anim_var_id = Unit.animation_find_variable(unit, self._active_stop_anim_var)

		if active_stop_anim_var_id then
			local old_anim_var_value = Unit.animation_get_variable(unit, active_stop_anim_var_id)
			local active_stop = math.clamp(math.lerp(old_anim_var_value, current_active_stop, dt * 20), 0, 1)

			Unit.animation_set_variable(unit, active_stop_anim_var_id, active_stop)
		end

		self._movement_direction_animation_control:update(dt, t)
	end
end

PlayerHuskLocomotionExtension.move_speed = function (self)
	return self._move_speed
end

PlayerHuskLocomotionExtension.move_speed_squared = function (self)
	return self._move_speed_squared
end

PlayerHuskLocomotionExtension._link = function (self, node, parent_unit, parent_node)
	self._unlinked_parent_node = Unit.scene_graph_parent(self._unit, node)
	self._linked_node = node

	World.link_unit(self._world, self._unit, node, parent_unit, parent_node, false, false)
end

PlayerHuskLocomotionExtension._unlink = function (self)
	World.unlink_unit(self._world, self._unit, false)
	Unit.scene_graph_link(self._unit, self._linked_node, self._unlinked_parent_node)

	self._linked_node = nil
	self._unlinked_parent_node = nil
end

PlayerHuskLocomotionExtension.rpc_set_player_link = function (self, channel_id, game_object_id, node, parent_unit_id, parent_node)
	local parent_unit = Managers.state.unit_spawner:unit(parent_unit_id)

	fassert(parent_unit, "[PlayerHuskLocomotionExtension] Parent Unit from parent_unit_id(%d) is nil.", parent_unit_id)
	self:_link(node, parent_unit, parent_node)
end

PlayerHuskLocomotionExtension.rpc_player_unlink = function (self, channel_id, game_object_id)
	self:_unlink()
end

PlayerHuskLocomotionExtension.current_velocity = function (self)
	local pitch = GameSession.game_object_field(self._game_session, self._game_object_id, "pitch")
	local yaw = GameSession.game_object_field(self._game_session, self._game_object_id, "yaw")
	local roll = GameSession.game_object_field(self._game_session, self._game_object_id, "roll")
	local rot = Quaternion.from_yaw_pitch_roll(yaw, pitch, roll)
	local move_speed = GameSession.game_object_field(self._game_session, self._game_object_id, "move_speed")

	return Quaternion.rotate(rot, Vector3.forward()) * move_speed
end

return PlayerHuskLocomotionExtension
