-- chunkname: @scripts/settings/options/render_settings.lua

local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local OptionsUtilities = require("scripts/utilities/ui/options")
local SettingsUtilitiesFunction = require("scripts/settings/options/settings_utils")
local render_settings = {}
local SettingsUtilities = {}
local RENDER_TEMPLATES = {
	{
		default_value = false,
		display_name = "loc_vsync",
		id = "vsync",
		require_apply = true,
		require_restart = false,
		tooltip_text = "loc_vsync_mouseover",
		value_type = "boolean",
	},
	{
		display_name = "loc_setting_brightness",
		id = "brightness",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_brightness_mouseover",
		widget_type = "button",
		supported_platforms = {
			win32 = true,
			xbs = true,
		},
		pressed_function = function (parent, widget, template)
			local pages_templates = require("scripts/ui/views/custom_settings_view/custom_settings_view_pages")

			Managers.ui:open_view("custom_settings_view", nil, nil, nil, nil, {
				pages = pages_templates.brightness_render_option_settings,
			})
		end,
	},
	{
		display_name = "loc_settings_menu_group_performance",
		group_name = "performance",
		widget_type = "group_header",
	},
	{
		default_value = "off",
		display_name = "loc_setting_nvidia_dlss",
		id = "dlss_master",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_nvidia_dlss_mouseover",
		validation_function = function ()
			return Application.render_caps("dlss_supported")
		end,
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = "off",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						dlss = 0,
						dlss_g = 0,
					},
				},
			},
			{
				display_name = "loc_settings_menu_on",
				id = "on",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						dlss = 1,
						dlss_g = 1,
						nv_reflex_low_latency = 1,
					},
				},
			},
		},
	},
	{
		apply_on_startup = true,
		default_value = 0,
		display_name = "loc_setting_dlss",
		id = "dlss",
		indentation_level = 1,
		require_apply = true,
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_dlss_mouseover",
		validation_function = function ()
			return Application.render_caps("dlss_supported")
		end,
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = 0,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_enabled = false,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_auto",
				id = 1,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_enabled = true,
						upscaling_quality = "auto",
					},
					master_render_settings = {
						fsr = 0,
						fsr2 = 0,
						xess = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_ultra_performance",
				id = 2,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_enabled = true,
						upscaling_quality = "ultra_performance",
					},
					master_render_settings = {
						fsr = 0,
						fsr2 = 0,
						xess = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_max_performance",
				id = 3,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_enabled = true,
						upscaling_quality = "performance",
					},
					master_render_settings = {
						fsr = 0,
						fsr2 = 0,
						xess = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_balanced",
				id = 4,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_enabled = true,
						upscaling_quality = "balanced",
					},
					master_render_settings = {
						fsr = 0,
						fsr2 = 0,
						xess = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_max_quality",
				id = 5,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_enabled = true,
						upscaling_quality = "quality",
					},
					master_render_settings = {
						fsr = 0,
						fsr2 = 0,
						xess = 0,
					},
				},
			},
		},
		disable_rules = {
			{
				disable_value = 0,
				id = "anti_aliasing_solution",
				reason = "loc_disable_rule_dlss_aa",
				validation_function = function (value)
					return value > 0
				end,
			},
		},
	},
	{
		apply_on_startup = true,
		default_value = 0,
		display_name = "loc_setting_dlss_g",
		id = "dlss_g",
		indentation_level = 1,
		require_apply = true,
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_dlss_g_mouseover",
		validation_function = function ()
			return Application.render_caps("dlss_g_supported")
		end,
		options = {
			{
				display_name = "loc_rt_setting_off",
				id = 0,
				require_apply = false,
				require_restart = false,
				values = {
					render_settings = {
						dlss_g_enabled = false,
					},
				},
			},
			{
				display_name = "loc_rt_setting_on",
				id = 1,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_g_enabled = true,
					},
					master_render_settings = {
						nv_reflex_low_latency = 1,
						vsync = false,
					},
				},
			},
		},
		disable_rules = {
			{
				disable_value = false,
				id = "vsync",
				reason = "loc_disable_rule_dlss_g_vsync",
				validation_function = function (value)
					return value == 1
				end,
			},
			{
				disable_value = 1,
				id = "nv_reflex_low_latency",
				reason = "loc_disable_rule_dlss_g_reflex",
				validation_function = function (value)
					return value == 1
				end,
			},
		},
	},
	{
		apply_on_startup = true,
		default_value = 1,
		display_name = "loc_setting_nv_reflex",
		id = "nv_reflex_low_latency",
		indentation_level = 1,
		require_apply = true,
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_nv_reflex_mouseover",
		validation_function = function ()
			return Application.render_caps("reflex_supported")
		end,
		options = {
			{
				display_name = "loc_setting_nv_reflex_disabled",
				id = 0,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_low_latency_boost = false,
						nv_low_latency_mode = false,
					},
				},
			},
			{
				display_name = "loc_setting_nv_reflex_low_latency_enabled",
				id = 1,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_low_latency_boost = false,
						nv_low_latency_mode = true,
					},
				},
			},
			{
				display_name = "loc_setting_nv_reflex_low_latency_boost",
				id = 2,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_low_latency_boost = true,
						nv_low_latency_mode = true,
					},
				},
			},
		},
	},
	{
		default_value = 0,
		display_name = "loc_setting_framerate_cap",
		id = "nv_reflex_framerate_cap",
		require_apply = true,
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_framerate_cap_mouseover",
		options = {
			{
				display_name = "loc_setting_nv_reflex_framerate_cap_unlimited",
				id = 0,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 0,
					},
				},
			},
			{
				display_name = "loc_setting_nv_reflex_framerate_cap_30",
				id = 1,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 30,
					},
				},
			},
			{
				display_name = "loc_setting_nv_reflex_framerate_cap_40",
				id = 2,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 40,
					},
				},
			},
			{
				display_name = "loc_setting_nv_reflex_framerate_cap_60",
				id = 3,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 60,
					},
				},
			},
			{
				display_name = "loc_setting_nv_reflex_framerate_cap_72",
				id = 4,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 72,
					},
				},
			},
			{
				display_name = "loc_setting_nv_reflex_framerate_cap_90",
				id = 5,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 90,
					},
				},
			},
			{
				display_name = "loc_setting_nv_reflex_framerate_cap_120",
				id = 6,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 120,
					},
				},
			},
		},
	},
	{
		apply_on_startup = true,
		default_value = 0,
		display_name = "loc_setting_fsr2",
		id = "fsr2",
		require_apply = true,
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_fsr2_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = 0,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr2_enabled = false,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_ultra_performance",
				id = 1,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr2_enabled = true,
						upscaling_quality = "ultra_performance",
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						xess = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_max_performance",
				id = 2,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr2_enabled = true,
						upscaling_quality = "performance",
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						xess = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_balanced",
				id = 3,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr2_enabled = true,
						upscaling_quality = "balanced",
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						xess = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_max_quality",
				id = 4,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr2_enabled = true,
						upscaling_quality = "quality",
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						xess = 0,
					},
				},
			},
			{
				display_name = "loc_setting_fsr2_native_quality",
				id = 5,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr2_enabled = true,
						upscaling_quality = "native",
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						xess = 0,
					},
				},
			},
		},
		disable_rules = {
			{
				disable_value = 0,
				id = "anti_aliasing_solution",
				reason = "loc_disable_rule_fsr_aa",
				validation_function = function (value)
					return value > 0
				end,
			},
		},
	},
	{
		apply_on_startup = true,
		default_value = 0,
		display_name = "loc_setting_xess",
		id = "xess",
		require_apply = true,
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_xess_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = 0,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						xess_enabled = false,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_max_performance",
				id = 1,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "performance",
						xess_enabled = true,
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						fsr2 = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_balanced",
				id = 2,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "balanced",
						xess_enabled = true,
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						fsr2 = 0,
					},
				},
			},
			{
				display_name = "loc_setting_dlss_quality_max_quality",
				id = 3,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "quality",
						xess_enabled = true,
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						fsr2 = 0,
					},
				},
			},
			{
				display_name = "loc_setting_fsr_quality_ultra_quality",
				id = 4,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "ultra_quality",
						xess_enabled = true,
					},
					master_render_settings = {
						dlss = 0,
						fsr = 0,
						fsr2 = 0,
					},
				},
			},
		},
		disable_rules = {
			{
				disable_value = 0,
				id = "anti_aliasing_solution",
				reason = "loc_disable_rule_xess_aa",
				validation_function = function (value)
					return value > 0
				end,
			},
		},
	},
	{
		apply_on_startup = true,
		default_value = 0,
		display_name = "loc_setting_fsr",
		id = "fsr",
		require_apply = true,
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_fsr_mouseover",
		options = {
			{
				display_name = "loc_setting_fsr_quality_off",
				id = 0,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = false,
						fsr_quality = 0,
					},
				},
			},
			{
				display_name = "loc_setting_fsr_quality_performance",
				id = 1,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 1,
					},
					master_render_settings = {
						anti_aliasing_solution = 2,
						dlss = 0,
						fsr2 = 0,
					},
				},
			},
			{
				display_name = "loc_setting_fsr_quality_balanced",
				id = 2,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 2,
					},
					master_render_settings = {
						dlss = 0,
						fsr2 = 0,
					},
				},
			},
			{
				display_name = "loc_setting_fsr_quality_quality",
				id = 3,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 3,
					},
					master_render_settings = {
						dlss = 0,
						fsr2 = 0,
					},
				},
			},
			{
				display_name = "loc_setting_fsr_quality_ultra_quality",
				id = 4,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 4,
					},
					master_render_settings = {
						dlss = 0,
						fsr2 = 0,
					},
				},
			},
		},
		disable_rules = {
			{
				disable_value = 2,
				id = "anti_aliasing_solution",
				reason = "loc_disable_rule_fsr_aa",
				validation_function = function (value)
					return value > 0
				end,
			},
		},
	},
	{
		display_name = "loc_sharpness_slider",
		id = "sharpness",
		max = 1,
		min = 0,
		num_decimals = 2,
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		step_size = 0.01,
		tooltip_text = "loc_sharpness_slider_mouseover",
		value_type = "number",
	},
	{
		default_value = 0,
		display_name = "loc_setting_anti_ailiasing",
		id = "anti_aliasing_solution",
		require_apply = true,
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_anti_ailiasing_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = 0,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fxaa_enabled = false,
						taa_enabled = false,
					},
				},
			},
			{
				display_name = "loc_setting_anti_ailiasing_fxaa",
				id = 1,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fxaa_enabled = true,
						taa_enabled = false,
					},
				},
			},
			{
				display_name = "loc_setting_anti_ailiasing_taa",
				id = 2,
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fxaa_enabled = false,
						taa_enabled = true,
					},
				},
			},
		},
	},
	{
		display_name = "loc_ray_tracing",
		group_name = "ray_tracing",
		widget_type = "group_header",
		validation_function = function ()
			return Application.render_caps("dxr")
		end,
	},
	{
		apply_on_startup = true,
		display_name = "loc_rt_reflections_quality",
		id = "rt_reflections_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_rt_reflections_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = "off",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						rt_checkerboard_reflections = false,
						rt_reflections_enabled = false,
						world_space_motion_vectors = false,
					},
				},
			},
			{
				display_name = "loc_settings_menu_low",
				id = "low",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						ssr_quality = "high",
					},
					render_settings = {
						dxr = true,
						rt_checkerboard_reflections = true,
						rt_mixed_reflections = true,
						rt_reflections_enabled = true,
						ssr_enabled = true,
						world_space_motion_vectors = true,
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						ssr_quality = "off",
					},
					render_settings = {
						dxr = true,
						rt_checkerboard_reflections = true,
						rt_mixed_reflections = false,
						rt_reflections_enabled = true,
						world_space_motion_vectors = true,
					},
				},
			},
		},
		validation_function = function ()
			return Application.render_caps("dxr")
		end,
		disable_rules = {
			{
				disable_value = "off",
				id = "ssr_quality",
				reason = "loc_disable_rule_rt_reflections_ssr",
				validation_function = function (value)
					return value == "high"
				end,
			},
			{
				disable_value = "high",
				id = "ssr_quality",
				reason = "loc_disable_rule_rt_reflections_ssr",
				validation_function = function (value)
					return value == "low"
				end,
			},
		},
	},
	{
		apply_on_startup = true,
		default_value = "off",
		display_name = "loc_rtxgi_quality",
		id = "rtxgi_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_rtxgi_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = "off",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						baked_ddgi = true,
						rtxgi_enabled = false,
					},
				},
			},
			{
				display_name = "loc_settings_menu_low",
				id = "low",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						baked_ddgi = true,
						dxr = true,
						rtxgi_enabled = true,
						rtxgi_scale = 0.5,
					},
				},
			},
			{
				display_name = "loc_settings_menu_medium",
				id = "medium",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						baked_ddgi = false,
						dxr = true,
						rtxgi_enabled = true,
						rtxgi_scale = 0.5,
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						baked_ddgi = false,
						dxr = true,
						rtxgi_enabled = true,
						rtxgi_scale = 1,
					},
				},
			},
		},
		disable_rules = {
			{
				disable_value = "high",
				id = "gi_quality",
				reason = "loc_disable_rule_rtxgi_gi",
				validation_function = function (value)
					return value == "high"
				end,
			},
			{
				disable_value = "low",
				id = "gi_quality",
				reason = "loc_disable_rule_rtxgi_gi",
				validation_function = function (value)
					return value == "low" or value == "medium"
				end,
			},
		},
		validation_function = function ()
			return Application.render_caps("dxr")
		end,
	},
	{
		display_name = "loc_settings_menu_group_graphics_preset",
		group_name = "graphics",
		widget_type = "group_header",
	},
	{
		apply_on_startup = true,
		display_name = "loc_setting_graphics_quality",
		id = "graphics_quality",
		save_location = "master_render_settings",
		startup_prio = 1,
		tooltip_text = "loc_setting_graphics_quality_mouseover",
		default_value = DefaultGameParameters.default_graphics_quality,
		options = {
			{
				display_name = "loc_settings_menu_low",
				id = "low",
				require_apply = true,
				require_restart = false,
				values = {
					performance_settings = {
						decal_lifetime = 10,
						max_blood_decals = 15,
						max_impact_decals = 15,
						max_ragdolls = 5,
					},
					master_render_settings = {
						ambient_occlusion_quality = "low",
						dof_quality = "off",
						gi_quality = "low",
						lens_flare_quality = "off",
						light_quality = "low",
						ssr_quality = "off",
						texture_quality = "low",
						volumetric_fog_quality = "low",
					},
					render_settings = {
						bloom_enabled = true,
						lens_quality_enabled = false,
						lod_object_multiplier = 0.7,
						lod_scatter_density = 0.25,
						motion_blur_enabled = false,
						rough_transparency_enabled = false,
						skin_material_enabled = false,
					},
				},
			},
			{
				display_name = "loc_settings_menu_medium",
				id = "medium",
				require_apply = true,
				require_restart = false,
				values = {
					performance_settings = {
						decal_lifetime = 20,
						max_blood_decals = 30,
						max_impact_decals = 30,
						max_ragdolls = 8,
					},
					master_render_settings = {
						ambient_occlusion_quality = "medium",
						dof_quality = "medium",
						gi_quality = "low",
						lens_flare_quality = "sun_light_only",
						light_quality = "medium",
						ssr_quality = "medium",
						texture_quality = "medium",
						volumetric_fog_quality = "medium",
					},
					render_settings = {
						bloom_enabled = true,
						lens_quality_enabled = true,
						lod_object_multiplier = 1,
						lod_scatter_density = 0.5,
						motion_blur_enabled = true,
						rough_transparency_enabled = true,
						skin_material_enabled = false,
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = false,
				values = {
					performance_settings = {
						decal_lifetime = 40,
						max_blood_decals = 50,
						max_impact_decals = 50,
						max_ragdolls = 12,
					},
					master_render_settings = {
						ambient_occlusion_quality = "high",
						dof_quality = "high",
						gi_quality = "high",
						lens_flare_quality = "all_lights",
						light_quality = "high",
						ssr_quality = "high",
						texture_quality = "high",
						volumetric_fog_quality = "high",
					},
					render_settings = {
						bloom_enabled = true,
						lens_quality_enabled = true,
						lod_object_multiplier = 2,
						lod_scatter_density = 1,
						motion_blur_enabled = true,
						rough_transparency_enabled = true,
						skin_material_enabled = true,
					},
				},
			},
			{
				display_name = "loc_setting_graphics_quality_option_custom",
				id = "custom",
			},
		},
	},
	{
		display_name = "loc_settings_menu_group_graphics_advanced",
		group_name = "render_settings",
		widget_type = "group_header",
	},
	{
		display_name = "loc_setting_texture_quality",
		id = "texture_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_texture_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_low",
				id = "low",
				require_apply = true,
				require_restart = true,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					texture_settings = {
						["content/texture_categories/character_bc"] = 2,
						["content/texture_categories/character_bca"] = 2,
						["content/texture_categories/character_bcm"] = 2,
						["content/texture_categories/character_hm"] = 2,
						["content/texture_categories/character_mask"] = 2,
						["content/texture_categories/character_mask2"] = 2,
						["content/texture_categories/character_nm"] = 2,
						["content/texture_categories/character_orm"] = 2,
						["content/texture_categories/environment_bc"] = 2,
						["content/texture_categories/environment_bca"] = 2,
						["content/texture_categories/environment_hm"] = 2,
						["content/texture_categories/environment_nm"] = 2,
						["content/texture_categories/environment_orm"] = 2,
						["content/texture_categories/weapon_bc"] = 2,
						["content/texture_categories/weapon_bca"] = 2,
						["content/texture_categories/weapon_hm"] = 2,
						["content/texture_categories/weapon_mask"] = 2,
						["content/texture_categories/weapon_nm"] = 2,
						["content/texture_categories/weapon_orm"] = 2,
					},
				},
			},
			{
				display_name = "loc_settings_menu_medium",
				id = "medium",
				require_apply = true,
				require_restart = true,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					texture_settings = {
						["content/texture_categories/character_bc"] = 1,
						["content/texture_categories/character_bca"] = 1,
						["content/texture_categories/character_bcm"] = 1,
						["content/texture_categories/character_hm"] = 1,
						["content/texture_categories/character_mask"] = 1,
						["content/texture_categories/character_mask2"] = 1,
						["content/texture_categories/character_nm"] = 1,
						["content/texture_categories/character_orm"] = 1,
						["content/texture_categories/environment_bc"] = 1,
						["content/texture_categories/environment_bca"] = 1,
						["content/texture_categories/environment_hm"] = 1,
						["content/texture_categories/environment_nm"] = 1,
						["content/texture_categories/environment_orm"] = 1,
						["content/texture_categories/weapon_bc"] = 1,
						["content/texture_categories/weapon_bca"] = 1,
						["content/texture_categories/weapon_hm"] = 1,
						["content/texture_categories/weapon_mask"] = 1,
						["content/texture_categories/weapon_nm"] = 1,
						["content/texture_categories/weapon_orm"] = 1,
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = true,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					texture_settings = {
						["content/texture_categories/character_bc"] = 0,
						["content/texture_categories/character_bca"] = 0,
						["content/texture_categories/character_bcm"] = 0,
						["content/texture_categories/character_hm"] = 0,
						["content/texture_categories/character_mask"] = 0,
						["content/texture_categories/character_mask2"] = 0,
						["content/texture_categories/character_nm"] = 0,
						["content/texture_categories/character_orm"] = 0,
						["content/texture_categories/environment_bc"] = 0,
						["content/texture_categories/environment_bca"] = 0,
						["content/texture_categories/environment_hm"] = 0,
						["content/texture_categories/environment_nm"] = 0,
						["content/texture_categories/environment_orm"] = 0,
						["content/texture_categories/weapon_bc"] = 0,
						["content/texture_categories/weapon_bca"] = 0,
						["content/texture_categories/weapon_hm"] = 0,
						["content/texture_categories/weapon_mask"] = 0,
						["content/texture_categories/weapon_nm"] = 0,
						["content/texture_categories/weapon_orm"] = 0,
					},
				},
			},
		},
	},
	{
		display_name = "loc_setting_lod_object_multiplier",
		id = "lod_object_multiplier",
		max = 5,
		min = 0.5,
		num_decimals = 1,
		require_apply = true,
		require_restart = false,
		save_location = "render_settings",
		step_size = 0.1,
		tooltip_text = "loc_setting_lod_object_multiplier_mouseover",
		value_type = "number",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
		default_value = DefaultGameParameters.default_lod_object_multiplier,
	},
	{
		apply_on_startup = true,
		display_name = "loc_setting_ambient_occlusion_quality",
		id = "ambient_occlusion_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_ambient_occlusion_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = "off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						ao_enabled = false,
						gtao_enabled = false,
						gtao_quality = 0,
					},
				},
			},
			{
				display_name = "loc_settings_menu_low",
				id = "low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						ao_enabled = true,
						cacao_enabled = false,
						gtao_enabled = true,
						gtao_quality = 0,
					},
				},
			},
			{
				display_name = "loc_settings_menu_medium",
				id = "medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						ao_enabled = true,
						cacao_enabled = false,
						gtao_enabled = true,
						gtao_quality = 1,
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						ao_enabled = true,
						cacao_enabled = false,
						gtao_enabled = true,
						gtao_quality = 2,
					},
				},
			},
			{
				display_name = "loc_settings_menu_extreme",
				id = "extreme",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						ao_enabled = true,
						cacao_enabled = false,
						gtao_enabled = true,
						gtao_quality = 3,
					},
				},
			},
		},
	},
	{
		display_name = "loc_setting_light_quality",
		id = "light_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_light_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_low",
				id = "low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_max_static_shadow_distance = 100,
						local_lights_shadow_map_filter_quality = "low",
						local_lights_shadows_enabled = true,
						static_sun_shadows = true,
						sun_shadow_map_filter_quality = "low",
						sun_shadows = false,
						sun_shadow_map_size = {
							4,
							4,
						},
						static_sun_shadow_map_size = {
							2048,
							2048,
						},
						local_lights_shadow_atlas_size = {
							512,
							512,
						},
					},
				},
			},
			{
				display_name = "loc_settings_menu_medium",
				id = "medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_max_static_shadow_distance = 100,
						local_lights_shadow_map_filter_quality = "low",
						local_lights_shadows_enabled = true,
						static_sun_shadows = true,
						sun_shadow_map_filter_quality = "medium",
						sun_shadows = true,
						sun_shadow_map_size = {
							2048,
							2048,
						},
						static_sun_shadow_map_size = {
							2048,
							2048,
						},
						local_lights_shadow_atlas_size = {
							1024,
							1024,
						},
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_max_static_shadow_distance = 100,
						local_lights_shadow_map_filter_quality = "high",
						local_lights_shadows_enabled = true,
						static_sun_shadows = true,
						sun_shadow_map_filter_quality = "high",
						sun_shadows = true,
						sun_shadow_map_size = {
							2048,
							2048,
						},
						static_sun_shadow_map_size = {
							2048,
							2048,
						},
						local_lights_shadow_atlas_size = {
							2048,
							2048,
						},
					},
				},
			},
			{
				display_name = "loc_settings_menu_extreme",
				id = "extreme",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_max_static_shadow_distance = 100,
						local_lights_shadow_map_filter_quality = "high",
						local_lights_shadows_enabled = true,
						static_sun_shadows = true,
						sun_shadow_map_filter_quality = "high",
						sun_shadows = true,
						sun_shadow_map_size = {
							2048,
							2048,
						},
						static_sun_shadow_map_size = {
							2048,
							2048,
						},
						local_lights_shadow_atlas_size = {
							4096,
							4096,
						},
					},
				},
			},
		},
	},
	{
		display_name = "loc_setting_volumetric_fog_quality",
		id = "volumetric_fog_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_volumetric_fog_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_low",
				id = "low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						light_shafts_enabled = false,
						volumetric_extrapolation_high_quality = false,
						volumetric_extrapolation_volumetric_shadows = false,
						volumetric_lighting_local_lights = false,
						volumetric_reprojection_amount = 0.875,
						volumetric_volumes_enabled = true,
						volumetric_data_size = {
							80,
							64,
							96,
						},
					},
				},
			},
			{
				display_name = "loc_settings_menu_medium",
				id = "medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						light_shafts_enabled = true,
						volumetric_extrapolation_high_quality = true,
						volumetric_extrapolation_volumetric_shadows = false,
						volumetric_lighting_local_lights = true,
						volumetric_reprojection_amount = 0.625,
						volumetric_volumes_enabled = true,
						volumetric_data_size = {
							96,
							80,
							128,
						},
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						light_shafts_enabled = true,
						volumetric_extrapolation_high_quality = true,
						volumetric_extrapolation_volumetric_shadows = false,
						volumetric_lighting_local_lights = true,
						volumetric_reprojection_amount = 0,
						volumetric_volumes_enabled = true,
						volumetric_data_size = {
							128,
							96,
							160,
						},
					},
				},
			},
			{
				display_name = "loc_settings_menu_extreme",
				id = "extreme",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						light_shafts_enabled = true,
						volumetric_extrapolation_high_quality = true,
						volumetric_extrapolation_volumetric_shadows = true,
						volumetric_lighting_local_lights = true,
						volumetric_reprojection_amount = -0.875,
						volumetric_volumes_enabled = true,
						volumetric_data_size = {
							144,
							112,
							196,
						},
					},
				},
			},
		},
	},
	{
		display_name = "loc_setting_dof_quality",
		id = "dof_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_dof_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = "off",
				require_apply = false,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						dof_enabled = false,
						dof_high_quality = false,
					},
				},
			},
			{
				display_name = "loc_settings_menu_medium",
				id = "medium",
				require_apply = false,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						dof_enabled = true,
						dof_high_quality = false,
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = false,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						dof_enabled = true,
						dof_high_quality = true,
					},
				},
			},
		},
	},
	{
		display_name = "loc_setting_gi_quality",
		id = "gi_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_gi_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_low",
				id = "low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						rtxgi_scale = 0.5,
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						rtxgi_scale = 1,
					},
				},
			},
		},
	},
	{
		display_name = "loc_setting_bloom_enabled",
		id = "bloom_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		tooltip_text = "loc_setting_bloom_enabled_mouseover",
		value_type = "boolean",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
	},
	{
		display_name = "loc_setting_skin_material_enabled",
		id = "skin_material_enabled",
		require_apply = true,
		require_restart = false,
		save_location = "render_settings",
		tooltip_text = "loc_setting_skin_material_enabled_mouseover",
		value_type = "boolean",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
	},
	{
		display_name = "loc_setting_motion_blur_enabled",
		id = "motion_blur_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		tooltip_text = "loc_setting_motion_blur_enabled_mouseover",
		value_type = "boolean",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
		default_value = IS_XBS and true,
		supported_platforms = {
			win32 = true,
			xbs = true,
		},
	},
	{
		display_name = "loc_setting_ssr_quality",
		id = "ssr_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_ssr_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = "off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						ssr_enabled = false,
						ssr_high_quality = false,
					},
				},
			},
			{
				display_name = "loc_settings_menu_medium",
				id = "medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					master_render_settings = {},
					render_settings = {
						ssr_enabled = true,
						ssr_high_quality = false,
					},
				},
			},
			{
				display_name = "loc_settings_menu_high",
				id = "high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					master_render_settings = {},
					render_settings = {
						ssr_enabled = true,
						ssr_high_quality = true,
					},
				},
			},
		},
	},
	{
		display_name = "loc_setting_lens_quality_enabled",
		id = "lens_quality_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		tooltip_text = "loc_setting_lens_quality_enabled_mouseover",
		value_type = "boolean",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
		disable_rules = {
			{
				disable_value = false,
				id = "lens_quality_color_fringe_enabled",
				reason = "loc_disable_rule_lens_quality_fringe",
				validation_function = function (value)
					return value == false
				end,
			},
			{
				disable_value = false,
				id = "lens_quality_distortion_enabled",
				reason = "loc_disable_rule_lens_quality_distortion",
				validation_function = function (value)
					return value == false
				end,
			},
		},
	},
	{
		display_name = "loc_setting_lens_quality_color_fringe_enabled",
		id = "lens_quality_color_fringe_enabled",
		indentation_level = 1,
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		tooltip_text = "loc_setting_lens_quality_color_fringe_enabled_mouseover",
		value_type = "boolean",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
	},
	{
		display_name = "loc_setting_lens_quality_distortion_enabled",
		id = "lens_quality_distortion_enabled",
		indentation_level = 1,
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		tooltip_text = "loc_setting_lens_quality_distortion_enabled_mouseover",
		value_type = "boolean",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
	},
	{
		display_name = "loc_setting_lens_flare_quality",
		id = "lens_flare_quality",
		save_location = "master_render_settings",
		tooltip_text = "loc_setting_lens_flare_quality_mouseover",
		options = {
			{
				display_name = "loc_settings_menu_off",
				id = "off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						lens_flares_enabled = false,
						sun_flare_enabled = false,
					},
				},
			},
			{
				display_name = "loc_setting_lens_flare_quality_setting_sun_light_only",
				id = "sun_light_only",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						lens_flares_enabled = false,
						sun_flare_enabled = true,
					},
				},
			},
			{
				display_name = "loc_setting_lens_flare_quality_setting_all_lights",
				id = "all_lights",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom",
				},
				values = {
					render_settings = {
						lens_flares_enabled = true,
						sun_flare_enabled = true,
					},
				},
			},
		},
	},
	{
		display_name = "loc_setting_lod_scatter_density",
		id = "lod_scatter_density",
		max = 1,
		min = 0,
		num_decimals = 2,
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		step_size = 0.01,
		tooltip_text = "loc_setting_lod_scatter_density_mouseover",
		value_type = "number",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
	},
	{
		display_name = "loc_setting_lod_max_ragdolls",
		id = "max_ragdolls",
		max = 50,
		min = 3,
		num_decimals = 0,
		require_apply = false,
		require_restart = false,
		save_location = "performance_settings",
		step_size = 1,
		tooltip_text = "loc_setting_lod_max_ragdolls_mouseover",
		value_type = "number",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
		default_value = DefaultGameParameters.default_max_ragdolls,
	},
	{
		display_name = "loc_setting_max_impact_decals",
		id = "max_impact_decals",
		max = 100,
		min = 5,
		num_decimals = 0,
		require_apply = false,
		require_restart = false,
		save_location = "performance_settings",
		step_size = 1,
		tooltip_text = "loc_setting_max_impact_decals_mouseover",
		value_type = "number",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
		default_value = DefaultGameParameters.default_max_impact_decals,
	},
	{
		display_name = "loc_setting_max_blood_decals",
		id = "max_blood_decals",
		max = 100,
		min = 5,
		num_decimals = 0,
		require_apply = false,
		require_restart = false,
		save_location = "performance_settings",
		step_size = 1,
		tooltip_text = "loc_setting_max_blood_decals_mouseover",
		value_type = "number",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
		default_value = DefaultGameParameters.default_max_blood_decals,
	},
	{
		display_name = "loc_setting_decal_lifetime",
		id = "decal_lifetime",
		max = 60,
		min = 10,
		num_decimals = 0,
		require_apply = false,
		require_restart = false,
		save_location = "performance_settings",
		step_size = 1,
		tooltip_text = "loc_setting_decal_lifetime_mouseover",
		value_type = "number",
		apply_values_on_edited = {
			graphics_quality = "custom",
		},
		default_value = DefaultGameParameters.default_decal_lifetime,
	},
	{
		display_name = "loc_settings_menu_group_gore",
		group_name = "gore",
		widget_type = "group_header",
	},
	{
		default_value = true,
		display_name = "loc_blood_decals_enabled",
		id = "blood_decals_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "gore_settings",
		tooltip_text = "loc_blood_decals_enabled_mouseover",
		value_type = "boolean",
	},
	{
		default_value = true,
		display_name = "loc_gibbing_enabled",
		id = "gibbing_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "gore_settings",
		tooltip_text = "loc_gibbing_enabled_mouseover",
		value_type = "boolean",
	},
	{
		default_value = true,
		display_name = "loc_minion_wounds_enabled",
		id = "minion_wounds_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "gore_settings",
		tooltip_text = "loc_minion_wounds_enabled_mouseover",
		value_type = "boolean",
	},
	{
		default_value = true,
		display_name = "loc_attack_ragdolls_enabled",
		id = "attack_ragdolls_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "gore_settings",
		tooltip_text = "loc_attack_ragdolls_enabled_mouseover",
		value_type = "boolean",
	},
}
local default_supported_platforms = {
	win32 = true,
}

