-- chunkname: @scripts/settings/equipment/weapon_templates/grenades/expeditions_big_grenade.lua

local ProjectileTemplates = require("scripts/settings/projectile/projectile_templates")
local FootstepIntervalsTemplates = require("scripts/settings/equipment/footstep/footstep_intervals_templates")
local grenade_weapon_template_generator = require("scripts/settings/equipment/weapon_templates/weapon_template_generators/grenade_weapon_template_generator")
local weapon_template = grenade_weapon_template_generator(nil)

weapon_template.anim_state_machine_3p = nil
weapon_template.anim_state_machine_1p = nil
weapon_template.breed_anim_state_machine_3p = {
	human = "content/characters/player/human/third_person/animations/big_fing_grenade",
	ogryn = "content/characters/player/ogryn/third_person/animations/big_fing_grenade",
}
weapon_template.breed_anim_state_machine_1p = {
	human = "content/characters/player/human/first_person/animations/big_fing_grenade",
	ogryn = "content/characters/player/ogryn/first_person/animations/big_fing_grenade",
}
weapon_template.actions.action_wield.total_time = 1
weapon_template.actions.action_aim.allowed_chain_actions.aim_released.chain_time = 0.6
weapon_template.actions.action_aim_underhand.allowed_chain_actions.short_hand_throw.chain_time = 0.6

local AMMUNITION_USAGE = 1
local REMOVE_ITEM_FROM_INVENTORY = true

weapon_template.actions.action_throw_grenade.ammunition_usage = AMMUNITION_USAGE
weapon_template.actions.action_underhand_throw_grenade.ammunition_usage = AMMUNITION_USAGE
weapon_template.actions.action_throw_grenade.remove_item_from_inventory = REMOVE_ITEM_FROM_INVENTORY
weapon_template.actions.action_underhand_throw_grenade.remove_item_from_inventory = REMOVE_ITEM_FROM_INVENTORY
weapon_template.ammo_template = "expeditions_big_grenade"
weapon_template.swap_pickup_name = "expedition_grenade_big_pocketable"
weapon_template.projectile_template = ProjectileTemplates.expeditions_big_grenade
weapon_template.footstep_intervals = FootstepIntervalsTemplates.ogryn_combat_blade
weapon_template.hud_icon = "content/ui/materials/icons/throwables/hud/big_fn_grenade"
weapon_template.hud_icon_small = "content/ui/materials/icons/throwables/hud/big_fn_grenade"

return weapon_template
