-- chunkname: @scripts/settings/circumstance/mission_overrides/health_station_overrides.lua

local HealthStationOverrides = {}

HealthStationOverrides.no_health_station_charges = {
	health_station = {
		charges_to_distribute = 0,
	},
}
HealthStationOverrides.health_disable_all_stations = {
	health_station = {
		charges_to_distribute = 0,
		remove_plugged_charges = true,
		skip_battery_spawning = true,
	},
}

return HealthStationOverrides
