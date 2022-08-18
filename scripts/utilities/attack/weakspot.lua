local AttackSettings = require("scripts/settings/damage/attack_settings")
local BuffSettings = require("scripts/settings/buff/buff_settings")
local WeakspotSettings = require("scripts/settings/damage/weakspot_settings")
local Weakspot = {}
local attack_types = AttackSettings.attack_types
local keywords = BuffSettings.keywords
local _type = nil

Weakspot.hit_weakspot = function (breed_or_nil, hit_zone_name, attack_type, optional_attacker_buff_extension)
	local weakspot_type = _type(breed_or_nil, hit_zone_name)
	local hit_weakspot = weakspot_type ~= nil and weakspot_type ~= "shield"
	local hit_shield = weakspot_type == "shield"

	if optional_attacker_buff_extension and not hit_weakspot and attack_type == attack_types.ranged then
		local weakspot_keyword_override = optional_attacker_buff_extension:has_keyword(keywords.ranged_counts_as_weakspot)
		hit_weakspot = weakspot_keyword_override
	end

	return hit_weakspot, hit_shield
end

Weakspot.finesse_boost_modifer = function (breed_or_nil, hit_zone_name, finesse_boost_amount)
	local weakspot_type = _type(breed_or_nil, hit_zone_name)

	if not weakspot_type then
		return 1
	end

	local modifier = WeakspotSettings.finesse_boost_modifers[weakspot_type](finesse_boost_amount)

	return modifier
end

function _type(breed_or_nil, hit_zone_name)
	if not breed_or_nil or not breed_or_nil.hit_zone_weakspot_types then
		return
	end

	local weakspot_type = breed_or_nil.hit_zone_weakspot_types[hit_zone_name]

	return weakspot_type
end

return Weakspot
