-- chunkname: @scripts/settings/equipment/weapon_templates/autopistols/settings_templates/autopistol_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

hitscan_templates.default_autopistol_bullet = {
	range = 100,
	damage = {
		impact = {
			damage_profile = DamageProfileTemplates.default_autopistol_assault
		}
	}
}
overrides.snp_autopistol_bullet = {
	parent_template_name = "default_autopistol_bullet",
	overrides = {
		{
			"damage",
			"impact",
			"damage_profile",
			DamageProfileTemplates.default_autopistol_snp
		}
	}
}

return {
	base_templates = hitscan_templates,
	overrides = overrides
}
