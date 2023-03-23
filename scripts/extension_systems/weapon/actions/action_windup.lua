require("scripts/extension_systems/weapon/actions/action_weapon_base")

local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local PROC_INTERVAL_DEFAULT = 0.25
local ActionWindup = class("ActionWindup", "ActionWeaponBase")

ActionWindup.start = function (self, action_settings, t, time_scale, params)
	ActionWindup.super.start(self, action_settings, t, time_scale, params)

	self._proc_trigger_time = self:_latest_chain_time(action_settings)
	local buff_extension = self._buff_extension
	local param_table = buff_extension:request_proc_event_param_table()

	if param_table then
		param_table.combo_count = params.combo_count

		buff_extension:add_proc_event(proc_events.on_windup_start, param_table)
	end
end

ActionWindup.fixed_update = function (self, dt, t, time_in_action)
	if self._proc_trigger_time and self._proc_trigger_time <= time_in_action then
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

return ActionWindup
