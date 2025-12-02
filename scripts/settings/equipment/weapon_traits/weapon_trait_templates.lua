-- chunkname: @scripts/settings/equipment/weapon_traits/weapon_trait_templates.lua

local templates = {}

local function _create_entry(path, optional_num_levels)
	local entry_templates = require(path)

	for name, template in upairs(entry_templates) do
		local needed_num_levels = optional_num_levels or 4

		for buff_name, buff_values in pairs(template.buffs) do
			local num_levels = #buff_values
		end

		template.name = name
		templates[name] = template
	end
end

_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autogun_p3")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_autopistol_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_bolter_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_boltpistol_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainaxe_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainsword_2h_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_chainsword_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combataxe_p3")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatknife_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_combatsword_p3")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_crowbar_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_dual_shivs_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_needlepistol_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_dual_autopistols_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_dual_stubpistols_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_flamer_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p3")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcestaff_p4")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcesword_2h_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_forcesword_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_lasgun_p3")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_laspistol_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_club_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_club_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_combatblade_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_gauntlet_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_heavystubber_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_heavystubber_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_pickaxe_2h_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_powermaul_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_powermaul_slabshield_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_rippergun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_ogryn_thumper_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_plasmagun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_2h_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powermaul_shield_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_2h_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_powersword_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_saw_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p2")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotgun_p4")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_shotpistol_shield_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_stubrevolver_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_traits_bespoke_thunderhammer_2h_p1")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_perks_melee")
_create_entry("scripts/settings/equipment/weapon_traits/weapon_perks_ranged")
_create_entry("scripts/settings/equipment/gadget_traits/gadget_traits_common")

return templates
