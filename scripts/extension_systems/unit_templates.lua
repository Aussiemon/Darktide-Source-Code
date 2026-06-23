-- chunkname: @scripts/extension_systems/unit_templates.lua

local FORMAT_STRING = "scripts/extension_systems/unit_templates/%s_unit_template"
local UNIT_TEMPLATES = {
	"area_of_effect_unit_spawner",
	"broker_stimm_field_crate_deployable",
	"cryptic_personal_force_field",
	"deployable_mine",
	"expedition_airstrike_bomb",
	"expedition_airstrike_supply",
	"health_station",
	"item_deployable_side_relation_projectile",
	"item_projectile",
	"level_prop",
	"liquid_area",
	"medical_crate_deployable",
	"minion_companion_dog",
	"minion_companion_servo_skull",
	"minion",
	"pickup",
	"player_character_social_hub",
	"player_character",
	"psyker_force_field",
	"shooting_range_loadout",
	"shooting_range_locked_indicator",
	"shooting_range_portal",
	"smoke_fog",
	"spineless_minion",
	"training_grounds_servitor",
}

local function _unit_templates()
	local unit_templates = {}

	for ii = 1, #UNIT_TEMPLATES do
		local unit_template_name = UNIT_TEMPLATES[ii]
		local path = string.format(FORMAT_STRING, unit_template_name)
		local unit_template = require(path)

		unit_templates[unit_template_name] = unit_template
	end

	return unit_templates
end

return _unit_templates()
