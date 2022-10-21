require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local AcceleratedLocalSpaceMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/accelerated_local_space_movement")
local ActionHandlerSettings = require("scripts/settings/action/action_handler_settings")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interrupt = require("scripts/utilities/attack/interrupt")
local LedgeVaulting = require("scripts/extension_systems/character_state_machine/character_states/utilities/ledge_vaulting")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local Action = require("scripts/utilities/weapon/action")
local slot_configuration = PlayerCharacterConstants.slot_configuration
local FOOTSTEP_SOUND_ALIAS = "footstep"
local UPPER_BODY_FOLEY = "sfx_foley_upper_body"
local WEAPON_FOLEY = "sfx_weapon_locomotion"
local EXTRA_FOLEY = "sfx_player_extra_slot"
local PlayerCharacterStateSprinting = class("PlayerCharacterStateSprinting", "PlayerCharacterStateBase")
local _sideways_speed_function, _forward_speed_function, _abort_sprint = nil

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
	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true
	local sprint_character_state_component = self._sprint_character_state_component
	sprint_character_state_component.is_sprinting = true
	sprint_character_state_component.wants_sprint_camera = true
	sprint_character_state_component.sprint_overtime = 0
	local ignore_immunity = true

	Interrupt.ability_and_action(t, unit, "started_sprint", nil, ignore_immunity)
	AcceleratedLocalSpaceMovement.refresh_local_move_variables(self._archetype_sprint_template.sprint_move_speed, locomotion_steering, self._locomotion_component, self._first_person_component)
	Stamina.set_regeneration_paused(self._stamina_component, true)

	local inventory_component = self._inventory_component
	local wielded_slot = inventory_component.wielded_slot

	if wielded_slot ~= "none" then
		local slot_type = slot_configuration[wielded_slot].slot_type

		if slot_type == "ability" and not wielded_slot == "slot_grenade_ability" then
			PlayerUnitVisualLoadout.wield_previous_weapon_slot(inventory_component, unit, t)
		end
	end

	self._previous_velocity_move_speed = nil
end

PlayerCharacterStateSprinting.on_exit = function (self, unit, t, next_state)
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
	local archetype_sprint_template = self._archetype_sprint_template
	local constants = self._constants
	local move_settings = self._movement_settings_component
	local weapon_extension = self._weapon_extension

	weapon_extension:update_weapon_actions(fixed_frame)
	self._ability_extension:update_ability_actions(fixed_frame)

	local input_extension = self._input_extension
	local sprint_input = Sprint.sprint_input(input_extension, true)
	local has_any_queued_input = self._action_input_extension:has_any_queued_input()
	local wants_sprint = sprint_input and not has_any_queued_input
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local stat_buffs = buff_extension:stat_buffs()
	local move_direction, move_speed, new_x, new_y, wants_to_stop = self:_wanted_movement(dt, input_extension, locomotion_steering, locomotion, move_settings, self._first_person_component, wants_sprint, weapon_extension, stat_buffs, t)
	local old_y = locomotion_steering.local_move_y
	local decreasing_speed = new_y < old_y
	local action_move_speed_modifier = weapon_extension:move_speed_modifier(t)
	local actual_move_speed = move_speed * action_move_speed_modifier
	actual_move_speed = actual_move_speed * stat_buffs.movement_speed * stat_buffs.sprint_movement_speed
	locomotion_steering.velocity_wanted = move_direction * actual_move_speed
	locomotion_steering.local_move_x = new_x
	locomotion_steering.local_move_y = new_y
	local movement_state = self._movement_state_component
	local old_method = movement_state.method
	local sprint_move_speed = archetype_sprint_template.sprint_move_speed
	local new_method, wants_sprint_camera = nil

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

	local sprint_component = self._sprint_character_state_component
	sprint_component.wants_sprint_camera = wants_sprint_camera
	local animation_ext = self._animation_extension

	Crouch.check(unit, self._first_person_extension, animation_ext, weapon_extension, self._movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, input_extension, t)

	if old_method ~= new_method then
		animation_ext:anim_event(new_method)

		movement_state.method = new_method

		animation_ext:anim_event_1p(new_method)
	end

	local run_move_speed = constants.move_speed
	local sprint_momentum = math.max((move_speed - run_move_speed) / (sprint_move_speed - run_move_speed), 0)
	local wants_slide = self._movement_state_component.is_crouching

	return self:_check_transition(unit, t, next_state_params, input_extension, decreasing_speed, actual_move_speed, action_move_speed_modifier, sprint_momentum, wants_slide, wants_to_stop, has_any_queued_input)
