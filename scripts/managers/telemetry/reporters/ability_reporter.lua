-- chunkname: @scripts/managers/telemetry/reporters/ability_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local AbilityReporter = class("AbilityReporter")

AbilityReporter.init = function (self, params, ability_name)
	self._reports = {}
	self._report_name = "player_" .. ability_name .. "_report"
end

AbilityReporter.destroy = function (self)
	return
end

AbilityReporter.update = function (self, dt, t)
	return
end

AbilityReporter.report = function (self)
	if table.is_empty(self._reports) then
		return
	end

	Managers.telemetry_events:player_ability_report(self._reports, self._report_name)
end

AbilityReporter.register_event = function (self, player, ability_name)
	local subject = player:telemetry_subject()
	local player_key = string.format("%s:%s", subject.account_id, subject.character_id)
	local entries = self._reports[player_key] and self._reports[player_key].entries

	if entries then
		entries[ability_name] = (entries[ability_name] or 0) + 1
	else
		local player_data = {
			telemetry_subject = subject,
			telemetry_game_session = player:telemetry_game_session(),
		}

		self._reports[player_key] = {
			player_data = player_data,
			entries = {
				[ability_name] = 1,
			},
		}
	end
end

implements(AbilityReporter, ReporterInterface)

return AbilityReporter
