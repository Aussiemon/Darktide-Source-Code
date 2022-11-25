local PseudoRandomDistribution = require("scripts/utilities/pseudo_random_distribution")
local CriticalStrike = {
	is_critical_strike = function (chance, prd_state, seed)
		local chance = math.round_with_precision(chance, 2)
		local is_critical_strike, new_prd_state, new_seed = PseudoRandomDistribution.flip_coin(chance, prd_state, seed)

		return is_critical_strike, new_prd_state, new_seed
	end
}

CriticalStrike.chance = function (player, weapon_handling_template, is_ranged, is_melee)
	local profile = player:profile()
	local archetype = profile.archetype
	local specialization_name = profile.specialization
	local specialization = archetype.specializations[specialization_name]
	local base_chance = specialization.base_critical_strike_chance
	local buff_extension = ScriptUnit.extension(player.player_unit, "buff_system")
	local buffs = buff_extension:stat_buffs()
	local additional_chance = buffs.critical_strike_chance

	if is_melee then
		additional_chance = additional_chance + buffs.melee_critical_strike_chance
	elseif is_ranged then
		additional_chance = additional_chance + buffs.ranged_critical_strike_chance
	end

	local critical_strike = weapon_handling_template.critical_strike

	if critical_strike then
		additional_chance = additional_chance + critical_strike.chance_modifier
	end

	return math.clamp(base_chance + additional_chance, 0, 1)
end

return CriticalStrike