end

PlayerCharacterStateSprinting.update = function (self, unit, dt, t)
	self:_update_footsteps_and_foley(t, FOOTSTEP_SOUND_ALIAS, UPPER_BODY_FOLEY, WEAPON_FOLEY, EXTRA_FOLEY)
end

PlayerCharacterStateSprinting._check_transition = function (self, unit, t, next_state_params, input_source, decreasing_speed, move_speed, action_move_speed_modifier, sprint_momentum, wants_slide, wants_to_stop, has_any_queued_input)
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

	if self:_is_wielding_minigame_device() then
		return "minigame"
	end

	if input_source:get("jump") and self._movement_state_component.can_jump then
		local can_vault, ledge = LedgeVaulting.can_enter(self._ledge_finder_extension, self._ledge_vault_tweak_values, self._unit_data_extension, self._input_extension, self._visual_loadout_extension)

		if can_vault then
			next_state_params.ledge = ledge

			return "ledge_vaulting"
		else
			return "jumping"
		end
	end

	local inair_state = self._inair_state_component

	if not inair_state.on_ground then
		return "falling"
	end

	if wants_slide then
		return "sliding"
	end

	local is_colliding, ladder_unit, climb_state = self:_should_climb_ladder(unit, t)

	if is_colliding then
		next_state_params.ladder_unit = ladder_unit

		return climb_state
	end

	local weapon_template = PlayerUnitVisualLoadout.wielded_weapon_template(self._visual_loadout_extension, self._inventory_component)

	if wants_to_stop then
		if has_any_queued_input then
			self._sprint_character_state_component.cooldown = t + weapon_template.sprint_ready_up_time
		end

		return "walking"
	end

	local _, action_setting = Action.current_action(self._weapon_action_component, weapon_template)
	local abort_sprint = _abort_sprint(action_setting)

	if abort_sprint then
		return "walking"
	end

	return nil
end

