-- chunkname: @scripts/settings/ability/player_abilities/abilities/cryptic_abilities.lua

local TalentSettings = require("scripts/settings/talent/talent_settings")
local CompanionServoSkullAbility = require("scripts/utilities/companion/companion_servo_skull_ability")
local CompanionServoSkullSettings = require("scripts/settings/companion/companion_servo_skull_settings")
local SpecialRulesSettings = require("scripts/settings/ability/special_rules_settings")
local cryptic_talent_settings = TalentSettings.cryptic
local force_field_talent_settings = cryptic_talent_settings.force_field
local arc_grenade_talent_settings = cryptic_talent_settings.arc_grenade
local discharge_ability_talent_settings = cryptic_talent_settings.discharge_ability
local precision_stance_talent_settings = cryptic_talent_settings.precision_stance
local chordclaw_ability_talent_settings = cryptic_talent_settings.chordclaw_ability
local servo_skull_shooting_base_settings = cryptic_talent_settings.servo_skull_shooting_base
local special_rules = SpecialRulesSettings.special_rules
local abilities = {
	cryptic_servo_skull_order = {
		ability_group = "cryptic_servo_skull_order",
		ability_template = "cryptic_servo_skull_order",
		ability_type = "grenade_ability",
		hud_icon = "content/ui/textures/icons/throwables/hud/cryptic_servo_skull_order_shooting",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/cryptic_servo_skull_order",
		max_charges = 4,
		stat_buff = "extra_max_amount_of_grenades",
		hud_configuration = {
			uses_ammunition = true,
		},
		archetypes = {
			"cryptic",
		},
	},
	cryptic_servo_skull_order_base = {
		ability_group = "cryptic_servo_skull_order",
		ability_template = "cryptic_servo_skull_order_base",
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/throwables/hud/cryptic_servo_skull_order_shooting",
		hud_icon_small = "content/ui/materials/icons/throwables/hud/small/party_non_grenade",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges = 1,
		stat_buff = "extra_max_amount_of_grenades",
		hud_configuration = {
			uses_ammunition = false,
		},
		cooldown = servo_skull_shooting_base_settings.cooldown,
		archetypes = {
			"cryptic",
		},
		pause_cooldown_settings = {
			pause_fulfilled_func = function (context)
				local player_unit = context.unit
				local companion_spawner_extension = ScriptUnit.has_extension(player_unit, "companion_spawner_system")
				local companion_unit = companion_spawner_extension and companion_spawner_extension:spawned_unit_lookup(special_rules.cryptic_servo_skull_hack)
				local buff_extension = ScriptUnit.has_extension(companion_unit, "buff_system")
				local buff_name = CompanionServoSkullSettings.buffs.base_order_ability_buff_name

				if buff_extension and buff_extension:has_buff_using_buff_template(buff_name) then
					return false
				end

				return true
			end,
		},
	},
	cryptic_discharge_base = {
		ability_group = "cryptic_discharge",
		ability_template = "cryptic_discharge_base",
		ability_type = "combat_ability",
		hud_icon = "content/ui/textures/icons/abilities/hud/cryptic/cryptic_ability_discharge",
		hud_icon_frame = "content/ui/textures/icons/talents/hud/combat_frame_battery_inner",
		hud_icon_frame_glow = "content/ui/textures/effects/hud/combat_ability_battery_glow_shape",
		hud_icon_frame_glow_spin = "content/ui/textures/effects/hud/combat_ability_battery_glow_spin",
		hud_icon_mask = "content/ui/textures/icons/abilities/hud/ability_mask_battery",
		hud_icon_ramp = "content/fx/textures/ramps/warp_ramp_03",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges_usage_cost = 3,
		min_charges_usage_cost = 1,
		stat_buff = "ability_extra_charges",
		ability_template_tweak_data = {},
		archetypes = {
			"cryptic",
		},
		cooldown = discharge_ability_talent_settings.cooldown,
		max_charges = discharge_ability_talent_settings.max_charges,
	},
	cryptic_discharge = {
		ability_group = "cryptic_discharge",
		ability_template = "cryptic_discharge",
		ability_type = "combat_ability",
		hud_icon = "content/ui/textures/icons/abilities/hud/cryptic/cryptic_ability_discharge",
		hud_icon_frame = "content/ui/textures/icons/talents/hud/combat_frame_battery_inner",
		hud_icon_frame_glow = "content/ui/textures/effects/hud/combat_ability_battery_glow_shape",
		hud_icon_frame_glow_spin = "content/ui/textures/effects/hud/combat_ability_battery_glow_spin",
		hud_icon_mask = "content/ui/textures/icons/abilities/hud/ability_mask_battery",
		hud_icon_ramp = "content/fx/textures/ramps/warp_ramp_03",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges_usage_cost = 3,
		min_charges_usage_cost = 1,
		stat_buff = "ability_extra_charges",
		ability_template_tweak_data = {},
		archetypes = {
			"cryptic",
		},
		cooldown = discharge_ability_talent_settings.cooldown,
		max_charges = discharge_ability_talent_settings.max_charges,
	},
	cryptic_precision_stance = {
		ability_group = "cryptic_precision_stance",
		ability_template = "cryptic_precision_stance",
		ability_type = "combat_ability",
		hud_icon = "content/ui/textures/icons/abilities/hud/cryptic/cryptic_ability_precision_stance",
		hud_icon_frame = "content/ui/textures/icons/talents/hud/combat_frame_battery_inner",
		hud_icon_frame_glow = "content/ui/textures/effects/hud/combat_ability_battery_glow_shape",
		hud_icon_frame_glow_spin = "content/ui/textures/effects/hud/combat_ability_battery_glow_spin",
		hud_icon_mask = "content/ui/textures/icons/abilities/hud/ability_mask_battery",
		hud_icon_ramp = "content/fx/textures/ramps/warp_ramp_03",
		icon = "content/ui/materials/icons/abilities/combat/default",
		max_charges_usage_cost = 2,
		min_charges_usage_cost = 1,
		stat_buff = "ability_extra_charges",
		ability_template_tweak_data = {
			auto_wield_slot = "slot_secondary",
			charge_based_buffs_to_add = {
				"cryptic_precision_stance_one_charge",
				"cryptic_precision_stance_two_charges",
				"cryptic_precision_stance_three_charges",
			},
		},
		archetypes = {
			"cryptic",
		},
		cooldown = precision_stance_talent_settings.cooldown,
		max_charges = precision_stance_talent_settings.max_charges,
	},
	cryptic_chordclaw = {
		ability_group = "cryptic_chordclaw",
		ability_locked_while_active = true,
		ability_template = "cryptic_chordclaw",
		ability_type = "combat_ability",
		can_be_previously_wielded_to = false,
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/textures/icons/abilities/hud/cryptic/cryptic_ability_chordclaw",
		hud_icon_frame = "content/ui/textures/icons/talents/hud/combat_frame_battery_inner",
		hud_icon_frame_glow = "content/ui/textures/effects/hud/combat_ability_battery_glow_shape",
		hud_icon_frame_glow_spin = "content/ui/textures/effects/hud/combat_ability_battery_glow_spin",
		hud_icon_mask = "content/ui/textures/icons/abilities/hud/ability_mask_battery",
		hud_icon_ramp = "content/fx/textures/ramps/warp_ramp_03",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/melee/transonic_claw_p1_m1",
		max_charges_usage_cost = 1,
		min_charges_usage_cost = 1,
		stat_buff = "ability_extra_charges",
		ability_template_tweak_data = {},
		archetypes = {
			"cryptic",
		},
		cooldown = chordclaw_ability_talent_settings.cooldown,
		max_charges = chordclaw_ability_talent_settings.max_charges,
	},
	cryptic_force_field = {
		ability_group = "cryptic_force_field",
		ability_template = "cryptic_force_field",
		ability_type = "grenade_ability",
		can_be_previously_wielded_to = false,
		can_be_wielded_when_depleted = false,
		hud_icon = "content/ui/materials/icons/throwables/hud/cryptic_force_field",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_reference = "content/items/generic/cryptic_force_field",
		stat_buff = "extra_max_amount_of_grenades",
		ability_template_tweak_data = {
			buff_to_add = "cryptic_grenade_ability_force_field_active",
		},
		hud_configuration = {
			uses_ammunition = true,
		},
		max_charges = force_field_talent_settings.max_charges,
		archetypes = {
			"cryptic",
		},
	},
	arc_grenade = {
		ability_type = "grenade_ability",
		hud_icon = "content/ui/materials/icons/abilities/throwables/default",
		icon = "content/ui/materials/icons/abilities/combat/default",
		inventory_item_name = "content/items/weapons/player/grenade_arc",
		stat_buff = "extra_max_amount_of_grenades",
		max_charges = arc_grenade_talent_settings.charges,
		archetypes = {
			"cryptic",
		},
	},
}

abilities.cryptic_servo_skull_order_base_inactive = table.clone(abilities.cryptic_servo_skull_order_base)
abilities.cryptic_servo_skull_order_base_inactive.max_charges = 0
abilities.cryptic_servo_skull_order_base_inactive.ability_template = nil
abilities.cryptic_servo_skull_order_base_inactive.hud_icon = "content/ui/materials/icons/throwables/hud/cryptic_servo_skull_order_shooting"

return abilities
