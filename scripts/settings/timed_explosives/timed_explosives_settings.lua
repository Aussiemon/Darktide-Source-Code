-- chunkname: @scripts/settings/timed_explosives/timed_explosives_settings.lua

local timed_explosives_settings = {}

timed_explosives_settings.explosive_barrel = {
	explosion_template_name = "explosive_barrel",
	fuse_time = 2,
}
timed_explosives_settings.explosive_luggable = {
	explosion_template_name = "explosive_barrel",
	fuse_time = 2,
}
timed_explosives_settings.decoy_landmine = {
	explosion_template_name = "decoy_landmine",
	fuse_time = 2,
}

return settings("TimedExplosivesSettings", timed_explosives_settings)
