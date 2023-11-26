-- chunkname: @scripts/managers/telemetry/reporters/smart_tag_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local SmartTagReporter = class("SmartTagReporter")

SmartTagReporter.init = function (self)
	self._reports = {}
end

SmartTagReporter.update = function (self, dt, t)
	return
end

SmartTagReporter.report = function (self)
	if table.is_empty(self._reports) then
		return
	end

	Managers.telemetry_events:smart_tag_report(self._reports)
end

SmartTagReporter.register_event = function (self, player, template_name)
	local subject = player:telemetry_subject()
	local player_key = string.format("%s:%s", subject.account_id, subject.character_id)
	local entries = self._reports[player_key] and self._reports[player_key].entries

	if entries then
		entries[template_name] = (entries[template_name] or 0) + 1
	else
		local player_data = {
			telemetry_subject = subject,
			telemetry_game_session = player:telemetry_game_session()
		}

		self._reports[player_key] = {
			player_data = player_data,
			entries = {
				[template_name] = 1
			}
		}
	end
end

SmartTagReporter.destroy = function (self)
	return
end

implements(SmartTagReporter, ReporterInterface)

return SmartTagReporter
