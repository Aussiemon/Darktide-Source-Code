-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/magazine_ammo.lua

local Action = require("scripts/utilities/weapon/action")
local Component = require("scripts/utilities/component")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local MagazineAmmo = class("MagazineAmmo")

MagazineAmmo.init = function (self, context, slot, weapon_template, fx_sources)
	local owner_unit = context.owner_unit

	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._reload_template = weapon_template.reload_template
	self._is_reloading = false
	self._ammo_clip_at_reload_start = 0

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	local unit_components = {}
	local num_attachments_1p = #slot.attachments_1p

	for ii = 1, num_attachments_1p do
		local attachment_unit = slot.attachments_1p[ii]
		local components = Component.get_components_by_name(attachment_unit, "MagazineAmmo")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end

	local num_attachments_3p = #slot.attachments_3p

	for ii = 1, num_attachments_3p do
		local attachment_unit = slot.attachments_3p[ii]
		local components = Component.get_components_by_name(attachment_unit, "MagazineAmmo")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end

	self._unit_components = unit_components
end

MagazineAmmo.fixed_update = function (self, unit, dt, t, frame)
	return
end

MagazineAmmo.update = function (self, unit, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local weapon_action_component = self._weapon_action_component
	local current_ammo_clip = inventory_slot_component.current_ammunition_clip
	local current_ammo_reserve = inventory_slot_component.current_ammunition_reserve
	local max_ammo_clip = inventory_slot_component.max_ammunition_clip
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
	local is_reloading = action_kind == "reload_state" or action_kind == "reload_shotgun"

	if not self._is_reloading and is_reloading then
		self._ammo_clip_at_reload_start = current_ammo_clip
	end

	self._is_reloading = is_reloading

	local show_full_magazine = false

	if is_reloading then
		local action_start_time = weapon_action_component.start_t
		local time_in_action = t - action_start_time
		local reload_template = self._weapon_template.reload_template
		local reload_state = ReloadStates.reload_state(reload_template, inventory_slot_component)
		local show_magazine_ammo_time = reload_state.show_magazine_ammo_time or 0

		if show_magazine_ammo_time <= time_in_action then
			show_full_magazine = true
		end
	end

	local ammo_in_magazine

	if is_reloading then
		if show_full_magazine then
			ammo_in_magazine = math.min(max_ammo_clip, current_ammo_reserve)
		else
			ammo_in_magazine = self._ammo_clip_at_reload_start
		end
	else
		ammo_in_magazine = current_ammo_clip
	end

	local unit_components = self._unit_components
	local num_components = #unit_components

	for ii = 1, num_components do
		local display = unit_components[ii]

		display.component:set_ammo(display.unit, ammo_in_magazine, max_ammo_clip)
	end
end

MagazineAmmo.update_first_person_mode = function (self, first_person_mode)
	return
end

MagazineAmmo.wield = function (self)
	return
end

MagazineAmmo.unwield = function (self)
	return
end

MagazineAmmo.destroy = function (self)
	return
end

implements(MagazineAmmo, WieldableSlotScriptInterface)

return MagazineAmmo
