-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/revolver_speedloader.lua

local Action = require("scripts/utilities/weapon/action")
local Component = require("scripts/utilities/component")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local _components
local RevolverSpeedloader = class("RevolverSpeedloader")

RevolverSpeedloader.init = function (self, context, slot, weapon_template, fx_sources)
	local owner_unit = context.owner_unit

	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._is_reloading = false

	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")

	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._bullets = {
		{
			bullet_attachment_name = "bullet_01",
			casing_attachment_name = "casing_01",
			visible = true,
			visible_at_reload_start = true,
		},
		{
			bullet_attachment_name = "bullet_02",
			casing_attachment_name = "casing_02",
			visible = true,
			visible_at_reload_start = true,
		},
		{
			bullet_attachment_name = "bullet_03",
			casing_attachment_name = "casing_03",
			visible = true,
			visible_at_reload_start = true,
		},
		{
			bullet_attachment_name = "bullet_04",
			casing_attachment_name = "casing_04",
			visible = true,
			visible_at_reload_start = true,
		},
		{
			bullet_attachment_name = "bullet_05",
			casing_attachment_name = "casing_05",
			visible = true,
			visible_at_reload_start = true,
		},
	}
	self._components_1p = {}
	self._components_3p = {}
	self._components_lookup_1p = {}
	self._components_lookup_3p = {}

	_components(self._components_1p, self._components_lookup_1p, slot.attachments_1p, slot.attachments_name_lookup_1p)
	_components(self._components_3p, self._components_lookup_3p, slot.attachments_3p, slot.attachments_name_lookup_3p)
end

RevolverSpeedloader.fixed_update = function (self, unit, dt, t)
	return
end

RevolverSpeedloader.update = function (self, unit, dt, t, frame)
	self:_update_ammo_count(t, false)
end

RevolverSpeedloader.update_first_person_mode = function (self, first_person_mode)
	self:_update_ammo_count(nil, true)
end

RevolverSpeedloader.wield = function (self)
	self:_update_ammo_count(nil, true)
end

RevolverSpeedloader.unwield = function (self)
	return
end

RevolverSpeedloader.destroy = function (self)
	return
end

RevolverSpeedloader._update_ammo_count = function (self, t, force_update)
	local weapon_action_component = self._weapon_action_component
	local inventory_slot_component = self._inventory_slot_component
	local current_ammo_clip = inventory_slot_component.current_ammunition_clip
	local max_ammo_clip = inventory_slot_component.max_ammunition_clip
	local missing_ammo = max_ammo_clip - current_ammo_clip
	local action_settings = Action.current_action_settings_from_component(weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
	local is_reloading = action_kind == "reload_state" or action_kind == "reload_shotgun"
	local bullets = self._bullets

	if not self._is_reloading and is_reloading then
		for ii = 1, #bullets do
			local bullet = bullets[ii]

			bullet.visible_at_reload_start = bullet.visible
		end
	end

	self._is_reloading = is_reloading

	local components_lookup_1p = self._components_lookup_1p
	local components_lookup_3p = self._components_lookup_3p
	local is_in_1p = self._first_person_extension:is_in_first_person_mode()
	local show_all_bullets = false

	if is_reloading then
		local action_start_time = weapon_action_component.start_t
		local time_in_action = (t or 0) - action_start_time
		local reload_template = self._weapon_template.reload_template
		local reload_state = ReloadStates.reload_state(reload_template, inventory_slot_component)
		local show_magazine_ammo_time = reload_state.show_magazine_ammo_time or 0

		if show_magazine_ammo_time <= time_in_action then
			show_all_bullets = true
		end
	end

	for ii = 1, #bullets do
		local bullet = bullets[ii]
		local is_visible = bullet.visible
		local should_be_visible = show_all_bullets or is_reloading and bullet.visible_at_reload_start or missing_ammo < ii
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

		local update_visibility = not is_reloading or is_reloading and show_all_bullets

		if update_visibility then
			bullet.visible = should_be_visible
		end
	end
end

function _components(destination, destination_lookup, attachments, attachments_name_lookup)
	local num_attachments = #attachments

	for ii = 1, num_attachments do
		local attachment_unit = attachments[ii]
		local components = Component.get_components_by_name(attachment_unit, "HideableAmmo")

		for _, component in ipairs(components) do
			local lookup_name = attachments_name_lookup[attachment_unit]
			local data = {
				unit = attachment_unit,
				lookup_name = lookup_name,
				component = component,
			}

			destination[#destination + 1] = data
			destination_lookup[lookup_name] = data
		end
	end
end

return RevolverSpeedloader
