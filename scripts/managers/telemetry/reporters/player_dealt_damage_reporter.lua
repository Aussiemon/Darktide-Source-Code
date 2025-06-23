-- chunkname: @scripts/managers/telemetry/reporters/player_dealt_damage_reporter.lua

local ReporterInterface = require("scripts/managers/telemetry/reporters/reporter_interface")
local PlayerDealtDamageReporter = class("PlayerDealtDamageReporter")

PlayerDealtDamageReporter.init = function (self)
	self._reports = {}
end

PlayerDealtDamageReporter.update = function (self, dt, t)
	return
end

PlayerDealtDamageReporter.report = function (self)
	if table.is_empty(self._reports) then
		return
	end

	Managers.telemetry_events:player_dealt_damage_report(self._reports)
end

local function compare_entry(e1, e2)
	return e1.victim == e2.victim and e1.is_boss == e2.is_boss and e1.attack_type == e2.attack_type and e1.weapon == e2.weapon and e1.damage_profile == e2.damage_profile
end

local function extract_data(entry)
	return {
		observations = 1,
		victim = entry.victim,
		is_boss = entry.is_boss,
		attack_type = entry.attack_type,
		weapon = entry.weapon,
		damage_profile = entry.damage_profile,
		damage = entry.damage,
		actual_damage = entry.actual_damage
	}
end

PlayerDealtDamageReporter.register_event = function (self, player, data)
	local subject = player:telemetry_subject()
	local player_key = string.format("%s:%s", subject.account_id, subject.character_id)
	local entries = self._reports[player_key] and self._reports[player_key].entries

	if entries then
		for _, entry in pairs(entries) do
			if compare_entry(entry, data) then
				entry.damage = entry.damage + data.damage
				entry.actual_damage = entry.actual_damage + data.actual_damage
				entry.observations = entry.observations + 1

				return
			end
		end

		entries[#entries + 1] = extract_data(data)
	else
		local player_data = {
			telemetry_subject = subject,
			telemetry_game_session = player:telemetry_game_session()
		}

		self._reports[player_key] = {
			player_data = player_data,
			entries = {
				extract_data(data)
			}
		}
	end
end

PlayerDealtDamageReporter.destroy = function (self)
	return
end

implements(PlayerDealtDamageReporter, ReporterInterface)

return PlayerDealtDamageReporter
