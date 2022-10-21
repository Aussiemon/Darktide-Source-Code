require("scripts/extension_systems/weapon/actions/action_target_finder")

local ActionModules = require("scripts/extension_systems/weapon/actions/modules/action_modules")
local ActionOverloadTargetFinder = class("ActionOverloadTargetFinder", "ActionTargetFinder")

ActionOverloadTargetFinder.init = function (self, action_context, action_params, action_settings)
	ActionOverloadTargetFinder.super.init(self, action_context, action_params, action_settings)

	local player_unit = self._player_unit
	local overload_module_class_name = action_settings.overload_module_class_name
	self._overload_module = ActionModules[overload_module_class_name]:new(player_unit, action_settings, self._inventory_slot_component)
	local weapon = action_params.weapon
	self._fx_sources = weapon.fx_sources
end

ActionOverloadTargetFinder.start = function (self, action_settings, t, time_scale, action_start_params)
	ActionOverloadTargetFinder.super.start(self, action_settings, t, time_scale, action_start_params)
	self._overload_module:start(t)

	local fx_extension = self._fx_extension
	local charge_effects = action_settings.charge_effects

	if charge_effects then
		local fx_sources = self._fx_sources
		local looping_sound_alias = charge_effects.looping_sound_alias

		if looping_sound_alias then
			local sfx_source_name = charge_effects.sfx_source_name
			local sfx_source = fx_sources[sfx_source_name]

			fx_extension:trigger_looping_wwise_event(looping_sound_alias, sfx_source)

			self._looping_sound_alias = looping_sound_alias
		end

		local looping_effect_alias = charge_effects.looping_effect_alias

		if looping_effect_alias then
			local vfx_source_name = charge_effects.vfx_source_name
			local vfx_source = fx_sources[vfx_source_name]

			fx_extension:spawn_looping_particles(looping_effect_alias, vfx_source)

			self._looping_effect_alias = looping_effect_alias
		end
	end
end

ActionOverloadTargetFinder.fixed_update = function (self, dt, t, time_in_action)
	ActionOverloadTargetFinder.super.fixed_update(self, dt, t, time_in_action)
	self._overload_module:fixed_update(dt, t)
end

ActionOverloadTargetFinder.finish = function (self, reason, data, t, time_in_action)
	ActionOverloadTargetFinder.super.finish(self, reason, data, t, time_in_action)
	self._overload_module:finish(reason, data, t)

	local fx_extension = self._fx_extension
	local looping_sound_alias = self._looping_sound_alias
	local looping_effect_alias = self._looping_effect_alias

	if looping_sound_alias then
		fx_extension:stop_looping_wwise_event(looping_sound_alias)
	end

	if looping_effect_alias then
		fx_extension:stop_looping_particles(looping_effect_alias, true)
	end
end

return ActionOverloadTargetFinder
