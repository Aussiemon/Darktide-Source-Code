-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_sliding.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local Dodge = require("scripts/extension_systems/character_state_machine/character_states/utilities/dodge")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local HitMass = require("scripts/utilities/attack/hit_mass")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LagCompensation = require("scripts/utilities/lag_compensation")
local MaterialQuery = require("scripts/utilities/material_query")
local PlayerUnitPeeking = require("scripts/utilities/player_unit_peeking")
local buff_keywords = BuffSettings.keywords
local damage_types = DamageSettings.damage_types
local proc_events = BuffSettings.proc_events
local DAMAGE_COLLISION_FILTER = "filter_player_character_lunge"
local DEFAULT_POWER_LEVEL = 300
local SPEED_EPSILON = 0.001
local HIT_WEAKSPOT = false
local IS_CRITICAL_STRIKE = false
local slide_knock_down_damage_settings = {
	radius = 2,
	damage_profile = DamageProfileTemplates.slide_knockdown,
	damage_type = damage_types.physical,
}
local PlayerCharacterStateSliding = class("PlayerCharacterStateSliding", "PlayerCharacterStateBase")
local _max_hit_mass

PlayerCharacterStateSliding.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateSliding.super.init(self, character_state_init_context, ...)

	local unit_data = character_state_init_context.unit_data
	local slide_character_state_component = unit_data:write_component("slide_character_state")

	slide_character_state_component.friction_function = "default"
	slide_character_state_component.was_in_dodge_cooldown = false
	self._slide_character_state_component = slide_character_state_component
	self._sway_control_component = unit_data:write_component("sway_control")
	self._spread_control_component = unit_data:write_component("spread_control")

	local character_state_hit_mass_component = unit_data:write_component("character_state_hit_mass")

	character_state_hit_mass_component.used_hit_mass_percentage = 0
	self._character_state_hit_mass_component = character_state_hit_mass_component
	self._dodge_character_state_component = unit_data:write_component("dodge_character_state")

	local breed = unit_data:breed()

	self._sliding_loop_alias = breed.sfx.sliding_alias
	self._peeking_component = unit_data:write_component("peeking")
	self._hit_enemy_units = {}
end

local TRAINING_GROUNDS_GAME_MODE_NAME = "training_grounds"
local FX_SOURCE_NAME = "right_foot"

PlayerCharacterStateSliding.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateSliding.super.on_enter(self, unit, dt, t, previous_state, params)

	local locomotion_steering = self._locomotion_steering_component

	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true
	self._slide_character_state_component.friction_function = params.friction_function or "default"

	local first_person_extension = self._first_person_extension

	first_person_extension:set_wanted_player_height("slide", 0.3)

	local animation_extension = self._animation_extension

	animation_extension:anim_event_1p("slide_in")

	local buff_extension = self._buff_extension

	animation_extension:anim_event("slide_in")

	local movement_state_component = self._movement_state_component

	movement_state_component.method = "sliding"
	movement_state_component.is_dodging = true

	local game_mode_name = Managers.state.game_mode:game_mode_name()

	if game_mode_name == TRAINING_GROUNDS_GAME_MODE_NAME then
		Managers.event:trigger("tg_on_slide")
	end

	local character_state_hit_mass_component = self._character_state_hit_mass_component

	character_state_hit_mass_component.used_hit_mass_percentage = 0

	table.clear(self._hit_enemy_units)

	self._slide_character_state_component.was_in_dodge_cooldown = t < self._dodge_character_state_component.consecutive_dodges_cooldown

	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		buff_extension:add_proc_event(proc_events.on_slide_start, param_table)
	end
end

PlayerCharacterStateSliding.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateSliding.super.on_exit(self, unit, t, next_state)

	self._movement_state_component.method = "idle"

	self._animation_extension:anim_event_1p("slide_out")

	local movement_state_component = self._movement_state_component

	movement_state_component.is_dodging = false

	local buff_extension = self._buff_extension
	local base_dodge_template = self._archetype_dodge_template
	local weapon_dodge_template = self._weapon_extension:dodge_template()

	if self._slide_character_state_component.was_in_dodge_cooldown then
		self._dodge_character_state_component.consecutive_dodges_cooldown = t + base_dodge_template.consecutive_dodges_reset + (weapon_dodge_template and weapon_dodge_template.consecutive_dodges_reset or 0)
	end

	if next_state == "falling" and movement_state_component.is_crouching and not Crouch.crouch_input(self._input_extension, true, false, true) and Crouch.can_exit(unit) then
		Crouch.exit(unit, self._first_person_extension, self._animation_extension, self._weapon_extension, self._movement_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, t)
	end

	if next_state == "walking" then
		if movement_state_component.is_crouching then
			self._first_person_extension:set_wanted_player_height("crouch", 0.3)
		end
	else
		PlayerUnitPeeking.leaving_peekable_character_state(self._peeking_component, self._animation_extension, self._first_person_extension)
	end

	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		buff_extension:add_proc_event(proc_events.on_slide_end, param_table)
	end
