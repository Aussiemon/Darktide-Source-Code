local ArmorSettings = require("scripts/settings/damage/armor_settings")
local Armor = {}
local default_armor = ArmorSettings.types.unarmored
local _check_toughness, _character_armor_type = nil

Armor.armor_type = function (unit, breed_or_nil, hit_zone_name_or_nil, attack_type)
	if breed_or_nil then
		return _character_armor_type(unit, breed_or_nil, hit_zone_name_or_nil, attack_type)
	else
		return default_armor
	end
end

Armor.aborts_attack = function (unit, breed_or_nil, hit_zone_name_or_nil)
	local armor_type = Armor.armor_type(unit, breed_or_nil, hit_zone_name_or_nil)

	return ArmorSettings.aborts_attack[armor_type] or false
end

function _character_armor_type(unit, breed, hit_zone_name_or_nil, attack_type_or_nil)
	local armor_type = nil
	local has_toughess, toughness_armor_type = _check_toughness(unit, breed)

	if has_toughess and toughness_armor_type then
		armor_type = toughness_armor_type
	elseif hit_zone_name_or_nil then
		armor_type = breed.hitzone_armor_override and attack_type_or_nil ~= "impact" and breed.hitzone_armor_override[hit_zone_name_or_nil] or breed.armor_type
	else
		armor_type = breed.armor_type
	end

	return armor_type
end

function _check_toughness(unit, breed)
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
	local has_toughess = toughness_extension and toughness_extension:current_toughness_percent() > 0
	local toughness_armor_type = breed.toughness_armor_type

	return has_toughess, toughness_armor_type
end

return Armor
