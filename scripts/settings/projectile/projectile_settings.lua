-- chunkname: @scripts/settings/projectile/projectile_settings.lua

local projectile_settings = {}

projectile_settings.projectile_types = table.enum("deafult", "luggable", "player_grenade", "minion_grenade", "ogryn_grenade", "ogryn_box", "ogryn_rock", "throwing_knife", "weapon_grenade", "force_staff_ball")

return settings("ProjectileSettings", projectile_settings)
