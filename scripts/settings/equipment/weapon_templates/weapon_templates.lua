local WeaponTweakTemplates = require("scripts/extension_systems/weapon/utilities/weapon_tweak_templates")
local weapon_templates = {}

local function _require_template(path_prefix, template_name)
	local full_path = string.format(path_prefix, template_name)
	local template_data = require(full_path)

	if not template_data.sprint_ready_up_time then
		template_data.sprint_ready_up_time = 0
	end

	for action_name, action_settings in pairs(template_data.actions) do
		action_settings.name = action_name
	end

	template_data.name = template_name
	weapon_templates[template_name] = template_data
end

local function _require_group(path_prefix, group_name, ...)
	local new_prefix = string.format(path_prefix, string.format("%s/%s", group_name, "%s"))

	for ii = 1, select("#", ...), 1 do
		_require_template(new_prefix, select(ii, ...))
	end
end

local function _require_weapon_templates(path_prefix, template_groups, template_names)
	for ii = 1, #template_groups, 1 do
		local group = template_groups[ii]

		_require_group(path_prefix, unpack(group))
	end

	for ii = 1, #template_names, 1 do
		local template_name = template_names[ii]

		_require_template(path_prefix, template_name)
	end
end

local path_prefix = "scripts/settings/equipment/weapon_templates/%s"
local template_groups = {
	{
		"autoguns",
		"autogun_p1_m1",
		"autogun_p1_m2",
		"autogun_p1_m3",
		"autogun_p2_m1",
		"autogun_p2_m2",
		"autogun_p3_m1",
		"autogun_p3_m2",
		"autogun_p3_m3"
	},
	{
		"autopistols",
		"autopistol_p1_m1",
		"autopistol_p2_m1"
	},
	{
		"bolters",
		"bolter_p1_m1",
		"bolter_p1_m2",
		"bolter_p1_m3"
	},
	{
		"chain_swords",
		"chainsword_2h_p1_m1",
		"chainsword_p1_m1"
	},
	{
		"chain_axes",
		"chainaxe_p1_m1"
	},
	{
		"combat_abilities",
		"psyker_force_field",
		"psyker_force_field_dome",
		"preacher_relic"
	},
	{
		"combat_axes",
		"combataxe_p1_m1",
		"combataxe_p1_m2",
		"combataxe_p1_m3",
		"combataxe_p2_m1",
		"prologue_shovel_human",
		"combataxe_p3_m2"
	},
	{
		"combat_blades",
		"ogryn_combatblade_p1_m1"
	},
	{
		"combat_knives",
		"combatknife_p1_m1"
	},
	{
		"combat_swords",
		"combatsword_p1_m1",
		"combatsword_p1_m2",
		"combatsword_p1_m3",
		"combatsword_p2_m1",
		"combatsword_p3_m1"
	},
	{
		"devices",
		"auspex_scanner",
		"skull_decoder"
	},
	{
		"flamers",
		"flamer_p1_m1"
	},
	{
		"force_staffs",
		"forcestaff_p1_m1",
		"forcestaff_p1_m2",
		"forcestaff_p1_m3",
		"forcestaff_p2_m1",
		"forcestaff_p3_m1"
	},
	{
		"force_swords",
		"forcesword_p1_m1",
		"forcesword_p1_m2",
		"forcesword_p1_m3"
	},
	{
		"grenades",
		"fire_grenade",
		"frag_grenade",
		"krak_grenade",
		"ogryn_grenade",
		"psyker_smite",
		"psyker_throwing_knives",
		"psyker_chain_lightning",
		"shock_grenade"
	},
	{
		"grenadier_gauntlets",
		"ogryn_gauntlet_p1_m1"
	},
	{
		"lasguns",
		"lasgun_p1_m1",
		"lasgun_p1_m2",
		"lasgun_p1_m3",
		"lasgun_p1_m1_ironsight",
		"lasgun_p1_m2_ironsight",
		"lasgun_p1_m3_ironsight",
		"lasgun_p2_m1",
		"lasgun_p2_m2",
		"lasgun_p2_m3",
		"lasgun_p3_m1",
		"lasgun_p3_m2"
	},
	{
		"laspistols",
		"laspistol_p1_m1"
	},
	{
		"luggables",
		"luggable_mission",
		"luggable"
	},
	{
		"ogryn_clubs",
		"ogryn_club_p1_m1",
		"ogryn_club_p2_m1"
	},
	{
		"ogryn_power_mauls",
		"ogryn_powermaul_p1_m1"
	},
	{
		"ogryn_powermaul_slabshield",
		"ogryn_powermaul_slabshield_p1_m1"
	},
	{
		"ogryn_heavystubbers",
		"ogryn_heavystubber_p1_m1"
	},
	{
		"plasma_rifles",
		"plasmagun_p1_m1",
		"plasmagun_p2_m1"
	},
	{
		"pocketables",
		"ammo_cache_pocketable",
		"grimoire_pocketable",
		"medical_crate_pocketable",
		"tome_pocketable"
	},
	{
		"power_mauls",
		"powermaul_p1_m1"
	},
	{
		"power_mauls_2h",
		"powermaul_2h_p1_m1"
	},
	{
		"power_swords",
		"powersword_p1_m1"
	},
	{
		"ripperguns",
		"ogryn_rippergun_p1_m1"
	},
	{
		"scanner",
		"scanner_equip"
	},
	{
		"thumpers",
		"ogryn_thumper_p1_m1",
		"ogryn_thumper_p1_m2"
	},
	{
		"shotguns",
		"shotgun_p1_m1",
		"shotgun_p3_m1"
	},
	{
		"stub_pistols",
		"stubrevolver_p1_m1"
	},
	{
		"stub_rifles",
		"stubrifle_p1_m1"
	},
	{
		"thunder_hammers",
		"thunderhammer_2h_p1_m1"
	},
	{
		"debug",
		"debug_forcestaff_p1_base",
		"debug_forcestaff_p2_base",
		"debug_forcestaff_p3_base",
		"debug_forcesword_2h_p1_base"
	}
}
local template_names = {
	"unarmed_hub_ogryn",
	"unarmed_hub_psyker",
	"unarmed_hub_veteran",
	"unarmed_hub_zealot",
	"unarmed",
	"unarmed_training_grounds",
	"bot_lasgun_killshot"
}

_require_weapon_templates(path_prefix, template_groups, template_names)

local unwield_action_kinds = {
	unwield_to_specific = true,
	unwield = true,
	unwield_to_previous = true
}

for name, weapon_template in pairs(weapon_templates) do
	local weapon_template_sprint_ready_up_time = weapon_template.sprint_ready_up_time

	fassert(weapon_template_sprint_ready_up_time, "weapon_template %q has no sprint_ready_up_time variable set.", name)

	for _, action_settings in pairs(weapon_template.actions) do
		if not action_settings.sprint_ready_up_time and not unwield_action_kinds[action_settings.kind] then
			action_settings.sprint_ready_up_time = weapon_template_sprint_ready_up_time
		end
	end

	WeaponTweakTemplates.preparse_weapon_template(weapon_template)
end

return settings("WeaponTemplates", weapon_templates)
