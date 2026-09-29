-- chunkname: @scripts/settings/fx/effect_templates/renegade_wizard_vanish_settings.lua

local RenegadeWizardVanishSettings = {}

RenegadeWizardVanishSettings.templates = {
	renegade_wizard_vanish = {
		cloud_name = "flies_limb_emit",
		scale_variable = "emitter_scale",
		set_delay_weight = 0.1,
		vfx_name = "content/fx/particles/enemies/renegade_wizard/renegade_wizard_vanish_limb_cinematic",
		sets = {
			{
				{
					duration_weight = 0.4,
					end_scale = 1.4,
					name = "head",
					start_scale = 1.2,
					bones = {
						"j_head_end",
						"j_head",
						"j_neck",
					},
				},
			},
			{
				{
					duration_weight = 1,
					end_scale = 2.6,
					name = "spine",
					start_scale = 1.8,
					bones = {
						"j_neck",
						"j_spine1",
						"j_spine",
						"j_hips",
					},
				},
			},
			{
				{
					duration_weight = 0.9,
					end_scale = 1,
					name = "left_arm",
					start_scale = 1.2,
					bones = {
						"j_leftarm",
						"j_leftforearm",
						"j_lefthand",
					},
				},
				{
					duration_weight = 0.9,
					end_scale = 1,
					name = "right_arm",
					start_scale = 1.2,
					bones = {
						"j_rightarm",
						"j_rightforearm",
						"j_righthand",
					},
				},
				{
					duration_weight = 0.9,
					end_scale = 1,
					name = "left_leg",
					start_scale = 1.2,
					bones = {
						"j_leftupleg",
						"j_leftleg",
						"j_leftfoot",
					},
				},
				{
					duration_weight = 0.9,
					end_scale = 1,
					name = "right_leg",
					start_scale = 1.2,
					bones = {
						"j_rightupleg",
						"j_rightleg",
						"j_rightfoot",
					},
				},
			},
		},
	},
}
RenegadeWizardVanishSettings.DIRECTION_TOP_DOWN = "top_down"
RenegadeWizardVanishSettings.DIRECTION_BOTTOM_UP = "bottom_up"

return RenegadeWizardVanishSettings
