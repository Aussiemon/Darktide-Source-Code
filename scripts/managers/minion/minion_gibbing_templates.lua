﻿-- chunkname: @scripts/managers/minion/minion_gibbing_templates.lua

local gibbing_templates = {}

local function _create_gibbing_template_entry(path)
	local gibbing_template = require(path)
	local name = gibbing_template.name

	gibbing_templates[name] = gibbing_template
end

_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_daemonhost_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_hound_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_mutant_charger_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_newly_infected_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_ogryn_bulwark_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_ogryn_executor_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_ogryn_gunner_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_poxwalker_bomber_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_poxwalker_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_mutated_poxwalker_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_lesser_mutated_poxwalker_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_beast_of_nurgle_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/chaos_spawn_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/cultist_assault_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/cultist_berzerker_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/cultist_flamer_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/cultist_grenadier_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/cultist_gunner_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/cultist_melee_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/cultist_ritualist_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/cultist_shocktrooper_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_assault_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_captain_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_executor_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_grenadier_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_gunner_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_melee_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_netgunner_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_rifleman_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_shocktrooper_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_sniper_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_flamer_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/renegade_berzerker_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/event/rotten_armor/chaos_ogryn_executor_rotten_armor_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/event/rotten_armor/renegade_berzerker_rotten_armor_gibbing_template")
_create_gibbing_template_entry("scripts/managers/minion/minion_gibbing_templates/event/rotten_armor/renegade_executor_rotten_armor_gibbing_template")

return settings("MinionGibbingTemplates", gibbing_templates)