PlayerCharacterStateSprinting._wanted_movement = function (self, dt, input_source, locomotion_steering, locomotion, movement_settings_component, first_person_component, wants_sprint, weapon_extension, stat_buffs, t)
	local move_input = input_source:get("move")
	local wanted_x = move_input.x
	local wanted_y = move_input.y

	if wanted_y > 0 and not wants_sprint then
		wanted_y = 0
	end

	local current_x = locomotion_steering.local_move_x
	local current_y = locomotion_steering.local_move_y
	local constants = self._constants
	local archetype_sprint_template = self._archetype_sprint_template
	local weapon_sprint_template = weapon_extension:sprint_template()
	local side_acc = weapon_sprint_template and weapon_sprint_template.sprint_sideway_acceleration or 1
	local side_dec = weapon_sprint_template and weapon_sprint_template.sprint_sideway_deceleration or 1
	local new_x = _sideways_speed_function(current_x, wanted_x, side_acc, side_dec, dt)
	local normal_move_speed = constants.move_speed
	local weapon_sprint_speed_mod = weapon_sprint_template and weapon_sprint_template.sprint_speed_mod or 1
	local weapon_no_stamina_sprint_speed_mod = weapon_sprint_template and weapon_sprint_template.no_stamina_sprint_speed_mod or 1
	local sprint_move_speed = archetype_sprint_template.sprint_move_speed
	local max_x = normal_move_speed / sprint_move_speed
	new_x = math.clamp(new_x, -max_x, max_x)
	local acc = weapon_sprint_template and weapon_sprint_template.sprint_forward_acceleration or 1
	local dec = weapon_sprint_template and weapon_sprint_template.sprint_forward_deceleration or 1
	local new_y = _forward_speed_function(current_y, wanted_y, acc, dec, dt)
	local stopped = new_x == 0 and new_y == 0
	local speed_scale = stopped and 0 or math.sqrt(math.min(1, new_x * new_x + new_y * new_y))
	local time_in_sprint = t - self._character_state_component.entered_t
	local slowdown_time = 0.11
	local speed_mod = math.clamp(time_in_sprint, 0, slowdown_time) / slowdown_time
	speed_scale = speed_scale * speed_mod
	local max_move_speed = sprint_move_speed + weapon_sprint_speed_mod
	local archetype_stamina_template = self._archetype_stamina_template
	local weapon_stamina_template = self._weapon_extension:stamina_template()
	local base_cost_per_second = weapon_stamina_template and weapon_stamina_template.sprint_cost_per_second or math.huge
	local buff_cost_multiplier = stat_buffs.sprinting_cost_multiplier
	local cost_per_second = base_cost_per_second * buff_cost_multiplier
	local remaining_stamina = Stamina.drain(self._unit, cost_per_second * dt, t)
	local sprint_overtime_percentage = 0

	if remaining_stamina <= 0 then
		local previus_overtime = self._sprint_character_state_component.sprint_overtime
		local overtime = previus_overtime + dt
		self._sprint_character_state_component.sprint_overtime = overtime
		local no_stamina_sprint_speed_multiplier = archetype_stamina_template.no_stamina_sprint_speed_multiplier + weapon_no_stamina_sprint_speed_mod - 1
		local no_stamina_sprint_speed_deceleration_time = archetype_stamina_template.no_stamina_sprint_speed_deceleration_time
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

	return move_direction, move_speed, new_x, new_y, wants_to_stop
end

PlayerCharacterStateSprinting._check_bump_sound = function (self, locomotion, locomotion_steering, archetype_sprint_template, constants)
	local current_velocity_flat = Vector3.flat(locomotion.velocity_current)
	local current_velocity_move_speed = Vector3.length(current_velocity_flat)
	local previous_velocity_move_speed = self._previous_velocity_move_speed

	if previous_velocity_move_speed then
		local base_move_speed = constants.move_speed
		local sprint_move_speed = archetype_sprint_template.sprint_move_speed
		local sprint_range = sprint_move_speed - base_move_speed
		local above_velocity_threshold = previous_velocity_move_speed >= base_move_speed + sprint_range * 0.5
		local lost_enough_move_speed = (previous_velocity_move_speed - current_velocity_move_speed) / previous_velocity_move_speed >= 0.3

		if above_velocity_threshold and lost_enough_move_speed then
			local velocity_wanted_dir = Vector3.normalize(Vector3.flat(locomotion_steering.velocity_wanted))
			local position = self._first_person_component.position + velocity_wanted_dir
			local rotation = Quaternion.look(-velocity_wanted_dir, Vector3.up())

			self._fx_extension:trigger_wwise_event("wwise/events/player/play_sprint_bump", false, position, rotation)
		end
	end

	self._previous_velocity_move_speed = current_velocity_move_speed
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

function _forward_speed_function(speed, wanted_speed, acceleration, deceleration, dt)
	if wanted_speed == 0 then
		speed = math.max(speed - deceleration * dt, 0)
	elseif speed > 1 then
		speed = math.max(speed - deceleration * dt, 1)
	elseif wanted_speed > 0 then
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

function _abort_sprint(action_settings)
	if not action_settings then
		return false
	end

	local action_settings_abort_sprint = action_settings.abort_sprint

	if action_settings_abort_sprint ~= nil then
		return action_settings_abort_sprint
	end

	local action_kind = action_settings.kind
	local action_kind_abort_sprint = _abort_sprint_table[action_kind]

	return action_kind_abort_sprint
end

return PlayerCharacterStateSprinting