for _, template in ipairs(RENDER_TEMPLATES) do
	template.supported_platforms = template.supported_platforms or default_supported_platforms
end

local function create_render_settings_entry(template)
	local entry
	local id = template.id
	local display_name = template.display_name
	local indentation_level = template.indentation_level
	local tooltip_text = template.tooltip_text
	local value_type = template.value_type
	local default_value = template.default_value
	local get_function = template.get_function
	local on_changed = template.on_changed
	local default_value_type = value_type or default_value ~= nil and type(default_value) or nil
	local options = template.options
	local save_location = template.save_location

	if options then
		entry = {
			options = options,
			display_name = display_name,
			on_activated = function (value, template)
				SettingsUtilities.verify_and_apply_changes(template, value)
			end,
			on_changed = on_changed or function (value, template)
				local option

				for i = 1, #options do
					if options[i].id == value then
						option = options[i]

						break
					end
				end

				if option == nil then
					if default_value then
						for i = 1, #options do
							if options[i].id == default_value then
								option = options[i]

								break
							end
						end
					else
						option = options[1]
					end
				end

				local dirty = false
				local current_value = template.get_function(template)

				if not SettingsUtilities.is_same(current_value, value) then
					SettingsUtilities.set_user_setting(template.save_location, template.id, value)

					if template.changed_callback then
						template.changed_callback(value)
					end

					dirty = true
				end

				return dirty, option.require_apply
			end,
			get_function = get_function or function (template)
				local old_value = SettingsUtilities.get_user_setting(template.save_location, template.id)

				if old_value == nil then
					return default_value
				else
					return old_value
				end
			end,
		}
	elseif default_value_type == "number" then
		local function change_function(value, template)
			local dirty = false
			local current_value = template.get_function(template)

			if not SettingsUtilities.is_same(current_value, value) then
				dirty = true
			end

			if dirty then
				SettingsUtilities.set_user_setting(template.save_location, template.id, value)

				if template.require_apply then
					SettingsUtilities.apply_user_settings()
				end

				SettingsUtilities.save_user_settings()
			end
		end

		local get_function = get_function or function (template)
			return SettingsUtilities.get_user_setting(template.save_location, template.id) or default_value
		end
		local slider_params = {
			display_name = display_name,
			min_value = template.min,
			max_value = template.max,
			default_value = template.default_value,
			step_size_value = template.step_size,
			num_decimals = template.num_decimals,
			value_get_function = get_function,
			on_value_changed_function = change_function,
		}

		entry = OptionsUtilities.create_value_slider_template(slider_params)

		entry.on_activated = function (value, template)
			SettingsUtilities.verify_and_apply_changes(template, value)
		end

		entry.type = "slider"
	elseif default_value_type == "boolean" then
		entry = {
			display_name = display_name,
			on_activated = function (value, template)
				SettingsUtilities.verify_and_apply_changes(template, value)
			end,
			on_changed = on_changed or function (value, template)
				local dirty = false
				local current_value = template.get_function(template)

				if current_value == nil then
					current_value = template.default_value
				end

				if not SettingsUtilities.is_same(current_value, value) then
					SettingsUtilities.set_user_setting(template.save_location, template.id, value)

					dirty = true
				end

				return dirty, template.require_apply
			end,
			get_function = get_function or function (template)
				local old_value = SettingsUtilities.get_user_setting(template.save_location, template.id)

				if old_value == nil then
					return default_value
				else
					return old_value
				end
			end,
		}
	elseif template.widget_type then
		return template
	end

	entry.apply_on_startup = template.apply_on_startup
	entry.validation_function = template.validation_function
	entry.default_value = template.default_value
	entry.indentation_level = indentation_level
	entry.tooltip_text = tooltip_text
	entry.disable_rules = template.disable_rules
	entry.save_location = save_location
	entry.apply_values_on_edited = template.apply_values_on_edited
	entry.startup_prio = template.startup_prio
	entry.require_apply = template.require_apply
	entry.id = id

	return entry
