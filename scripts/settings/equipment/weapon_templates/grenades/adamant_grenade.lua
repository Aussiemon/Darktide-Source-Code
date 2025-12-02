-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/adamant_grenade.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local grenade_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_weapon_template_generator")
local weapon_template = grenade_weapon_template_generator()

weapon_template.projectile_template = ProjectileTemplates.adamant_grenade
weapon_template.actions.action_wield.total_time = 0.5
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_grenade"

return weapon_template
