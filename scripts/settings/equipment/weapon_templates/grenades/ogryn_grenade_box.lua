local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local grenade_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/grenades/grenade_weapon_template_generator")
local weapon_template = grenade_weapon_template_generator()
weapon_template.anim_state_machine_3p = "content/characters/player/ogryn/third_person/animations/grenade"
weapon_template.anim_state_machine_1p = "content/characters/player/ogryn/first_person/animations/grenade_box"
weapon_template.projectile_template = ProjectileTemplates.ogryn_grenade_box
weapon_template.actions.action_wield.total_time = 0.7
weapon_template.actions.action_wield.anim_event = "to_grenade_box"
weapon_template.actions.action_aim.allowed_chain_actions.aim_released.chain_time = 0.9
weapon_template.actions.action_aim_underhand.allowed_chain_actions.short_hand_throw.chain_time = 0.9
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/ogryn_grenade"

return weapon_template
