-- chunkname: @scripts/settings/live_event/mechanicus_event_weapons.lua

local WeaponTemplates = require("scripts/settings/equipment/weapon_templates/weapon_templates")
local mechanicus_event_weapons = {
	"boltpistol_p1_m1",
	"shotgun_p2_m1",
	"powermaul_p1_m1",
	"powermaul_p1_m2",
	"ogryn_pickaxe_2h_p1_m1",
	"ogryn_pickaxe_2h_p1_m2",
	"ogryn_pickaxe_2h_p1_m3",
}

return settings("MechanicusEventWeapons", mechanicus_event_weapons)
