-- chunkname: @scripts/managers/minion/minion_gibbing_templates/chaos_poxwalker_bomber_gibbing_template.lua

local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local gibbing_template = {
	name = "chaos_poxwalker_bomber",
	fallback_hit_zone = {
		default = {
			override_hit_zone_name = "torso",
			scale_node = "j_spine",
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_poxwalker_bomber/gibbing/torso_gib_cap",
				vfx = {
					particle_effect = "content/fx/particles/impacts/flesh/blood_fountain_head_01",
					linked = true,
					node_name = "fx_blood"
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck"
				}
			},
			gibbing_threshold = GibbingThresholds.always,
			material_overrides = {
				"slot_body",
				"envrionmental_override"
			}
		}
	}
}

return gibbing_template
