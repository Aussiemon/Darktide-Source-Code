-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_consumed.lua

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
local PlayerCharacterStateConsumed = class("PlayerCharacterStateConsumed", "PlayerCharacterStateBase")

PlayerCharacterStateConsumed.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateConsumed.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data
	local disabled_character_state_component = unit_data_extension:write_component("disabled_character_state")

	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	self._disabled_character_state_component = disabled_character_state_component
	self._disabled_state_input = unit_data_extension:read_component("disabled_state_input")
	self._dead_state_input = unit_data_extension:read_component("dead_state_input")
	self._entered_state_t = nil
end

local ENTER_TELEPORT_NODE = "root_point"
local DISABLING_UNIT_LINK_NODE = "j_tongue_attach"
local CONSUMED_UNIT_LINK_NODE = "root_point"
local DISABLED_UNIT_LINK_NODE = "j_hips"
local SET_CONSUMED_TIMING = {
	human = 3.566666666666667,
	ogryn = 3.8
}
local FOLLOW_CONSUMED_TARGET_CAMERA_TIMING = 0.5

PlayerCharacterStateConsumed.on_enter = function (self, unit, dt, t, previous_state, params)
	if not params.cancel_assist then
		local inventory_component = self._inventory_component
		local visual_loadout_extension = self._visual_loadout_extension

		Interrupt.ability_and_action(t, unit, "consumed", nil)
		Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)
		PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)
		self._animation_extension:anim_event("to_beast_of_nurgle")

		local locomotion_steering_component = self._locomotion_steering_component

		locomotion_steering_component.move_method = "script_driven"
		locomotion_steering_component.velocity_wanted = Vector3.zero()
		locomotion_steering_component.calculate_fall_velocity = false
		locomotion_steering_component.disable_velocity_rotation = true
		locomotion_steering_component.disable_minion_collision = true
		self._movement_state_component.method = "idle"

		local disabling_unit = self._disabled_state_input.disabling_unit
		local disabling_unit_data_extension = ScriptUnit.extension(disabling_unit, "unit_data_system")

		self._disabling_breed = disabling_unit_data_extension:breed()

		local disabled_character_state_component = self._disabled_character_state_component

		disabled_character_state_component.is_disabled = true
		disabled_character_state_component.disabling_unit = disabling_unit
		disabled_character_state_component.disabling_type = "consumed"

		local is_server = self._is_server

		if is_server then
			local link_node = Unit.node(disabling_unit, ENTER_TELEPORT_NODE)
			local teleport_position = Unit.world_position(disabling_unit, link_node)
			local unit_forward = Quaternion.forward(Unit.world_rotation(disabling_unit, link_node))

			teleport_position = teleport_position + unit_forward * 4.5

			PlayerMovement.teleport_fixed_update(unit, teleport_position)
		end

		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_extension:set_parent_unit(disabling_unit)
		locomotion_extension:visual_link(disabling_unit, DISABLING_UNIT_LINK_NODE, DISABLED_UNIT_LINK_NODE)
		FirstPersonView.exit(t, self._first_person_mode_component)

		if is_server then
			self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
		end

		local locomotion_force_rotation_component = self._locomotion_force_rotation_component
		local disabling_unit_rotation = Unit.world_rotation(disabling_unit, 1)
		local force_rotation = Quaternion.look(-Quaternion.forward(disabling_unit_rotation))

		ForceRotation.start(locomotion_force_rotation_component, locomotion_steering_component, force_rotation, force_rotation, t, 1)

		self._entered_state_t = t

		if is_server then
			self:_add_buffs(t)
		end

		PlayerVoiceGrunts.trigger_voice(VCE, self._visual_loadout_extension, self._fx_extension, true)

		self._follow_consumed_camera_timing = t + FOLLOW_CONSUMED_TARGET_CAMERA_TIMING
	else
		self._animation_extension:anim_event("revive_abort")
	end

	self._consumed_timing = t + SET_CONSUMED_TIMING[self._breed.name]
end

local THROW_TELEPORT_UP_OFFSET_HUMAN, THROW_TELEPORT_UP_OFFSET_OGRYN = 1.5, 1.5
local THROW_TELEPORT_FWD_OFFSET_HUMAN, THROW_TELEPORT_FWD_OFFSET_OGRYN = 3.2, 3.2

