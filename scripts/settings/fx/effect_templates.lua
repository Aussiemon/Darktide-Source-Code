local effect_templates = {}

local function _create_effect_template_entry(path)
	local effect_template = require(path)
	local effect_template_name = effect_template.name

	fassert(effect_template_name, "[EffectTemplates] Missing name field in %q.", path)
	fassert(not effect_templates[effect_template_name], "[EffectTemplates] Duplicate name: %q, encountered when parsing: %q", effect_template_name, path)

	effect_templates[effect_template_name] = effect_template
end

_create_effect_template_entry("scripts/settings/fx/effect_templates/chaos_daemonhost_ambience")
_create_effect_template_entry("scripts/settings/fx/effect_templates/chaos_daemonhost_warp_grab")
_create_effect_template_entry("scripts/settings/fx/effect_templates/chaos_daemonhost_warp_sweep")
_create_effect_template_entry("scripts/settings/fx/effect_templates/chaos_ogryn_gunner_heavy_stubber")
_create_effect_template_entry("scripts/settings/fx/effect_templates/chaos_plague_ogryn_charge_impact")
_create_effect_template_entry("scripts/settings/fx/effect_templates/chaos_poxwalker_bomber_foley")
_create_effect_template_entry("scripts/settings/fx/effect_templates/chaos_hound_approach")
_create_effect_template_entry("scripts/settings/fx/effect_templates/cultist_assault_autogun")
_create_effect_template_entry("scripts/settings/fx/effect_templates/cultist_flamer")
_create_effect_template_entry("scripts/settings/fx/effect_templates/cultist_flamer_approach")
_create_effect_template_entry("scripts/settings/fx/effect_templates/cultist_grenadier_grenade")
_create_effect_template_entry("scripts/settings/fx/effect_templates/cultist_gunner_stubber")
_create_effect_template_entry("scripts/settings/fx/effect_templates/cultist_mutant_charge_foley")
_create_effect_template_entry("scripts/settings/fx/effect_templates/cultist_shocktrooper_grenade")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_assault_lasgun_smg")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_captain_grenade")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_captain_hellgun")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_captain_hellgun_spray_and_pray")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_captain_power_sword_sweep")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_captain_powermaul_ground_slam")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_captain_void_shield")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_executor_chainaxe")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_grenadier_grenade")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_gunner_hellgun")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_netgunner_approach")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_netgunner_net")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_shocktrooper_grenade")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_sniper_laser")
_create_effect_template_entry("scripts/settings/fx/effect_templates/renegade_captain_plasma_pistol_charge_up")
_create_effect_template_entry("scripts/settings/fx/effect_templates/corruptor_ambience")
_create_effect_template_entry("scripts/settings/fx/effect_templates/corruptor_ambience_burrowed")
_create_effect_template_entry("scripts/settings/fx/effect_templates/void_shield_explosion")

return settings("EffectTemplates", effect_templates)
