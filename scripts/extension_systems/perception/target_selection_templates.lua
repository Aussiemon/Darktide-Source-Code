﻿-- chunkname: @scripts/extension_systems/perception/target_selection_templates.lua

local TargetSelectionTemplates = {}

local function _create_target_selection_template_entry(path)
	local target_selection_templates = require(path)

	for name, template in pairs(target_selection_templates) do
		TargetSelectionTemplates[name] = template
	end
end

_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/bot_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/melee_elite_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/melee_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/ranged_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/chaos_beast_of_nurgle_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/chaos_daemonhost_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/chaos_hound_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/chaos_plague_ogryn_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/chaos_poxwalker_bomber_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/chaos_spawn_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/cultist_mutant_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/cultist_ritualist_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/renegade_captain_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/renegade_grenadier_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/renegade_netgunner_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/renegade_sniper_target_selection_template")
_create_target_selection_template_entry("scripts/extension_systems/perception/target_selection_templates/renegade_twin_captain_target_selection_template")

return TargetSelectionTemplates
