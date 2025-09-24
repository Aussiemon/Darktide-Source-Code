-- chunkname: @scripts/utilities/attack/weakspot.lua

local WeakspotSettings = require("scripts/settings/damage/weakspot_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local buff_keywords = BuffSettings.keywords
local Weakspot = {}
local _weakspot_type

Weakspot.hit_weakspot = function (breed_or_nil, hit_zone_name, attacking_unit_or_nil)
	local weakspot_type = _weakspot_type(breed_or_nil, hit_zone_name)
	local hit_weakspot = weakspot_type ~= nil and weakspot_type ~= "shield"
	local hit_shield = weakspot_type == "shield"
	local attacker_buff_extension = ScriptUnit.has_extension(attacking_unit_or_nil, "buff_system")

	if attacker_buff_extension and attacker_buff_extension:has_keyword(buff_keywords.guaranteed_weakspot_on_hit) then
		hit_weakspot = true
	end

	return hit_weakspot, hit_shield
end

Weakspot.finesse_boost_modifier = function (breed_or_nil, hit_zone_name, finesse_boost_amount)
	local weakspot_type = _weakspot_type(breed_or_nil, hit_zone_name)

	if not weakspot_type then
		return 1
	end

	local modifier = WeakspotSettings.finesse_boost_modifiers[weakspot_type](finesse_boost_amount)

	return modifier
end

function _weakspot_type(breed_or_nil, hit_zone_name)
	if not breed_or_nil or not breed_or_nil.hit_zone_weakspot_types then
		return
	end

	local weakspot_type = breed_or_nil.hit_zone_weakspot_types[hit_zone_name]

	return weakspot_type
end

return Weakspot