end

PlayerCharacterStateSliding.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local first_person_extension = self._first_person_extension
	local anim_extension = self._animation_extension
	local weapon_extension = self._weapon_extension
	local locomotion_steering = self._locomotion_steering_component
	local locomotion = self._locomotion_component
	local input_source = self._input_extension
	local move_state_component = self._movement_state_component
	local velocity_current = locomotion.velocity_current

	self._fx_extension:run_looping_sound(self._sliding_loop_alias, FX_SOURCE_NAME, nil, fixed_frame)
	weapon_extension:update_weapon_actions(fixed_frame)
	self._ability_extension:update_ability_actions(fixed_frame)

	local max_mass_hit = false
	local buff_extension = self._buff_extension
	local knock_enemies = buff_extension:has_keyword(buff_keywords.knock_down_on_slide)

	if knock_enemies and slide_knock_down_damage_settings and not self._unit_data_extension.is_resimulating then
		max_mass_hit = self:_update_enemy_hit_detection(unit, slide_knock_down_damage_settings)
	end

	local constants = self._constants
	local is_crouching = true
	local character_state_component = self._character_state_component
	local time_in_action = t - character_state_component.entered_t
	local commit_period_over = time_in_action > constants.slide_commit_time
	local flat_move_speed_sq = Vector3.length_squared(Vector3.flat(self._locomotion_component.velocity_current))

	if commit_period_over or flat_move_speed_sq < 4 then
		is_crouching = Crouch.check(unit, first_person_extension, anim_extension, weapon_extension, move_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, input_source, t, true)
	end

	PlayerUnitPeeking.fixed_update(self._peeking_component, self._ledge_finder_extension, anim_extension, first_person_extension, self._talent_extension, is_crouching, self._breed)

	local speed = Vector3.length(Vector3.flat(velocity_current))

	if speed > SPEED_EPSILON then
		local weapon_template_or_nil = weapon_extension:weapon_template()
		local friction_function = self._slide_character_state_component.friction_function
		local friction_speed

		if buff_extension:has_keyword(buff_keywords.zero_slide_friction) then
			friction_speed = 0
		elseif friction_function == "sprint" then
			friction_speed = self._constants.sprint_slide_friction_function(speed, time_in_action, buff_extension, weapon_template_or_nil)
		else
			friction_speed = self._constants.slide_friction_function(speed, time_in_action, buff_extension, weapon_template_or_nil)
		end

		local friction = math.min(speed, friction_speed * dt) / speed * velocity_current

		locomotion_steering.velocity_wanted = velocity_current - friction
	end

	local next_state = self:_check_transition(unit, t, next_state_params, input_source, is_crouching, commit_period_over, max_mass_hit, speed)

	return next_state
end

PlayerCharacterStateSliding._do_material_query = function (self)
	local length = 0.3
	local raycast_position = self._locomotion_component.position + Vector3(0, 0, length * 0.5)
	local hit, material, position, normal, hit_unit, hit_actor = MaterialQuery.query_material(self._physics_world, raycast_position, raycast_position - Vector3(0, 0, length), "slide")

	if hit and material then
		return material
	else
		return "default"
	end
end

PlayerCharacterStateSliding.update = function (self, unit, dt, t)
	return
end

