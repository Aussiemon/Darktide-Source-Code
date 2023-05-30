require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local Fall = require("scripts/extension_systems/character_state_machine/character_states/utilities/fall")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interrupt = require("scripts/utilities/attack/interrupt")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Vo = require("scripts/utilities/vo")
local PlayerCharacterStateCatapulted = class("PlayerCharacterStateCatapulted", "PlayerCharacterStateBase")
local CATAPULTED_ANIMS = {
	forward = {
		enter = {
			anim_3p = "airtime_bwd",
			anim_1p = "airtime_fwd"
		},
		exit = {
			anim_3p = "airtime_bwd",
			anim_1p = "airtime_fwd"
		},
		collide = {
			anim_3p = "airtime_bwd",
			anim_1p = "airtime_fwd"
		}
	},
	backward = {
		enter = {
			anim_3p = "airtime_fwd",
			anim_1p = "airtime_bwd"
		},
		exit = {
			anim_3p = "airtime_fwd",
			anim_1p = "airtime_bwd"
		},
		collide = {
			anim_3p = "airtime_fwd",
			anim_1p = "airtime_bwd"
		}
	}
}
local SFX_SOURCE = "head"
local STINGER_ALIAS = "disabled_enter"
local STINGER_PROPERTIES = {
	stinger_type = "catapulted"
}

PlayerCharacterStateCatapulted.on_enter = function (self, unit, dt, t, previous_state, params)
	local velocity = params.velocity
	local first_person = self._first_person_component
	local locomotion_steering = self._locomotion_steering_component
	local inair_state = self._inair_state_component
	local locomotion = self._locomotion_component
	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = false
	locomotion_steering.velocity_wanted = velocity
	locomotion_steering.disable_minion_collision = true
	inair_state.on_ground = false
	local rotation = first_person.rotation
	local forward = Quaternion.forward(rotation)
	local direction = Vector3.normalize(velocity)
	local locomotion_position = locomotion.position
	local catapulted_direction = nil
	local dot = Vector3.dot(forward, direction)
	catapulted_direction = dot > 0 and "forward" or "backward"
	self._catapulted_direction = catapulted_direction
	self._start_catapulted_height = locomotion_position.z

	Interrupt.ability_and_action(t, unit, "catapulted", nil)
	Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)

	if previous_state ~= "grabbed" then
		PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)
	end

	self:_trigger_anim_event(catapulted_direction, "enter")
	self._fx_extension:trigger_looping_wwise_event("catapulted", "head")

	local is_server = self._is_server

	if is_server then
		self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
	end

	Vo.player_catapulted_event(unit)

	local locomotion_steering_component = self._locomotion_steering_component
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component
	local wanted_direction = catapulted_direction == "forward" and direction or -direction
	local force_rotation = Quaternion.look(wanted_direction)

	ForceRotation.start(locomotion_force_rotation_component, locomotion_steering_component, force_rotation, force_rotation, t, 1)

	self._skip_next_frame = true
end

PlayerCharacterStateCatapulted._trigger_anim_event = function (self, direction, reason)
	local anim_event = CATAPULTED_ANIMS[direction][reason].anim_1p
	local anim_event_3p = anim_event or CATAPULTED_ANIMS[direction][reason].anim_3p
	local anim_extension = self._animation_extension

	anim_extension:anim_event_1p(anim_event)
	anim_extension:anim_event(anim_event_3p)
end

PlayerCharacterStateCatapulted.on_exit = function (self, unit, t, next_state)
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	if locomotion_force_rotation_component.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation_component)
	end

	local fx_extension = self._fx_extension
	local locomotion_component = self._locomotion_component
	local inair_state_component = self._inair_state_component
	local constants = self._constants

	if next_state ~= "dead" then
		PlayerUnitVisualLoadout.wield_previous_slot(self._inventory_component, unit, t)
	end

	fx_extension:stop_looping_wwise_event("catapulted")
	Fall.trigger_impact_sound(unit, fx_extension, constants, locomotion_component, inair_state_component)
	Fall.set_fall_height(self._locomotion_component, self._inair_state_component)

	self._locomotion_steering_component.disable_minion_collision = false
end

PlayerCharacterStateCatapulted.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	if self._skip_next_frame then
		self._skip_next_frame = false

		return
	end

	local locomotion_component = self._locomotion_component
	local velocity_current = locomotion_component.velocity_current
	local gravity_acceleration = self._constants.gravity

	if self._locomotion_component.velocity_current.z > 0 then
		Fall.set_fall_height(locomotion_component, self._inair_state_component)
	end

	local fall_speed = velocity_current.z - gravity_acceleration * dt
	self._locomotion_steering_component.velocity_wanted = Vector3(velocity_current.x, velocity_current.y, fall_speed)
	local constants = self._constants
	local inair_state_component = self._inair_state_component

	if self._is_server then
		Fall.check_damage(unit, constants, locomotion_component, inair_state_component)
	end

	local next_state = self:_check_transition(unit, t, next_state_params)

	return next_state
end

PlayerCharacterStateCatapulted._check_transition = function (self, unit, t, next_state_params)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local disruptive_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_transition then
		return disruptive_transition
	end

	local is_colliding_on_hang_ledge, hang_ledge_unit = self:_should_hang_on_ledge(unit, t)

	if is_colliding_on_hang_ledge then
		next_state_params.hang_ledge_unit = hang_ledge_unit

		Vo.player_catapulted_land_event(unit)

		return "ledge_hanging"
	end

	local inair_state = self._inair_state_component

	if inair_state.on_ground then
		self:_trigger_anim_event("backward", "exit")
		Vo.player_catapulted_land_event(unit)

		return "walking"
	end

	local mover = Unit.mover(unit)

	if Mover.collides_sides(mover) then
		self:_trigger_anim_event("backward", "collide")
		Vo.player_catapulted_land_event(unit)

		return "walking"
	end
end

return PlayerCharacterStateCatapulted
