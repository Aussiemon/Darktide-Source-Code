﻿-- chunkname: @scripts/settings/minion_visual_loadout/minion_visual_loadout_templates.lua

local minion_visual_loadout_templates = {}

local function _extract_templates(path)
	local templates = require(path)

	for name, template in pairs(templates) do
		minion_visual_loadout_templates[name] = template

		for zone_id_or_default, template_variations in pairs(template) do
			for _, t in ipairs(template_variations) do
				-- Nothing
			end
		end
	end
end

_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_beast_of_nurgle_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_daemonhost_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_spawn_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_hound_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_hound_mutator_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_newly_infected_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_armored_infected_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_ogryn_bulwark_visual_loadout_template")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_ogryn_executor_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_ogryn_gunner_visual_loadout_template")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_plague_ogryn_sprayer_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_plague_ogryn_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_poxwalker_bomber_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_poxwalker_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_mutated_poxwalker_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/chaos_lesser_mutated_poxwalker_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_assault_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_berzerker_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_captain_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_flamer_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_grenadier_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_gunner_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_melee_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_mutant_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_mutant_mutator_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/cultist_shocktrooper_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_assault_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_berzerker_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_captain_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_executor_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_flamer_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_grenadier_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_gunner_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_melee_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_netgunner_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_twin_captain_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_twin_captain_two_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_rifleman_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_shocktrooper_visual_loadout_templates")
_extract_templates("scripts/settings/minion_visual_loadout/templates/renegade_sniper_visual_loadout_templates")

return settings("MinionVisualLoadoutTemplates", minion_visual_loadout_templates)
