-- chunkname: @scripts/settings/equipment/weapon_templates/pocketables/motion_detection_mine_fire_pocketable.lua

local trap_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/trap_weapon_template_generator")
local weapon_template = trap_weapon_template_generator(nil)
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")

weapon_template.mine_settings_name = "fire_trap"
weapon_template.hud_icon = "content/ui/materials/icons/pocketables/hud/landmine_fire"
weapon_template.hud_icon_small = "content/ui/materials/icons/pocketables/hud/landmine_fire"
weapon_template.swap_pickup_name = "motion_detection_mine_fire_pocketable"
weapon_template.pickup_name = "motion_detection_mine_fire_pocketable"
weapon_template.ammo_template = "motion_detection_mine"
weapon_template.ammo_template_static = "motion_detection_mine"
weapon_template.breed_footstep_intervals = {
	human = FootstepIntervalsTemplates.pocketable_human,
	ogryn = FootstepIntervalsTemplates.pocketable_ogryn,
}

return weapon_template
