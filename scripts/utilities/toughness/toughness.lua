-- chunkname: @scripts/utilities/toughness/toughness.lua

local Toughness = {}

Toughness.replenish = function (unit, recovery_type)
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
	local recovered_tougness = 0

	if toughness_extension then
		recovered_tougness = toughness_extension:recover_toughness(recovery_type)
	end

	return recovered_tougness
end

Toughness.replenish_percentage = function (unit, fixed_percentage, ignore_stat_buffs, reason)
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
	local recovered_tougness = 0

	if toughness_extension then
		recovered_tougness = toughness_extension:recover_percentage_toughness(fixed_percentage, ignore_stat_buffs, reason)
	end

	return recovered_tougness
end

Toughness.replenish_flat = function (unit, amount, ignore_stat_buffs, reason)
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
	local recovered_tougness = 0

	if toughness_extension then
		recovered_tougness = toughness_extension:recover_flat_toughness(amount, ignore_stat_buffs, reason)
	end

	return recovered_tougness
end

Toughness.recover_max_toughness = function (unit, reason, ignore_state_block)
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")
	local recovered_tougness = 0

	if toughness_extension then
		recovered_tougness = toughness_extension:recover_max_toughness(reason, ignore_state_block)
	end

	return recovered_tougness
end

Toughness.current_toughness_percent = function (unit)
	local amount = 0
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

	if toughness_extension then
		amount = toughness_extension:current_toughness_percent()
	end

	return amount
end

Toughness.break_toughness = function (unit)
	local toughness_extension = ScriptUnit.has_extension(unit, "toughness_system")

	if toughness_extension then
		toughness_extension:break_toughness()
	end
end

return Toughness
