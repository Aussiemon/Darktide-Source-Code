local MatchmakingConstants = require("scripts/settings/network/matchmaking_constants")
local HOST_TYPES = MatchmakingConstants.HOST_TYPES
local VIEW_SETTINGS = {
	{
		view_name = "mission_intro_view",
		valid_states = {
			"StateLoading"
		},
		validation_func = function ()
			if Managers.ui:view_active("lobby_view") then
				return false
			end

			local host_type = Managers.multiplayer_session:host_type()

			if host_type ~= HOST_TYPES.mission_server then
				return false
			end

			if Managers.mechanism:mechanism_state() == "adventure_selected" then
				return false
			end

			return true
		end
	},
	{
		view_name = "loading_view",
		valid_states = {
			"StateLoading",
			"StateExitToMainMenu",
			"GameplayStateInit",
			"StateError"
		},
		validation_func = function ()
			if Managers.ui:view_active("lobby_view") then
				return false
			end

			return true
		end
	}
}
local ConstantElementLoading = class("ConstantElementLoading")

ConstantElementLoading.init = function (self, parent, draw_layer, start_scale)
	local view_settings_by_state = {}

	for i = 1, #VIEW_SETTINGS do
		local setting = VIEW_SETTINGS[i]
		local valid_states = setting.valid_states

		for j = 1, #valid_states do
			local state = valid_states[j]
			local settings = view_settings_by_state[state]

			if not settings then
				settings = {}
				view_settings_by_state[state] = settings
			end

			settings[#settings + 1] = setting
		end
	end

	self._view_settings_by_state = view_settings_by_state
	self._current_state_name = nil
	self._current_state_view_settings = nil
end

ConstantElementLoading.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	local current_sub_state_name = Managers.ui:get_current_sub_state_name()
	local current_state_name = current_sub_state_name == "" and Managers.ui:get_current_state_name() or current_sub_state_name

	if current_state_name ~= self._current_state_name then
		self:_on_state_changed(current_state_name)
	end

	local state_view_settings = self._current_state_view_settings

	if state_view_settings then
		self:_update_state_views(state_view_settings)
	end
end

ConstantElementLoading._on_state_changed = function (self, new_state_name)
	local view_settings_by_state = self._view_settings_by_state
	local current_settings = self._current_state_view_settings
	local new_settings = view_settings_by_state[new_state_name]

	Log.info("ConstantElementLoading", "State changed %s -> %s", self._current_state_name, new_state_name)

	if current_settings then
		for i = 1, #current_settings do
			local view_name = current_settings[i].view_name
			local keep_view = false

			if new_settings then
				for j = 1, #new_settings do
					if new_settings[j].view_name == view_name then
						Log.info("ConstantElementLoading", "Keeping view %q open from previous state", view_name)

						keep_view = true

						break
					end
				end
			end

			if not keep_view then
				self:_close_view_if_active(view_name)
			end
		end
	end

	self._current_state_name = new_state_name
	self._current_state_view_settings = new_settings
end

ConstantElementLoading._update_state_views = function (self, state_view_settings)
	local valid_view_name = nil

	for i = 1, #state_view_settings do
		local settings = state_view_settings[i]
		local is_valid = settings.validation_func()

		if is_valid then
			valid_view_name = settings.view_name

			break
		end
	end

	for i = 1, #state_view_settings do
		local settings = state_view_settings[i]
		local view_name = settings.view_name

		if view_name == valid_view_name then
			self:_open_view_if_inactive(valid_view_name)
		else
			self:_close_view_if_active(view_name)
		end
	end
end

ConstantElementLoading._open_view_if_inactive = function (self, view_name)
	local ui_manager = Managers.ui

	if not ui_manager:view_active(view_name) then
		Log.info("ConstantElementLoading", "Opening view %q", view_name)
		ui_manager:open_view(view_name, nil, nil, nil, nil, nil)
	end
end

ConstantElementLoading._close_view_if_active = function (self, view_name)
	local ui_manager = Managers.ui

	if ui_manager:view_active(view_name) and not ui_manager:is_view_closing(view_name) then
		Log.info("ConstantElementLoading", "Closing view %q", view_name)
		ui_manager:close_view(view_name)
	end
end

ConstantElementLoading.set_visible = function (self, visible, optional_visibility_parameters)
	return
end

ConstantElementLoading.should_update = function (self)
	return true
end

ConstantElementLoading.should_draw = function (self)
	return false
end

return ConstantElementLoading
