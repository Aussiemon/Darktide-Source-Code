-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_sprinting.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local AbilityTemplate = require("scripts/utilities/ability/ability_template")
local AcceleratedLocalSpaceMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/accelerated_local_space_movement")
local Action = require("scripts/utilities/action/action")
local ActionHandlerSettings = require("scripts/settings/action/action_handler_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interacting = require("scripts/extension_systems/character_state_machine/character_states/utilities/interacting")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LedgeVaulting = require("scripts/extension_systems/character_state_machine/character_states/utilities/ledge_vaulting")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local buff_keywords = BuffSettings.keywords
local slot_configuration = PlayerCharacterConstants.slot_configuration
local PlayerCharacterStateSprinting = class("PlayerCharacterStateSprinting", "PlayerCharacterStateBase")
local _sideways_speed_function, _forward_speed_function, _abort_sprint, _check_input

PlayerCharacterStateSprinting.init = function (self, ...)
	PlayerCharacterStateSprinting.super.init(self, ...)

	local unit = self._unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local sprint_character_state_component = unit_data_extension:write_component("sprint_character_state")

	sprint_character_state_component.is_sprinting = false
	sprint_character_state_component.is_sprint_jumping = false
	sprint_character_state_component.wants_sprint_camera = false
	sprint_character_state_component.last_sprint_time = 0
	sprint_character_state_component.sprint_overtime = 0
	sprint_character_state_component.cooldown = 0
	sprint_character_state_component.use_sprint_start_slowdown = false
	self._sprint_character_state_component = sprint_character_state_component
	self._stamina_component = unit_data_extension:write_component("stamina")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
	self._action_input_extension = ScriptUnit.extension(unit, "action_input_system")

	local ledge_vault_tweak_values = self._breed.ledge_vault_tweak_values

	self._ledge_vault_tweak_values = ledge_vault_tweak_values

	local archetype = self._archetype

	self._archetype_sprint_template = archetype.sprint
	self._archetype_stamina_template = archetype.stamina
end

PlayerCharacterStateSprinting.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateSprinting.super.on_enter(self, unit, dt, t, previous_state, params)

	local locomotion_steering = self._locomotion_steering_component

	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true

	local sprint_character_state_component = self._sprint_character_state_component

	sprint_character_state_component.is_sprinting = true
	sprint_character_state_component.wants_sprint_camera = true
	sprint_character_state_component.sprint_overtime = 0
	sprint_character_state_component.use_sprint_start_slowdown = not params.disable_sprint_start_slowdown

	local ignore_immunity = true

	Interrupt.ability_and_action(t, unit, "started_sprint", nil, ignore_immunity)

	local base_sprint_template = self._archetype_sprint_template

	AcceleratedLocalSpaceMovement.refresh_local_move_variables(base_sprint_template.sprint_move_speed, locomotion_steering, self._locomotion_component, self._first_person_component)
	Stamina.set_regeneration_paused(self._stamina_component, true)

	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot ~= "none" then
		local slot_type = slot_configuration[wielded_slot].slot_type

		if slot_type == "ability" and wielded_slot ~= "slot_grenade_ability" then
			PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, unit, t)
		end
	end

	self._previous_velocity_move_speed = nil
end

PlayerCharacterStateSprinting.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateSprinting.super.on_exit(self, unit, t, next_state)

	local sprint_character_state_component = self._sprint_character_state_component

	sprint_character_state_component.is_sprinting = false
	sprint_character_state_component.last_sprint_time = t

	if next_state ~= "jumping" then
		sprint_character_state_component.wants_sprint_camera = false
	end

	Stamina.set_regeneration_paused(self._stamina_component, false)
end

local WALK_MOVE_ANIM_THRESHOLD = 0.8

