require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local Crouch = require("scripts/extension_systems/character_state_machine/character_states/utilities/crouch")
local DamageProfile = require("scripts/utilities/attack/damage_profile")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local HealthStateTransitions = require("scripts/extension_systems/character_state_machine/character_states/utilities/health_state_transitions")
local HitMass = require("scripts/utilities/attack/hit_mass")
local ImpactEffect = require("scripts/utilities/attack/impact_effect")
local LagCompensation = require("scripts/utilities/lag_compensation")
local MaterialQuery = require("scripts/utilities/material_query")
local PlayerMovement = require("scripts/utilities/player_movement")
local buff_keywords = BuffSettings.keywords
local DAMAGE_COLLISION_FILTER = "filter_player_character_lunge"
local DEFUALT_POWER_LEVEL = 300
local EPSILON = 0.001
local damage_types = DamageSettings.damage_types
local slide_knock_down_damage_settings = {
	radius = 2,
	damage_profile = DamageProfileTemplates.slide_knockdown,
	damage_type = damage_types.physical
}
local PlayerCharacterStateSliding = class("PlayerCharacterStateSliding", "PlayerCharacterStateBase")
local _max_hit_mass = nil

PlayerCharacterStateSliding.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateSliding.super.init(self, character_state_init_context, ...)

	local unit_data = character_state_init_context.unit_data
	self._sway_control_component = unit_data:write_component("sway_control")
	self._spread_control_component = unit_data:write_component("spread_control")
	local character_state_hit_mass_component = character_state_init_context.unit_data:write_component("character_state_hit_mass")
	character_state_hit_mass_component.used_hit_mass_percentage = 0
	self._character_state_hit_mass_component = character_state_hit_mass_component
	local breed = unit_data:breed()
	self._sliding_loop_alias = breed.sfx.sliding_alias
	self._hit_enemy_units = {}
end

local FX_SOURCE_NAME = "rightfoot"

PlayerCharacterStateSliding.on_enter = function (self, unit, dt, t, previous_state, params)
	fassert(self._movement_state_component.is_crouching, "Sliding component assumes crouching state and won't be robust entered when not crouching.")

	local locomotion_steering = self._locomotion_steering_component
	locomotion_steering.move_method = "script_driven"
	locomotion_steering.calculate_fall_velocity = true
	local first_person_extension = self._first_person_extension

	first_person_extension:set_wanted_player_height("slide", 0.3)

	local animation_extension = self._animation_extension

	animation_extension:anim_event_1p("slide_in")
	self._fx_extension:trigger_looping_wwise_event(self._sliding_loop_alias, FX_SOURCE_NAME)
	animation_extension:anim_event("slide_in")

	self._movement_state_component.method = "sliding"
	self._movement_state_component.is_dodging = true
	local character_state_hit_mass_component = self._character_state_hit_mass_component
	character_state_hit_mass_component.used_hit_mass_percentage = 0

	table.clear(self._hit_enemy_units)
end

PlayerCharacterStateSliding.on_exit = function (self, unit, t, next_state)
	self._movement_state_component.method = "idle"

	self._animation_extension:anim_event_1p("slide_out")

	self._movement_state_component.is_dodging = false

	self._fx_extension:stop_looping_wwise_event(self._sliding_loop_alias)
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

	weapon_extension:update_weapon_actions(fixed_frame)

	local max_mass_hit = false
	local buff_extension = ScriptUnit.extension(unit, "buff_system")
	local knock_enemies = buff_extension and buff_extension:has_keyword(buff_keywords.knock_down_on_slide)

	if knock_enemies and slide_knock_down_damage_settings and not self._unit_data_extension.is_resimulating then
		max_mass_hit = self:_update_enemy_hit_detection(unit, slide_knock_down_damage_settings)
	end

	local constants = self._constants
	local is_crouching = true
	local time_in_action = t - self._character_state_component.entered_t
	local commit_period_over = constants.slide_commit_time < time_in_action

	if commit_period_over then
		is_crouching = Crouch.check(unit, first_person_extension, anim_extension, weapon_extension, move_state_component, self._sway_control_component, self._sway_component, self._spread_control_component, input_source, t)
	end

	local speed = Vector3.length(Vector3.flat(velocity_current))

	if EPSILON < speed then
		local friction_speed = self._constants.slide_friction_function(speed, time_in_action)
		local friction = math.min(speed, friction_speed * dt) / speed * velocity_current
		locomotion_steering.velocity_wanted = velocity_current - friction
	end

	local next_state = self:_check_transition(unit, t, next_state_params, input_source, is_crouching, commit_period_over, max_mass_hit)

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