PlayerCharacterStateSliding._check_transition = function (self, unit, t, next_state_params, input_source, is_crouching, commit_period_over, max_mass_hit, current_speed)
	local unit_data_extension = self._unit_data_extension
	local health_transition = HealthStateTransitions.poll(unit_data_extension, next_state_params)

	if health_transition then
		return health_transition
	end

	local disruptive_transition = DisruptiveStateTransition.poll(unit, unit_data_extension, next_state_params)

	if disruptive_transition then
		return disruptive_transition
	end

	local anim_extension = self._animation_extension
	local move_state_component = self._movement_state_component

	if commit_period_over and input_source:get("jump") and (not is_crouching or Crouch.can_exit(unit)) and move_state_component.can_jump then
		if is_crouching then
			Crouch.exit(unit, self._first_person_extension, anim_extension, self._weapon_extension, move_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, t)
		end

		return "jumping"
	end

	local inair_state = self._inair_state_component

	if not inair_state.on_ground then
		return "falling"
	end

	if max_mass_hit then
		return "walking"
	end

	if not is_crouching or current_speed < 0.01 then
		return "walking"
	end
end

PlayerCharacterStateSliding._update_enemy_hit_detection = function (self, unit, damage_settings)
	local side_system = Managers.state.extension:system("side_system")
	local damage_profile = damage_settings.damage_profile
	local damage_type = damage_settings.damage_type
	local locomotion_component = self._locomotion_component
	local locomotion_position = locomotion_component.position
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
	local radius = damage_settings.radius
	local actors, num_actors = PhysicsWorld.immediate_overlap(self._physics_world, "shape", "sphere", "position", locomotion_position, "size", radius, "collision_filter", DAMAGE_COLLISION_FILTER, "rewind_ms", rewind_ms)
	local character_state_hit_mass_component = self._character_state_hit_mass_component
	local max_hit_mass = _max_hit_mass(damage_settings, unit)
	local used_hit_mass_percentage = character_state_hit_mass_component.used_hit_mass_percentage
	local current_mass_hit = max_hit_mass >= math.huge and 0 or max_hit_mass * used_hit_mass_percentage
	local fp_position = self._first_person_component.position
	local lunge_direction = self._lunge_character_state_component.direction
	local lunge_dir_right = Vector3.cross(lunge_direction, Vector3.up())
	local forward, right = Vector3.forward(), Vector3.right()
	local lunge_rotation = Quaternion.look(lunge_direction)
	local left_attack_direction = Quaternion.rotate(lunge_rotation, Vector3.normalize(forward - right))
	local right_attack_direction = Quaternion.rotate(lunge_rotation, Vector3.normalize(forward + right))
	local hit_enemy_units = self._hit_enemy_units

	for i = 1, num_actors do
		local hit_actor = actors[i]
		local hit_unit = Actor.unit(hit_actor)

		if side_system:is_enemy(unit, hit_unit) and not hit_enemy_units[hit_unit] then
			hit_enemy_units[hit_unit] = true
			self._last_hit_unit = hit_unit

			local hit_position = POSITION_LOOKUP[hit_unit]
			local hit_direction = Vector3.normalize(Vector3.flat(hit_position - fp_position))
			local attack_direction
			local dot = Vector3.dot(hit_direction, lunge_dir_right)

			if dot > 0 then
				attack_direction = right_attack_direction
			else
				attack_direction = left_attack_direction
			end

			local hit_world_position = Actor.position(hit_actor)
			local attack_type = AttackSettings.attack_types.melee
			local damage_dealt, attack_result, damage_efficiency = Attack.execute(hit_unit, damage_profile, "power_level", 1000, "hit_world_position", hit_world_position, "attack_direction", attack_direction, "attack_type", attack_type, "attacking_unit", unit, "damage_type", damage_type)

			ImpactEffect.play(hit_unit, hit_actor, damage_dealt, damage_type, nil, attack_result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

			current_mass_hit = current_mass_hit + HitMass.target_hit_mass(unit, hit_unit, HIT_WEAKSPOT, IS_CRITICAL_STRIKE, attack_type)
		end
	end

	local max_hit_mass_reached = max_hit_mass <= current_mass_hit

	return max_hit_mass_reached
end

local NO_LERP_VALUES = {}

function _max_hit_mass(damage_settings, unit)
	local charge_level = 1
	local damage_profile = damage_settings.damage_profile
	local critical_strike = false
	local max_hit_mass_attack, max_hit_mass_impact = DamageProfile.max_hit_mass(damage_profile, DEFAULT_POWER_LEVEL, charge_level, NO_LERP_VALUES, critical_strike, unit)
	local max_hit_mass = math.max(max_hit_mass_attack, max_hit_mass_impact)

	return max_hit_mass
end

return PlayerCharacterStateSliding
