local SplashPageDefinitions = require("scripts/ui/views/splash_view/splash_view_page_definitions")
local StateTitle = require("scripts/game_states/game/state_title")
local StateSplash = class("StateSplash")
local VIEW_NAME = "splash_view"

local function _should_skip()
	local skip_title = LEVEL_EDITOR_TEST or DEDICATED_SERVER or GameParameters.mission or Managers.data_service.social:has_invite() or not Managers.ui

	return skip_title
end

StateSplash.on_enter = function (self, parent, params, creation_context)
	self._creation_context = creation_context
	self._next_state = StateTitle
	self._next_state_params = params
	local should_skip = _should_skip()
	self._should_skip = should_skip

	if should_skip then
		self._continue = true
	else
		self._end_duration = SplashPageDefinitions.duration

		Managers.ui:open_view(VIEW_NAME)
		Managers.event:register(self, "event_state_splash_continue", "_continue_cb")
	end
end

StateSplash._continue_cb = function (self)
	self._continue = true
end

StateSplash.update = function (self, main_dt, main_t)
	local context = self._creation_context

	context.network_receive_function(main_dt)
	context.network_transmit_function()

	local view = Managers.ui:view_instance(VIEW_NAME)

	if view and view:is_done() then
		self._continue = true
	else
		local end_duration = self._end_duration

		if end_duration then
			self._end_duration = end_duration - main_dt

			if self._end_duration <= 0 then
				self._end_duration = nil
				self._continue = true
			end
		end
	end

	if self._continue then
		return self._next_state, self._next_state_params
	end
end

StateSplash.on_exit = function (self)
	if not self._should_skip then
		Managers.event:unregister(self, "event_state_splash_continue")
		Managers.ui:close_view(VIEW_NAME)
	end
end

return StateSplash
