﻿-- chunkname: @scripts/settings/damage/impact_effect_settings.lua

local impact_effect_settings = {}
local parse = require("scripts/settings/damage/impact_fx_parser")
local impact_fx_lookup, impact_fx_templates = parse()

impact_effect_settings.impact_fx_lookup = impact_fx_lookup
impact_effect_settings.impact_fx_templates = impact_fx_templates
impact_effect_settings.impact_anim = {
	bwd = "hit_reaction_backward",
	fwd = "hit_reaction_forward",
	left = "hit_reaction_left",
	right = "hit_reaction_right",
}

return settings("ImpactEffectSettings", impact_effect_settings)
