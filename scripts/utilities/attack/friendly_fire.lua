-- chunkname: @scripts/utilities/attack/friendly_fire.lua

local Breed = require("scripts/utilities/breed")
local AttackSettings = require("scripts/settings/damage/attack_settings")
local attack_types = AttackSettings.attack_types
local FriendlyFire = {}

FriendlyFire.is_enabled = function (attacking_unit, target_unit, attack_type)
	local target_unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
	local target_breed_or_nil = target_unit_data_extension and target_unit_data_extension:breed()
	local target_is_player = Breed.is_player(target_breed_or_nil)
	local target_is_minion = Breed.is_minion(target_breed_or_nil)

	return Managers.state.difficulty:friendly_fire_enabled(target_is_player, target_is_minion)
end

return FriendlyFire
