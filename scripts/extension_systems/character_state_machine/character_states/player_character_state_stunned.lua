-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_stunned.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local AcceleratedLocalSpaceMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/accelerated_local_space_movement")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DisorientationSettings = require("scripts/settings/damage/disorientation_settings")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interrupt = require("scripts/utilities/attack/interrupt")
local IntoxicatedMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/intoxicated_movement")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local buff_keywords = BuffSettings.keywords
local disorientation_templates = DisorientationSettings.disorientation_templates
local PlayerCharacterStateStunned = class("PlayerCharacterStateStunned", "PlayerCharacterStateBase")

PlayerCharacterStateStunned.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateStunned.super.init(self, character_state_init_context, ...)

	local unit_data = character_state_init_context.unit_data
	local stunned_character_state_component = unit_data:write_component("stunned_character_state")

	stunned_character_state_component.start_time = 0
	stunned_character_state_component.disorientation_type = "none"
	stunned_character_state_component.stunned = false
	stunned_character_state_component.actions_interrupted = false
	stunned_character_state_component.exit_event_played = false
	self._stunned_character_state_component = stunned_character_state_component
	self._sway_control_component = unit_data:write_component("sway_control")
	self._spread_control_component = unit_data:write_component("spread_control")
	self._recoil_control_component = unit_data:write_component("recoil_control")
	self._weapon_action_component = unit_data:read_component("weapon_action")
	self._intoxicated_movement_component = unit_data:write_component("intoxicated_movement")
	self._character_state_random_component = unit_data:write_component("character_state_random")
end

PlayerCharacterStateStunned.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateStunned.super.on_enter(self, unit, dt, t, previous_state, params)

	local animation_extension = self._animation_extension
	local locomotion_component = self._locomotion_component
	local locomotion_steering_component = self._locomotion_steering_component
	local stunned_character_state_component = self._stunned_character_state_component

	locomotion_steering_component.move_method = "script_driven"
	locomotion_steering_component.calculate_fall_velocity = true

	local first_person_component = self._first_person_component

	AcceleratedLocalSpaceMovement.refresh_local_move_variables(self._constants.move_speed, locomotion_steering_component, locomotion_component, first_person_component)

	local disorientation_type = params.disorientation_type
	local disorientation_template = disorientation_templates[disorientation_type]
	local stun_settings = disorientation_template.stun

	self._previous_frame_state = previous_state
	locomotion_steering_component.velocity_wanted = Vector3.zero()
	stunned_character_state_component.start_time = t
	stunned_character_state_component.disorientation_type = disorientation_type
	stunned_character_state_component.stunned = true
	stunned_character_state_component.actions_interrupted = false

	local start_anim = stun_settings.start_anim
	local start_anim_3p = stun_settings.start_anim_3p or start_anim

	if start_anim then
		animation_extension:anim_event_1p(start_anim)
	end

	if start_anim_3p then
		animation_extension:anim_event(start_anim_3p)
	end

	local stun_immunity_time_buff = stun_settings.stun_immunity_time_buff

	if stun_immunity_time_buff then
		local buff_extension = self._buff_extension
		local has_buff = buff_extension:has_keyword(buff_keywords.stun_immune)

		if not has_buff then
			buff_extension:add_internally_controlled_buff(stun_immunity_time_buff, t)
		end
	end
end

PlayerCharacterStateStunned.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateStunned.super.on_exit(self, unit, t, next_state)

	local stunned_character_state_component = self._stunned_character_state_component

	stunned_character_state_component.stunned = false
	stunned_character_state_component.start_time = 0
	stunned_character_state_component.disorientation_type = "none"
	stunned_character_state_component.actions_interrupted = false
	stunned_character_state_component.exit_event_played = false

	IntoxicatedMovement.initialize_component(self._intoxicated_movement_component)
end

local WIELD_ACTION_INPUT = "wield"
local NO_KEYWORDS = {}
local interrupt_reason_data = {}

