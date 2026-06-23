-- chunkname: @scripts/utilities/attack_intensity.lua

local AttackIntensity = {}
local Breed = require("scripts/utilities/breed")

AttackIntensity.add_intensity = function (target_unit, attack_intensities)
	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not target_attack_intensity_extension then
		return
	end

	for type, intensity in pairs(attack_intensities) do
		target_attack_intensity_extension:add_intensity(type, intensity)
	end
end

AttackIntensity.set_attacked = function (target_unit)
	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not target_attack_intensity_extension then
		return
	end

	target_attack_intensity_extension:set_attacked()
end

AttackIntensity.set_damage_dealt = function (target_unit)
	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not target_attack_intensity_extension then
		return
	end

	target_attack_intensity_extension:set_damage_dealt()
end

AttackIntensity.set_attacked_melee = function (target_unit)
	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not target_attack_intensity_extension then
		return
	end

	target_attack_intensity_extension:set_attacked_melee()
end

AttackIntensity.remove_attacked_melee = function (target_unit)
	if not ALIVE[target_unit] then
		return
	end

	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not target_attack_intensity_extension then
		return
	end

	target_attack_intensity_extension:remove_attacked_melee()
end

AttackIntensity.minion_can_attack = function (unit, type, target_unit)
	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not target_attack_intensity_extension then
		return true
	end

	local attack_intensity_extension = ScriptUnit.has_extension(unit, "attack_intensity_system")

	if not attack_intensity_extension then
		return true
	end

	local target_allowed_attack = target_attack_intensity_extension:attack_allowed(type)

	if target_allowed_attack and attack_intensity_extension then
		local attack_allowed = attack_intensity_extension:can_attack(type)

		return attack_allowed
	end
end

AttackIntensity.set_monster_attacker = function (target_unit, attacker_unit)
	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not target_attack_intensity_extension then
		return
	end

	target_attack_intensity_extension:set_monster_attacker(attacker_unit)
end

AttackIntensity.monster_attacker = function (target_unit)
	local target_attack_intensity_extension = ScriptUnit.has_extension(target_unit, "attack_intensity_system")

	if not target_attack_intensity_extension then
		return
	end

	return target_attack_intensity_extension:monster_attacker()
end

AttackIntensity.player_can_be_attacked = function (player_unit, type)
	local target_has_unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")

	if not target_has_unit_data_extension then
		return false
	end

	local target_unit_data_extension = ScriptUnit.has_extension(player_unit, "unit_data_system")
	local breed = target_unit_data_extension:breed()

	if Breed.is_player(breed) then
		local attack_intensity_extension = ScriptUnit.extension(player_unit, "attack_intensity_system")

		return attack_intensity_extension:attack_allowed(type)
	else
		return false
	end
end

AttackIntensity.player_is_locked_in_melee = function (player_unit)
	local attack_intensity_extension = ScriptUnit.extension(player_unit, "attack_intensity_system")

	return attack_intensity_extension:locked_in_melee()
end

return AttackIntensity
