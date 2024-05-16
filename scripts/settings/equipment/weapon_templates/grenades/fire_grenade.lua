-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/fire_grenade.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local grenade_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_weapon_template_generator")
local weapon_template = grenade_weapon_template_generator()

weapon_template.projectile_template = ProjectileTemplates.fire_grenade
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/flame_grenade"
weapon_template.actions.action_wield.allowed_chain_actions = {
	combat_ability = {
		action_name = "combat_ability",
	},
	wield = {
		action_name = "action_unwield",
	},
	aim_hold = {
		action_name = "action_aim",
		chain_time = 0.5,
	},
	short_hand_aim_hold = {
		action_name = "action_aim_underhand",
		chain_time = 0.2,
	},
}

return weapon_template
