-- chunkname: @scripts/settings/equipment/weapon_templates/thumpers/settings_templates/thumper_hitscan_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local hitscan_templates = {}
local overrides = {}

table.make_unique(hitscan_templates)
table.make_unique(overrides)

return {
	base_templates = hitscan_templates,
	overrides = overrides,
}
