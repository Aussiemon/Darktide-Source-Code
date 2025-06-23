-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/ammo_belt.lua

local Action = require("scripts/utilities/action/action")
local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local AmmoBelt = class("AmmoBelt")

AmmoBelt.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit

	self._weapon_actions = weapon_template.actions

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	local unit_components = {}
	local attachments_1p = slot.attachments_by_unit_1p[unit_1p]
	local num_attachments_1p = #attachments_1p

	for ii = 1, num_attachments_1p do
		local attachment_unit = attachments_1p[ii]
		local components = Component.get_components_by_name(attachment_unit, "AmmoBelt")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = attachment_unit,
				component = component
			}
		end
	end

	local attachments_3p = slot.attachments_by_unit_3p[unit_3p]
	local num_attachments_3p = #attachments_3p

	for ii = 1, num_attachments_3p do
		local attachment_unit = attachments_3p[ii]
		local components = Component.get_components_by_name(attachment_unit, "AmmoBelt")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = attachment_unit,
				component = component
			}
		end
	end

	self._unit_components = unit_components
end

AmmoBelt.fixed_update = function (self, unit, dt, t, frame)
	return
end

AmmoBelt.update = function (self, unit, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local current_ammo_clip = inventory_slot_component.current_ammunition_clip
	local current_ammo_reserve = inventory_slot_component.current_ammunition_reserve
	local max_ammo_clip = inventory_slot_component.max_ammunition_clip
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
	local is_reloading = action_kind == "reload_state" or action_kind == "reload_shotgun"
	local unit_components = self._unit_components
	local num_components = #unit_components

	for ii = 1, num_components do
		local ammo_belt = unit_components[ii]

		current_ammo_clip = is_reloading and math.min(max_ammo_clip, current_ammo_reserve) or current_ammo_clip

		ammo_belt.component:set_ammo(ammo_belt.unit, current_ammo_clip, max_ammo_clip)
	end
end

AmmoBelt.update_first_person_mode = function (self, first_person_mode)
	return
end

AmmoBelt.wield = function (self)
	return
end

AmmoBelt.unwield = function (self)
	return
end

AmmoBelt.destroy = function (self)
	return
end

implements(AmmoBelt, WieldableSlotScriptInterface)

return AmmoBelt
