-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/holo_sight.lua

local Action = require("scripts/utilities/action/action")
local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local HoloSightTemplates = require("scripts/settings/equipment/holo_sight_templates")
local HoloSight = class("HoloSight")
local _slot_components, _update_glass_visibility

HoloSight.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local alternate_fire_component = unit_data_extension:read_component("alternate_fire")

	self._alternate_fire_component = alternate_fire_component
	self._equipment_component = context.equipment_component
	self._first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self._was_aiming_down_sights = false
	self._slot = slot
	self._hip_at_t = nil
	self._alternate_fire_at_t = nil
	self._holo_sight_components_1p = _slot_components(slot.attachments_by_unit_1p[unit_1p])
	self._holo_sight_components_3p = _slot_components(slot.attachments_by_unit_3p[unit_3p])

	_update_glass_visibility(self._holo_sight_components_3p, false)

	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")

	local holo_sight_template = weapon_template.holo_sight_template

	self._holo_sight_template = holo_sight_template or HoloSightTemplates.default
end

HoloSight.update = function (self, unit, dt, t)
	local is_aiming_down_sights = self._alternate_fire_component.is_active
	local first_person_extension = self._first_person_extension

	if first_person_extension:is_in_first_person_mode() then
		local unit_1p = self._slot.parent_unit_1p
		local holo_sight_template = self._holo_sight_template
		local show_delay = holo_sight_template.show_delay
		local hide_delay = holo_sight_template.hide_delay
		local ads_ring = holo_sight_template.ads_ring
		local ads_dot = holo_sight_template.ads_dot
		local hip_ring = holo_sight_template.hip_ring
		local hip_dot = holo_sight_template.hip_dot
		local diff_ring = holo_sight_template.diff_ring
		local diff_dot = holo_sight_template.diff_dot
		local hip_at_t = self._hip_at_t
		local alternate_fire_at_t = self._alternate_fire_at_t
		local was_in_third_person = self._was_in_third_person
		local was_aiming_down_sights = self._was_aiming_down_sights

		if (was_aiming_down_sights or was_in_third_person) and not is_aiming_down_sights and not hip_at_t then
			hip_at_t = t + show_delay
		elseif (not was_aiming_down_sights or was_in_third_person) and is_aiming_down_sights then
			alternate_fire_at_t = alternate_fire_at_t or t + hide_delay
		end

		if was_in_third_person then
			hip_at_t = 0
			self._was_in_third_person = false
		end

		if hip_at_t then
			local progress = math.ease_exp(1 - math.clamp((hip_at_t - t) / show_delay, 0, 1))
			local ring = ads_ring - diff_ring * progress
			local dot = ads_dot - diff_dot * progress

			Unit.set_vector2_for_materials(unit_1p, "optic_layers", Vector2(ring, dot), true)

			if hip_at_t <= t then
				hip_at_t = nil
			end
		elseif alternate_fire_at_t then
			local progress = math.easeInCubic(1 - math.clamp((alternate_fire_at_t - t) / hide_delay, 0, 1))
			local ring = hip_ring + diff_ring * progress
			local dot = hip_dot + diff_dot * progress

			Unit.set_vector2_for_materials(unit_1p, "optic_layers", Vector2(ring, dot), true)

			if alternate_fire_at_t <= t then
				alternate_fire_at_t = nil
			end
		end

		self._hip_at_t = hip_at_t
		self._alternate_fire_at_t = alternate_fire_at_t

		local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
		local action_kind = action_settings and action_settings.kind
		local is_inspecting = action_kind == "inspect"

		if not self._was_inspecting and is_inspecting then
			_update_glass_visibility(self._holo_sight_components_1p, false)

			self._was_inspecting = true
		elseif self._was_inspecting and not is_inspecting then
			_update_glass_visibility(self._holo_sight_components_1p, true)

			self._was_inspecting = false
		end
	end

	self._was_aiming_down_sights = is_aiming_down_sights
end

HoloSight.update_first_person_mode = function (self, first_person_mode)
	return
end

HoloSight.wield = function (self)
	self._was_aiming_down_sights = true
end

HoloSight.unwield = function (self)
	return
end

HoloSight.destroy = function (self)
	return
end

function _slot_components(attachments)
	local component_list = {}

	for ii = 1, #attachments do
		local attachment_unit = attachments[ii]
		local components = Component.get_components_by_name(attachment_unit, "HoloSight")

		for _, component in ipairs(components) do
			Unit.set_unit_objects_visibility(attachment_unit, true, false)

			component_list[#component_list + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end

	return component_list
end

function _update_glass_visibility(components, is_visible)
	for ii = 1, #components do
		local holo_sight = components[ii]

		holo_sight.component:set_glass_visibility(is_visible)
	end
end

implements(HoloSight, WieldableSlotScriptInterface)

return HoloSight
