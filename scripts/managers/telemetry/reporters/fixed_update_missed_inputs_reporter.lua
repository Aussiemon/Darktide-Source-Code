-- chunkname: @scripts/managers/telemetry/reporters/fixed_update_missed_inputs_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local FixedUpdateMissedInputsReporter = class("FixedUpdateMissedInputsReporter")

FixedUpdateMissedInputsReporter.init = function (self)
	self._reports = {}
end

FixedUpdateMissedInputsReporter.update = function (self, dt, t)
	return
end

FixedUpdateMissedInputsReporter.report = function (self)
	if table.is_empty(self._reports) then
		return
	end

	Managers.telemetry_events:fixed_update_missed_inputs_report(self._reports)
end

FixedUpdateMissedInputsReporter.register_event = function (self, player)
	local subject = player:telemetry_subject()
	local player_key = string.format("%s:%s", subject.account_id, subject.character_id)
	local entries = self._reports[player_key] and self._reports[player_key].entries

	if entries then
		self._reports[player_key].entries = entries + 1
	else
		local player_data = {
			telemetry_subject = subject,
			telemetry_game_session = player:telemetry_game_session()
		}

		self._reports[player_key] = {
			entries = 1,
			player_data = player_data
		}
	end
end

FixedUpdateMissedInputsReporter.destroy = function (self)
	return
end

implements(FixedUpdateMissedInputsReporter, ReporterInterface)

return FixedUpdateMissedInputsReporter