PlayerCharacterStateConsumed.on_exit = function (self, unit, t, next_state)
	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	if locomotion_force_rotation_component.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation_component)
	end

	local disabled_character_state_component = self._disabled_character_state_component
	local disabling_unit = disabled_character_state_component.disabling_unit
	local is_server = self._is_server

	if is_server and ALIVE[disabling_unit] then
		local breed_name = self._breed.name
		local is_human = breed_name == "human"
		local disabling_unit_position = Unit.world_position(disabling_unit, 1)
		local unit_rotation = Unit.local_rotation(disabling_unit, 1)
		local up = Vector3.up() * (is_human and THROW_TELEPORT_UP_OFFSET_HUMAN or THROW_TELEPORT_UP_OFFSET_OGRYN)
		local disabling_unit_forward = Quaternion.forward(unit_rotation) * (is_human and THROW_TELEPORT_FWD_OFFSET_HUMAN or THROW_TELEPORT_FWD_OFFSET_OGRYN)
		local teleport_position = disabling_unit_position + disabling_unit_forward + up
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
	disabled_character_state_component.disabling_type = "none"
	self._locomotion_steering_component.disable_minion_collision = false

	local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

	locomotion_extension:set_parent_unit(nil)
	locomotion_extension:visual_unlink()

	local locomotion_steering_component = self._locomotion_steering_component

	locomotion_steering_component.velocity_wanted = Vector3.zero()

	if self._is_server then
		self:_remove_buffs()

		if self._consumed_effect_id then
			local fx_system = Managers.state.extension:system("fx_system")

			fx_system:stop_template_effect(self._consumed_effect_id)

			self._consumed_effect_id = nil
		end

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
				local position = Unit.world_position(unit, 1)
				local allowed_move_distance = 1
				local _, non_colliding_position = Mover.fits_at(mover, position, allowed_move_distance)

				if non_colliding_position then
					PlayerMovement.teleport_fixed_update(unit, non_colliding_position)
				end
			end
		end

		self._entered_state_t = nil
	end
end

PlayerCharacterStateConsumed._add_buffs = function (self, t)
	local constants = self._constants
	local buff_extension = self._buff_extension

	if not self._buff_indexes then
		local _, local_index, component_index = buff_extension:add_externally_controlled_buff(constants.beast_of_nurgle_consumed_buff, t)

		self._buff_indexes = {
			local_index = local_index,
			component_index = component_index
		}
	end
end

PlayerCharacterStateConsumed._remove_buffs = function (self)
	local buff_extension = self._buff_extension
	local buff_indexes = self._buff_indexes

	if buff_indexes then
		local local_index = buff_indexes.local_index
		local component_index = buff_indexes.component_index

		buff_extension:remove_externally_controlled_buff(local_index, component_index)

		self._buff_indexes = nil
	end
end

PlayerCharacterStateConsumed.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local disabling_unit = self._disabled_state_input.disabling_unit

	if self._consumed_timing and t >= self._consumed_timing and ALIVE[disabling_unit] then
		local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")

		locomotion_extension:visual_unlink()
		locomotion_extension:visual_link(disabling_unit, CONSUMED_UNIT_LINK_NODE, DISABLED_UNIT_LINK_NODE)

		local breed_name = self._breed.name

		self._animation_extension:anim_event("player_" .. breed_name .. "_consumed")

		if self._is_server then
			local teleport_position, teleport_rotation = Unit.world_position(disabling_unit, Unit.node(disabling_unit, CONSUMED_UNIT_LINK_NODE)), Quaternion.inverse(Unit.local_rotation(disabling_unit, Unit.node(disabling_unit, CONSUMED_UNIT_LINK_NODE)))

			PlayerMovement.teleport_fixed_update(unit, teleport_position, teleport_rotation)

			local fx_system = Managers.state.extension:system("fx_system")
			local disabling_breed = self._disabling_breed
			local target_effect_template = disabling_breed.target_effect_template
			local effect_id = fx_system:start_template_effect(target_effect_template, unit)

			self._consumed_effect_id = effect_id
		end

		self._consumed_timing = nil
	end

	return self:_check_transition(unit, t, next_state_params)
end

PlayerCharacterStateConsumed._check_transition = function (self, unit, t, next_state_params)
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

return PlayerCharacterStateConsumed