PlayerCharacterStateSliding._check_transition = function (self, unit, t, next_state_params, input_source, is_crouching, commit_period_over, max_mass_hit)
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

	if not is_crouching or Vector3.length_squared(self._locomotion_steering_component.velocity_wanted) < 0.01 then
		return "walking"
	end
end

PlayerCharacterStateSliding._update_enemy_hit_detection = function (self, unit, damage_settings)
	local side_system = Managers.state.extension:system("side_system")
	local damage_profile = damage_settings.damage_profile
	local damage_type = damage_settings.damage_type
	local locomotion_component = self._locomotion_component
	local locomotion_position = PlayerMovement.locomotion_position(locomotion_component)
	local rewind_ms = LagCompensation.rewind_ms(self._is_server, self._is_local_unit, self._player)
	local radius = damage_settings.radius
	local actors, num_actors = PhysicsWorld.immediate_overlap(self._physics_world, "shape", "sphere", "position", locomotion_position, "size", radius, "collision_filter", DAMAGE_COLLISION_FILTER, "rewind_ms", rewind_ms)
	local character_state_hit_mass_component = self._character_state_hit_mass_component
	local max_hit_mass = _max_hit_mass(damage_settings)
	local used_hit_mass_percentage = character_state_hit_mass_component.used_hit_mass_percentage
	local current_mass_hit = (math.huge <= max_hit_mass and 0) or max_hit_mass * used_hit_mass_percentage
	local fp_position = self._first_person_component.position
	local lunge_direction = self._lunge_character_state_component.direction
	local lunge_dir_right = Vector3.cross(lunge_direction, Vector3.up())
	local forward = Vector3.forward()
	local right = Vector3.right()
	local lunge_rotation = Quaternion.look(lunge_direction)
	local left_attack_direction = Quaternion.rotate(lunge_rotation, Vector3.normalize(forward - right))
	local right_attack_direction = Quaternion.rotate(lunge_rotation, Vector3.normalize(forward + right))
	local hit_enemy_units = self._hit_enemy_units

	for i = 1, num_actors, 1 do
		local hit_actor = actors[i]
		local hit_unit = Actor.unit(hit_actor)

		if side_system:is_enemy(unit, hit_unit) and not hit_enemy_units[hit_unit] then
			hit_enemy_units[hit_unit] = true
			self._last_hit_unit = hit_unit
			local hit_position = POSITION_LOOKUP[hit_unit]
			local hit_direction = Vector3.normalize(Vector3.flat(hit_position - fp_position))
			local attack_direction = nil
			local dot = Vector3.dot(hit_direction, lunge_dir_right)

			if dot > 0 then
				attack_direction = right_attack_direction
			else
				attack_direction = left_attack_direction
			end

			local hit_world_position = Actor.position(hit_actor)
			local damage_dealt, attack_result, damage_efficiency = Attack.execute(hit_unit, damage_profile, "power_level", 1000, "hit_world_position", hit_world_position, "attack_direction", attack_direction, "attack_type", AttackSettings.attack_types.melee, "attacking_unit", unit, "damage_type", damage_type)

			ImpactEffect.play(hit_unit, hit_actor, damage_dealt, damage_type, nil, attack_result, hit_position, nil, attack_direction, unit, nil, nil, nil, damage_efficiency, damage_profile)

			current_mass_hit = current_mass_hit + HitMass.target_hit_mass(hit_unit)
		end
	end

	local max_hit_mass_reached = max_hit_mass <= current_mass_hit

	return max_hit_mass_reached
end

local NO_LERP_VALUES = {}

function _max_hit_mass(damage_settings)
	local charge_level = 1
	local damage_profile = damage_settings.damage_profile
	local critical_strike = false
	local max_hit_mass_attack, max_hit_mass_impact = DamageProfile.max_hit_mass(damage_profile, DEFUALT_POWER_LEVEL, charge_level, NO_LERP_VALUES, critical_strike)
	local max_hit_mass = math.max(max_hit_mass_attack, max_hit_mass_impact)

	return max_hit_mass
end

return PlayerCharacterStateSliding
