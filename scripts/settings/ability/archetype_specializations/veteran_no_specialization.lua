local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local archetype_specialization = {
	name = "none",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/veteran_basic",
	archetype = "veteran",
	base_critical_strike_chance = 0.1,
	health = 150,
	knocked_down_health = 1000,
	toughness = ArchetypeToughnessTemplates.veteran,
	dodge = ArchetypeDodgeTemplates.default,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.default,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	talent_groups = {}
}

return archetype_specialization
