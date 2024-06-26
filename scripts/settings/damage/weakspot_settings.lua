-- chunkname: @scripts/settings/damage/weakspot_settings.lua

local weakspot_settings = {}
local weakspot_types = table.enum("headshot", "weakspot", "protected", "protected_weakspot", "shield", "explosive_backpack")
local finesse_boost_modifers = {
	[weakspot_types.headshot] = function (finesse_boost_amount)
		return finesse_boost_amount
	end,
	[weakspot_types.weakspot] = function (finesse_boost_amount)
		return finesse_boost_amount
	end,
	[weakspot_types.protected] = function (finesse_boost_amount)
		return finesse_boost_amount - 0.5
	end,
	[weakspot_types.protected_weakspot] = function (finesse_boost_amount)
		return finesse_boost_amount * 0.25
	end,
	[weakspot_types.shield] = function (finesse_boost_amount)
		return 0
	end,
}

table.set_readonly(finesse_boost_modifers)

weakspot_settings.types = weakspot_types
weakspot_settings.finesse_boost_modifers = finesse_boost_modifers

return settings("WeakspotSettings", weakspot_settings)
