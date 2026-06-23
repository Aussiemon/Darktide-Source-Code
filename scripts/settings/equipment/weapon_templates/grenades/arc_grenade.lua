-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/arc_grenade.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local grenade_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_weapon_template_generator")
local weapon_template = grenade_weapon_template_generator("grenade_ability")

weapon_template.projectile_template = ProjectileTemplates.arc_grenade
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/arc_grenade"
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/grenade"
weapon_template.actions.action_wield.total_time = 0.5
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_grenade"

return weapon_template
