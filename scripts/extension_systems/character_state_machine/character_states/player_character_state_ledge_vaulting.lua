local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local Interrupt = require("scripts/utilities/attack/interrupt")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local PlayerCharacterStateLedgeVaulting = class("PlayerCharacterStateLedgeVaulting", "PlayerCharacterStateBase")

PlayerCharacterStateLedgeVaulting.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateLedgeVaulting.super.init(self, character_state_init_context, ...)

	self._locomotion_extension = ScriptUnit.extension(self._unit, "locomotion_system")
	local unit_data = character_state_init_context.unit_data
	local ledge_vaulting_character_state_component = unit_data:write_component("ledge_vaulting_character_state")
	self._ledge_vaulting_character_state_component = ledge_vaulting_character_state_component
	ledge_vaulting_character_state_component.left = Vector3.zero()
	ledge_vaulting_character_state_component.right = Vector3.zero()
	ledge_vaulting_character_state_component.forward = Vector3.zero()
	ledge_vaulting_character_state_component.traverse_velocity = Vector3.zero()
	ledge_vaulting_character_state_component.is_step_up = false
	ledge_vaulting_character_state_component.was_sprinting = false
	self._ledge_vault_tweak_values = self._breed.ledge_vault_tweak_values
	self._sway_control_component = unit_data:write_component("sway_control")
	self._spread_control_component = unit_data:write_component("spread_control")
end

local LEDGE_TRAVERSE_SPEED = 4
local HEIGHT_DISTANCE_CONSIDERED_VAULT = 0.9
local HEIGHT_DISTANCE_CONSIDERED_VAULT_FROM_AIRBORNE = 0.9

PlayerCharacterStateLedgeVaulting.on_enter = function (self, unit, dt, t, previous_state, params)
	local ledge = params.ledge
	local ledge_vaulting = self._ledge_vaulting_character_state_component
	local left_point = ledge.left:unbox()
	local right_point = ledge.right:unbox()
	ledge_vaulting.left = left_point
	ledge_vaulting.right = right_point
	local forward = ledge.forward:unbox()
	ledge_vaulting.forward = forward
	ledge_vaulting.was_sprinting = params.was_sprinting or false
	local enter_velocity = self._locomotion_component.velocity_current
	local enter_velocity_flat = Vector3.flat(enter_velocity)
	local speed = Vector3.length(enter_velocity_flat)
	local first_person_rotation = self._first_person_component.rotation
	local fp_forward = Quaternion.forward(first_person_rotation)
	local fp_forward_flat = Vector3.normalize(Vector3.flat(fp_forward))
	local traverse_dir = fp_forward_flat

	if speed <= LEDGE_TRAVERSE_SPEED then
		ledge_vaulting.traverse_velocity = traverse_dir * LEDGE_TRAVERSE_SPEED
	else
		ledge_vaulting.traverse_velocity = traverse_dir * speed * 0.9
	end

	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.calculate_fall_velocity = false
	locomotion_steering.move_method = "script_driven"
	local movement_state = self._movement_state_component
	movement_state.method = "vaulting"
	local first_person_extension = self._first_person_extension
	local animation_extension = self._animation_extension

	if not movement_state.is_crouching then
		Crouch.enter(unit, first_person_extension, animation_extension, self._weapon_extension, movement_state, self._sway_control_component, self._sway_component, self._spread_control_component, t)
	end

	first_person_extension:set_wanted_player_height("vault", 0.5)

	local ledge_vault_tweak_values = self._breed.ledge_vault_tweak_values
	local is_step_up = nil

	if ledge_vault_tweak_values.always_step_up then
		is_step_up = true
	else
		local comparison = nil

		if previous_state == "jumping" or previous_state == "falling" then
			comparison = HEIGHT_DISTANCE_CONSIDERED_VAULT_FROM_AIRBORNE
		else
			comparison = HEIGHT_DISTANCE_CONSIDERED_VAULT
		end

		local height_distance = ledge.height_distance_from_player_unit
		is_step_up = height_distance < comparison
	end

	ledge_vaulting.is_step_up = is_step_up

	if is_step_up then
		local first_person_unit = self._first_person_extension:first_person_unit()

		if Unit.has_animation_event(first_person_unit, "step_up_start") then
			animation_extension:anim_event_1p("step_up_start")
		end
	else
		local weapon_template = WeaponTemplate.current_weapon_template(self._weapon_action_component)

		if not weapon_template.can_use_while_vaulting then
			local reason_data = nil
			local ignore_immunity = true

			Interrupt.ability_and_action(t, unit, "ledge_vaulting", reason_data, ignore_immunity)
			PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)
		end

		local first_person_unit = self._first_person_extension:first_person_unit()

		if Unit.has_animation_event(first_person_unit, "vault_start") then
			animation_extension:anim_event_1p("vault_start")
		end
	end

	if not is_step_up then
		local ledge_mid_point = Vector3.lerp(left_point, right_point, 0.5)

		self:_play_on_enter_vault_event(ledge_mid_point, ledge.material_or_nil)
	end

	self._movement_state_component.is_dodging = true
end

PlayerCharacterStateLedgeVaulting._play_on_enter_vault_event = function (self, ledge_mid_point, ledge_material_or_nil)
	local _, event_name, has_husk_events = self._visual_loadout_extension:resolve_gear_sound("player_vault")
	local append_husk_to_event_name = has_husk_events
	local is_predicted = true
	local switch_name = "surface_material"
	local switch_value = ledge_material_or_nil or "default"

	self._fx_extension:trigger_wwise_event_synced(event_name, append_husk_to_event_name, is_predicted, nil, nil, nil, ledge_mid_point, nil, nil, nil, switch_name, switch_value)