end

render_settings[#render_settings + 1] = {
	display_name = "loc_settings_menu_group_display",
	group_name = "display",
	widget_type = "group_header",
}

local resolution_undefined_return_value = 0
local resolution_custom_return_value = -1

local function generate_resolution_options()
	if not IS_WINDOWS then
		return
	end

	local num_adapters = DisplayAdapter.num_adapters()

	if num_adapters and num_adapters > 0 then
		local output_screen = Application.user_setting("fullscreen_output") + 1
		local adapter_index = Application.user_setting("adapter_index") + 1

		if DisplayAdapter.num_outputs(adapter_index) < 1 then
			local found_valid_adapter = false

			for i = 1, num_adapters do
				if DisplayAdapter.num_outputs(i) > 0 then
					found_valid_adapter = true
					adapter_index = i

					break
				end
			end

			if not found_valid_adapter then
				return {
					display_name = "n/a",
				}
			end
		end

		local options = {}
		local num_modes = DisplayAdapter.num_modes(adapter_index, output_screen)

		for i = 1, num_modes do
			local width, height = DisplayAdapter.mode(adapter_index, output_screen, i)

			if width >= DefaultGameParameters.lowest_resolution then
				local index = #options + 1

				options[index] = {
					ignore_localization = true,
					id = index,
					display_name = tostring(width) .. " x " .. tostring(height),
					adapter_index = adapter_index,
					output_screen = output_screen,
					width = width,
					height = height,
				}
			end
		end

		if #options > 0 then
			options[resolution_undefined_return_value] = {
				display_name = "loc_setting_resolution_undefined",
				height = 0,
				width = 0,
				id = resolution_undefined_return_value,
				adapter_index = adapter_index,
				output_screen = output_screen,
			}
			options[resolution_custom_return_value] = {
				display_name = "",
				height = 0,
				ignore_localization = true,
				loc_display_name = "loc_setting_resolution_custom",
				width = 0,
				id = resolution_custom_return_value,
				adapter_index = adapter_index,
				output_screen = output_screen,
			}
		end

		return options
	end
