-- chunkname: @scripts/settings/equipment/weapon_templates/combat_abilities/area_buff_drone.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local drone_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/drone_weapon_template_generator")
local weapon_template = drone_weapon_template_generator()

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/adamant_drone"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/adamant_drone"
weapon_template.projectile_template = ProjectileTemplates.area_buff_drone
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/area_buff_drone"
weapon_template.placement_preview_settings = {
	action_name = "action_aim_drone",
	vfx = "content/fx/particles/weapons/grenades/area_buff_drone/area_buff_drone_radius_indicator",
}

return weapon_template
