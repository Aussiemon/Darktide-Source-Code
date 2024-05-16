-- chunkname: @scripts/settings/equipment/weapon_templates/combat_abilities/psyker_force_field.lua

local force_field_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/force_field_weapon_template_generator")
local functional_unit = "content/characters/player/human/attachments_combat/psyker_shield/psyker_shield_flat_functional"
local visual_unit = "content/characters/player/human/attachments_combat/psyker_shield/psyker_shield_flat_visual"
local allow_rotation = true
local weapon_template = force_field_weapon_template_generator(functional_unit, visual_unit, allow_rotation)

return weapon_template