end

local function _vfov_to_hfov(vfov)
	local width, height = RESOLUTION_LOOKUP.width, RESOLUTION_LOOKUP.height
	local aspect_ratio = width / height
	local hfov = math.round(2 * math.deg(math.atan(math.tan(math.rad(vfov) / 2) * aspect_ratio)))

	return hfov
end

local _fov_format_params = {}
local min_value = IS_XBS and DefaultGameParameters.min_console_vertical_fov or DefaultGameParameters.min_vertical_fov
local max_value = IS_XBS and DefaultGameParameters.max_console_vertical_fov or DefaultGameParameters.max_vertical_fov
local default_value = DefaultGameParameters.vertical_fov

render_settings[#render_settings + 1] = {
	apply_on_drag = false,
	apply_on_startup = false,
	display_name = "loc_settings_gameplay_fov",
	focusable = true,
	id = "gameplay_fov",
	mark_default_value = true,
	num_decimals = 0,
	step_size_value = 1,
	tooltip_text = "loc_settings_gameplay_fov_mouseover",
	widget_type = "value_slider",
	default_value = default_value,
	min_value = min_value,
	max_value = max_value,
	on_activated = function (value, template)
		SettingsUtilities.verify_and_apply_changes(template, value)
	end,
	on_changed = function (value, template)
		Application.set_user_setting("render_settings", "vertical_fov", value)

		local camera_manager = rawget(_G, "Managers") and Managers.state.camera

		if camera_manager then
			local fov_multiplier = value / template.default_value

			camera_manager:set_fov_multiplier(fov_multiplier)
		end

		if template.changed_callback then
			template.changed_callback(value)
		end

		return true, template.require_apply
	end,
	get_function = function (template)
		local vertical_fov = Application.user_setting("render_settings", "vertical_fov") or DefaultGameParameters.vertical_fov

		return vertical_fov
	end,
	format_value_function = function (value)
		local number_format = string.format("%%.%sf", 2)

		return string.format(number_format, value)
	end,
	explode_function = function (normalized_value, template)
		local value_range = template.max_value - template.min_value
		local exploded_value = template.min_value + normalized_value * value_range
		local step_size = template.step_size_value or 1

		exploded_value = math.round(exploded_value / step_size) * step_size

		return exploded_value
	end,
	format_value_function = function (vfov)
		local format_params = _fov_format_params

		format_params.hfov = _vfov_to_hfov(vfov)
		format_params.vfov = vfov

		return Localize("loc_settings_gameplay_fov_presentation_format", true, format_params)
	end,
}