PlayerCharacterStateSprinting.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local locomotion = self._locomotion_component
	local locomotion_steering = self._locomotion_steering_component
	local base_sprint_template = self._archetype_sprint_template
	local constants = self._constants
	local move_settings = self._movement_settings_component
	local weapon_extension = self._weapon_extension

	weapon_extension:update_weapon_actions(fixed_frame)
	self._ability_extension:update_ability_actions(fixed_frame)

	local input_extension = self._input_extension
	local sprint_input = Sprint.sprint_input(input_extension, true)
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local has_sprinting_buff = buff_extension:has_keyword(buff_keywords.allow_hipfire_during_sprint)
	local weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(self._visual_loadout_extension, self._inventory_component)
	local has_weapon_action_input, weapon_action_input = _check_input(self._action_input_extension, weapon_template, has_sprinting_buff)
	local wants_sprint = sprint_input and not has_weapon_action_input
	local sprint_character_state_component = self._sprint_character_state_component
	local move_direction, move_speed, new_x, new_y, wants_to_stop, remaining_stamina = self:_wanted_movement(dt, sprint_character_state_component, input_extension, locomotion_steering, locomotion, move_settings, self._first_person_component, wants_sprint, weapon_extension, stat_buffs, t)
	local old_y = locomotion_steering.local_move_y
	local decreasing_speed = new_y < old_y
	local action_move_speed_modifier = weapon_extension:move_speed_modifier(t)
	local move_speed_without_weapon_actions = move_speed * stat_buffs.sprint_movement_speed * stat_buffs.movement_speed
	local move_speed_with_weapon_actions = move_speed_without_weapon_actions * action_move_speed_modifier

	locomotion_steering.velocity_wanted = move_direction * move_speed_with_weapon_actions
	locomotion_steering.local_move_x = new_x
	locomotion_steering.local_move_y = new_y

	local movement_state = self._movement_state_component
	local old_method = movement_state.method
	local sprint_move_speed = base_sprint_template.sprint_move_speed
	local new_method, wants_sprint_camera

	if not decreasing_speed then
		new_method = "sprint"
		wants_sprint_camera = true
	elseif move_speed >= sprint_move_speed * WALK_MOVE_ANIM_THRESHOLD then
		new_method = "sprint"
		wants_sprint_camera = true
	else
		new_method = "move_fwd"
		wants_sprint_camera = false
	end

	sprint_character_state_component.wants_sprint_camera = wants_sprint_camera

	local animation_ext = self._animation_extension

	Crouch.check(unit, self._first_person_extension, animation_ext, weapon_extension, movement_state, self._sway_control_component, self._sway_component, self._spread_control_component, input_extension, t, false)

	if old_method ~= new_method then
		animation_ext:anim_event(new_method)

		movement_state.method = new_method

		animation_ext:anim_event_1p(new_method)
	end

	local run_move_speed = constants.move_speed
	local sprint_momentum = math.max((move_speed - run_move_speed) / (sprint_move_speed - run_move_speed), 0)
	local wants_slide = movement_state.is_crouching

	return self:_check_transition(unit, t, next_state_params, input_extension, decreasing_speed, action_move_speed_modifier, sprint_momentum, wants_slide, wants_to_stop, has_weapon_action_input, weapon_action_input, move_direction, move_speed_without_weapon_actions)
end

PlayerCharacterStateSprinting._check_transition = function (self, unit, t, next_state_params, input_source, decreasing_speed, action_move_speed_modifier, sprint_momentum, wants_slide, wants_to_stop, has_weapon_action_input, weapon_action_input, move_direction, move_speed_without_weapon_actions)
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

		return "ledge_hanging"
	end

	if Interacting.check(self._interaction_component) then
		return "interacting"
	end

	if self:_is_wielding_minigame_device() then
		return "minigame"
	end

	if input_source:get("jump") and self._movement_state_component.can_jump then
		local can_vault, ledge = LedgeVaulting.can_enter(self._ledge_finder_extension, self._ledge_vault_tweak_values, self._unit_data_extension, self._input_extension, self._visual_loadout_extension)

		if can_vault then
			next_state_params.ledge = ledge
			next_state_params.was_sprinting = true

			return "ledge_vaulting"
		else
			self._sprint_character_state_component.is_sprint_jumping = true

			return "jumping"
		end
	end

	local inair_state = self._inair_state_component

	if not inair_state.on_ground then
		self._sprint_character_state_component.is_sprint_jumping = true

		return "falling"
	end

	if wants_slide then
		self._locomotion_steering_component.velocity_wanted = move_direction * move_speed_without_weapon_actions
		next_state_params.friction_function = "sprint"

		return "sliding"
	end

	local is_colliding, ladder_unit, climb_state = self:_should_climb_ladder(unit, t)

	if is_colliding then
		next_state_params.ladder_unit = ladder_unit

		return climb_state
	end

	local ability_transition, ability_transition_params = self:_poll_ability_state_transitions(unit, t)

	if ability_transition then
		table.merge(next_state_params, ability_transition_params)

		return ability_transition
	end

	local weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(self._visual_loadout_extension, self._inventory_component)

	if wants_to_stop then
		if has_weapon_action_input then
			local action_settings = self._weapon_extension:action_settings_from_action_input(weapon_action_input)
			local sprint_ready_up_time = action_settings and action_settings.sprint_ready_up_time or weapon_template and weapon_template.sprint_ready_up_time or 0

			self._sprint_character_state_component.cooldown = t + sprint_ready_up_time
		end

		return "walking"
	end

	local buff_extension = self._buff_extension
	local has_allow_sprinting_buff = buff_extension:has_keyword(buff_keywords.allow_hipfire_during_sprint)
	local _, weapon_action_setting = Action.current_action(self._weapon_action_component, weapon_template)
	local combat_ability_template = AbilityTemplate.current_ability_template(self._combat_ability_action_component)
	local _, combat_ability_action_settings = Action.current_action(self._combat_ability_action_component, combat_ability_template)
	local abort_sprint = _abort_sprint(weapon_action_setting, has_allow_sprinting_buff) or _abort_sprint(combat_ability_action_settings, has_allow_sprinting_buff)

	if abort_sprint then
		return "walking"
	end

	return nil
