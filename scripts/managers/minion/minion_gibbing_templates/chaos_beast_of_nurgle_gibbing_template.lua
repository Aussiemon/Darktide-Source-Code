-- chunkname: @scripts/managers/minion/minion_gibbing_templates/chaos_beast_of_nurgle_gibbing_template.lua

local GibbingSettings = require("scripts/settings/gibbing/gibbing_settings")
local GibbingThresholds = GibbingSettings.gibbing_thresholds
local gibbing_template = {
	name = "chaos_beast_of_nurgle",
	torso = {
		default = {
			scale_node = "j_spine",
			stump_settings = {
				stump_attach_node = "j_hips",
				stump_unit = "content/characters/enemy/chaos_beast_of_nurgle/gibbing/bon_gib_cap",
				vfx = {
					linked = true,
					node_name = "fx_blood",
					particle_effect = "content/fx/particles/enemies/beast_of_nurgle/bon_death_torso_fountain_stream",
				},
				sfx = {
					node_name = "fx_blood",
					sound_event = "wwise/events/weapon/play_combat_shared_gore_blood_fountain_neck",
				},
			},
			gibbing_threshold = GibbingThresholds.impossible,
			material_overrides = {
				"slot_body",
				"envrionmental_override",
			},
		},
	},
	head = {
		default = {
			gib_settings = {
				gib_actor = "rp_bon_head_gib",
				gib_spawn_node = "j_neck",
				gib_unit = "content/characters/enemy/chaos_beast_of_nurgle/gibbing/bon_head_gib",
				override_push_force = {
					2000,
					3000,
				},
			},
			gibbing_threshold = GibbingThresholds.impossible,
		},
	},
	tongue = {
		default = {
			gib_settings = {
				gib_actor = "rp_bon_tongue_gib",
				gib_spawn_node = "j_neck",
				gib_unit = "content/characters/enemy/chaos_beast_of_nurgle/gibbing/bon_tongue_gib",
				override_push_force = {
					2000,
					3000,
				},
			},
			gibbing_threshold = GibbingThresholds.impossible,
		},
	},
	lower_left_arm = {
		default = {
			gib_settings = {
				gib_actor = "rp_bon_left_arm_gib",
				gib_spawn_node = "j_leftshoulder",
				gib_unit = "content/characters/enemy/chaos_beast_of_nurgle/gibbing/bon_left_arm_gib",
				override_push_force = {
					2000,
					3000,
				},
			},
			gibbing_threshold = GibbingThresholds.impossible,
		},
	},
	lower_right_arm = {
		default = {
			gib_settings = {
				gib_actor = "rp_bon_right_arm_gib",
				gib_spawn_node = "j_rightshoulder",
				gib_unit = "content/characters/enemy/chaos_beast_of_nurgle/gibbing/bon_right_arm_gib",
				override_push_force = {
					2000,
					3000,
				},
			},
			gibbing_threshold = GibbingThresholds.impossible,
		},
	},
}

return gibbing_template
