-- chunkname: @scripts/extension_systems/character_state_machine/character_states/player_character_state_vortex_grabbed.lua

require("scripts/extension_systems/character_state_machine/character_states/player_character_state_base")

local Attack = require("scripts/utilities/attack/attack")
local ForceRotation = require("scripts/extension_systems/locomotion/utilities/force_rotation")
local Interrupt = require("scripts/utilities/attack/interrupt")
local Luggable = require("scripts/utilities/luggable")
local PlayerUnitVisualLoadout = require("scripts/extension_systems/visual_loadout/utilities/player_unit_visual_loadout")
local DisruptiveStateTransition = require("scripts/extension_systems/character_state_machine/character_states/utilities/disruptive_state_transition")
local CameraShake = require("scripts/utilities/camera/camera_shake")
local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local damage_types = DamageSettings.damage_types
local PlayerCharacterStateVortexGrabbed = class("PlayerCharacterStateVortexGrabbed", "PlayerCharacterStateBase")
local SFX_SOURCE = "head"
local STINGER_ALIAS = "disabled_enter"
local STINGER_EXIT_ALIAS = "disabled_exit"
local STINGER_PROPERTIES = {
	stinger_type = "vortex_grabbed",
}

PlayerCharacterStateVortexGrabbed.init = function (self, character_state_init_context, ...)
	PlayerCharacterStateVortexGrabbed.super.init(self, character_state_init_context, ...)

	local unit_data_extension = character_state_init_context.unit_data

	self._unit_data_extension = unit_data_extension

	local disabled_character_state_component = unit_data_extension:write_component("disabled_character_state")

	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.target_drag_position = Vector3.zero()
	self._disabled_character_state_component = disabled_character_state_component
	self._disabled_state_input = unit_data_extension:read_component("disabled_state_input")
	self._dead_state_input = unit_data_extension:read_component("dead_state_input")
	self._execute_anim_played = false

	local game_session = Managers.state.game_session:game_session()

	self._game_session = game_session
	self._entered_state_t = nil
end

local INITIAL_VERTICAL_SPEED = 1.5

PlayerCharacterStateVortexGrabbed.on_enter = function (self, unit, dt, t, previous_state, params)
	PlayerCharacterStateVortexGrabbed.super.on_enter(self, unit, dt, t, previous_state, params)

	local inventory_component = self._inventory_component
	local visual_loadout_extension = self._visual_loadout_extension

	Interrupt.ability_and_action(t, unit, "vortex_grabbed", nil)
	Luggable.drop_luggable(t, unit, inventory_component, visual_loadout_extension, true)
	PlayerUnitVisualLoadout.wield_slot("slot_unarmed", unit, t)

	local locomotion_steering_component = self._locomotion_steering_component
	local disabling_unit = self._disabled_state_input.disabling_unit
	local disabled_character_state_component = self._disabled_character_state_component

	self._movement_state_component.method = "idle"
	locomotion_steering_component.move_method = "script_driven"
	locomotion_steering_component.calculate_fall_velocity = false
	locomotion_steering_component.disable_velocity_rotation = true
	disabled_character_state_component.is_disabled = true
	disabled_character_state_component.disabling_unit = disabling_unit
	disabled_character_state_component.disabling_type = "vortex_grabbed"

	local is_server = self._is_server

	if is_server then
		self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
	end

	self._vortex_extension = ScriptUnit.extension(disabling_unit, "minion_vortex_system")

	local vortex_pos = self._vortex_extension:get_position()
	local unit_pos = Unit.world_position(unit, 1)
	local to = vortex_pos - unit_pos
	local horizontal_direction = Vector3.normalize(to)

	self._horizontal_direction = Vector3Box(horizontal_direction)
	self._vertical_direction = 1
	self._vertical_speed = INITIAL_VERTICAL_SPEED
	self._resume_spinning_t = 0
	self._entered_state_t = t

	self._animation_extension:anim_event_1p("airtime_fwd")

	local unit_data_extension = ScriptUnit.extension(self._unit, "unit_data_system")

	self._locomotion_component = unit_data_extension:write_component("locomotion")
	self._locomotion_push_component = unit_data_extension:write_component("locomotion_push")
