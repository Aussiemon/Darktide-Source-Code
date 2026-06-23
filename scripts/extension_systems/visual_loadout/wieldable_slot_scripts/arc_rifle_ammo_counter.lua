-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/arc_rifle_ammo_counter.lua

local Action = require("scripts/utilities/action/action")
local Ammo = require("scripts/utilities/ammo")
local Component = require("scripts/utilities/component")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local ArcRifleAmmoCounter = class("ArcRifleAmmoCounter")
local VISUAL_AMMO_REFILL_DURATION = 0.45
local _unit_components

ArcRifleAmmoCounter.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local slot_name = slot.name

	self._inventory_slot_component = unit_data_extension:read_component(slot_name)
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._ammo_refill_start_time = nil
	self._is_reloading = false
	self._last_clip_size = 0
	self._weapon_material_variables_1p = {}
	self._weapon_material_variables_3p = {}

	_unit_components(self._weapon_material_variables_1p, slot.attachments_by_unit_1p[unit_1p])
	_unit_components(self._weapon_material_variables_3p, slot.attachments_by_unit_3p[unit_3p])
end

ArcRifleAmmoCounter.destroy = function (self)
	return
end

ArcRifleAmmoCounter.wield = function (self)
	self:_toggle_on_off(true)
end

ArcRifleAmmoCounter.unwield = function (self)
	self:_toggle_on_off(false)
end

ArcRifleAmmoCounter.fixed_update = function (self, unit, dt, t, frame)
	return
end

ArcRifleAmmoCounter.update = function (self, unit, dt, t)
	local weapon_action_component = self._weapon_action_component
	local time_scale = weapon_action_component.time_scale
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
	local is_reloading = action_kind == "reload_state" or action_kind == "reload_shotgun"

	self:_update_ammo_count(unit, dt, t, time_scale, is_reloading)
	self:_update_reloading(unit, dt, t, time_scale, is_reloading)
	self:_update_reload_refill(t, time_scale, is_reloading)
end

ArcRifleAmmoCounter._update_ammo_count = function (self, unit, dt, t, time_scale, is_reloading)
	if is_reloading then
		return
	end

	local inventory_slot_component = self._inventory_slot_component
	local current_clip = Ammo.current_ammo_in_clips(inventory_slot_component)

	if self._last_clip_size ~= current_clip then
		local max_clip = Ammo.max_ammo_in_clips(inventory_slot_component)
		local ammo_percentage = max_clip > 0 and current_clip / max_clip or 0

		self:_set_weapon_material_charge_level(ammo_percentage)

		self._last_clip_size = current_clip
	end
end

ArcRifleAmmoCounter._update_reloading = function (self, unit, dt, t, time_scale, is_reloading)
	local inventory_slot_component = self._inventory_slot_component
	local weapon_action_component = self._weapon_action_component

	if is_reloading then
		local action_start_time = weapon_action_component.start_t
		local time_in_action = (t or 0) - action_start_time
		local reload_template = self._weapon_template.reload_template
		local reload_state = ReloadStates.reload_state(reload_template, inventory_slot_component)
		local show_magazine_ammo_time = reload_state.show_magazine_ammo_time or 0

		if time_in_action >= show_magazine_ammo_time / time_scale and not self._ammo_refill_start_time then
			self._ammo_refill_start_time = t
		end

		local hide_magazine_ammo_time = reload_state.hide_magazine_ammo_time or 0

		if time_in_action >= hide_magazine_ammo_time / time_scale and not self._ammo_refill_start_time then
			self:_set_weapon_material_charge_level(0)
		end
	end

	self._is_reloading = is_reloading
end

ArcRifleAmmoCounter._update_reload_refill = function (self, t, time_scale, is_reloading)
	if not self._ammo_refill_start_time then
		return
	end

	local ammo_refill_start_time = self._ammo_refill_start_time
	local ammo_refill_end_time = ammo_refill_start_time + VISUAL_AMMO_REFILL_DURATION / time_scale
	local lerp_t = math.ilerp(ammo_refill_start_time, ammo_refill_end_time, t)
	local value = math.lerp(0, 1, math.ease_in_quad(lerp_t))

	self:_set_weapon_material_charge_level(value)

	if lerp_t >= 1 and not self._is_reloading then
		self._ammo_refill_start_time = nil
	end
end

ArcRifleAmmoCounter.update_first_person_mode = function (self, first_person_mode)
	return
end

ArcRifleAmmoCounter._set_weapon_material_charge_level = function (self, ammo_percentage)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:set_charge_level(ammo_percentage, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:set_charge_level(ammo_percentage, weapon_material_variable.unit)
	end
end

ArcRifleAmmoCounter._toggle_on_off = function (self, is_on)
	local variables_1p = self._weapon_material_variables_1p
	local variables_3p = self._weapon_material_variables_3p

	for ii = 1, #variables_1p do
		local weapon_material_variable = variables_1p[ii]

		weapon_material_variable.component:toggle_on_off(is_on, weapon_material_variable.unit)
	end

	for ii = 1, #variables_3p do
		local weapon_material_variable = variables_3p[ii]

		weapon_material_variable.component:toggle_on_off(is_on, weapon_material_variable.unit)
	end
end

function _unit_components(components, attachments)
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local attachment_unit = attachments[ii]
		local unit_components = Component.get_components_by_name(attachment_unit, "WeaponMaterialVariables")

		for _, component in ipairs(unit_components) do
			components[#components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end
end

implements(ArcRifleAmmoCounter, WieldableSlotScriptInterface)

return ArcRifleAmmoCounter
