-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/revolver_bullets.lua

local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local _components
local RevolverBullets = class("RevolverBullets")

RevolverBullets.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit

	self._owner_unit = owner_unit

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._bullets = {
		{
			casing_attachment_name = "casing_01",
			bullet_attachment_name = "bullet_01",
			visible = true
		},
		{
			casing_attachment_name = "casing_02",
			bullet_attachment_name = "bullet_02",
			visible = true
		},
		{
			casing_attachment_name = "casing_03",
			bullet_attachment_name = "bullet_03",
			visible = true
		},
		{
			casing_attachment_name = "casing_04",
			bullet_attachment_name = "bullet_04",
			visible = true
		},
		{
			casing_attachment_name = "casing_05",
			bullet_attachment_name = "bullet_05",
			visible = true
		}
	}
	self._components_1p = {}
	self._components_3p = {}
	self._components_lookup_1p = {}
	self._components_lookup_3p = {}

	_components(self._components_1p, self._components_lookup_1p, slot.attachments_by_unit_1p[unit_1p], slot.attachment_map_by_unit_1p[unit_1p])
	_components(self._components_3p, self._components_lookup_3p, slot.attachments_by_unit_3p[unit_3p], slot.attachment_map_by_unit_3p[unit_3p])
end

RevolverBullets.fixed_update = function (self, unit, dt, t)
	return
end

RevolverBullets.update = function (self, unit, dt, t, frame)
	self:_update_ammo_count()
end

RevolverBullets.update_first_person_mode = function (self, first_person_mode)
	self:_update_ammo_count(true)
end

RevolverBullets.wield = function (self)
	self:_update_ammo_count(true)
end

RevolverBullets.unwield = function (self)
	return
end

RevolverBullets.destroy = function (self)
	return
end

RevolverBullets._update_ammo_count = function (self, force_update)
	local inventory_slot_component = self._inventory_slot_component
	local current_ammo_clip = inventory_slot_component.current_ammunition_clip
	local max_ammo_clip = inventory_slot_component.max_ammunition_clip
	local missing_ammo = max_ammo_clip - current_ammo_clip
	local components_lookup_1p = self._components_lookup_1p
	local components_lookup_3p = self._components_lookup_3p
	local is_in_1p = self._first_person_extension:is_in_first_person_mode()
	local bullets = self._bullets

	for ii = 1, #bullets do
		local bullet = bullets[ii]
		local is_visible = bullet.visible
		local should_be_visible = missing_ammo < ii
		local bullet_attachment_name = bullet.bullet_attachment_name
		local casing_attachment_name = bullet.casing_attachment_name
		local bullet_component_1p = components_lookup_1p[bullet_attachment_name].component
		local bullet_component_3p = components_lookup_3p[bullet_attachment_name].component
		local casing_component_1p = components_lookup_1p[casing_attachment_name].component
		local casing_component_3p = components_lookup_3p[casing_attachment_name].component

		if (force_update or is_visible) and not should_be_visible then
			if is_in_1p then
				bullet_component_1p:hide()
				casing_component_1p:show()
			else
				bullet_component_3p:hide()
				casing_component_3p:show()
			end
		elseif (force_update or not is_visible) and should_be_visible then
			if is_in_1p then
				bullet_component_1p:show()
				casing_component_1p:hide()
			else
				bullet_component_3p:show()
				casing_component_3p:hide()
			end
		end

		bullet.visible = should_be_visible
	end
end

function _components(destination, destination_lookup, attachments, attachment_name_lookup)
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local attachment_unit = attachments[ii]
		local components = Component.get_components_by_name(attachment_unit, "HideableAmmo")

		for _, component in ipairs(components) do
			local lookup_name = attachment_name_lookup[attachment_unit]
			local data = {
				unit = attachment_unit,
				lookup_name = lookup_name,
				component = component
			}

			destination[#destination + 1] = data
			destination_lookup[lookup_name] = data
		end
	end
end

implements(RevolverBullets, WieldableSlotScriptInterface)

return RevolverBullets
