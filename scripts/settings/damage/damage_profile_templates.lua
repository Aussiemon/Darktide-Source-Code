﻿-- chunkname: @scripts/settings/damage/damage_profile_templates.lua

local WeaponTweaks = require("scripts/utilities/weapon_tweaks")
local templates = {}
local loaded_files = {}

WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/minion_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/common_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/debug_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/ability_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/buff_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/prop_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/assault_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/bfg_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/demolitions_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/killshot_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/spraynpray_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/linesman_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/ninjafencer_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/smiter_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/tank_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/grenade_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/luggable_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/psyker_smite_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/damage/damage_profiles/zealot_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autoguns/settings_templates/autogun_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/bolters/settings_templates/bolter_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/chain_swords/settings_templates/chain_sword_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/chain_swords/settings_templates/chain_sword_2h_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/chain_axes/settings_templates/chain_axe_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/combat_axes/settings_templates/combat_axe_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/combat_blades/settings_templates/combat_blade_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/combat_knives/settings_templates/combat_knife_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/combat_swords/settings_templates/combatsword_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/flamers/settings_templates/flamer_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/force_staffs/settings_templates/force_staff_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/force_swords/settings_templates/force_sword_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/grenadier_gauntlets/settings_templates/grenadier_gauntlet_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/lasguns/settings_templates/lasgun_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/laspistols/settings_templates/laspistol_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ogryn_clubs/settings_templates/ogryn_club_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ogryn_clubs/settings_templates/ogryn_shovel_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ogryn_power_mauls/settings_templates/ogryn_power_maul_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/power_mauls/settings_templates/power_maul_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/plasma_rifles/settings_templates/plasma_rifle_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/power_swords/settings_templates/power_sword_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ripperguns/settings_templates/rippergun_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/shotguns/settings_templates/shotgun_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/stub_pistols/settings_templates/stub_pistol_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/thunder_hammers/settings_templates/thunder_hammer_damage_profile_templates", templates, loaded_files)
WeaponTweaks.extract_weapon_tweaks("scripts/settings/equipment/weapon_templates/ogryn_heavystubbers/settings_templates/ogryn_heavystubber_damage_profile_templates", templates, loaded_files)

for name, damage_profile in pairs(templates) do
	damage_profile.name = name
end

return settings("DamageProfileTemplates", templates)
