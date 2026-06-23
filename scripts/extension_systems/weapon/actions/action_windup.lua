-- chunkname: @scripts/extension_systems/weapon/actions/action_windup.lua

require("scripts/extension_systems/weapon/actions/action_weapon_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local PROC_INTERVAL_DEFAULT = 0.25
local ActionWindup = class("ActionWindup", "ActionWeaponBase")

ActionWindup.init = function (self, action_context, action_params, action_settings)
	ActionWindup.super.init(self, action_context, action_params, action_settings)

	local unit_data_extension = action_context.unit_data_extension

	self._weapon_action_component = unit_data_extension:write_component("weapon_action")
end

ActionWindup.start = function (self, action_settings, t, time_scale, params)
	ActionWindup.super.start(self, action_settings, t, time_scale, params)

	if action_settings.activate_special_during_windup then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, true)

		self._weapon_action_component.special_active_at_start = true
	end

	self._proc_trigger_time = self:_latest_chain_time(action_settings)

	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.combo_count = params.combo_count

		buff_extension:add_proc_event(proc_events.on_windup_start, param_table)
	end

	local special_active = self._inventory_slot_component.special_active
	local weapon_tweak_templates_component = self._weapon_tweak_templates_component
	local weapon_template = self._weapon_template

	weapon_tweak_templates_component.spread_template_name = action_settings.spread_template or weapon_template.spread_template or "none"
	weapon_tweak_templates_component.recoil_template_name = action_settings.recoil_template or weapon_template.recoil_template or "none"
	weapon_tweak_templates_component.sway_template_name = action_settings.sway_template or weapon_template.sway_template or "none"
	weapon_tweak_templates_component.charge_template_name = action_settings.charge_template or special_active and weapon_template.special_charge_template or weapon_template.charge_template or "none"
end

ActionWindup.fixed_update = function (self, dt, t, time_in_action)
	if self._proc_trigger_time and time_in_action >= self._proc_trigger_time then
		local action_settings = self._action_settings
		local proc_interval = action_settings.proc_time_interval or PROC_INTERVAL_DEFAULT

		self._proc_trigger_time = self._proc_trigger_time + proc_interval

		local buff_extension = self._buff_extension
		local param_table = buff_extension:request_proc_event_param_table()

		if param_table then
			buff_extension:add_proc_event(proc_events.on_windup_trigger, param_table)
		end
	end
end

ActionWindup._latest_chain_time = function (self, action_settings)
	local allowed_chain_actions = action_settings.allowed_chain_actions

	if not allowed_chain_actions then
		return math.huge
	end

	local latest_chain_time = 0

	for action_input, chain_action in pairs(allowed_chain_actions) do
		local action_chain_time = chain_action.chain_time

		if action_chain_time and latest_chain_time < action_chain_time then
			latest_chain_time = action_chain_time
		end
	end

	return latest_chain_time > 0 and latest_chain_time or math.huge
end

ActionWindup.server_correction_occurred = function (self)
	self._proc_trigger_time = self:_latest_chain_time(self._action_settings)
end

ActionWindup.finish = function (self, reason, data, t, time_in_action)
	ActionWindup.super.finish(self, reason, data, t, time_in_action)

	local action_settings = self._action_settings
	local is_next_action_sweep = data and data.new_action_kind == "sweep"
	local should_deactivate_special = not action_settings.keep_special_active_on_sweep_chain_from_windup or not is_next_action_sweep

	if action_settings.activate_special_during_windup and should_deactivate_special then
		self._weapon_extension:set_wielded_weapon_weapon_special_active(t, false)
	end

	self._weapon_tweak_templates_component.spread_template_name = self._weapon_template.spread_template or "none"
end

return ActionWindup
