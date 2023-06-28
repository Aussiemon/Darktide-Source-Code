local MinionDifficultySettings = require("scripts/settings/difficulty/minion_difficulty_settings")
local PlayerDifficultySettings = require("scripts/settings/difficulty/player_difficulty_settings")
local DifficultyManager = class("DifficultyManager")

DifficultyManager.init = function (self, is_server, resistance, challenge)
	self._is_server = is_server
	self._resistance = resistance
	self._challenge = challenge

	Log.info("DifficultyManager", "Difficulty initialized to challenge %s, resistance %s", challenge, resistance)
end

DifficultyManager.get_minion_max_health = function (self, breed_name)
	local max_health_settings = MinionDifficultySettings.health[breed_name]
	local current_challenge = self._challenge
	local max_health = max_health_settings[math.min(#max_health_settings, current_challenge)]

	return max_health
end

DifficultyManager.get_minion_attack_power_level = function (self, breed, attack_type)
	local breed_power_level_type = breed.power_level_type
	local power_level_type = type(breed_power_level_type) == "table" and breed_power_level_type[attack_type] or breed_power_level_type
	local power_level_settings = MinionDifficultySettings.power_level[power_level_type]
	local current_challenge = self._challenge
	local power_level = power_level_settings[math.min(#power_level_settings, current_challenge)]

	return power_level
end

DifficultyManager.get_table_entry_by_resistance = function (self, t)
	local resistance = self._resistance

	return t[math.min(#t, resistance)]
end

DifficultyManager.get_table_entry_by_challenge = function (self, t)
	local challenge = self._challenge

	return t[math.min(#t, challenge)]
end

DifficultyManager.get_challenge = function (self)
	return self._challenge
end

DifficultyManager.get_resistance = function (self)
	return self._resistance
end

DifficultyManager.get_difficulty = function (self)
	return self:get_challenge()
end

DifficultyManager.get_dummy_challenge = function (self)
	return self._dummy_challenge
end

DifficultyManager.set_challenge = function (self, new_challenge)
	self._challenge = new_challenge

	Log.info("DifficultyManager", "Challenge set to %s", self._challenge)
end

DifficultyManager.set_resistance = function (self, new_resistance)
	self._resistance = new_resistance

	Log.info("DifficultyManager", "Resistance set to %s", self._resistance)
end

DifficultyManager.set_dummy_challenge = function (self, new_challenge)
	self._dummy_challenge = new_challenge

	Log.info("DifficultyManager", "Dummy challenge set to %s", self._dummy_challenge)
end

DifficultyManager.modify_resistance = function (self, modifier)
	self._resistance = math.max(1, self._resistance + modifier)

	Log.info("DifficultyManager", "Resistance modified to %s", self._resistance)
end

DifficultyManager.friendly_fire_enabled = function (self, target_is_player, target_is_minion)
	if target_is_player then
		return false
	elseif target_is_minion then
		return true
	end

	return true
end

DifficultyManager.player_wounds = function (self, specialization)
	local wounds_settings = PlayerDifficultySettings.specialization_wounds[specialization]
	local challenge = self._challenge
	local max_wounds = wounds_settings[math.min(#wounds_settings, challenge)]

	return max_wounds
end

return DifficultyManager
