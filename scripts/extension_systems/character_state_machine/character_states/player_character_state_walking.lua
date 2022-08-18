require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local AcceleratedLocalSpaceMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/accelerated_local_space_movement")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interacting = require("scripts/extension_systems/character_state_machine/character_states/utilities/interacting")
local LedgeVaulting = require("scripts/extension_systems/character_state_machine/character_states/utilities/ledge_vaulting")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local FOOTSTEP_SOUND_ALIAS = "footstep"
local UPPER_BODY_FOLEY = "sfx_foley_upper_body"
local WEAPON_FOLEY = "sfx_weapon_locomotion"
local EXTRA_FOLEY = "sfx_player_extra_slot"
local PlayerCharacterStateWalking = class("PlayerCharacterStateWalking", "PlayerCharacterStateBase")

PlayerCharacterStateWalking.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateWalking.super.init(self, character_state_init_context, ...)

	local unit_data = character_state_init_context.unit_data
	self._sway_control_component = unit_data:write_component("sway_control")
	self._spread_control_component = unit_data:write_component("spread_control")
	local ledge_vault_tweak_values = self._breed.ledge_vault_tweak_values
	self._ledge_vault_tweak_values = ledge_vault_tweak_values
end

PlayerCharacterStateWalking.on_enter = function (self, unit, dt, t, previous_state, params)
	local locomotion = self._locomotion_component
	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true
	self._previous_frame_state = previous_state
	local first_person = self._first_person_component

	AcceleratedLocalSpaceMovement.refresh_local_move_variables(self._constants.move_speed, locomotion_steering, locomotion, first_person)
end

PlayerCharacterStateWalking.on_exit = function (self, unit, t, next_state)
	if next_state ~= "jumping" then
		self._animation_extension:anim_event_1p("idle")

		self._movement_state_component.method = "idle"
	end
end

PlayerCharacterStateWalking.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local first_person_extension = self._first_person_extension
	local anim_extension = self._animation_extension
	local weapon_extension = self._weapon_extension
	local locomotion_steering = self._locomotion_steering_component
	local locomotion = self._locomotion_component
	local move_settings = self._movement_settings_component
	local movement_state = self._movement_state_component
	local input_extension = self._input_extension
	local move_state_component = self._movement_state_component
	local velocity_current = locomotion.velocity_current

	weapon_extension:update_weapon_actions(fixed_frame)
	self._ability_extension:update_ability_actions(fixed_frame)

	local is_crouching = Crouch.check(unit, first_person_extension, anim_extension, weapon_extension, move_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, input_extension, t)
	local move_direction, move_speed, new_x, new_y, wants_move, stopped, moving_backwards, wants_slide = AcceleratedLocalSpaceMovement.wanted_movement(self._constants, input_extension, locomotion_steering, move_settings, self._first_person_component, is_crouching, velocity_current, dt)
	local action_move_speed_modifier = weapon_extension:move_speed_modifier(t)
	move_speed = move_speed * action_move_speed_modifier
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	move_speed = move_speed * stat_buffs.movement_speed

	AcceleratedLocalSpaceMovement.set_wanted_movement(locomotion_steering, move_direction, move_speed, new_x, new_y)

	local previous_frame_state = self._previous_frame_state

	self:_update_move_method(movement_state, velocity_current, moving_backwards, wants_move, stopped, anim_extension, previous_frame_state)

	if previous_frame_state then
		self._previous_frame_state = nil
	end

	local next_state = self:_check_transition(unit, t, next_state_params, input_extension, wants_slide)

	return next_state
end

PlayerCharacterStateWalking.update = function (self, unit, dt, t)
	self:_update_footsteps_and_foley(t, FOOTSTEP_SOUND_ALIAS, UPPER_BODY_FOLEY, WEAPON_FOLEY, EXTRA_FOLEY)
end

PlayerCharacterStateWalking._check_transition = function (self, unit, t, next_state_params, input_source, wants_slide)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local disruptive_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_transition then
		return disruptive_transition
	end

	if Interacting.check(self._interaction_component) then
		return "interacting"
	end

	if self:_is_wielding_minigame_device() then
		return "minigame"
	end

	local wanted_ability_transition, ability_transition_params = self._ability_extension:wanted_character_state_transition()

	if wanted_ability_transition then
		table.merge(next_state_params, ability_transition_params)

		return wanted_ability_transition
	end

	local is_colliding_on_hang_ledge, hang_ledge_unit = self:_should_hang_on_ledge(unit, t)

	if is_colliding_on_hang_ledge then
		next_state_params.hang_ledge_unit = hang_ledge_unit

		return "ledge_hanging"
	end

	local movement_state_component = self._movement_state_component
	local weapon_action_component = self._weapon_action_component
	local anim_extension = self._animation_extension
	local is_crouching = movement_state_component.is_crouching
	local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

	if Sprint.check(t, unit, movement_state_component, self._sprint_character_state_component, input_source, self._locomotion_component, weapon_action_component, self._alternate_fire_component, weapon_template, self._constants) then
		return "sprinting"
	end

	if wants_slide then
		return "sliding"
	end

	local jump_input = movement_state_component.can_jump and input_source:get("jump")
	local archetype_dodge_template = self._archetype_dodge_template
	local should_dodge, local_dodge_direction = Dodge.check(t, self._unit_data_extension, archetype_dodge_template, input_source)

	if should_dodge then
		next_state_params.dodge_direction = local_dodge_direction

		return "dodging"
	end

	if jump_input then
		local can_vault, ledge = LedgeVaulting.can_enter(self._ledge_finder_extension, self._ledge_vault_tweak_values, self._unit_data_extension, self._input_extension, self._visual_loadout_extension)

		if can_vault then
			next_state_params.ledge = ledge

			return "ledge_vaulting"
		end
	end

	if jump_input and (not is_crouching or Crouch.can_exit(unit)) then
		if is_crouching then
			Crouch.exit(unit, self._first_person_extension, anim_extension, self._weapon_extension, movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, t)
		end

		return "jumping"
	end

	local inair_state = self._inair_state_component

	if not inair_state.on_ground then
		return "falling"
	end

	local is_colliding, ladder_unit, climb_state = self:_should_climb_ladder(unit, t)

	if is_colliding then
		next_state_params.ladder_unit = ladder_unit

		return climb_state
	end
end

return PlayerCharacterStateWalking
