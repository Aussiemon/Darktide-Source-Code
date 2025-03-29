-- chunkname: @scripts/settings/ability/shout_target_templates.lua

local DamageProfileTemplates = require("scripts/settings/damage/damage_profile_templates")
local TalentSettings = require("scripts/settings/talent/talent_settings")
local shout_target_templates = {}

shout_target_templates.veteran_shout = {
	enemies = {
		force_stagger_type_if_not_staggered = "heavy",
		force_stagger_type_if_not_staggered_duration = 2.5,
		power_level = 500,
		damage_profile = DamageProfileTemplates.shout_stagger_veteran,
	},
	allies = {
		revive_allies = true,
	},
}
shout_target_templates.ogryn_shout = {
	enemies = {
		buff_to_add = "taunted",
		force_stagger_duration = 1,
		force_stagger_type = "light",
		power_level = 500,
		special_rule_buff_enemy = "ogryn_taunt_increased_damage_taken_buff",
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
	enemies = {
		force_stagger_type_if_not_staggered = "heavy",
		force_stagger_type_if_not_staggered_duration = 2.5,
		power_level = 500,
		damage_profile = DamageProfileTemplates.shout_stagger_veteran,
	},
}

return settings("ShoutTargetTemplates", shout_target_templates)
