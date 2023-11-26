-- chunkname: @scripts/settings/equipment/weapon_templates/combat_abilities/psyker_force_field_dome.lua

local force_field_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/force_field_weapon_template_generator")
local functional_unit = "content/characters/player/human/attachments_combat/psyker_shield/shield_sphere_functional"
local visual_unit = "content/characters/player/human/attachments_combat/psyker_shield/shield_sphere_visual"
local allow_rotation = false
local weapon_template = force_field_weapon_template_generator(functional_unit, visual_unit, allow_rotation)

return weapon_template
