local templates = {}

local function _create_entry(path)
	local entry_templates = require(path)

	for name, template in pairs(entry_templates) do
		templates[name] = template
	end
end

_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autopistol_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainaxe_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainsword_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p3")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatknife_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p3")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcesword_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_club_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_combatblade_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_powermaul_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_rippergun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_stubrevolver_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_thunderhammer_2h_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_melee_activated")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_melee_common")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_aimed")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_common")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_explosive")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_high_fire_rate")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_low_fire_rate")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_medium_fire_rate")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_overheat")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_ranged_warp_charge")

return templates
