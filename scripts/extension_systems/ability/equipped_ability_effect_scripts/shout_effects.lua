-- chunkname: @scripts/extension_systems/ability/equipped_ability_effect_scripts/shout_effects.lua

local AbilityTemplate = require("scripts/utilities/ability/ability_template")
local Action = require("scripts/utilities/weapon/action")
local ShoutEffects = class("ShoutEffects")
local AIM_EFFECT = "content/fx/particles/abilities/ability_radius_aoe"
local DEFAULT_RADIUS = 8

ShoutEffects.init = function (self, context, ability_template)
	self._world = context.world
	self._wwise_world = context.wwise_world
	self._ability_template = ability_template
	self._vfx = ability_template.vfx
	self._delay_t = self._vfx.delay
	self._is_local_unit = context.is_local_unit

	local unit = context.unit
	local unit_data_extension = context.unit_data_extension

	self._combat_ability_component = unit_data_extension:read_component("combat_ability")
	self._combat_ability_action_component = unit_data_extension:read_component("combat_ability_action")
	self._buff_extension = ScriptUnit.has_extension(unit, "buff_system")
	self._active = false
	self._aim_shout_effect_id = nil
	self._active_shout_effect_id = nil
end

ShoutEffects.extensions_ready = function (self, world, unit)
	self._buff_extension = self._buff_extension or ScriptUnit.has_extension(unit, "buff_system")
end

ShoutEffects.destroy = function (self)
	self:_destroy_effects()
end

ShoutEffects.update = function (self, unit, dt, t)
	self:_update_aim_shout(unit, dt, t)
	self:_update_active_shout(unit, dt, t)
end

ShoutEffects._update_aim_shout = function (self, unit, dt, t)
	if not self._is_local_unit then
		return
	end

	local combat_ability_action_component = self._combat_ability_action_component
	local ability_template = AbilityTemplate.current_ability_template(combat_ability_action_component)
	local _, current_action_settings = Action.current_action(combat_ability_action_component, ability_template)
	local current_action_kind = current_action_settings and current_action_settings.kind
	local radius = current_action_settings and current_action_settings.radius or DEFAULT_RADIUS
	local buff_extension = self._buff_extension
	local stat_buffs = buff_extension and buff_extension:stat_buffs()
	local radius_modifier = stat_buffs and stat_buffs.shout_radius_modifier or 1

	radius = radius * radius_modifier

	local aim_shout_effect_id = self._aim_shout_effect_id
	local correct_action_kind = current_action_kind == "shout_aim" or current_action_kind == "veteran_shout_aim"
	local spawn_effects = correct_action_kind and not aim_shout_effect_id
	local destroy_effects = not correct_action_kind and aim_shout_effect_id
	local move_effects = correct_action_kind and not not aim_shout_effect_id

	if spawn_effects then
		self:_spawn_aim_shout_effects(radius, unit)
	elseif destroy_effects then
		self:_destroy_aim_shout_effects(unit)
	elseif move_effects then
		local position = POSITION_LOOKUP[unit] + Vector3.up()

		self:_update_aim_shout_effect_positions(position)
	end
end

ShoutEffects._spawn_aim_shout_effects = function (self, radius, unit)
	local position = POSITION_LOOKUP[unit]
	local fx_extension = ScriptUnit.has_extension(unit, "fx_system")

	if fx_extension then
		local variable_name = "radius"
		local variable_value = Vector3(radius * 2, radius * 2, radius * 2)
		local aim_shout_effect_id = World.create_particles(self._world, AIM_EFFECT, position, nil, nil, nil)
		local variable_index = World.find_particles_variable(self._world, AIM_EFFECT, variable_name)

		World.set_particles_variable(self._world, aim_shout_effect_id, variable_index, variable_value)

		self._aim_shout_effect_id = aim_shout_effect_id
	end
end

ShoutEffects._destroy_aim_shout_effects = function (self, unit)
	if self._aim_shout_effect_id then
		World.destroy_particles(self._world, self._aim_shout_effect_id)

		self._aim_shout_effect_id = nil
	end
end

ShoutEffects._update_aim_shout_effect_positions = function (self, target_position)
	local effect_id = self._aim_shout_effect_id

	if not effect_id then
		return
	end

	World.move_particles(self._world, effect_id, target_position)
end

ShoutEffects._update_active_shout = function (self, unit, dt, t)
	if not self._active and self._combat_ability_component.active then
		local delay_t = self._delay_t

		if delay_t then
			delay_t = delay_t - dt
			self._delay_t = delay_t
		end

		if not delay_t or delay_t < 0 then
			self._active = true
			self._delay_t = self._vfx.delay

			self:_spawn_active_shout_effects(unit)
		end
	elseif self._active and not self._combat_ability_component.active then
		self._active = false
	end

	local position = POSITION_LOOKUP[unit] + Vector3.up()

	self:_update_active_shout_effect_positions(position)
end

ShoutEffects._spawn_active_shout_effects = function (self, unit)
	local combat_ability_action_component = self._combat_ability_action_component
	local ability_template = AbilityTemplate.current_ability_template(combat_ability_action_component)
	local _, current_action_settings = Action.current_action(combat_ability_action_component, ability_template)
	local radius = current_action_settings and current_action_settings.radius or DEFAULT_RADIUS
	local effect_name = self._vfx.name
	local position = POSITION_LOOKUP[unit] + Vector3.up()
	local variable_name = "size"
	local variable_value = Vector3(radius, radius, radius)
	local active_shout_effect_id = World.create_particles(self._world, effect_name, position, nil, nil, nil)
	local variable_index = World.find_particles_variable(self._world, effect_name, variable_name)

	World.set_particles_variable(self._world, active_shout_effect_id, variable_index, variable_value)

	self._active_shout_effect_id = active_shout_effect_id
end

ShoutEffects._update_active_shout_effect_positions = function (self, target_position)
	local effect_id = self._active_shout_effect_id

	if not effect_id then
		return
	end

	World.move_particles(self._world, effect_id, target_position)
end

ShoutEffects._destroy_effects = function (self)
	local world = self._world

	if self._aim_shout_effect_id then
		World.destroy_particles(world, self._aim_shout_effect_id)

		self._aim_shout_effect_id = nil
	end

	if self._active_shout_effect_id then
		World.destroy_particles(world, self._active_shout_effect_id)

		self._active_shout_effect_id = nil
	end
end

return ShoutEffects