end

PlayerCharacterStateVortexGrabbed.on_exit = function (self, unit, t, next_state)
	PlayerCharacterStateVortexGrabbed.super.on_exit(self, unit, t, next_state)

	local locomotion_force_rotation_component = self._locomotion_force_rotation_component

	if locomotion_force_rotation_component.use_force_rotation then
		ForceRotation.stop(locomotion_force_rotation_component)
	end

	local locomotion_steering_component = self._locomotion_steering_component

	locomotion_steering_component.disable_velocity_rotation = false

	if next_state ~= "dead" then
		local inventory_component = self._inventory_component

		PlayerUnitVisualLoadout.wield_previous_slot(inventory_component, unit, t)
	end

	local disabled_character_state_component = self._disabled_character_state_component

	disabled_character_state_component.is_disabled = false
	disabled_character_state_component.disabling_unit = nil
	disabled_character_state_component.disabling_type = "none"

	local is_server = self._is_server

	if is_server then
		self._fx_extension:trigger_gear_wwise_event_with_source(STINGER_EXIT_ALIAS, STINGER_PROPERTIES, SFX_SOURCE, true, true)
	end

	if self._is_server then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local player = player_unit_spawn_manager:owner(unit)
		local is_player_alive = player:unit_is_alive()

		if is_player_alive then
			local rescued_by_player = false
			local state_name = "vortex_grabbed"
			local time_in_captivity = t - self._entered_state_t

			Managers.telemetry_events:player_exits_captivity(player, rescued_by_player, state_name, time_in_captivity)
		end

		self._entered_state_t = nil
	end
end

PlayerCharacterStateVortexGrabbed.fixed_update = function (self, unit, dt, t, next_state_params, fixed_frame)
	local input_component = self._disabled_state_input
	local trigger_animation = input_component.trigger_animation

	if trigger_animation == "airtime_fwd" and not self._execute_anim_played then
		self._animation_extension:anim_event("airtime_fwd")

		self._execute_anim_played = true
	end

	local vortex_unit = self._disabled_state_input.disabling_unit

	if vortex_unit and Unit.alive(vortex_unit) then
		local game_session = self._game_session
		local game_object_id = Managers.state.unit_spawner:game_object_id(vortex_unit)
		local vortex_spawn_time = GameSession.game_object_field(game_session, game_object_id, "spawn_time")
		local disabling_unit_data_extension = ScriptUnit.extension(vortex_unit, "unit_data_system")
		local breed = disabling_unit_data_extension:breed()
		local vortex_template = breed.vortex_template

		self._damage_profile_template = DamageProfileTemplates[vortex_template.wall_slam_damage_profile]

		self:update_spin_velocity(unit, vortex_unit, vortex_spawn_time, vortex_template, dt, t)
	end

	return self:_check_transition(unit, t, next_state_params)
end

PlayerCharacterStateVortexGrabbed._check_transition = function (self, unit, t, next_state_params)
	local disruptive_transition = DisruptiveStateTransition.poll(unit, self._unit_data_extension, next_state_params)
	local disabling_unit = self._disabled_state_input.disabling_unit

	if disruptive_transition and not disabling_unit and disruptive_transition == "catapulted" then
		return "catapulted"
	end

	if not disabling_unit or not HEALTH_ALIVE[disabling_unit] then
		return "walking"
	end

	local dead_state_input = self._dead_state_input

	if dead_state_input.die then
		next_state_params.time_to_despawn_corpse = dead_state_input.despawn_time

		return "dead"
	end

	return nil
end

