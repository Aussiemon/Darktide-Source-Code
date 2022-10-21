local Action = require("scripts/utilities/weapon/action")
local Component = require("scripts/utilities/component")
local SweepTrail = class("SweepTrail")
local WINDUP_START_SOUND_ALIAS = "windup_start"
local WINDUP_STOP_SOUND_ALIAS = "windup_stop"
local SOURCE_NAME = "_sweep"
local VISIBILITY_GROUP_NAME = "trail"
local EXTERNAL_PROPERTIES = {}
local _slot_components, _update_status = nil

SweepTrail.init = function (self, context, slot, weapon_template, fx_sources, item)
	local owner_unit = context.owner_unit
	self._weapon_template = weapon_template
	self._weapon_actions = weapon_template.actions
	self._fx_source_name = fx_sources[SOURCE_NAME]
	self._playing_id = nil
	local unit_data_extension = ScriptUnit.extension(owner_unit, "unit_data_system")
	self._critical_strike_component = unit_data_extension:read_component("critical_strike")
	self._inventory_slot_component = unit_data_extension:read_component(slot.name)
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._fx_extension = ScriptUnit.extension(owner_unit, "fx_system")
	self._sweep_trail_components_1p = _slot_components(slot.attachments_1p)
	self._sweep_trail_components_3p = _slot_components(slot.attachments_3p)
	self._trail_visible = true
end

SweepTrail.fixed_update = function (self, unit, dt, t, frame)
	return
end

SweepTrail.update = function (self, unit, dt, t)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind

	self:_update_windup(action_kind)
	self:_update_trail_status(action_kind)
end

SweepTrail.update_first_person_mode = function (self, first_person_mode)
	return
end

SweepTrail.wield = function (self)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind

	self:_update_windup(action_kind)
	self:_update_trail_status(action_kind)
end

SweepTrail.unwield = function (self)
	self._fx_extension:trigger_gear_wwise_event_with_source(WINDUP_STOP_SOUND_ALIAS, EXTERNAL_PROPERTIES, self._fx_source_name, false, false)
end

SweepTrail.destroy = function (self)
	return
end

SweepTrail._update_windup = function (self, action_kind)
	local source_name = self._fx_source_name
	local sync_to_clients = false
	local include_client = false

	if action_kind == "windup" and not self._playing_id then
		self._playing_id = self._fx_extension:trigger_gear_wwise_event_with_source(WINDUP_START_SOUND_ALIAS, EXTERNAL_PROPERTIES, source_name, sync_to_clients, include_client)
	elseif action_kind ~= "windup" and self._playing_id then
		self._fx_extension:trigger_gear_wwise_event_with_source(WINDUP_STOP_SOUND_ALIAS, EXTERNAL_PROPERTIES, source_name, sync_to_clients, include_client)

		self._playing_id = nil
	end
end

SweepTrail._update_trail_status = function (self, action_kind)
	local is_critical = self._critical_strike_component.is_active
	local is_powered = self._inventory_slot_component.special_active
	local is_visible = self._trail_visible

	if action_kind == "sweep" and not is_visible then
		is_visible = true
	elseif action_kind ~= "sweep" then
		is_visible = is_visible and false
	end

	local visibility_changed = is_visible ~= self._trail_visible

	_update_status(self._sweep_trail_components_1p, is_critical, is_powered, is_visible, visibility_changed)
	_update_status(self._sweep_trail_components_3p, is_critical, is_powered, is_visible, visibility_changed)

	self._trail_visible = is_visible
end

function _slot_components(attachments)
	local component_list = {}

	for ii = 1, #attachments do
		local attachment_unit = attachments[ii]
		local components = Component.get_components_by_name(attachment_unit, "SweepTrail")

		for _, component in ipairs(components) do
			Unit.set_unit_objects_visibility(attachment_unit, true, false)

			component_list[#component_list + 1] = {
				unit = attachment_unit,
				component = component
			}
		end
	end

	return component_list
end

function _update_status(components, is_critical, is_powered, is_visible, visibility_changed)
	for ii = 1, #components do
		local sweep_trail = components[ii]
		local unit = sweep_trail.unit

		sweep_trail.component:set_critical_strike(unit, is_critical)
		sweep_trail.component:set_powered(unit, is_powered)

		if visibility_changed then
			Unit.set_visibility(unit, VISIBILITY_GROUP_NAME, is_visible)
		end
	end
end

return SweepTrail
