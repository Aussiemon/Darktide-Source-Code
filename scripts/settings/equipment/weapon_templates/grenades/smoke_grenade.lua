-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/smoke_grenade.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local grenade_handleless_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_weapon_template_generator")
local weapon_template = grenade_handleless_weapon_template_generator()

weapon_template.projectile_template = ProjectileTemplates.smoke_grenade
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/smoke_grenade"

return weapon_template