end

PlayerCharacterStateLedgeVaulting.on_exit = function (self, unit, t, next_state)
	local ledge_vaulting = self._ledge_vaulting_character_state_component
	local animation_extension = self._animation_extension

	if ledge_vaulting.is_step_up then
		local first_person_unit = self._first_person_extension:first_person_unit()

		if Unit.has_animation_event(first_person_unit, "step_up_end") then
			animation_extension:anim_event_1p("step_up_end")
		end
	else
		local first_person_unit = self._first_person_extension:first_person_unit()

		if Unit.has_animation_event(first_person_unit, "vault_end") then
			animation_extension:anim_event_1p("vault_end")
		end

		local weapon_template = WeaponTemplate.current_weapon_template(self._weapon_action_component)

		if not weapon_template.can_use_while_vaulting then
			PlayerUnitVisualLoadout.wield_previous_slot(self._inventory_component, unit, t)
		end
	end

	self._locomotion_steering_component.calculate_fall_velocity = true
	local movement_state_component = self._movement_state_component
	local is_crouching = movement_state_component.is_crouching
	local first_person_extension = self._first_person_extension

	if is_crouching and next_state ~= "sliding" and Crouch.can_exit(unit) then
		Crouch.exit(unit, first_person_extension, animation_extension, self._weapon_extension, self._movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, t)

		is_crouching = false
	end

	if is_crouching then
		first_person_extension:set_wanted_player_height("crouch", 0.3)
	else
		first_person_extension:set_wanted_player_height("default", 1)
	end

	self._movement_state_component.is_dodging = false
end

local LEDGE_CLIMB_SPEED = 3.6
local PASSED_BY_LEDGE_DISTANCE = 0.4
local PASSED_BY_LEDGE_DISTANCE_SQ = PASSED_BY_LEDGE_DISTANCE * PASSED_BY_LEDGE_DISTANCE
local ABOVE_LEDGENESS = 0.05

PlayerCharacterStateLedgeVaulting.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local locomotion = self._locomotion_component
	local locomotion_steering = self._locomotion_steering_component
	local player_position = locomotion.position
	local ledge_vaulting = self._ledge_vaulting_character_state_component
	local weapon_template = WeaponTemplate.current_weapon_template(self._weapon_action_component)

	if ledge_vaulting.is_step_up or weapon_template.can_use_while_vaulting then
		self._weapon_extension:update_weapon_actions(fixed_frame)
		self._ability_extension:update_ability_actions(fixed_frame)
	end

	local left = ledge_vaulting.left
	local right = ledge_vaulting.right
	local forward = ledge_vaulting.forward
	local mid_point = Vector3.lerp(left, right, 0.5)
	local velocity_wanted = ledge_vaulting.traverse_velocity
	local still_below_ledge = ABOVE_LEDGENESS < mid_point.z - player_position.z

	if still_below_ledge then
		velocity_wanted.z = LEDGE_CLIMB_SPEED
	end

	locomotion_steering.velocity_wanted = velocity_wanted
	local mid_point_flat = Vector3.flat(mid_point)
	local player_position_flat = Vector3.flat(player_position)
	local distance_to_ledge_flat_sq = Vector3.distance_squared(mid_point_flat, player_position_flat)
	local player_to_ledge_dir = Vector3.flat(Vector3.normalize(mid_point - player_position))
	local dot = Vector3.dot(player_to_ledge_dir, forward)
	local passed_by_ledge = dot < 0

	if passed_by_ledge and not locomotion_steering.calculate_fall_velocity then
		locomotion_steering.calculate_fall_velocity = true
	end

	local passed_by_ledge_and_enough_distance = passed_by_ledge and PASSED_BY_LEDGE_DISTANCE_SQ <= distance_to_ledge_flat_sq

	return self:_check_transition(unit, t, next_state_params, passed_by_ledge_and_enough_distance, weapon_template)
end

local LEDGE_CLIMB_TIMEOUT = 0.8

PlayerCharacterStateLedgeVaulting._check_transition = function (self, unit, t, next_state_params, passed_by_ledge, weapon_template)
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

	local time_in_state = t - self._character_state_component.entered_t

	if passed_by_ledge or LEDGE_CLIMB_TIMEOUT < time_in_state then
		if self._inair_state_component.on_ground then
			local movement_state_component = self._movement_state_component
			local input_extension = self._input_extension
			local is_crouching = Crouch.check(unit, self._first_person_extension, self._animation_extension, self._weapon_extension, movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, input_extension, t)
			local locomotion_component = self._locomotion_component
			local velocity_current = locomotion_component.velocity_current
			local look_rotation = self._first_person_component.rotation
			local flat_look_direction = Vector3.normalize(Vector3.flat(Quaternion.forward(look_rotation)))
			local wants_slide = is_crouching and self._constants.slide_move_speed_threshold < Vector3.dot(velocity_current, flat_look_direction)

			if wants_slide then
				if self._ledge_vaulting_character_state_component.was_sprinting then
					next_state_params.friction_function = "sprint"
				end

				return "sliding"
			elseif Sprint.check(t, unit, movement_state_component, self._sprint_character_state_component, input_extension, locomotion_component, self._weapon_action_component, self._alternate_fire_component, weapon_template, self._constants) then
				if self._ledge_vaulting_character_state_component.was_sprinting then
					next_state_params.disable_sprint_start_slowdown = true
				end

				return "sprinting"
			else
				return "walking"
			end
		else
			return "falling"
		end
	end

	return nil
end

return PlayerCharacterStateLedgeVaulting
