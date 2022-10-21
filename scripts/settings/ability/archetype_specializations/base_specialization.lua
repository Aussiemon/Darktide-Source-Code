local ArchetypeDodgeTemplates = require("scripts/settings/dodge/archetype_dodge_templates")
local ArchetypeSprintTemplates = require("scripts/settings/sprint/archetype_sprint_templates")
local ArchetypeStaminaTemplates = require("scripts/settings/stamina/archetype_stamina_templates")
local ArchetypeToughnessTemplates = require("scripts/settings/toughness/archetype_toughness_templates")
local ArchetypeWarpChargeTemplates = require("scripts/settings/warp_charge/archetype_warp_charge_templates")
local base_specialization = {
	name = "none",
	background_large = "content/ui/materials/placeholders/ability_backgrounds/ogryn_basic",
	archetype = "none",
	base_critical_strike_chance = 0,
	health = 100,
	knocked_down_health = 100,
	toughness = ArchetypeToughnessTemplates.veteran,
	dodge = ArchetypeDodgeTemplates.default,
	sprint = ArchetypeSprintTemplates.default,
	stamina = ArchetypeStaminaTemplates.default,
	warp_charge = ArchetypeWarpChargeTemplates.default,
	talent_groups = {}
}

return base_specialization