local resolution_options = generate_resolution_options()

render_settings[#render_settings + 1] = {
	display_name = "loc_setting_resolution",
	id = "resolution",
	require_apply = true,
	tooltip_text = "loc_setting_resolution_mouseover",
	options = resolution_options,
	validation_function = function ()
		return IS_WINDOWS and DisplayAdapter.num_adapters() > 0
	end,
	on_activated = function (value, template)
		SettingsUtilities.verify_and_apply_changes(template, value)
	end,
	on_changed = function (value, template)
		if value == resolution_undefined_return_value or value == resolution_custom_return_value then
			return
		end

		local option = resolution_options[value]
		local output_screen = option.output_screen
		local adapter_index = option.adapter_index
		local width = option.width
		local height = option.height
		local resolution = {
			width,
			height,
		}

		Application.set_user_setting("adapter_index", adapter_index - 1)
		Application.set_user_setting("fullscreen_output", output_screen - 1)
		Application.set_user_setting("screen_resolution", resolution)

		if template.changed_callback then
			template.changed_callback(value)
		end

		return true, template.require_apply
	end,
	get_function = function (template)
		local resolution_width, resolution_height

		if not Application.user_setting("fullscreen") and Application.back_buffer_size then
			local window_width, window_height = Application.back_buffer_size()

			resolution_width = window_width
			resolution_height = window_height
		else
			local resolution = Application.user_setting("screen_resolution")

			resolution_width = resolution and resolution[1]
			resolution_height = resolution and resolution[2]
		end

		if resolution_options and #resolution_options > 0 then
			for i = 1, #resolution_options do
				local option = resolution_options[i]

				if option.width == resolution_width and option.height == resolution_height then
					return i
				end
			end

			if Application.back_buffer_size then
				local option = resolution_options[resolution_custom_return_value]

				if option and (option.width ~= resolution_width or option.height ~= resolution_height) then
					option.width = resolution_width
					option.height = resolution_height
					option.display_name = string.format("%s (%d x %d)", Localize(option.loc_display_name), resolution_width, resolution_height)
				end

				return resolution_custom_return_value
			end

			return 1
		end

		return resolution_undefined_return_value
	end,
}

