-- chunkname: @scripts/extension_systems/ability/equipped_ability_effect_scripts/hide_visibility_group_effects.lua

local HideVisibilityGroupEffects = class("HideVisibilityGroupEffects")

HideVisibilityGroupEffects.init = function (self, equipped_ability_effect_scripts_context, ability_template)
	if DEDICATED_SERVER then
		return
	end

	self._ability_template = ability_template
	self._world = equipped_ability_effect_scripts_context.world
	self._wwise_world = equipped_ability_effect_scripts_context.wwise_world
	self._unit = equipped_ability_effect_scripts_context.unit
	self._is_local_unit = equipped_ability_effect_scripts_context.is_local_unit

	local unit = self._unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")

	self._inventory_component = unit_data_extension:read_component("inventory")

	local equipped_ability_effect_scripts_tweak_data = ability_template.equipped_ability_effect_scripts_tweak_data
	local hide_visibility_group = equipped_ability_effect_scripts_tweak_data.hide_visibility_group

	self._target_unit_slot = hide_visibility_group.target_unit_slot
	self._visibility_group_name = hide_visibility_group.visibility_group_name
	self._target_wielded_slot = hide_visibility_group.target_wielded_slot
	self._visual_loadout_extension = ScriptUnit.has_extension(unit, "visual_loadout_system")
	self._is_hand_hidden = false
end

HideVisibilityGroupEffects.extensions_ready = function (self, world, unit)
	self._visual_loadout_extension = ScriptUnit.has_extension(unit, "visual_loadout_system")
end

HideVisibilityGroupEffects.update = function (self, unit, dt, t)
	if DEDICATED_SERVER then
		return
	end

	local wielded_slot = self._inventory_component.wielded_slot
	local is_wielding_target_slot = wielded_slot == self._target_wielded_slot

	if is_wielding_target_slot and not self._is_hand_hidden then
		self:_set_hand_visibility(false)
	elseif not is_wielding_target_slot and self._is_hand_hidden then
		self:_set_hand_visibility(true)
	end
end

HideVisibilityGroupEffects.destroy = function (self)
	if DEDICATED_SERVER then
		return
	end

	if self._is_hand_hidden then
		self:_set_hand_visibility(true)
	end
end

HideVisibilityGroupEffects._set_hand_visibility = function (self, visibility)
	self._is_hand_hidden = not visibility

	local unit_1p, unit_3p, _, _ = self._visual_loadout_extension:unit_and_attachments_from_slot(self._target_unit_slot)
	local has_visibility_group = Unit.has_visibility_group(unit_1p, self._visibility_group_name) and Unit.has_visibility_group(unit_3p, self._visibility_group_name)

	if has_visibility_group then
		Unit.set_visibility(unit_1p, self._visibility_group_name, visibility)
		Unit.set_visibility(unit_3p, self._visibility_group_name, visibility)
	end
end

return HideVisibilityGroupEffects
