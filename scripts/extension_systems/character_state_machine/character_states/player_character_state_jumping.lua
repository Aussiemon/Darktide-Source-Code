-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_jumping.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local LedgeVaulting = require("scripts/extension_systems/character_state_machine/character_states/utilities/ledge_vaulting")
local PlayerVoiceGrunts = require("scripts/utilities/player_voice_grunts")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Stamina = require("scripts/utilities/attack/stamina")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local VCE = "jump_vce"
local PlayerCharacterStateJumping = class("PlayerCharacterStateJumping", "PlayerCharacterStateBase")

PlayerCharacterStateJumping.init = function (self, ...)
	PlayerCharacterStateJumping.super.init(self, ...)

	local unit_data_ext = ScriptUnit.extension(self._unit, "unit_data_system")

	self._sprint_character_state_component = unit_data_ext:write_component("sprint_character_state")
	self._stamina_component = unit_data_ext:write_component("stamina")
	self._locomotion_component = unit_data_ext:read_component("locomotion")

	local ledge_vault_tweak_values = self._breed.ledge_vault_tweak_values

	self._ledge_vault_tweak_values = ledge_vault_tweak_values
end

PlayerCharacterStateJumping._play_jump_animation = function (self, animation_extension)
	local event_name_3p
	local input_ext = self._input_extension
	local move = input_ext:get("move")

	event_name_3p = Vector3.length_squared(move) > 0 and "jump_fwd" or "jump_idle"

	animation_extension:anim_event(event_name_3p)
	animation_extension:anim_event_1p("jump")
	PlayerVoiceGrunts.trigger_voice(VCE, self._visual_loadout_extension, self._fx_extension, false)

	self._step_up_done = false
end

PlayerCharacterStateJumping.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateJumping.super.on_enter(self, unit, dt, t, previous_state, params)

	local locomotion_steering = self._locomotion_steering_component

	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = false
	self._inair_state_component.on_ground = false

	local jump_velocity

	if previous_state == "ladder_climbing" then
		local ladder_unit = params.ladder_unit
		local direction = -Quaternion.forward(Unit.world_rotation(ladder_unit, 1))
		local is_distrupted = params.is_distrupted
		local constants = self._constants
		local force = is_distrupted and constants.ladder_distrupted_backwards_force or constants.ladder_jump_backwards_force

		jump_velocity = direction * force
	else
		local velocity_current = self._locomotion_component.velocity_current
		local weapon_extension = self._weapon_extension
		local action_move_speed_modifier = weapon_extension:move_speed_modifier(t)
		local jump_speed = self._constants.jump_speed

		if previous_state == "dodging" then
			velocity_current = Vector3.normalize(velocity_current)

			local modified_velocity = jump_speed * action_move_speed_modifier

			jump_velocity = Vector3(velocity_current.x * modified_velocity, velocity_current.y * modified_velocity, jump_speed)
		else
			local speed = Vector3.length(velocity_current)
			local speed_mod = speed == 0 and 0 or 5 / math.max(speed, 5)

			jump_velocity = Vector3(velocity_current.x * speed_mod, velocity_current.y * speed_mod, jump_speed)
		end
	end

	if previous_state == "sprinting" then
		local amount = 1

		Stamina.drain(unit, amount, t)
	end

	locomotion_steering.velocity_wanted = jump_velocity

	self:_play_jump_animation(self._animation_extension)

	self._movement_state_component.method = "jumping"
end

PlayerCharacterStateJumping.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateJumping.super.on_exit(self, unit, t, next_state)

	if not next_state then
		return
	end

	if next_state ~= "falling" then
		local sprint_character_state_component = self._sprint_character_state_component

		if sprint_character_state_component.is_sprint_jumping then
			sprint_character_state_component.is_sprint_jumping = false
		end

		local anim_ext = self._animation_extension

		anim_ext:anim_event("land_still")
		anim_ext:anim_event("to_onground")

		if next_state ~= "sprinting" then
			sprint_character_state_component.wants_sprint_camera = false
		end

		anim_ext:anim_event_1p("landing")
	end
end

PlayerCharacterStateJumping.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	self._weapon_extension:update_weapon_actions(fixed_frame)
	self._ability_extension:update_ability_actions(fixed_frame)

	local rotation = self._first_person_component.rotation
	local input_extension = self._input_extension
	local move = input_extension:get("move")
	local wanted_x = move.x
	local wanted_y = move.y
	local weapon_extension = self._weapon_extension
	local action_move_speed_modifier = weapon_extension:move_speed_modifier(t)
	local constants = self._constants
	local move_speed = constants.move_speed * action_move_speed_modifier
	local velocity_current = self._locomotion_component.velocity_current
	local move_settings = self._movement_settings_component
	local velocity_wanted = self:_air_movement(velocity_current, wanted_x, wanted_y, rotation, move_speed, move_settings.player_speed_scale, dt)
	local locomotion_steering = self._locomotion_steering_component
	local gravity_acceleration = self._constants.gravity
	local fall_speed = velocity_wanted.z - gravity_acceleration * dt

	velocity_wanted.z = fall_speed
	locomotion_steering.velocity_wanted = velocity_wanted

	local sprint_character_state_component = self._sprint_character_state_component

	if self._sprint_character_state_component.is_sprint_jumping then
		local flat_speed_sq = Vector3.length_squared(Vector3.flat(velocity_current))

		if flat_speed_sq < constants.sprint_jump_speed_threshold_sq then
			sprint_character_state_component.is_sprint_jumping = false
			sprint_character_state_component.wants_sprint_camera = false
		end
	end

	return self:_check_transition(unit, t, next_state_params, input_extension, velocity_current)
end

PlayerCharacterStateJumping._check_transition = function (self, unit, t, next_state_params, input_source, velocity_current)
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

	local character_state_component = self._character_state_component
	local previous_state_name = character_state_component.previous_state_name
	local dodge_jumping = previous_state_name == "dodging"

	if input_source:get("jump_held") and not dodge_jumping then
		local can_vault, ledge = LedgeVaulting.can_enter(self._ledge_finder_extension, self._ledge_vault_tweak_values, self._unit_data_extension, self._input_extension, self._visual_loadout_extension)

		if can_vault then
			next_state_params.ledge = ledge

			if self._sprint_character_state_component.is_sprint_jumping then
				next_state_params.was_sprinting = true
			end

			return "ledge_vaulting"
		end
	end

	local inair_state = self._inair_state_component

	if inair_state.on_ground then
		local weapon_action_component = self._weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)
		local sprint_character_state_component = self._sprint_character_state_component

		if Sprint.check(t, unit, self._movement_state_component, sprint_character_state_component, input_source, self._locomotion_component, weapon_action_component, self._combat_ability_action_component, self._alternate_fire_component, weapon_template, self._constants) then
			if sprint_character_state_component.is_sprint_jumping then
				next_state_params.disable_sprint_start_slowdown = true
			end

			return "sprinting"
		else
			return "walking"
		end
	end

	if velocity_current.z <= 0 then
		return "falling"
	end

	local is_colliding, ladder_unit = self:_should_climb_ladder(unit, t)

	if is_colliding then
		next_state_params.ladder_unit = ladder_unit

		return "ladder_climbing"
	end
end

return PlayerCharacterStateJumping
