-- chunkname: @scripts/settings/deployables/templates/broker_stimm_field_crate.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local broker_talent_settings = TalentSettings.broker
local broker_stimm_field_crate = {
	unit_template = "broker_stimm_field_crate_deployable",
	proximity_radius = broker_talent_settings.combat_ability.stimm_field.proximity_radius,
	stickiness_limit = broker_talent_settings.combat_ability.stimm_field.stickiness_limit,
	stickiness_time = broker_talent_settings.combat_ability.stimm_field.stickiness_time,
	proximity_init_data = {
		base_buff = broker_talent_settings.combat_ability.stimm_field.base_buff,
		life_time = broker_talent_settings.combat_ability.stimm_field.life_time,
		buff_to_add = broker_talent_settings.combat_ability.stimm_field.buff_to_add,
	},
}

return broker_stimm_field_crate
