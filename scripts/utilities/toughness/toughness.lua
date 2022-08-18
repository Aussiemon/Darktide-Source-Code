local Toughness = {
	replenish = function (unit, recovery_type)
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

		if toughness_extension then
			toughness_extension:recover_toughness(recovery_type)
		end
	end,
	replenish_percentage = function (unit, fixed_percentage, ignore_stat_buffs)
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

		if toughness_extension then
			toughness_extension:recover_percentage_toughness(fixed_percentage, ignore_stat_buffs)
		end
	end,
	recover_max_toughness = function (unit)
		local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

		if toughness_extension then
			toughness_extension:recover_max_toughness()
		end
	end
}

return Toughness
