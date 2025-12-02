-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/tox_grenade.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local grenade_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_weapon_template_generator")
local weapon_template = grenade_weapon_template_generator()

weapon_template.projectile_template = ProjectileTemplates.broker_tox_grenade
weapon_template.anim_state_machine_3p = "content/characters/player/human/third_person/animations/grenade"
weapon_template.anim_state_machine_1p = "content/characters/player/human/first_person/animations/grenade_tox_equipable"
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_grenade"
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
weapon_template.fx_sources = {
	_cap = "rp_tox_grenade_tox_01",
}

return weapon_template