end

PlayerCharacterStateSprinting._wanted_movement = function (self, dt, sprint_character_state_component, input_source, locomotion_steering, locomotion, movement_settings_component, first_person_component, wants_sprint, weapon_extension, stat_buffs, t)
	local move_input = input_source:get("move")
	local wanted_x = move_input.x
	local wanted_y = move_input.y

	if wanted_y > 0 and not wants_sprint then
		wanted_y = 0
	end

	local current_x, current_y = locomotion_steering.local_move_x, locomotion_steering.local_move_y
	local constants = self._constants
	local base_sprint_template = self._archetype_sprint_template
	local weapon_sprint_template = weapon_extension:sprint_template()
	local side_acc = weapon_sprint_template and weapon_sprint_template.sprint_sideway_acceleration or 1
	local side_dec = weapon_sprint_template and weapon_sprint_template.sprint_sideway_deceleration or 1
	local new_x = _sideways_speed_function(current_x, wanted_x, side_acc, side_dec, dt)
	local normal_move_speed = constants.move_speed
	local weapon_sprint_speed_mod = weapon_sprint_template and weapon_sprint_template.sprint_speed_mod or 1
	local weapon_no_stamina_sprint_speed_mod = weapon_sprint_template and weapon_sprint_template.no_stamina_sprint_speed_mod or 1
	local sprint_move_speed = base_sprint_template.sprint_move_speed
	local max_x = normal_move_speed / sprint_move_speed

	new_x = math.clamp(new_x, -max_x, max_x)

	local acc = weapon_sprint_template and weapon_sprint_template.sprint_forward_acceleration or 1
	local dec = weapon_sprint_template and weapon_sprint_template.sprint_forward_deceleration or 1
	local new_y = _forward_speed_function(current_y, wanted_y, acc, dec, dt)
	local stopped = new_x == 0 and new_y == 0
	local speed_scale = stopped and 0 or math.sqrt(math.min(1, new_x * new_x + new_y * new_y))

	if sprint_character_state_component.use_sprint_start_slowdown then
		local time_in_sprint = t - self._character_state_component.entered_t
		local slowdown_time = 0.11
		local speed_mod = math.clamp(time_in_sprint, 0, slowdown_time) / slowdown_time

		speed_scale = speed_scale * speed_mod
	end

	local max_move_speed = sprint_move_speed + weapon_sprint_speed_mod
	local base_stamina_template = self._archetype_stamina_template
	local weapon_stamina_template = self._weapon_extension:stamina_template()
	local base_cost_per_second = weapon_stamina_template and weapon_stamina_template.sprint_cost_per_second or math.huge
	local buff_cost_multiplier = stat_buffs.sprinting_cost_multiplier
	local cost_per_second = base_cost_per_second * buff_cost_multiplier
	local remaining_stamina = Stamina.drain(self._unit, cost_per_second * dt, t)
	local sprint_overtime_percentage = 0

	if remaining_stamina <= 0 then
		local previus_overtime = sprint_character_state_component.sprint_overtime
		local overtime = previus_overtime + dt

		sprint_character_state_component.sprint_overtime = overtime

		local no_stamina_sprint_speed_multiplier = base_stamina_template.no_stamina_sprint_speed_multiplier + (weapon_no_stamina_sprint_speed_mod - 1)
		local no_stamina_sprint_speed_deceleration_time = base_stamina_template.no_stamina_sprint_speed_deceleration_time
		local move_speed_time_lerp = math.lerp(1, no_stamina_sprint_speed_multiplier, math.min(overtime / no_stamina_sprint_speed_deceleration_time, 1))

		max_move_speed = normal_move_speed + (max_move_speed - normal_move_speed) * move_speed_time_lerp
		sprint_overtime_percentage = math.min(overtime / no_stamina_sprint_speed_deceleration_time, 1)
	end

	local first_person_unit = self._first_person_extension:first_person_unit()
	local sprint_overtime_variable = Unit.animation_find_variable(first_person_unit, "sprint_overtime")

	if sprint_overtime_variable then
		Unit.animation_set_variable(first_person_unit, sprint_overtime_variable, sprint_overtime_percentage)
	end

	local move_speed = max_move_speed * speed_scale * movement_settings_component.player_speed_scale
	local local_move_direction = Vector3.normalize(Vector3(new_x, new_y, 0))
	local unit_rotation = first_person_component.rotation
	local flat_unit_rotation = Quaternion.look(Vector3.flat(Quaternion.forward(unit_rotation)), Vector3.up())
	local move_direction = Quaternion.rotate(flat_unit_rotation, local_move_direction)
	local wants_to_stop = wanted_y <= 0

	return move_direction, move_speed, new_x, new_y, wants_to_stop, remaining_stamina
