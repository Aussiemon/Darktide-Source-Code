-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/cryptic_servo_skull_order_effects.lua

local Action = require("scripts/utilities/action/action")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local CrypticServoSkullOrderEffects = class("CrypticServoSkullOrderEffects")

CrypticServoSkullOrderEffects.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	self._wwise_world = context.wwise_world
	self._weapon_actions = weapon_template.actions
	self._fx_sources = fx_sources

	local owner_unit = context.owner_unit

	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._weapon_template = weapon_template
	self._weapon_template_order_effects = weapon_template.order_effects

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._effects_running = false
end

CrypticServoSkullOrderEffects.fixed_update = function (self, unit, dt, t, frame)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local is_ordering_skull = action_settings and action_settings.name == "action_aim_servo_skull"

	if not self._effects_running and is_ordering_skull then
		self:_start_effects(t)
	elseif self._effects_running and not is_ordering_skull then
		self:_stop_effects()
	elseif self._effects_running then
		self:_run_looping_sfx(frame)
	end
end

CrypticServoSkullOrderEffects.update = function (self, unit, dt, t)
	return
end

CrypticServoSkullOrderEffects.update_first_person_mode = function (self, first_person_mode)
	return
end

CrypticServoSkullOrderEffects.wield = function (self)
	return
end

CrypticServoSkullOrderEffects.unwield = function (self)
	return
end

CrypticServoSkullOrderEffects.destroy = function (self)
	return
end

CrypticServoSkullOrderEffects._start_effects = function (self, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local order_effects = action_settings and action_settings.order_effects or self._weapon_template_order_effects

	if order_effects then
		self._order_effects = order_effects
		self._effects_running = true
	end
end

CrypticServoSkullOrderEffects._stop_effects = function (self)
	self._order_effects = nil
	self._looping_sound_alias = nil
	self._effects_running = false
end

CrypticServoSkullOrderEffects._run_looping_sfx = function (self, frame)
	local order_effects = self._order_effects

	if not order_effects then
		return
	end

	self._looping_sound_alias = order_effects.looping_sound_alias

	if self._looping_sound_alias then
		local fx_sources = self._fx_sources
		local sfx_source_name = order_effects.sfx_source_name
		local sfx_is_2d = order_effects.is_2d
		local sfx_source = not sfx_is_2d and fx_sources[sfx_source_name] or nil

		self._fx_extension:run_looping_sound(self._looping_sound_alias, sfx_source, nil, frame)
	end
end

implements(CrypticServoSkullOrderEffects, WieldableSlotScriptInterface)

return CrypticServoSkullOrderEffects
