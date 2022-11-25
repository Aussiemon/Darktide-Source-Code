require("scripts/extension_systems/weapon/actions/action_charge")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local Attack = require("scripts/utilities/attack/attack")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local DamageSettings = require("scripts/settings/damage/damage_settings")
local PowerLevelSettings = require("scripts/settings/damage/power_level_settings")
local DEFAULT_POWER_LEVEL = PowerLevelSettings.default_power_level
local attack_results = AttackSettings.attack_results
local attack_types = AttackSettings.attack_types
local damage_types = DamageSettings.damage_types
local proc_events = BuffSettings.proc_events
local ActionSmiteTargeting = class("ActionSmiteTargeting", "ActionCharge")

ActionSmiteTargeting.init = function (self, action_context, action_params, action_settings)
	ActionSmiteTargeting.super.init(self, action_context, action_params, action_settings)

	local player_unit = self._player_unit
	local unit_data_extension = action_context.unit_data_extension
	local physics_world = self._physics_world
	local inventory_slot_component = self._inventory_slot_component
	local warp_charge_component = unit_data_extension:read_component("warp_charge")
	self._warp_charge_component = warp_charge_component
	local targeting_component = unit_data_extension:write_component("action_module_targeting")
	self._targeting_component = targeting_component
	local target_finder_module_class_name = action_settings.target_finder_module_class_name
	local overload_module_class_name = action_settings.overload_module_class_name
	self._targeting_module = ActionModules[target_finder_module_class_name]:new(physics_world, player_unit, targeting_component, action_settings)
	self._overload_module = ActionModules[overload_module_class_name]:new(player_unit, action_settings, inventory_slot_component)
end

ActionSmiteTargeting.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionSmiteTargeting.super.start(self, action_settings, t, time_scale, action_start_params)

	self._had_target = nil
	self._attack_target = action_settings.attack_target
	self._has_attacked_target = nil
	self._time_on_target = 0
	self._target_locked = action_settings.target_locked
	self._target_charge = action_settings.target_charge

	if self._target_charge then
		local charge_duration = self:_calculate_charge_duration_of_target_health(action_settings)
		self._charge_duration = charge_duration

		self._targeting_module:start(t)
		self._overload_module:start(t)
		self._charge_module:reset(t, charge_duration)
	end

	if self._target_locked then
		local current_warp_charge_percentage = self._warp_charge_component.current_percentage
		self._starting_warp_charge_percent = current_warp_charge_percentage
	end
end

ActionSmiteTargeting.fixed_update = function (self, dt, t, time_in_action)
	local ignore_charge_module_update = true

	ActionSmiteTargeting.super.fixed_update(self, dt, t, time_in_action, ignore_charge_module_update)

	local previously_targeted_unit = self._targeting_component.target_unit_1

	self._targeting_module:fixed_update(dt, t)

	local target_unit = self._targeting_component.target_unit_1

	if target_unit and target_unit ~= previously_targeted_unit then
		if self._is_server then
			self._time_on_target = 0
		end

		if self._target_charge and self._target_locked then
			self._charge_module:reset(t, self._charge_duration)
		end
	end

	if target_unit and self._is_server then
		local action_settings = self._action_settings
		local time_to_attack = action_settings.attack_target_time or 0
		local should_attack = not self._has_attacked_target

		if should_attack and self._attack_target and time_to_attack < self._time_on_target then
			local target_unit_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
			local breed = target_unit_unit_data_extension:breed()

			if not breed.smite_stagger_immunity then
				local player_unit = self._player_unit
				local direction = Vector3.normalize(Vector3.flat(POSITION_LOOKUP[target_unit] - POSITION_LOOKUP[player_unit]))
				local attack_settings = action_settings.attack_settings
				local damage_profile = attack_settings.damage_profile
				local hit_zone_name = "head"

				Attack.execute(target_unit, damage_profile, "attack_direction", direction, "power_level", DEFAULT_POWER_LEVEL, "hit_zone_name", hit_zone_name, "attack_type", attack_types.ranged, "attacking_unit", player_unit, "item", self._weapon.item)
			end

			self._has_attacked_target = true
		end

		self._time_on_target = self._time_on_target + dt
	end

	if target_unit or self._target_charge and not self._target_locked then
		self._overload_module:fixed_update(dt, t)
		self._charge_module:fixed_update(dt, t, self._charge_duration)
	end

	if self._had_target and not target_unit and self._target_locked then
		local charge_level = self._action_module_charge_component.charge_level

		if not HEALTH_ALIVE[previously_targeted_unit] and charge_level >= 0.5 then
			self._action_module_charge_component.charge_level = 1
			local param_table = self._buff_extension:request_proc_event_param_table()

			if param_table then
				param_table.attacked_unit = target_unit
				param_table.attacking_unit = self._player_unit
				param_table.attack_instigator_unit = self._player_unit
				param_table.damage = 0
				param_table.attack_result = attack_results.died
				param_table.attack_type = attack_types.ranged
				param_table.damage_type = damage_types.smite

				self._buff_extension:add_proc_event(proc_events.on_hit, param_table)
			end
		end
	end

	self._had_target = target_unit
end

ActionSmiteTargeting._calculate_charge_duration_of_target_health = function (self, action_settings)
	if self._action_settings.kill_charge then
		local stat_buffs = self._buff_extension:stat_buffs()
		local attack_speed = stat_buffs.smite_attack_speed
		local charge_time = action_settings.charge_time or 3
		local max_charge_time = charge_time / attack_speed

		return max_charge_time
	end
end

ActionSmiteTargeting.finish = function (self, reason, data, t, time_in_action, action_settings, chaining_action_params)
	self._should_fade_kill = false

	ActionSmiteTargeting.super.finish(self, reason, data, t, time_in_action, chaining_action_params)
	self._targeting_module:finish(reason, data, t)
	self._overload_module:finish(reason, data, t)

	if chaining_action_params then
		chaining_action_params.starting_warp_charge_percent = self._starting_warp_charge_percent
	end
end

return ActionSmiteTargeting