PlayerCharacterStateVortexGrabbed.update_spin_velocity = function (self, unit, vortex_unit, vortex_spawn_time, vortex_template, dt, t)
	if not self._is_server then
		return
	end

	if t < self._resume_spinning_t then
		return
	end

	local unit_pos = Unit.world_position(unit, 1)
	local vortex_pos = self._vortex_extension:get_position()
	local vertical_target_pos = self:_vertical_target_position(t, dt, vortex_template, vortex_pos, unit_pos)
	local target_height = math.clamp(vertical_target_pos.z, 0, vortex_template.vortex_height)
	local is_colliding = self:_update_collision(t, unit, unit_pos, vortex_template)
	local horizontal_target_pos = self:_horizontal_target_pos(t, dt, is_colliding, vortex_pos, vortex_template, target_height)
	local target_pos = horizontal_target_pos + vertical_target_pos
	local distance = Vector3.distance(unit_pos, target_pos)
	local alpha = math.clamp01(distance / vortex_template.outer_radius)
	local speed = vortex_template.max_spin_speed * alpha
	local velocity = Vector3.normalize(target_pos - unit_pos) * speed
	local locomotion_steering_component = self._locomotion_steering_component

	locomotion_steering_component.velocity_wanted = velocity
end

local SPIN_PAUSE_TIME = 0.3

PlayerCharacterStateVortexGrabbed._update_collision = function (self, t, player_unit, unit_pos, vortex_template)
	local mover = Unit.mover(player_unit)
	local side_collides = Mover.collides_sides(mover)
	local collides_down = Mover.collides_down(mover)
	local colliding = side_collides and not collides_down

	if colliding then
		local near_distance = 8
		local far_distance = 16
		local near_scale = 1
		local far_scale = 0.5

		CameraShake.camera_shake_by_distance("breach_charge_explosion", unit_pos, near_distance, far_distance, near_scale, far_scale)

		local locomotion_extension = ScriptUnit.has_extension(player_unit, "locomotion_system")
		local player_velocity = locomotion_extension:current_velocity()
		local player_velocity_normalized = Vector3.normalize(player_velocity)

		self._resume_spinning_t = t + SPIN_PAUSE_TIME

		self:_deal_slam_damage(player_unit, player_velocity_normalized, vortex_template)
	end

	return colliding
end

PlayerCharacterStateVortexGrabbed._vertical_target_position = function (self, t, dt, vortex_template, vortex_pos, unit_pos)
	local min_height = vortex_template.wanted_minimum_flight_height
	local max_height = vortex_template.wanted_maximum_flight_height
	local target_height = self._vertical_target or min_height
	local speed_delta = 1 * dt

	self._vertical_speed = math.clamp(self._vertical_speed + speed_delta, 0, vortex_template.max_vertical_speed)

	local height_delta = self._vertical_speed * dt * self._vertical_direction

	target_height = target_height + height_delta

	if max_height <= target_height then
		self._vertical_direction = -1
	elseif target_height <= min_height then
		self._vertical_direction = 1
	end

	self._vertical_target = target_height

	return Vector3(0, 0, target_height)
end

PlayerCharacterStateVortexGrabbed._horizontal_target_pos = function (self, t, dt, is_colliding, vortex_pos, vortex_template, target_height)
	local angular_delta = is_colliding and math.pi or vortex_template.horizontal_angular_delta * dt
	local added_rotation = Quaternion(Vector3.up(), angular_delta)
	local horizontal_direction = self._horizontal_direction:unbox()

	horizontal_direction = Quaternion.rotate(added_rotation, horizontal_direction)
	horizontal_direction.z = 0

	local vertical_progress = math.ilerp(0, vortex_template.vortex_height, target_height)
	local vortex_width = vortex_template.outer_radius * vertical_progress
	local target_pos = vortex_pos + horizontal_direction * vortex_width

	self._horizontal_direction = Vector3Box(horizontal_direction)

	return target_pos
end

PlayerCharacterStateVortexGrabbed._deal_slam_damage = function (self, player_unit, velocity, vortex_template)
	local damage_profile = self._damage_profile_template
	local damage_type = damage_types.kinetic
	local max_power_level = vortex_template.wall_slam_max_power_level
	local scaled_power_level = max_power_level * 0.1

	Attack.execute(player_unit, damage_profile, "attack_direction", -velocity, "power_level", scaled_power_level, "hit_zone_name", "torso", "damage_type", damage_type)
end

return PlayerCharacterStateVortexGrabbed
