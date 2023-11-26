-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_grabbed.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local FirstPersonView = require("scripts/utilities/first_person_view")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LagCompensation = require("scripts/utilities/lag_compensation")
local Luggable = require("scripts/utilities/luggable")
local PlayerMovement = require("scripts/utilities/player_movement")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerVoiceGrunts = require("scripts/utilities/player_voice_grunts")
local SFX_SOURCE = "head"
local STINGER_ALIAS = "disabled_enter"
local STINGER_PROPERTIES = {
	stinger_type = "mutant_charge"
}
local VCE = "scream_long_vce"
local PlayerCharacterStateGrabbed = class("PlayerCharacterStateGrabbed", "PlayerCharacterStateBase")

PlayerCharacterStateGrabbed.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateGrabbed.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local disabled_character_state_component = unit_data_extension:write_component("disabled_character_state")

	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	self._disabled_character_state_component = disabled_character_state_component
	self._disabled_state_input = unit_data_extension:read_component("disabled_state_input")
	self._dead_state_input = unit_data_extension:read_component("dead_state_input")
	self._entered_state_t = nil
end

local ENTER_TELEPORT_NODE = "rp_base"
local DISABLING_UNIT_LINK_NODE = "j_lefthand"
local DISABLED_UNIT_LINK_NODE = "j_hips"
local START_EAT_TIMING = {
	human = 1.2,
	ogryn = 1.5666666666666667
}

PlayerCharacterStateGrabbed.on_enter = function (self, unit, dt, t, previous_state, params)
	if not params.cancel_assist then
		local inventory_component = self._inventory_component
		local visual_loadout_extension = self._visual_loadout_extension

		Interrupt.ability_and_action(t, unit, "consumed", nil)
		Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)
		PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)
		self._animation_extension:anim_event("to_chaos_spawn")

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
		disabled_character_state_component.disabling_type = "grabbed"

		local is_server = self._is_server

		if is_server then
			local link_node = Unit.node(disabling_unit, ENTER_TELEPORT_NODE)
			local teleport_position = Unit.world_position(disabling_unit, link_node)
			local unit_forward = Quaternion.forward(Unit.world_rotation(disabling_unit, link_node))

			teleport_position = teleport_position + unit_forward * 0.75

			local lookat_override = Quaternion.look(-Quaternion.forward(Unit.local_rotation(disabling_unit, 1)))

			PlayerMovement.teleport_fixed_update(unit, teleport_position, lookat_override)
		end

		local camera_extension = ScriptUnit.has_extension(unit, "camera_system")
		local will_be_predicted = true

		camera_extension:trigger_camera_shake("chaos_spawn_grabbed", will_be_predicted)

		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_extension:set_parent_unit(disabling_unit)
		locomotion_extension:visual_link(disabling_unit, DISABLING_UNIT_LINK_NODE, DISABLED_UNIT_LINK_NODE)
		FirstPersonView.exit(t, self._first_person_mode_component)

		if is_server then
			self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
		end

		self._charger_throw_smash = false
		self._smash_played = false
		self._throw_anim_played = false
		self._entered_state_t = t

		PlayerVoiceGrunts.trigger_voice(VCE, self._visual_loadout_extension, self._fx_extension, true)
	else
		self._animation_extension:anim_event("revive_abort")
	end

	self._start_eat_timing = t + START_EAT_TIMING[self._breed.name]
end

PlayerCharacterStateGrabbed.on_exit = function (self, unit, t, next_state)
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	if locomotion_force_rotation_component.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation_component)
	end

	local disabled_character_state_component = self._disabled_character_state_component
	local disabling_unit = disabled_character_state_component.disabling_unit
	local teleport_position

	if ALIVE[disabling_unit] then
		teleport_position = disabled_character_state_component.target_drag_position

		PlayerMovement.teleport_fixed_update(unit, teleport_position)

		local first_person_component = self._unit_data_extension:write_component("first_person")
		local flat_rotation = Unit.local_rotation(disabling_unit, 1)

		first_person_component.rotation = flat_rotation
	end

	local first_person_mode_component = self._first_person_mode_component
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)

	FirstPersonView.enter(t, first_person_mode_component, rewind_ms)

	if next_state ~= "dead" and next_state ~= "catapulted" then
		local inventory_component = self._inventory_component

		PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
	end

	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.disabling_type = "none"
	self._locomotion_steering_component.disable_minion_collision = false

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_extension:set_parent_unit(nil)
	locomotion_extension:visual_unlink()

	if self._is_server then
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

			local state_name = "consumed"
			local time_in_captivity = t - self._entered_state_t

			Managers.telemetry_events:player_exits_captivity(player, rescued_by_player, state_name, time_in_captivity)

			if next_state == "catapulted" then
				local mover = Unit.mover(unit)
				local allowed_move_distance = 1
				local _, non_colliding_position = Mover.fits_at(mover, teleport_position, allowed_move_distance)

				if non_colliding_position then
					PlayerMovement.teleport_fixed_update(unit, non_colliding_position)
				end
			end
		end

		self._entered_state_t = nil
	end
end

local START_EAT_ANIM_EVENT = "attack_grabbed_eat_start"

PlayerCharacterStateGrabbed.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local input_component = self._disabled_state_input
	local trigger_animation = input_component.trigger_animation

	if trigger_animation == "throw" and not self._throw_anim_played then
		local animation_event = "attack_grabbed_throw"

		self._animation_extension:anim_event(animation_event)

		self._throw_anim_played = true
	elseif (trigger_animation == "throw" or trigger_animation == "throw_left" or trigger_animation == "throw_right" or trigger_animation == "throw_bwd") and not self._throw_anim_played then
		local animation_event = "attack_grabbed_" .. trigger_animation

		self._animation_extension:anim_event(animation_event)

		self._throw_anim_played = true
	end

	if trigger_animation == "smash" and not self._smash_played then
		self._animation_extension:anim_event("attack_grabbed_smash")

		self._smash_played = true
	end

	if not self._smash_played and self._start_eat_timing and t >= self._start_eat_timing then
		self._animation_extension:anim_event(START_EAT_ANIM_EVENT)

		self._start_eat_timing = nil
	end

	return self:_check_transition(unit, t, next_state_params)
end

PlayerCharacterStateGrabbed._check_transition = function (self, unit, t, next_state_params)
	local disruptive_transition = DisruptiveStateTransition.poll(unit, self._unit_data_extension, next_state_params)
	local disabling_unit = self._disabled_state_input.disabling_unit

	if disruptive_transition and not disabling_unit and disruptive_transition == "catapulted" then
		return "catapulted"
	end

	if not disabling_unit or not HEALTH_ALIVE[disabling_unit] then
		return "walking"
	end

	local dead_state_input = self._dead_state_input

	if dead_state_input.die then
		next_state_params.time_to_despawn_corpse = dead_state_input.despawn_time

		return "dead"
	end

	return nil
end

return PlayerCharacterStateGrabbed
