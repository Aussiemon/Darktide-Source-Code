local Action = require("scripts/utilities/weapon/action")
local Component = require("scripts/utilities/component")
local SweepTrail = class("SweepTrail")
local WINDUP_START_SOUND_ALIAS = "windup_start"
local WINDUP_STOP_SOUND_ALIAS = "windup_stop"
local SOURCE_NAME = "_sweep"
local EXTERNAL_PROPERTIES = {}

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
	local sweep_trail_components = {}
	local num_attachments = #slot.attachments_1p

	for i = 1, num_attachments do
		local attachment_unit = slot.attachments_1p[i]
		local components = Component.get_components_by_name(attachment_unit, "SweepTrail")

		for _, component in ipairs(components) do
			Unit.set_unit_objects_visibility(attachment_unit, true, false)

			sweep_trail_components[#sweep_trail_components + 1] = {
				unit = attachment_unit,
				component = component
			}
		end
	end

	self._sweep_trail_components = sweep_trail_components
end

SweepTrail.fixed_update = function (self, unit, dt, t, frame)
	self:_update_windup()
	self:_update_trail_status()
end

SweepTrail.update = function (self, unit, dt, t)
	return
end

SweepTrail.update_first_person_mode = function (self, first_person_mode)
	return
end

SweepTrail.wield = function (self)
	self:_update_windup()
	self:_update_trail_status()
end

SweepTrail.unwield = function (self)
	self:_update_windup()
end

SweepTrail.destroy = function (self)
	return
end

SweepTrail._update_windup = function (self)
	local action_settings = Action.current_action_settings_from_component(self._weapon_action_component, self._weapon_actions)
	local action_kind = action_settings and action_settings.kind
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

SweepTrail._update_trail_status = function (self)
	local is_critical = self._critical_strike_component.is_active
	local is_powered = self._inventory_slot_component.special_active
	local sweep_trail_components = self._sweep_trail_components
	local num_trails = #sweep_trail_components

	for i = 1, num_trails do
		local sweep_trail = sweep_trail_components[i]

		sweep_trail.component:set_critical_strike(sweep_trail.unit, is_critical)
		sweep_trail.component:set_powered(sweep_trail.unit, is_powered)
	end
end

return SweepTrail
