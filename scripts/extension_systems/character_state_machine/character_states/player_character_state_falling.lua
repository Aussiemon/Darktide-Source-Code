require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local AcceleratedLocalSpaceMovement = require("scripts/extension_systems/character_state_machine/character_states/utilities/accelerated_local_space_movement")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local Fall = require("scripts/extension_systems/character_state_machine/character_states/utilities/fall")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local LedgeVaulting = require("scripts/extension_systems/character_state_machine/character_states/utilities/ledge_vaulting")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Vo = require("scripts/utilities/vo")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local FOOTSTEP_LAND_SOUND_ALIAS = "footstep_land"
local UPPER_BODY_FOLEY = "sfx_foley_upper_body"
local WEAPON_FOLEY = "sfx_weapon_locomotion"
local EXTRA_FOLEY = "sfx_player_extra_slot"
local PlayerCharacterStateFalling = class("PlayerCharacterStateFalling", "PlayerCharacterStateBase")

PlayerCharacterStateFalling.init = function (self, ...)
	PlayerCharacterStateFalling.super.init(self, ...)

	local unit_data_extension = self._unit_data_extension
	self._sprint_character_state_component = unit_data_extension:write_component("sprint_character_state")
	local falling_character_state_component = unit_data_extension:write_component("falling_character_state")
	falling_character_state_component.was_ledge_hanging = false
	falling_character_state_component.has_reached_damagable_distance = false
	local ledge_vault_tweak_values = self._breed.ledge_vault_tweak_values
	self._ledge_vault_tweak_values = ledge_vault_tweak_values
	self._falling_character_state_component = falling_character_state_component
end

local FALLING_ANIM_EVENT_3P = "to_inair"
local FALLING_ANIM_EVENT_1P = "in_air_fall"

PlayerCharacterStateFalling.on_enter = function (self, unit, dt, t, previous_state, params)
	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true
	local anim_extension = self._animation_extension

	anim_extension:anim_event(FALLING_ANIM_EVENT_3P)
	anim_extension:anim_event_1p(FALLING_ANIM_EVENT_1P)

	self._movement_state_component.method = "falling"
	local falling_character_state_component = self._falling_character_state_component
	falling_character_state_component.was_ledge_hanging = previous_state == "ledge_hanging"
	falling_character_state_component.has_reached_damagable_distance = false

	Fall.set_fall_height(self._locomotion_component, self._inair_state_component)
end

PlayerCharacterStateFalling.on_exit = function (self, unit, t, next_state)
	if not next_state then
		return
	end

	local fx_extension = self._fx_extension
	local locomotion_component = self._locomotion_component
	local inair_state_component = self._inair_state_component
	local constants = self._constants
	local fall_damage_settings = constants.fall_damage
	local time_in_falling = t - self._character_state_component.entered_t
	local rtpc_parameter_value = math.min(1, time_in_falling / 1.5)

	fx_extension:set_source_parameter("player_fall_time", rtpc_parameter_value, "hips")
	Vo.player_land_event(unit, time_in_falling)
	self:_trigger_footstep_and_foley(FOOTSTEP_LAND_SOUND_ALIAS, UPPER_BODY_FOLEY, WEAPON_FOLEY, EXTRA_FOLEY)

	local animation_ext = self._animation_extension
	local move = self._input_extension:get("move")
	local forward = move.y == 1 or move.x ~= 0
	local backward = move.y == -1

	if forward then
		animation_ext:anim_event("land_moving_fwd")
	elseif backward then
		animation_ext:anim_event("land_moving_bwd")
	else
		animation_ext:anim_event("land_still")
	end

	animation_ext:anim_event("to_onground")

	if next_state ~= "sprinting" then
		self._sprint_character_state_component.wants_sprint_camera = false
	end

	animation_ext:anim_event_1p("landing")
	Fall.trigger_impact_sound(unit, fx_extension, constants, locomotion_component, inair_state_component)
	Fall.set_fall_height(locomotion_component, inair_state_component)

	local event_name = fall_damage_settings.warning_wwise_stop_event

	fx_extension:trigger_exclusive_wwise_event(event_name)

	self._falling_character_state_component.has_reached_damagable_distance = false
end

PlayerCharacterStateFalling.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local locomotion = self._locomotion_component
	local locomotion_steering = self._locomotion_steering_component

	self._weapon_extension:update_weapon_actions(fixed_frame)
	self._ability_extension:update_ability_actions(fixed_frame)

	local velocity_current = locomotion.velocity_current
	local rotation = self._first_person_component.rotation
	local input_extension = self._input_extension
	local move = input_extension:get("move")
	local wanted_x = move.x
	local wanted_y = move.y
	local constants = self._constants
	local move_speed = constants.move_speed
	local move_settings = self._movement_settings_component
	local velocity_wanted = self:_air_movement(velocity_current, wanted_x, wanted_y, rotation, move_speed, move_settings.player_speed_scale, dt)
	locomotion_steering.velocity_wanted = velocity_wanted

	self:_update_falling_sound()

	local locomotion_component = self._locomotion_component
	local inair_state_component = self._inair_state_component

	if self._is_server then
		Fall.check_damage(unit, constants, locomotion_component, inair_state_component)
	end

	return self:_check_transition(unit, t, next_state_params, input_extension)
end

PlayerCharacterStateFalling._update_falling_sound = function (self)
	local falling_character_state_component = self._falling_character_state_component
	local locomotion_component = self._locomotion_component
	local inair_state_component = self._inair_state_component
	local fx_extension = self._fx_extension
	local constants = self._constants
	local fall_damage_settings = constants.fall_damage
	local warning_height = fall_damage_settings.warning_height
	local has_reached_damagable_distance = falling_character_state_component.has_reached_damagable_distance

	if not has_reached_damagable_distance and warning_height < Fall.fall_distance(locomotion_component, inair_state_component) then
		local event_name = fall_damage_settings.warning_wwise_event

		fx_extension:trigger_exclusive_wwise_event(event_name)

		self._falling_character_state_component.has_reached_damagable_distance = true
	end
end

PlayerCharacterStateFalling._check_transition = function (self, unit, t, next_state_params, input_source)
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

	if is_colliding_on_hang_ledge and not self._falling_character_state_component.was_ledge_hanging then
		next_state_params.hang_ledge_unit = hang_ledge_unit

		return "ledge_hanging"
	end

	local is_colliding_on_ladder, ladder_unit = self:_should_climb_ladder(unit, t)

	if is_colliding_on_ladder then
		next_state_params.ladder_unit = ladder_unit

		return "ladder_climbing"
	end

	if input_source:get("jump_held") then
		local can_vault, ledge = LedgeVaulting.can_enter(self._ledge_finder_extension, self._ledge_vault_tweak_values, self._unit_data_extension, self._input_extension, self._visual_loadout_extension)

		if can_vault then
			next_state_params.ledge = ledge

			return "ledge_vaulting"
		end
	end

	local inair_state = self._inair_state_component

	if inair_state.on_ground then
		local weapon_action_component = self._weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

		if Sprint.check(t, unit, self._movement_state_component, self._sprint_character_state_component, input_source, self._locomotion_component, weapon_action_component, self._alternate_fire_component, weapon_template, self._constants) then
			return "sprinting"
		else
			return "walking"
		end
	end
end

return PlayerCharacterStateFalling