if IS_XBS and Xbox.console_type() == Xbox.CONSOLE_TYPE_XBOX_SCARLETT_ANACONDA then
	render_settings[#render_settings + 1] = {
		apply_on_startup = true,
		default_value = "performance",
		display_name = "loc_setting_xbs_quality_preset",
		id = "xbox_quality_preset",
		require_apply = true,
		tooltip_text = "loc_setting_xbs_quality_preset_mouseover",
		options = {
			{
				display_name = "loc_setting_xbs_quality_preset_performance",
				id = "performance",
				data = {
					height = 1440,
					target_fps = 60,
					width = 2560,
				},
			},
			{
				display_name = "loc_setting_xbs_quality_preset_quality",
				id = "quality",
				data = {
					height = 2160,
					target_fps = 40,
					width = 3840,
				},
			},
		},
		on_activated = function (value, template)
			SettingsUtilities.verify_and_apply_changes(template, value)
		end,
		on_changed = function (value, template)
			local options = template.options
			local index = table.index_of_condition(options, function (option)
				return option.id == value
			end)
			local option = options[index]

			if not option then
				return
			end

			local target_fps = option.data.target_fps

			Application.set_target_frame_rate(target_fps)

			local width = option.data.width
			local height = option.data.height

			Application.set_resolution(width, height)
			Application.set_user_setting("render_settings", "xbox_quality_preset", value)

			if template.changed_callback then
				template.changed_callback(value)
			end

			return true, template.require_apply
		end,
		get_function = function (template)
			local xbox_quality_preset = Application.user_setting("render_settings", "xbox_quality_preset") or "performance"

			return xbox_quality_preset
		end,
	}
