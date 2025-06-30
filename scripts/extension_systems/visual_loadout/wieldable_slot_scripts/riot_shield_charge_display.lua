-- chunkname: @scripts/extension_systems/visual_loadout/wieldable_slot_scripts/riot_shield_charge_display.lua

local Component = require("scripts/utilities/component")
local WieldableSlotScriptInterface = require("scripts/extension_systems/visual_loadout/wieldable_slot_scripts/wieldable_slot_script_interface")
local RiotShieldChargeDisplay = class("RiotShieldChargeDisplay")
local _external_properties = {}

RiotShieldChargeDisplay.init = function (self, context, slot, weapon_template, fx_sources, item, unit_1p, unit_3p)
	local owner_unit = context.owner_unit
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	local inventory_slot_component = unit_data_extension:read_component(slot.name)

	self._inventory_slot_component = inventory_slot_component

	local unit_components = {}
	local attachments_1p = slot.attachments_by_unit_1p[unit_1p]
	local num_attachments_1p = #attachments_1p

	for ii = 1, num_attachments_1p do
		local attachment_unit = attachments_1p[ii]
		local components = Component.get_components_by_name(attachment_unit, "AmmoDisplay")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end

	local attachments_3p = slot.attachments_by_unit_3p[unit_3p]
	local num_attachments_3p = #attachments_3p

	for ii = 1, num_attachments_3p do
		local attachment_unit = attachments_3p[ii]
		local components = Component.get_components_by_name(attachment_unit, "AmmoDisplay")

		for _, component in ipairs(components) do
			unit_components[#unit_components + 1] = {
				unit = attachment_unit,
				component = component,
			}
		end
	end

	self._is_husk = context.is_husk
	self._is_local_unit = context.is_local_unit
	self._wwise_world = context.wwise_world
	self._weapon_special_tweak_data = weapon_template.weapon_special_tweak_data
	self._fx_extension = context.fx_extension
	self._visual_loadout_extension = context.visual_loadout_extension
	self._unit_components = unit_components
	self._num_special_charges = inventory_slot_component.num_special_charges
	self._display_sfx_source_name = fx_sources._display
end

RiotShieldChargeDisplay.fixed_update = function (self, unit, dt, t, frame)
	return
end

RiotShieldChargeDisplay.update = function (self, unit, dt, t)
	local above_threshold = false
	local charge_level, max_visual_charges, crossed_threshold
	local tweak_data = self._weapon_special_tweak_data
	local max_charges

	if tweak_data then
		max_charges = tweak_data.max_charges

		local thresholds = tweak_data.thresholds
		local num_special_charges = self._inventory_slot_component.num_special_charges

		charge_level = num_special_charges / max_charges
		max_visual_charges = math.floor(math.lerp(0, 14, charge_level))

		for ii = #thresholds, 2, -1 do
			local threshold = thresholds[ii].threshold

			if threshold <= num_special_charges then
				crossed_threshold = num_special_charges % threshold == 0
				above_threshold = true

				break
			end
		end
	end

	local unit_components = self._unit_components
	local num_displays = #unit_components

	for ii = 1, num_displays do
		local display = unit_components[ii]

		display.component:set_charges(display.unit, charge_level or 0, max_visual_charges or 0, above_threshold)
		display.component:set_frame_enabled(display.unit, not not max_charges and max_charges > 0)
	end

	if not self._is_local_unit or self._is_husk then
		return
	end

	local current_num_charges = self._num_special_charges
	local new_num_charges = self._inventory_slot_component.num_special_charges

	if new_num_charges ~= current_num_charges then
		local trigger_sound = above_threshold and crossed_threshold and current_num_charges < new_num_charges

		if trigger_sound then
			_external_properties.indicator_type = "riot_shield_block_charge"

			local resolved, event_name, _ = self._visual_loadout_extension:resolve_gear_sound("charge_ready_indicator", _external_properties)

			if resolved then
				local sfx_source_id = self._fx_extension:sound_source(self._display_sfx_source_name)

				WwiseWorld.trigger_resource_event(self._wwise_world, event_name, sfx_source_id)
			end
		end

		self._num_special_charges = new_num_charges
	end
end

RiotShieldChargeDisplay.update_first_person_mode = function (self, first_person_mode)
	return
end

RiotShieldChargeDisplay.wield = function (self)
	self._num_special_charges = self._inventory_slot_component.num_special_charges
end

RiotShieldChargeDisplay.unwield = function (self)
	return
end

RiotShieldChargeDisplay.destroy = function (self)
	return
end

implements(RiotShieldChargeDisplay, WieldableSlotScriptInterface)

return RiotShieldChargeDisplay
