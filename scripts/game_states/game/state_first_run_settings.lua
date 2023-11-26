-- chunkname: @scripts/game_states/game/state_first_run_settings.lua

local StateTitle = require("scripts/game_states/game/state_title")
local view_name = "first_run_settings_view"
local StateFirstRunSettings = class("StateFirstRunSettings")

StateFirstRunSettings.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context
	self._next_state = StateTitle
	self._next_state_params = params

	Managers.ui:open_view(view_name)
	Managers.event:register(self, "event_state_first_run_settings_continue", "_continue_cb")
end

StateFirstRunSettings._continue_cb = function (self)
	self._continue = true
end

StateFirstRunSettings.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()

	if self._continue then
		return self._next_state, self._next_state_params
	end
end

StateFirstRunSettings.on_exit = function (self)
	Managers.event:unregister(self, "event_state_first_run_settings_continue")
	Managers.ui:close_view(view_name)
end

return StateFirstRunSettings