end

local screen_mode_setting = {
	apply_on_startup = true,
	default_value = "window",
	display_name = "loc_setting_screen_mode",
	id = "screen_mode",
	tooltip_text = "loc_setting_screen_mode_mouseover",
	validation_function = function ()
		return IS_WINDOWS and DisplayAdapter.num_adapters() > 0
	end,
	get_function = function (template)
		local user_screen_mode = Application.user_setting("screen_mode")
		local screen_mode = user_screen_mode
		local is_fullscreen = Application.is_fullscreen and Application.is_fullscreen()
		local fullscreen

		if is_fullscreen ~= nil then
			fullscreen = is_fullscreen
		else
			fullscreen = Application.user_setting("fullscreen")
		end

		local borderless_fullscreen = Application.user_setting("borderless_fullscreen")

		if borderless_fullscreen then
			screen_mode = "borderless_fullscreen"
		elseif fullscreen then
			screen_mode = "fullscreen"
		elseif not borderless_fullscreen and not fullscreen then
			screen_mode = "window"
		end

		if screen_mode ~= user_screen_mode then
			template.on_activated(screen_mode, template)
		end

		return screen_mode or template.default_value
	end,
	on_changed = function (value, template)
		local dirty = false
		local options = template.options
		local option

		for i = 1, #options do
			if options[i].id == value then
				option = options[i]

				break
			end
		end

		if option == nil then
			if default_value then
				for i = 1, #options do
					if options[i].id == default_value then
						option = options[i]

						break
					end
				end
			else
				option = options[1]
			end
		end

		local current_value = Application.user_setting(template.id)

		if not SettingsUtilities.is_same(current_value, value) then
			SettingsUtilities.set_user_setting(template.save_location, template.id, value)

			if template.changed_callback then
				template.changed_callback(value)
			end

			dirty = true
		end

		local require_apply = option and option.require_apply

		return dirty, require_apply
	end,
	options = {
		{
			display_name = "loc_setting_screen_mode_window",
			id = "window",
			require_apply = true,
			require_restart = false,
			values = {
				borderless_fullscreen = false,
				fullscreen = false,
			},
		},
		{
			display_name = "loc_setting_screen_mode_borderless_fullscreen",
			id = "borderless_fullscreen",
			require_apply = true,
			require_restart = false,
			values = {
				borderless_fullscreen = true,
				fullscreen = false,
			},
		},
		{
			display_name = "loc_setting_screen_mode_fullscreen",
			id = "fullscreen",
			require_apply = true,
			require_restart = false,
			values = {
				borderless_fullscreen = false,
				fullscreen = true,
			},
		},
	},
	disable_rules = {
		{
			disable_value = 0,
			id = "resolution",
			reason = "loc_disable_rule_borderless_window",
			validation_function = function (value)
				return value == "borderless_fullscreen"
			end,
		},
	},
}

