-- chunkname: @scripts/utilities/toughness/toughness_depleted.lua

local ToughnessDepleted = {}

ToughnessDepleted.spill_over = function (current_toughness_damage, max_toughness, damage_amount)
	local remaning_toughness = max_toughness - current_toughness_damage
	local remaining_damage = math.max(damage_amount - remaning_toughness, 0)

	return remaining_damage
end

ToughnessDepleted.block = function (current_toughness_damage, max_toughness, damage_amount)
	return 0
end

ToughnessDepleted.all_damage_spill_over = function (current_toughness_damage, max_toughness, damage_amount)
	return damage_amount
end

return ToughnessDepleted
