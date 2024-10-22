-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_exploding.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local AcceleratedLocalSpaceMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/accelerated_local_space_movement")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interrupt = require("scripts/utilities/attack/interrupt")
local IntoxicatedMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/intoxicated_movement")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local PlayerCharacterStateExploding = class("PlayerCharacterStateExploding", "PlayerCharacterStateBase")

PlayerCharacterStateExploding.init = function (self, ...)
	PlayerCharacterStateExploding.super.init(self, ...)

	local unit_data_extension = self._unit_data_extension
	local state_component = unit_data_extension:write_component("exploding_character_state")

	state_component.slot_name = "none"
	state_component.reason = "overheat"
	state_component.is_exploding = false
	self._exploding_character_state_component = state_component
	self._intoxicated_movement_component = unit_data_extension:write_component("intoxicated_movement")
	self._character_state_random_component = unit_data_extension:write_component("character_state_random")
end

PlayerCharacterStateExploding.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateExploding.super.on_enter(self, unit, dt, t, previous_state, params)

	local slot_name = params.slot_name
	local reason = params.reason
	local wield_slot = params.wield_slot
	local explode_action = params.explode_action
	local state_component = self._exploding_character_state_component

	state_component.slot_name = slot_name
	state_component.reason = reason
	state_component.is_exploding = true

	local locomotion_steering = self._locomotion_steering_component

	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true

	AcceleratedLocalSpaceMovement.refresh_local_move_variables(self._constants.move_speed, locomotion_steering, self._locomotion_component, self._first_person_component)

	local ignore_immunity = true

	Interrupt.ability_and_action(t, unit, "exploding", nil, ignore_immunity)

	if wield_slot then
		PlayerUnitVisualLoadout.wield_slot(wield_slot, unit, t)
	end

	self._weapon_extension:start_action(explode_action, t)
end

PlayerCharacterStateExploding.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateExploding.super.on_exit(self, unit, t, next_state)

	local state_component = self._exploding_character_state_component

	state_component.is_exploding = false

	IntoxicatedMovement.initialize_component(self._intoxicated_movement_component)
end

local INTOXICATION_LEVEL = 5

PlayerCharacterStateExploding.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local locomotion_steering_component = self._locomotion_steering_component
	local input_extension = self._input_extension
	local locomotion_component = self._locomotion_component
	local velocity_current = locomotion_component.velocity_current
	local is_crouching = false
	local move_direction, move_speed, new_x, new_y, wants_move, stopped, moving_backwards = AcceleratedLocalSpaceMovement.wanted_movement(self._constants, input_extension, locomotion_steering_component, self._movement_settings_component, self._first_person_component, is_crouching, velocity_current, dt)

	move_direction, move_speed = IntoxicatedMovement.update(self._intoxicated_movement_component, self._character_state_random_component, INTOXICATION_LEVEL, dt, t, move_direction, move_speed)
	locomotion_steering_component.velocity_wanted = move_direction * move_speed
	locomotion_steering_component.local_move_x = new_x
	locomotion_steering_component.local_move_y = new_y

	if self._exploding_character_state_component.reason == "warp_charge" then
		self._weapon_extension:update_weapon_actions(fixed_frame)
		self._ability_extension:update_ability_actions(fixed_frame)
	end

	self:_update_move_method(self._movement_state_component, velocity_current, moving_backwards, wants_move, stopped, self._animation_extension)

	local state_component = self._exploding_character_state_component

	return self:_check_transition(unit, t, next_state_params, input_extension, state_component)
end

PlayerCharacterStateExploding._check_transition = function (self, unit, t, next_state_params, input_extension, state_component)
	local unit_data_extension = self._unit_data_extension
	local health_state_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_state_transition then
		return health_state_transition
	end

	local disabled_state_input = unit_data_extension:read_component("disabled_state_input")

	if disabled_state_input.wants_disable and disabled_state_input.disabling_unit then
		Interrupt.action(t, unit, disabled_state_input.disabling_type, nil, true)
	end

	local disruptive_state_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_state_transition and disruptive_state_transition ~= "exploding" then
		return disruptive_state_transition
	end

	if state_component.reason == "overheat" then
		local slot_name = state_component.slot_name
		local inventory_slot_component = unit_data_extension:read_component(slot_name)

		if inventory_slot_component.overheat_state ~= "exploding" then
			return "walking"
		end
	elseif state_component.reason == "warp_charge" then
		local warp_charge_component = unit_data_extension:read_component("warp_charge")

		if warp_charge_component.state ~= "exploding" then
			local data = {}

			self._weapon_extension:stop_action("aborted", data, t)

			local inventory_component = unit_data_extension:write_component("inventory")

			PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, self._unit, t)

			return "walking"
		end
	end
end

return PlayerCharacterStateExploding