end

local ALLOWED_INPUTS_IN_SPRINT = {
	combat_ability = true,
	wield = true,
}

function _check_input(action_input_extension, weapon_template, has_hip_fire_buff)
	local peek = action_input_extension:peek_next_input("weapon_action")
	local is_allowed = peek and (weapon_template and weapon_template.allowed_inputs_in_sprint or ALLOWED_INPUTS_IN_SPRINT)[peek]
	local is_hipfire_input = peek and weapon_template and weapon_template.hipfire_inputs and weapon_template.hipfire_inputs[peek]
	local is_hipfire_allowed_in_sprint = is_hipfire_input and has_hip_fire_buff

	if is_allowed or is_hipfire_allowed_in_sprint then
		return false
	end

	return peek ~= nil, peek
end

function _sideways_speed_function(speed, wanted_speed, acceleration, deceleration, dt)
	if wanted_speed == 0 then
		if speed > 0 then
			speed = math.max(speed - deceleration * dt, 0)
		else
			speed = math.min(speed + deceleration * dt, 0)
		end
	elseif wanted_speed > 0 then
		speed = math.min(speed + acceleration * dt, wanted_speed)
	else
		speed = math.max(speed - acceleration * dt, wanted_speed)
	end

	return speed
end

local WALK_SPEED_EPSILON = 0.1
local MOVE_SPEED = PlayerCharacterConstants.move_speed
local WALKING_SPEED_LIMIT = MOVE_SPEED - WALK_SPEED_EPSILON

function _forward_speed_function(speed, wanted_speed, acceleration, deceleration, dt)
	if wanted_speed == 0 then
		speed = math.max(speed - deceleration * dt, 0)
	elseif speed > 1 then
		speed = math.max(speed - deceleration * dt, 1)
	elseif wanted_speed > 0 then
		if speed < WALKING_SPEED_LIMIT then
			acceleration = acceleration * 4
		end

		local new_speed = math.min(speed + acceleration * dt, 1)

		speed = new_speed
	else
		local dec = deceleration * 3

		speed = math.max(speed - dec * dt, 0)
	end

	return speed
end

local _abort_sprint_table = {}

for i = 1, #ActionHandlerSettings.abort_sprint do
	local action_kind = ActionHandlerSettings.abort_sprint[i]

	_abort_sprint_table[action_kind] = true
end

function _abort_sprint(action_settings, has_allow_sprint_buff)
	if not action_settings then
		return false
	end

	local action_buff_keywords = action_settings.buff_keywords
	local buff_allows_sprint = has_allow_sprint_buff and action_buff_keywords and table.contains(action_buff_keywords, buff_keywords.allow_hipfire_during_sprint)
	local action_settings_abort_sprint = action_settings.abort_sprint

	if action_settings_abort_sprint ~= nil then
		return action_settings_abort_sprint and not buff_allows_sprint
	end

	local action_kind = action_settings.kind
	local action_kind_abort_sprint = _abort_sprint_table[action_kind]

	return action_kind_abort_sprint and not buff_allows_sprint
end

return PlayerCharacterStateSprinting
