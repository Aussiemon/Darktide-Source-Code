-- chunkname: @scripts/settings/circumstance/mission_overrides/hazard_prop_overrides.lua

local HazardPropOverrides = {}

HazardPropOverrides.no_empty_hazards = {
	hazard_prop_settings = {
		explosion = 1,
		fire = 1,
		none = 0,
	},
}
HazardPropOverrides.all_fire_barrels = {
	hazard_prop_settings = {
		explosion = 0,
		fire = 1,
		none = 0,
	},
}

return HazardPropOverrides
