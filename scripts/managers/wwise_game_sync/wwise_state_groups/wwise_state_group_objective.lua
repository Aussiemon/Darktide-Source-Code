require("scripts/managers/wwise_game_sync/wwise_state_groups/wwise_state_group_base")

local WwiseGameSyncSettings = require("scripts/settings/wwise_game_sync/wwise_game_sync_settings")
local WwiseStateGroupObjective = class("WwiseStateGroupObjective", "WwiseStateGroupBase")

WwiseStateGroupObjective.init = function (self, wwise_world, wwise_state_group_name)
	WwiseStateGroupObjective.super.init(self, wwise_world, wwise_state_group_name)

	self._mission_objective_system = nil
	self._player_unit = nil
	self._music_parameter_extension = nil
	self._old_objecitve_state = nil
	self._music_reset_timer = 0
end

WwiseStateGroupObjective.on_gameplay_post_init = function (self, level)
	WwiseStateGroupObjective.super.on_gameplay_post_init(self, level)

	local mission_objective_system = Managers.state.extension:system("mission_objective_system")
	self._mission_objective_system = mission_objective_system
end

WwiseStateGroupObjective.on_gameplay_shutdown = function (self)
	WwiseStateGroupObjective.super.on_gameplay_shutdown(self)

	self._mission_objective_system = nil
	self._player_unit = nil
	self._music_parameter_extension = nil
end

WwiseStateGroupObjective.update = function (self, dt, t)
	WwiseStateGroupObjective.super.update(self, dt, t)

	local player_unit = self._player_unit
	local mission_objective_system = self._mission_objective_system
	local music_parameter_extension = self._music_parameter_extension
	local wwise_state = nil
	local game_mode_name = Managers.state.game_mode and Managers.state.game_mode:game_mode_name()
	local is_valid_game_mode = game_mode_name == "coop_complete_objective"

	if is_valid_game_mode and music_parameter_extension then
		local last_man_standing = ALIVE[player_unit] and music_parameter_extension:last_man_standing()

		if last_man_standing then
			wwise_state = "last_man_standing"
		end
	end

	if not wwise_state and mission_objective_system then
		local objective_event_music = mission_objective_system:get_objective_event_music()

		if objective_event_music then
			wwise_state = objective_event_music
			self._old_objecitve_state = objective_event_music
			self._music_reset_timer = WwiseGameSyncSettings.music_state_reset_time
		else
			self._music_reset_timer = self._music_reset_timer - dt

			if self._music_reset_timer <= 0 then
				self._old_objecitve_state = nil
				wwise_state = nil
			else
				wwise_state = self._old_objecitve_state
			end
		end
	end

	wwise_state = wwise_state or WwiseGameSyncSettings.default_group_state

	self:_set_wwise_state(wwise_state)
end

WwiseStateGroupObjective.set_followed_player_unit = function (self, player_unit)
	local music_parameter_extension = player_unit and ScriptUnit.has_extension(player_unit, "music_parameter_system")

	if music_parameter_extension then
		self._player_unit = player_unit
		self._music_parameter_extension = music_parameter_extension
	else
		self._player_unit = nil
		self._music_parameter_extension = nil
	end
end

return WwiseStateGroupObjective
