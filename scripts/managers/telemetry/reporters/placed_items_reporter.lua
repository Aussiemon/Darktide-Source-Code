﻿-- chunkname: @scripts/managers/telemetry/reporters/placed_items_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local PlacedItemsReporter = class("PlacedItemsReporter")

PlacedItemsReporter.init = function (self)
	self._reports = {}
end

PlacedItemsReporter.update = function (self, dt, t)
	return
end

PlacedItemsReporter.report = function (self)
	if table.is_empty(self._reports) then
		return
	end

	Managers.telemetry_events:placed_items_report(self._reports)
end

PlacedItemsReporter.register_event = function (self, player, item_name)
	local subject = player:telemetry_subject()
	local player_key = string.format("%s:%s", subject.account_id, subject.character_id)
	local entries = self._reports[player_key] and self._reports[player_key].entries

	if entries then
		entries[item_name] = (entries[item_name] or 0) + 1
	else
		local player_data = {
			telemetry_subject = subject,
			telemetry_game_session = player:telemetry_game_session(),
		}

		self._reports[player_key] = {
			player_data = player_data,
			entries = {
				[item_name] = 1,
			},
		}
	end
end

PlacedItemsReporter.destroy = function (self)
	return
end

implements(PlacedItemsReporter, ReporterInterface)

return PlacedItemsReporter
