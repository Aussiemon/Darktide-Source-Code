-- chunkname: @scripts/extension_systems/weapon/actions/modules/multi_targeting_action_module.lua

local BallisticRaycast = require("scripts/extension_systems/weapon/actions/utilities/ballistic_raycast")
local EffectTemplates = require("scripts/settings/fx/effect_templates")
local WeaponTemplate = require("scripts/utilities/weapon/weapon_template")
local MultiTargetingActionModule = class("MultiTargetingActionModule", "SmartTargetingActionModule")

MultiTargetingActionModule.init = function (self, is_server, physics_world, player_unit, component, action_settings)
	MultiTargetingActionModule.super.init(self, is_server, physics_world, player_unit, component, action_settings)

	local unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")

	self._unit_data_extension = ScriptUnit.extension(player_unit, "unit_data_system")
	self._ability_extension = ScriptUnit.has_extension(player_unit, "ability_system")
	self._companion_spawner_extension = ScriptUnit.has_extension(player_unit, "companion_spawner_system")
	self._input_extension = ScriptUnit.extension(player_unit, "input_system")
	self._talent_extension = ScriptUnit.extension(player_unit, "talent_system")
	self._animation_extension = ScriptUnit.extension(player_unit, "animation_system")
	self._position_finder_component = unit_data_extension:write_component("action_module_position_finder")
	self._instant_cast = action_settings.instant_cast
	self._place_configuration = action_settings.place_configuration
	self._aim_on_ground_validate_function = action_settings.aim_on_ground_validate_function
	self._effect_template_name = action_settings.effect_template_name
	self._locomotion_component = unit_data_extension:read_component("locomotion")
	self._current_animation_event = nil

	local fx_system = Managers.state.extension:system("fx_system")

	self._fx_system = fx_system
end

MultiTargetingActionModule.start = function (self, action_settings, t)
	MultiTargetingActionModule.super.start(self, action_settings, t)

	self._position_finder_component.position_valid = false
	self._position_finder_component.position = Vector3.zero()

	if self._is_server then
		self._template_effect_id = self:_start_effect_template(self._player_unit, self._effect_template_name)
	end
end

MultiTargetingActionModule.fixed_update = function (self, dt, t)
	MultiTargetingActionModule.super.fixed_update(self, dt, t)

	local action_settings = self._action_settings
	local component = self._component
	local aim_on_ground_validate_function = self._aim_on_ground_validate_function

	if component.target_unit_1 or not aim_on_ground_validate_function(self._unit_data_extension, self._ability_extension, self._companion_spawner_extension, self._input_extension, self._talent_extension) then
		self._position_finder_component.position_valid = false
		self._position_finder_component.position = Vector3.zero()

		local weapon_action_component = self._unit_data_extension:read_component("weapon_action")
		local current_weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

		self._current_animation_event = action_settings.select_animation_event_func(self._player_unit, self._current_animation_event, current_weapon_template, self._animation_extension, self._component, self._position_finder_component, self._companion_spawner_extension, self._input_extension)

		return
	end

	local physics_world = self._physics_world
	local collision_filter = "filter_place_force_field"
	local max_steps = 5
	local max_time = 2
	local instant_cast = self._instant_cast
	local speed = instant_cast and 2.5 or 12.5
	local angle = math.pi / 16
	local gravity = -19.64
	local hit, hit_position, _, normal, _ = BallisticRaycast.cast(physics_world, collision_filter, self._first_person_component, max_steps, max_time, speed, angle, gravity)

	if hit and Vector3.dot(normal, Vector3.up()) < 0.75 then
		local player_position = self._locomotion_component.position
		local half_step_back = 1 * Vector3.normalize(hit_position - player_position)
		local step_back_position = hit_position - half_step_back
		local _, new_position, _, _, _ = PhysicsWorld.raycast(physics_world, step_back_position, Vector3(0, 0, -1), 5, "closest", "types", "both", "collision_filter", collision_filter)

		if new_position then
			hit_position = new_position
		else
			hit_position = Vector3.zero()
		end
	end

	hit_position = hit_position and hit_position + Vector3.up() * 2

	self:_on_input_action(self._place_configuration)

	self._position_finder_component.position_valid = true
	self._position_finder_component.position = hit_position

	local weapon_action_component = self._unit_data_extension:read_component("weapon_action")
	local current_weapon_template = WeaponTemplate.current_weapon_template(weapon_action_component)

	self._current_animation_event = action_settings.select_animation_event_func(self._player_unit, self._current_animation_event, current_weapon_template, self._animation_extension, self._component, self._position_finder_component, self._companion_spawner_extension, self._input_extension)
end

MultiTargetingActionModule.finish = function (self, reason, data, t)
	MultiTargetingActionModule.super.finish(self, reason, data, t)

	if reason == "hold_input_released" or reason == "stunned" or self._component.target_unit_1 then
		self._position_finder_component.position_valid = false
		self._position_finder_component.position = Vector3.zero()
	end

	if self._is_server then
		self:_stop_effect_template(self._player_unit)
	end

	self._current_animation_event = nil
end

MultiTargetingActionModule._on_input_action = function (self, place_configuration)
	if not place_configuration or not place_configuration.on_input_action_func then
		return
	end

	local key_input = place_configuration.key_input
	local has_input = self._input_extension:get(key_input)

	if has_input then
		place_configuration.on_input_action_func(self._unit_data_extension, self._ability_extension, self._companion_spawner_extension, self._is_server, self._input_extension, self._talent_extension)
	end
end

MultiTargetingActionModule._start_effect_template = function (self, unit, effect_template_name)
	local effect_template = EffectTemplates[effect_template_name]
	local fx_system = self._fx_system
	local effect_id = fx_system:start_template_effect(effect_template, unit)

	return effect_id
end

MultiTargetingActionModule._stop_effect_template = function (self, unit)
	local effect_id = self._template_effect_id

	if effect_id then
		local fx_system = self._fx_system

		fx_system:stop_template_effect(effect_id)

		self._template_effect_id = nil
	end
end

return MultiTargetingActionModule
