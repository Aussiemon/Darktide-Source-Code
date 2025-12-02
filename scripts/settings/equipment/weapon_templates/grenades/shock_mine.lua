-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/shock_mine.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local mine_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/mine_weapon_template_generator")
local weapon_template = mine_weapon_template_generator()

weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/shock_mine"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/shock_mine"
weapon_template.projectile_template = ProjectileTemplates.shock_mine
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_grenade"

return weapon_template
