-- chunkname: @scripts/managers/pacing/templates/havoc_pacing_template.lua

local DefaultPacingTemplate = require("scripts/managers/pacing/templates/default_pacing_template")
local HordePacingTemplates = require("scripts/managers/pacing/horde_pacing/horde_pacing_templates")
local SpecialsPacingTemplates = require("scripts/managers/pacing/specials_pacing/specials_pacing_templates")
local MonsterPacingTemplates = require("scripts/managers/pacing/monster_pacing/monster_pacing_templates")
local RoamerPacingTemplates = require("scripts/managers/pacing/roamer_pacing/roamer_pacing_templates")
local pacing_template = table.clone_instance(DefaultPacingTemplate)

local function _challenge_rating_multiplier_steps(value)
	local multiplier_step = {
		value * 1,
		value * 1.25,
		value * 1.5,
		value * 1.75,
		value * 2,
	}

	return multiplier_step
end

pacing_template.name = "havoc"
pacing_template.horde_pacing_template = HordePacingTemplates.havoc_horde
pacing_template.specials_pacing_template = SpecialsPacingTemplates.havoc_specials
pacing_template.monster_pacing_template = MonsterPacingTemplates.havoc_monsters
pacing_template.roamer_pacing_template = RoamerPacingTemplates.havoc_roamers
pacing_template.challenge_rating_thresholds = {
	specials = _challenge_rating_multiplier_steps(80),
	hordes = _challenge_rating_multiplier_steps(90),
	trickle_hordes = _challenge_rating_multiplier_steps(20),
	roamers = _challenge_rating_multiplier_steps(90),
	terror_events = _challenge_rating_multiplier_steps(100),
}

return pacing_template