PlayerCharacterStateStunned.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local is_crouching = Crouch.check(unit, self._first_person_extension, self._animation_extension, self._weapon_extension, self._movement_state_component, self._locomotion_component, self._inair_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, self._input_extension, t, false)
	local input_extension = self._input_extension
	local character_state_component = self._character_state_component
	local character_state_random_component = self._character_state_random_component
	local intoxicated_movement_component = self._intoxicated_movement_component
	local locomotion_component = self._locomotion_component
	local locomotion_steering_component = self._locomotion_steering_component
	local stunned_character_state_component = self._stunned_character_state_component
	local entered_t = character_state_component.entered_t
	local velocity_current = locomotion_component.velocity_current
	local time_in_state = t - entered_t
	local disorientation_type = stunned_character_state_component.disorientation_type
	local disorientation_template = disorientation_templates[disorientation_type]
	local stun_settings = disorientation_template.stun
	local action_delay = stun_settings.action_delay
	local stun_settings_interrupt_delay = stun_settings.interrupt_delay
	local interrupt_delay

	if stun_settings_interrupt_delay ~= nil then
		interrupt_delay = stun_settings_interrupt_delay or 0
	end

	local update_actions = true

	if interrupt_delay then
		update_actions = time_in_state <= interrupt_delay or time_in_state >= interrupt_delay + action_delay
	end

	local switched_to_melee_while_interrupted = false

	if update_actions then
		self._weapon_extension:update_weapon_actions(fixed_frame)
		self._ability_extension:update_ability_actions(fixed_frame)
	else
		local current_weapon_template = self._weapon_extension:weapon_template()
		local current_weapon_special_tweak_data = current_weapon_template and current_weapon_template.weapon_special_tweak_data

		if current_weapon_special_tweak_data and current_weapon_special_tweak_data.keep_active_on_stun then
			self._weapon_extension:update_weapon_special_implementation(fixed_frame)
		end

		local action_input, raw_input = self._action_input_extension:peek_next_input("weapon_action")
		local is_wield_input = action_input and action_input == WIELD_ACTION_INPUT
		local inventory_component = self._inventory_component
		local wanted_slot_name_or_nil = is_wield_input and PlayerUnitVisualLoadout.slot_name_from_wield_input(raw_input, inventory_component, self._visual_loadout_extension, self._weapon_extension, self._ability_extension, input_extension)
		local wielded_slot = inventory_component.wielded_slot
		local wanted_weapon_template_or_nil = wanted_slot_name_or_nil and self._visual_loadout_extension:weapon_template_from_slot(wanted_slot_name_or_nil)
		local weapon_keywords = wanted_weapon_template_or_nil and wanted_weapon_template_or_nil.keywords or NO_KEYWORDS
		local wants_melee_weapon = wanted_weapon_template_or_nil and table.array_contains(weapon_keywords, "melee")

		if wants_melee_weapon and wielded_slot ~= wanted_slot_name_or_nil then
			switched_to_melee_while_interrupted = true

			PlayerUnitVisualLoadout.wield_slot(wanted_slot_name_or_nil, unit, t)
		end
	end

	if interrupt_delay and interrupt_delay <= time_in_state and not stunned_character_state_component.actions_interrupted then
		interrupt_reason_data.self_stun = stun_settings.self_stun

		Interrupt.ability_and_action(t, unit, "stunned", interrupt_reason_data)

		stunned_character_state_component.actions_interrupted = true
	end

	local move_direction, move_speed, new_x, new_y, wants_move, stopped, moving_backwards = AcceleratedLocalSpaceMovement.wanted_movement(self._constants, input_extension, locomotion_steering_component, self._movement_settings_component, self._first_person_component, is_crouching, velocity_current, dt)
	local intoxication_level = stun_settings.intoxication_level

	if intoxication_level > 0 then
		move_direction, move_speed = IntoxicatedMovement.update(intoxicated_movement_component, character_state_random_component, intoxication_level, dt, t, move_direction, move_speed)
	end

	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()

	move_speed = move_speed * stat_buffs.movement_speed
	locomotion_steering_component.velocity_wanted = move_direction * move_speed
	locomotion_steering_component.local_move_x = new_x
	locomotion_steering_component.local_move_y = new_y

	local previous_frame_state = self._previous_frame_state

	if previous_frame_state then
		self._previous_frame_state = nil
	end

	self:_update_move_method(self._movement_state_component, velocity_current, moving_backwards, wants_move, stopped, self._animation_extension, previous_frame_state)

	return self:_check_transition(unit, t, next_state_params, switched_to_melee_while_interrupted)
end

PlayerCharacterStateStunned._play_end_animation = function (self)
	local disorientation_template = disorientation_templates[self._stunned_character_state_component.disorientation_type]
	local stun_settings = disorientation_template.stun
	local stunned_character_state_component = self._stunned_character_state_component

	stunned_character_state_component.exit_event_played = true

	local end_anim = stun_settings.end_anim
	local end_anim_3p = stun_settings.end_anim_3p or end_anim

	if end_anim then
		self._animation_extension:anim_event_1p(end_anim)
	end

	if end_anim_3p then
		self._animation_extension:anim_event(end_anim_3p)
	end
end

PlayerCharacterStateStunned._check_transition = function (self, unit, t, next_state_params, switched_to_melee_while_interrupted)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local disruptive_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_transition and disruptive_transition ~= "stunned" then
		return disruptive_transition
	end

	local is_colliding_on_hang_ledge, hang_ledge_unit = self:_should_hang_on_ledge(unit, t)

	if is_colliding_on_hang_ledge then
		next_state_params.hang_ledge_unit = hang_ledge_unit

		return "ledge_hanging"
	end

	local stunned_character_state_component = self._stunned_character_state_component
	local inair_state_component = self._inair_state_component
	local disorientation_template = disorientation_templates[self._stunned_character_state_component.disorientation_type]
	local stun_settings = disorientation_template.stun

	if not switched_to_melee_while_interrupted then
		local end_stun_early_time = stun_settings.end_stun_early_time or 0.5

		if not stunned_character_state_component.exit_event_played and t > stunned_character_state_component.start_time + stun_settings.stun_duration - end_stun_early_time then
			self:_play_end_animation()
		end
	end

	local stun_finished = switched_to_melee_while_interrupted or t > stunned_character_state_component.start_time + math.max(stun_settings.stun_duration)

	if stun_finished and not inair_state_component.on_ground then
		return "falling"
	end

	if stun_finished then
		return "walking"
	end

	local ability_transition, ability_transition_params = self:_poll_ability_state_transitions(unit, t)

	if ability_transition then
		table.merge(next_state_params, ability_transition_params)

		if not stunned_character_state_component.exit_event_played then
			self:_play_end_animation()
		end

		return ability_transition
	end
end

return PlayerCharacterStateStunned
