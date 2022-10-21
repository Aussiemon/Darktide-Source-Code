local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local GrenadeAbilityReporter = class("GrenadeAbilityReporter")

GrenadeAbilityReporter.init = function (self)
	self._reports = {}
end

GrenadeAbilityReporter.destroy = function (self)
	return
end

GrenadeAbilityReporter.update = function (self, dt, t)
	return
end

GrenadeAbilityReporter.report = function (self)
	if table.is_empty(self._reports) then
		return
	end

	Managers.telemetry_events:player_grenade_ability_report(self._reports)
end

GrenadeAbilityReporter.register_event = function (self, player, ability_name)
	local subject = player:telemetry_subject()
	local player_key = string.format("%s:%s", subject.account_id, subject.character_id)
	local entries = self._reports[player_key] and self._reports[player_key].entries

	if entries then
		entries[ability_name] = (entries[ability_name] or 0) + 1
	else
		local player_data = {
			telemetry_subject = subject,
			telemetry_game_session = player:telemetry_game_session()
		}
		self._reports[player_key] = {
			player_data = player_data,
			entries = {
				[ability_name] = 1
			}
		}
	end
end

implements(GrenadeAbilityReporter, ReporterInterface)

return GrenadeAbilityReporter
