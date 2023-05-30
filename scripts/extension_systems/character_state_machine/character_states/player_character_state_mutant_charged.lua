require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Luggable = require("scripts/utilities/luggable")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerVoiceGrunts = require("scripts/utilities/player_voice_grunts")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local SFX_SOURCE = "head"
local STINGER_ALIAS = "disabled_enter"
local STINGER_PROPERTIES = {
	stinger_type = "mutant_charge"
}
local VCE = "scream_long_vce"
local PlayerCharacterStateMutantCharged = class("PlayerCharacterStateMutantCharged", "PlayerCharacterStateBase")

PlayerCharacterStateMutantCharged.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateMutantCharged.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local disabled_character_state_component = unit_data_extension:write_component("disabled_character_state")
	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.target_drag_position = Vector3.zero()
	self._disabled_character_state_component = disabled_character_state_component
	self._disabled_state_input = unit_data_extension:read_component("disabled_state_input")
	self._dead_state_input = unit_data_extension:read_component("dead_state_input")
	self._entered_state_t = nil
end

local DISABLING_UNIT_LINK_NODE = "j_leftweaponattach"
local DISABLED_UNIT_LINK_NODE = "j_hips"

PlayerCharacterStateMutantCharged.on_enter = function (self, unit, dt, t, previous_state, params)
	if not params.cancel_assist then
		local inventory_component = self._inventory_component
		local visual_loadout_extension = self._visual_loadout_extension

		Interrupt.ability_and_action(t, unit, "mutant_charged", nil)
		Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)
		PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)
		self._animation_extension:anim_event("to_charger")

		local locomotion_steering_component = self._locomotion_steering_component
		locomotion_steering_component.move_method = "script_driven"
		locomotion_steering_component.velocity_wanted = Vector3.zero()
		locomotion_steering_component.calculate_fall_velocity = false
		locomotion_steering_component.disable_minion_collision = true
		self._movement_state_component.method = "idle"
		local disabling_unit = self._disabled_state_input.disabling_unit
		local disabled_character_state_component = self._disabled_character_state_component
		disabled_character_state_component.is_disabled = true
		disabled_character_state_component.disabling_unit = disabling_unit
		disabled_character_state_component.disabling_type = "mutant_charged"
		local is_server = self._is_server

		if is_server then
			local teleport_position = Unit.world_position(disabling_unit, 1)
			local teleport_rotation = Quaternion.inverse(Unit.local_rotation(disabling_unit, 1))

			PlayerMovement.teleport_fixed_update(unit, teleport_position, nil)
		end

		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_extension:set_parent_unit(disabling_unit)
		locomotion_extension:visual_link(disabling_unit, DISABLING_UNIT_LINK_NODE, DISABLED_UNIT_LINK_NODE)
		FirstPersonView.exit(t, self._first_person_mode_component)

		local locomotion_force_rotation_component = self._locomotion_force_rotation_component
		local disabling_unit_rotation = Unit.world_rotation(disabling_unit, 1)
		local force_rotation = Quaternion.look(-Quaternion.forward(disabling_unit_rotation))

		ForceRotation.start(locomotion_force_rotation_component, locomotion_steering_component, force_rotation, force_rotation, t, 1)

		if is_server then
			self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
		end

		self._charger_throw_smash = false
		self._charger_throw_played = false
		self._entered_state_t = t

		PlayerVoiceGrunts.trigger_voice(VCE, self._visual_loadout_extension, self._fx_extension, true)
	else
		self._animation_extension:anim_event("revive_abort")
	end
end

PlayerCharacterStateMutantCharged.on_exit = function (self, unit, t, next_state)
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	if locomotion_force_rotation_component.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation_component)
	end

	local disabled_character_state_component = self._disabled_character_state_component
	local disabling_unit = disabled_character_state_component.disabling_unit
	local is_server = self._is_server
	local teleport_position = nil

	if ALIVE[disabling_unit] then
		local breed_name = self._breed.name
		local is_human = breed_name == "human"
		teleport_position = disabled_character_state_component.target_drag_position
		local unit_rotation = Unit.local_rotation(disabling_unit, 1)
		local disabling_unit_forward = Quaternion.forward(unit_rotation)
		local direction = is_human and disabling_unit_forward or -disabling_unit_forward
		local teleport_rotation = Quaternion.look(direction)

		PlayerMovement.teleport_fixed_update(unit, teleport_position, teleport_rotation)
	end

	local first_person_mode_component = self._first_person_mode_component
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)

	FirstPersonView.enter(t, first_person_mode_component, rewind_ms)

	if next_state ~= "dead" then
		local inventory_component = self._inventory_component

		PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
	end

	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.target_drag_position = Vector3.zero()
	disabled_character_state_component.disabling_type = "none"
	self._locomotion_steering_component.disable_minion_collision = false
	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_extension:set_parent_unit(nil)
	locomotion_extension:visual_unlink()

	local locomotion_steering_component = self._locomotion_steering_component
	locomotion_steering_component.velocity_wanted = Vector3.zero()

	if is_server then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)
		local is_player_alive = player:unit_is_alive()

		if is_player_alive then
			local rescued_by_player = true

			if HEALTH_ALIVE[disabling_unit] then
				local target_blackboard = BLACKBOARDS[disabling_unit]

				if target_blackboard then
					local stagger_component = target_blackboard.stagger
					local not_staggered = stagger_component.num_triggered_staggers == 0

					if not_staggered then
						rescued_by_player = false
					end
				end
			end

			local state_name = "mutant_charged"
			local time_in_captivity = t - self._entered_state_t

			Managers.telemetry_events:player_exits_captivity(player, rescued_by_player, state_name, time_in_captivity)

			local mover = Unit.mover(unit)
			local position = teleport_position or Unit.world_position(unit, 1)
			local allowed_move_distance = 1
			local _, non_colliding_position = Mover.fits_at(mover, position, allowed_move_distance)

			if non_colliding_position then
				PlayerMovement.teleport_fixed_update(unit, non_colliding_position)
			end
		end

		self._entered_state_t = nil
	end
end

PlayerCharacterStateMutantCharged.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local input_component = self._disabled_state_input
	local trigger_animation = input_component.trigger_animation

	if trigger_animation == "smash" and not self._charger_throw_smash then
		self._animation_extension:anim_event("charger_smash")

		self._charger_throw_smash = true
	elseif (trigger_animation == "throw" or trigger_animation == "throw_left" or trigger_animation == "throw_right" or trigger_animation == "throw_bwd") and not self._charger_throw_played then
		local animation_event = "charger_" .. trigger_animation

		self._animation_extension:anim_event(animation_event)

		self._charger_throw_played = true
	end

	return self:_check_transition(unit, t, next_state_params)
end

PlayerCharacterStateMutantCharged._check_transition = function (self, unit, t, next_state_params)
	if not self._disabled_state_input.disabling_unit then
		return "walking"
	end

	local dead_state_input = self._dead_state_input

	if dead_state_input.die then
		next_state_params.time_to_despawn_corpse = dead_state_input.despawn_time

		return "dead"
	end

	return nil
end

return PlayerCharacterStateMutantCharged
