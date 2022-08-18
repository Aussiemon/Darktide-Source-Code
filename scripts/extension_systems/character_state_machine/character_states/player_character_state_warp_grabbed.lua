require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Luggable = require("scripts/utilities/luggable")
local Netted = require("scripts/extension_systems/character_state_machine/character_states/utilities/netted")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerCharacterStateWarpGrabbed = class("PlayerCharacterStateWarpGrabbed", "PlayerCharacterStateBase")
local SFX_SOURCE = "head"
local STINGER_ALIAS = "disabled_enter"
local STINGER_PROPERTIES = {
	stinger_type = "warp_grabbed"
}

PlayerCharacterStateWarpGrabbed.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateWarpGrabbed.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local disabled_character_state_component = unit_data_extension:write_component("disabled_character_state")
	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.target_drag_position = Vector3.zero()
	self._disabled_character_state_component = disabled_character_state_component
	self._drag_start_anim_played = false
	self._disabled_state_input = unit_data_extension:read_component("disabled_state_input")
	self._execute_anim_played = false
end

PlayerCharacterStateWarpGrabbed.on_enter = function (self, unit, dt, t, previous_state, params)
	if not params.cancel_assist then
		local inventory_component = self._inventory_component
		local visual_loadout_extension = self._visual_loadout_extension

		Interrupt.ability_and_action(t, unit, "warp_grabbed", nil)
		Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)
		PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)
		self._animation_extension:anim_event("to_grabbed")

		local locomotion_steering_component = self._locomotion_steering_component
		locomotion_steering_component.move_method = "anim_driven"
		locomotion_steering_component.velocity_wanted = Vector3.zero()
		locomotion_steering_component.calculate_fall_velocity = false
		self._movement_state_component.method = "idle"
		local disabling_unit = self._disabled_state_input.disabling_unit
		local locomotion_component = self._locomotion_component
		local navigation_extension = ScriptUnit.extension(unit, "navigation_system")
		local drag_position = Netted.calculate_drag_position(locomotion_component, navigation_extension, disabling_unit, self._nav_world)
		local disabled_character_state_component = self._disabled_character_state_component
		disabled_character_state_component.is_disabled = true
		disabled_character_state_component.disabling_unit = disabling_unit
		disabled_character_state_component.target_drag_position = drag_position
		disabled_character_state_component.disabling_type = "warp_grabbed"
		local locomotion_force_rotation_component = self._locomotion_force_rotation_component
		local disabling_unit_rotation = Unit.world_rotation(disabling_unit, 1)
		local force_rotation = Quaternion.look(-Quaternion.forward(disabling_unit_rotation))

		ForceRotation.start(locomotion_force_rotation_component, locomotion_steering_component, force_rotation, force_rotation, t, 1)

		local is_server = self._is_server

		if is_server then
			self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
		end

		FirstPersonView.exit(t, self._first_person_mode_component)
	else
		self._animation_extension:anim_event("revive_abort")
	end
end

PlayerCharacterStateWarpGrabbed.on_exit = function (self, unit, t, next_state)
	if not self._reached_drag_position then
		self:_on_drag_completed(t)
	end

	self._reached_drag_position = false
	self._drag_start_anim_played = false
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	if locomotion_force_rotation_component.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation_component)
	end

	local first_person_mode_component = self._first_person_mode_component
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)

	FirstPersonView.enter(t, first_person_mode_component, rewind_ms)

	local inventory_component = self._inventory_component
	local previously_wielded_slot_name = inventory_component.previously_wielded_slot

	PlayerUnitVisualLoadout.wield_slot(previously_wielded_slot_name, unit, t)

	local disabled_character_state_component = self._disabled_character_state_component
	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.target_drag_position = Vector3.zero()
	disabled_character_state_component.disabling_type = "none"
end

PlayerCharacterStateWarpGrabbed.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local input_component = self._disabled_state_input
	local trigger_animation = input_component.trigger_animation

	if trigger_animation == "grabbed_execution" and not self._execute_anim_played then
		self._animation_extension:anim_event("grabbed_execution")

		self._execute_anim_played = true
	end

	return self:_check_transition(unit, t, next_state_params)
end

PlayerCharacterStateWarpGrabbed._check_transition = function (self, unit, t, next_state_params)
	local unit_data_extension = self._unit_data_extension

	if not self._disabled_state_input.disabling_unit then
		return "walking"
	end

	local dead_state_input = unit_data_extension:read_component("dead_state_input")

	if dead_state_input.die then
		next_state_params.time_to_despawn_corpse = dead_state_input.despawn_time

		return "dead"
	end

	return nil
end

PlayerCharacterStateWarpGrabbed._on_drag_completed = function (self, t)
	FirstPersonView.exit(t, self._first_person_mode_component)

	local locomotion_steering_component = self._locomotion_steering_component
	locomotion_steering_component.velocity_wanted = Vector3.zero()
	self._reached_drag_position = true
end

return PlayerCharacterStateWarpGrabbed
