-- chunkname: @scripts/settings/circumstance/templates/base_expeditions_live_event_template.lua

local ExpeditionsCircumstanceTemplates = require("scripts/settings/circumstance/templates/expeditions_circumstance_template")
local BaseExpeditionsLiveEventTemplate = {}
local default_ui = {
	description = false,
	display_name = false,
	icon = "content/ui/materials/icons/mission_types/mission_type_event",
	mission_board_icon = "content/ui/materials/icons/mission_types_pj/mission_type_event",
}
local default_circumstance = {
	theme_tag = "default",
	wwise_state = "None",
	mutators = {},
	ui = default_ui,
}

BaseExpeditionsLiveEventTemplate["<ID>"] = table.clone(default_circumstance)
BaseExpeditionsLiveEventTemplate["<ID>_sand_twister"] = table.add_missing(ExpeditionsCircumstanceTemplates.spawn_sand_vortex, table.clone(default_circumstance))
BaseExpeditionsLiveEventTemplate["<ID>_necro_flies"] = table.add_missing(ExpeditionsCircumstanceTemplates.circ_exp_nurgle_flies, table.clone(default_circumstance))
BaseExpeditionsLiveEventTemplate["<ID>_tox_gas"] = table.add_missing(ExpeditionsCircumstanceTemplates.expedition_toxic_gas, table.clone(default_circumstance))
BaseExpeditionsLiveEventTemplate["<ID>_lightning"] = table.add_missing(ExpeditionsCircumstanceTemplates.lightning_storm, table.clone(default_circumstance))

return BaseExpeditionsLiveEventTemplate
