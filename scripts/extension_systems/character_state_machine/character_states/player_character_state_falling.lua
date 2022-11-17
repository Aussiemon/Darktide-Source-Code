require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local Fall = require("scripts/extension_systems/character_state_machine/character_states/utilities/fall")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local LedgeVaulting = require("scripts/extension_systems/character_state_machine/character_states/utilities/ledge_vaulting")
local Sprint = require("scripts/extension_systems/character_state_machine/character_states/utilities/sprint")
local Vo = require("scripts/utilities/vo")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local PlayerCharacterStateFalling = class("PlayerCharacterStateFalling", "PlayerCharacterStateBase")

PlayerCharacterStateFalling.init = function (self, ...)
	PlayerCharacterStateFalling.super.init(self, ...)

	local unit_data_extension = self._unit_data_extension
	self._sprint_character_state_component = unit_data_extension:write_component("sprint_character_state")
	local falling_character_state_component = unit_data_extension:write_component("falling_character_state")
	falling_character_state_component.was_ledge_hanging = false
	falling_character_state_component.has_reached_damagable_distance = false
	falling_character_state_component.likely_stuck = false
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
	local ledge_vault_tweak_values = self._breed.ledge_vault_tweak_values
	self._ledge_vault_tweak_values = ledge_vault_tweak_values
	self._falling_character_state_component = falling_character_state_component

	if self._is_server then
		self._likely_stuck_timer = 0
		self._last_position_z = 0
		local up = Vector3.up()
		local tau = math.pi * 2
		self._likely_stuck_directions = {
			Vector3Box(Quaternion.forward(Quaternion(up, tau * 0 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, tau * 4 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, tau * 1 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, tau * 5 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, tau * 2 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, tau * 6 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, tau * 3 / 8))),
			Vector3Box(Quaternion.forward(Quaternion(up, tau * 7 / 8)))
		}
		self._raycast_object = PhysicsWorld.make_raycast(self._physics_world, "closest", "types", "statics", "collision_filter", "filter_player_mover")
	end
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

	if self._is_server then
		self._likely_stuck_timer = 0
		self._last_position_z = self._locomotion_component.position.z
	end
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

	local movement_state_component = self._movement_state_component
	local was_crouching = movement_state_component.is_crouching
	local is_crouching = Crouch.check(unit, self._first_person_extension, self._animation_extension, self._weapon_extension, movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, self._input_extension, t)

	if was_crouching and is_crouching then
		animation_ext:anim_event("to_crouch")
	elseif not is_crouching then
		animation_ext:anim_event("to_onground")
	end

	local sprint_character_state_component = self._sprint_character_state_component
	sprint_character_state_component.wants_sprint_camera = false
	sprint_character_state_component.is_sprint_jumping = false

	animation_ext:anim_event_1p("landing")

	if next_state == "sliding" then
		Crouch.enter(unit, self._first_person_extension, animation_ext, self._weapon_extension, self._movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, t)
	end

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
	local sprint_character_state_component = self._sprint_character_state_component

	if self._sprint_character_state_component.is_sprint_jumping then
		local flat_speed_sq = Vector3.length_squared(Vector3.flat(velocity_current))

		if flat_speed_sq < constants.move_speed_sq then
			sprint_character_state_component.is_sprint_jumping = false
			sprint_character_state_component.wants_sprint_camera = false
		end
	end

	local weapon_extension = self._weapon_extension
	local action_move_speed_modifier = weapon_extension:move_speed_modifier(t)
	local move_speed = constants.move_speed * action_move_speed_modifier
	local move_settings = self._movement_settings_component
	local velocity_wanted = self:_air_movement(velocity_current, wanted_x, wanted_y, rotation, move_speed, move_settings.player_speed_scale, dt)
	locomotion_steering.velocity_wanted = velocity_wanted

	self:_update_falling_sound()

	local locomotion_component = self._locomotion_component
	local inair_state_component = self._inair_state_component

	if self._is_server then
		Fall.check_damage(unit, constants, locomotion_component, inair_state_component)
		self:_update_likely_stuck_hack(locomotion_component, dt, t, fixed_frame, input_extension)
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

local RAY_LENGTH = 0.8

PlayerCharacterStateFalling._stuck_ray = function (self, position, direction)
	local hit = Raycast.cast(self._raycast_object, position, direction, RAY_LENGTH)

	return hit
end

PlayerCharacterStateFalling._verify_stuckness = function (self, position)
	local likely_stuck_directions = self._likely_stuck_directions

	for i = 1, #likely_stuck_directions, 2 do
		if self:_stuck_ray(position, likely_stuck_directions[i]:unbox()) and self:_stuck_ray(position, likely_stuck_directions[i + 1]:unbox()) then
			return true
		end
	end

	return false
end

local STUCK_TIME = 0.2
local STUCK_EPS = 0.001

PlayerCharacterStateFalling._update_likely_stuck_hack = function (self, locomotion_component, dt, t, fixed_frame, input_extension)
	local position = locomotion_component.position
	local z = position.z
	local last_position_z = self._last_position_z
	local diff = math.abs(z - last_position_z)

	if diff < STUCK_EPS then
		self._likely_stuck_timer = math.min(self._likely_stuck_timer + dt, STUCK_TIME + 0.2)
	else
		self._likely_stuck_timer = math.max(self._likely_stuck_timer - dt, 0)
	end

	local likely_stuck = STUCK_TIME <= self._likely_stuck_timer
	self._last_position_z = z

	if likely_stuck and not self:_verify_stuckness(position) then
		likely_stuck = false
	end

	self._falling_character_state_component.likely_stuck = likely_stuck
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

			if self._sprint_character_state_component.is_sprint_jumping then
				next_state_params.was_sprinting = true
			end

			return "ledge_vaulting"
		end
	end

	local inair_state = self._inair_state_component

	if inair_state.on_ground then
		local wants_crouch = Crouch.crouch_input(input_source, self._movement_state_component.is_crouching, false)
		local locomotion_component = self._locomotion_component
		local flat_speed_sq = Vector3.length_squared(Vector3.flat(locomotion_component.velocity_current))
		local wants_slide = wants_crouch and self._constants.slide_move_speed_threshold_sq < flat_speed_sq
		local sprint_character_state_component = self._sprint_character_state_component
		local is_sprint_jumping = sprint_character_state_component.is_sprint_jumping
		local weapon_action_component = self._weapon_action_component
		local weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

		if wants_slide then
			if is_sprint_jumping then
				next_state_params.friction_function = "sprint"
			end

			return "sliding"
		elseif Sprint.check(t, unit, self._movement_state_component, sprint_character_state_component, input_source, locomotion_component, weapon_action_component, self._combat_ability_action_component, self._alternate_fire_component, weapon_template, self._constants) then
			if is_sprint_jumping then
				next_state_params.disable_sprint_start_slowdown = true
			end

			return "sprinting"
		else
			return "walking"
		end
	end

	local disable_likely_stuck = false

	if not disable_likely_stuck and self._falling_character_state_component.likely_stuck and input_source:get("jump") then
		return "jumping"
	end
end

return PlayerCharacterStateFalling