render_settings[#render_settings + 1] = create_render_settings_entry(screen_mode_setting)

local platform = PLATFORM

for i = 1, #RENDER_TEMPLATES do
	local template = RENDER_TEMPLATES[i]

	if template.supported_platforms[platform] then
		render_settings[#render_settings + 1] = create_render_settings_entry(template)
	end
end

SettingsUtilities = SettingsUtilitiesFunction(render_settings)

local function reset_function()
	local settings_to_run = {}

	for i = 1, #render_settings do
		local setting = render_settings[i]
		local is_valid

		if setting.validation_function then
			is_valid = setting.validation_function()
		else
			is_valid = true
		end

		if setting.default_value and setting.on_activated and is_valid then
			settings_to_run[#settings_to_run + 1] = setting
		end
	end

	local function sort_function(setting_a, setting_b)
		local prio_a = setting_a.startup_prio or math.huge
		local prio_b = setting_b.startup_prio or math.huge

		return prio_a < prio_b
	end

	table.sort(settings_to_run, sort_function)

	for i = 1, #settings_to_run do
		local setting = settings_to_run[i]
		local default_value = setting.default_value

		setting.on_activated(default_value, setting)
	end

	Application.set_user_setting("gamma", 0)
	SettingsUtilities.apply_user_settings()
	SettingsUtilities.save_user_settings()
end

return {
	display_name = "loc_settings_menu_category_render",
	icon = "content/ui/materials/icons/system/settings/category_video",
	reset_function = reset_function,
	settings_utilities = SettingsUtilities,
	settings_by_id = SettingsUtilities.settings_by_id,
	settings = render_settings,
	can_be_reset = IS_XBS,
}
