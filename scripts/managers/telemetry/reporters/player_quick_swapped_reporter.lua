-- chunkname: @scripts/managers/telemetry/reporters/player_quick_swapped_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local PlayerQuickSwappedReporter = class("PlayerQuickSwappedReporter")

PlayerQuickSwappedReporter.init = function (self)
	self._reports = {}
end

PlayerQuickSwappedReporter.update = function (self, dt, t)
	return
end

PlayerQuickSwappedReporter.report = function (self)
	if table.is_empty(self._reports) then
		return
	end

	Managers.telemetry_events:player_quick_swapped_report(self._reports)
end

PlayerQuickSwappedReporter.register_event = function (self, player, weapon_name)
	local subject = player:telemetry_subject()
	local player_key = string.format("%s:%s", subject.account_id, subject.character_id)
	local entries = self._reports[player_key] and self._reports[player_key].entries

	if entries then
		entries[weapon_name] = (entries[weapon_name] or 0) + 1
	else
		local player_data = {
			telemetry_subject = subject,
			telemetry_game_session = player:telemetry_game_session(),
			telemetry_current_instance = player:telemetry_current_instance(),
		}

		self._reports[player_key] = {
			player_data = player_data,
			entries = {
				[weapon_name] = 1,
			},
		}
	end
end

PlayerQuickSwappedReporter.destroy = function (self)
	return
end

implements(PlayerQuickSwappedReporter, ReporterInterface)

return PlayerQuickSwappedReporter
