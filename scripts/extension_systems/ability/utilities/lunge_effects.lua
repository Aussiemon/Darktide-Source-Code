local LungeTemplates = require("scripts/settings/lunge/lunge_templates")
local LungeEffects = class("LungeEffects")

LungeEffects.init = function (self, equiped_ability_effect_scripts_context, ability_template)
	self._is_local_unit = equiped_ability_effect_scripts_context.is_local_unit
	self._ability_template = ability_template
	local unit_data_extension = equiped_ability_effect_scripts_context.unit_data_extension
	self._lunge_character_state_component = unit_data_extension:read_component("lunge_character_state")
	self._is_sfx_active = false
	local unit = equiped_ability_effect_scripts_context.unit
	self._unit = unit
	self._fx_extension = ScriptUnit.has_extension(unit, "fx_system")
end

LungeEffects.destroy = function (self)
	if self._is_sfx_active then
		self:_stop_effects()
		self:_reset_wwise_state()
	end
end

LungeEffects.update = function (self, unit, dt, t)
	local lunge_character_state_component = self._lunge_character_state_component
	local is_lunging = lunge_character_state_component.is_lunging
	local is_sfx_active = self._is_sfx_active

	if is_lunging and not is_sfx_active then
		self._is_sfx_active = true
		local lunge_template_name = lunge_character_state_component.lunge_template
		self._lunge_template = LungeTemplates[lunge_template_name]

		self:_start_effects()
		self:_set_wwise_state()
	elseif not is_lunging and is_sfx_active then
		self._is_sfx_active = false

		self:_stop_effects()
		self:_reset_wwise_state()
	end
end

LungeEffects._start_effects = function (self)
	local lunge_template = self._lunge_template
	local start_sound_event = lunge_template and lunge_template.start_sound_event

	if start_sound_event and self._is_local_unit then
		self._fx_extension:trigger_wwise_event(start_sound_event, false)
	end
end

LungeEffects._stop_effects = function (self)
	local lunge_template = self._lunge_template
	local stop_sound_event = lunge_template and lunge_template.stop_sound_event

	if stop_sound_event and self._is_local_unit then
		self._fx_extension:trigger_wwise_event(stop_sound_event, false)
	end
end

LungeEffects._set_wwise_state = function (self)
	local lunge_template = self._lunge_template
	local wwise_state = lunge_template and lunge_template.wwise_state

	if wwise_state and self._is_local_unit then
		Wwise.set_state(wwise_state.group, wwise_state.on_state)
	end
end

LungeEffects._reset_wwise_state = function (self)
	local lunge_template = self._lunge_template
	local wwise_state = lunge_template and lunge_template.wwise_state

	if wwise_state and self._is_local_unit then
		Wwise.set_state(wwise_state.group, wwise_state.off_state)
	end
end

return LungeEffects
