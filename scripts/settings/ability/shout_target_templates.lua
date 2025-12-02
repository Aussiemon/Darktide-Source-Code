-- chunkname: @scripts/settings/ability/shout_target_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local shout_target_templates = {}
local talent_settings_adamant = TalentSettings.adamant

shout_target_templates.adamant_shout = {
	allies = nil,
	owner = nil,
	enemies = {
		buff_to_add = "adamant_whistle_electrocution",
		damage_type = nil,
		force_stagger_duration = 2.5,
		force_stagger_type = "light",
		power_level = 1000,
		damage_profile = DamageProfileTemplates.adamant_shout,
	},
}
shout_target_templates.adamant_shout_improved = {
	owner = nil,
	enemies = {
		buff_to_add = nil,
		damage_type = nil,
		force_stagger_duration = 2.5,
		force_stagger_type = "light",
		power_level = 1000,
		damage_profile = DamageProfileTemplates.adamant_shout,
	},
	allies = {
		shout_restores_toughness = true,
		toughness_replenish_percent = talent_settings_adamant.combat_ability.shout_improved.toughness,
	},
}
shout_target_templates.broker_rage_shout = {
	owner = nil,
	enemies = {
		buff_to_add = nil,
		buff_to_add_non_monster = nil,
		damage_type = nil,
		force_stagger_type_if_not_staggered = "heavy",
		force_stagger_type_if_not_staggered_duration = 2.5,
		power_level = 500,
		damage_profile = DamageProfileTemplates.broker_punk_rage_shout,
	},
	allies = {
		buff_to_add = nil,
		revive_allies = true,
	},
}
shout_target_templates.veteran_shout = {
	owner = nil,
	enemies = {
		buff_to_add = nil,
		buff_to_add_non_monster = nil,
		damage_type = nil,
		force_stagger_type_if_not_staggered = "heavy",
		force_stagger_type_if_not_staggered_duration = 2.5,
		power_level = 500,
		damage_profile = DamageProfileTemplates.shout_stagger_veteran,
	},
	allies = {
		buff_to_add = nil,
		revive_allies = true,
	},
}
shout_target_templates.ogryn_shout = {
	allies = nil,
	owner = nil,
	enemies = {
		buff_to_add = "taunted",
		damage_type = nil,
		force_stagger_duration = 1,
		force_stagger_type = "light",
		power_level = 500,
		special_rule_buff_enemy = "ogryn_taunt_increased_damage_taken_buff",
		special_rule_buff_enemy_monster = nil,
		buff_ignored_breeds = {
			chaos_daemonhost = true,
			chaos_mutator_daemonhost = true,
			chaos_mutator_ritualist = true,
		},
		can_not_hit = {
			chaos_mutator_daemonhost = true,
			chaos_mutator_ritualist = true,
		},
		damage_profile = DamageProfileTemplates.shout_stagger_ogryn_taunt,
	},
}
shout_target_templates.ogryn_shout_no_stagger = table.clone(shout_target_templates.ogryn_shout)
shout_target_templates.ogryn_shout_no_stagger.enemies.power_level = 0
shout_target_templates.ogryn_shout_no_stagger.enemies.force_stagger_duration = nil
shout_target_templates.ogryn_shout_no_stagger.enemies.force_stagger_type = nil
shout_target_templates.ogryn_shout_no_stagger.enemies.damage_profile = nil
shout_target_templates.hordes_zealot_lunge_shout = {
	allies = nil,
	owner = nil,
	enemies = {
		buff_to_add = nil,
		buff_to_add_non_monster = nil,
		damage_type = nil,
		force_stagger_type_if_not_staggered = "heavy",
		force_stagger_type_if_not_staggered_duration = 2.5,
		power_level = 500,
		damage_profile = DamageProfileTemplates.shout_stagger_veteran,
	},
}

return settings("ShoutTargetTemplates", shout_target_templates)
