-- chunkname: @scripts/extension_systems/weapon/actions/action_reload_state.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local Overheat = require("scripts/utilities/overheat")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local ReloadStates = require("scripts/extension_systems/weapon/utilities/reload_states")
local buff_proc_events = BuffSettings.proc_events
local ActionReloadState = class("ActionReloadState", "ActionWeaponBase")

ActionReloadState.init = function (self, action_context, ...)
	ActionReloadState.super.init(self, action_context, ...)

	local unit_data_extension = action_context.unit_data_extension

	self._action_reload_component = unit_data_extension:write_component("action_reload")
	self._spread_control_component = unit_data_extension:write_component("spread_control")
	self._sway_control_component = unit_data_extension:write_component("sway_control")
	self._alternate_fire_component = unit_data_extension:write_component("alternate_fire")
	self._buff_extension = ScriptUnit.extension(action_context.player_unit, "buff_system")
end

ActionReloadState.start = function (self, action_settings, t, time_scale, ...)
	ActionReloadState.super.start(self, action_settings, t, time_scale, ...)

	local action_reload_component = self._action_reload_component
	local inventory_slot_component = self._inventory_slot_component
	local reload_template = self._weapon_template.reload_template

	self:_start_reload_state(reload_template, inventory_slot_component, action_reload_component, t)

	local event_data = self._dialogue_input:get_event_data_payload()

	self._dialogue_input:trigger_dialogue_event("reloading", event_data)

	local param_table = self._buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.weapon_template = self._weapon_template
		param_table.shotgun = false

		self._buff_extension:add_proc_event(buff_proc_events.on_reload_start, param_table)
	end
end

ActionReloadState.fixed_update = function (self, dt, t, time_in_action)
	local inventory_slot = self._inventory_slot_component
	local reload_template = self._weapon_template.reload_template
	local reload_state = ReloadStates.reload_state(reload_template, inventory_slot)
	local time_scale = self._weapon_action_component.time_scale

	self:_update_functionality(reload_state, time_in_action, time_scale, dt)
end

ActionReloadState._start_reload_state = function (self, reload_template, inventory_slot_component, action_reload_component, t)
	action_reload_component.has_refilled_ammunition = false
	action_reload_component.has_removed_ammunition = false

	local wielded_slot = self._inventory_component.wielded_slot
	local condition_func_params = self._weapon_extension:condition_func_params(wielded_slot)
	local anim_1p, anim_3p, action_time_offset = ReloadStates.start_reload_state(reload_template, inventory_slot_component, condition_func_params)

	self:trigger_anim_event(anim_1p, anim_3p, action_time_offset)
end

ActionReloadState.finish = function (self, reason, data, t, time_in_action)
	ActionReloadState.super.finish(self, reason, data, t)

	local inventory_slot = self._inventory_slot_component
	local reload_template = self._weapon_template.reload_template
	local time_scale = self._weapon_action_component.time_scale
	local reload_state = ReloadStates.reload_state(reload_template, inventory_slot)

	self:_update_functionality(reload_state, time_in_action, time_scale, 0, t)
	self:_handle_state_transition(reload_template, inventory_slot, time_in_action, time_scale)
	self._animation_extension:anim_event_1p("reload_finished")

	if self._action_reload_component.has_refilled_ammunition then
		local param_table_on_reload = self._buff_extension:request_proc_event_param_table()

		if param_table_on_reload then
			param_table_on_reload.weapon_template = self._weapon_template
			param_table_on_reload.shotgun = false

			self._buff_extension:add_proc_event(buff_proc_events.on_reload_finished, param_table_on_reload)
		end
	end
end

ActionReloadState._update_functionality = function (self, reload_state, time_in_action, time_scale, dt, t)
	local inventory_slot_component = self._inventory_slot_component
	local action_reload_component = self._action_reload_component
	local has_refilled_ammunition = action_reload_component.has_refilled_ammunition
	local has_removed_ammunition = action_reload_component.has_removed_ammunition

	for functionality, time in pairs(reload_state.functionality) do
		if time_in_action >= time / time_scale then
			if functionality == "remove_ammunition" and not has_removed_ammunition then
				ReloadStates.reimburse_clip_to_reserve(inventory_slot_component)

				action_reload_component.has_removed_ammunition = true
			elseif functionality == "refill_ammunition" and not has_refilled_ammunition then
				local buff_extension = self._buff_extension
				local param_table = buff_extension:request_proc_event_param_table()

				if param_table then
					param_table.weapon_template = self._weapon_template
					param_table.shotgun = false

					buff_extension:add_proc_event(buff_proc_events.on_reload, param_table)
				end

				ReloadStates.reload(inventory_slot_component)

				action_reload_component.has_refilled_ammunition = true
			elseif functionality == "clear_overheat" and dt > 0 then
				local remove_percentage = dt * (reload_state.overheat_clear_speed or 1)

				Overheat.decrease_immediate(remove_percentage, inventory_slot_component)
			end
		end
	end
end

ActionReloadState._calculate_next_state_transition = function (self, reload_template, inventory_slot_component, time_in_action, time_scale)
	local reload_state = ReloadStates.reload_state(reload_template, inventory_slot_component)
	local state_transitions = reload_state.state_transitions
	local highest_completed_state_transition
	local highest_completed_state_time = 0

	for state_name, time in pairs(state_transitions) do
		local scaled_time = time / time_scale

		if highest_completed_state_time <= scaled_time and scaled_time <= time_in_action then
			highest_completed_state_time = scaled_time
			highest_completed_state_transition = state_name
		end
	end

	return highest_completed_state_transition
end

ActionReloadState._handle_state_transition = function (self, reload_template, inventory_slot_component, time_in_action, time_scale)
	local highest_completed_state_transition = self:_calculate_next_state_transition(reload_template, inventory_slot_component, time_in_action, time_scale)

	if highest_completed_state_transition then
		inventory_slot_component.reload_state = highest_completed_state_transition
	end
end

return ActionReloadState
