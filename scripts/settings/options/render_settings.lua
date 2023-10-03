local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local OptionsUtilities = require("scripts/utilities/ui/options")
local SettingsUtilitiesFunction = require("scripts/settings/options/settings_utils")
local render_settings = {}
local SettingsUtilities = {}
local RENDER_TEMPLATES = {
	{
		require_restart = false,
		require_apply = true,
		display_name = "loc_vsync",
		tooltip_text = "loc_vsync_mouseover",
		id = "vsync",
		value_type = "boolean",
		default_value = false
	},
	{
		save_location = "master_render_settings",
		display_name = "loc_setting_brightness",
		id = "brightness",
		tooltip_text = "loc_setting_brightness_mouseover",
		widget_type = "button",
		supported_platforms = {
			win32 = true,
			xbs = true
		},
		pressed_function = function (parent, widget, template)
			local pages_templates = require("scripts/ui/views/custom_settings_view/custom_settings_view_pages")

			Managers.ui:open_view("custom_settings_view", nil, nil, nil, nil, {
				pages = pages_templates.brightness_render_option_settings
			})
		end
	},
	{
		group_name = "performance",
		display_name = "loc_settings_menu_group_performance",
		widget_type = "group_header"
	},
	{
		default_value = "off",
		display_name = "loc_setting_nvidia_dlss",
		id = "dlss_master",
		tooltip_text = "loc_setting_nvidia_dlss_mouseover",
		save_location = "master_render_settings",
		validation_function = function ()
			return Application.render_caps("dlss_supported")
		end,
		options = {
			{
				id = "off",
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						dlss_g = 0,
						dlss = 0
					}
				}
			},
			{
				id = "on",
				display_name = "loc_settings_menu_on",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						dlss_g = 1,
						nv_reflex_low_latency = 1,
						dlss = 1
					}
				}
			}
		}
	},
	{
		id = "dlss",
		display_name = "loc_setting_dlss",
		require_apply = true,
		default_value = 0,
		apply_on_startup = true,
		indentation_level = 1,
		tooltip_text = "loc_setting_dlss_mouseover",
		save_location = "master_render_settings",
		validation_function = function ()
			return Application.render_caps("dlss_supported")
		end,
		options = {
			{
				id = 0,
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_enabled = false
					}
				}
			},
			{
				id = 1,
				display_name = "loc_setting_dlss_quality_auto",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "auto",
						dlss_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						fsr2 = 0
					}
				}
			},
			{
				id = 2,
				display_name = "loc_setting_dlss_quality_ultra_performance",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "ultra_performance",
						dlss_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						fsr2 = 0
					}
				}
			},
			{
				id = 3,
				display_name = "loc_setting_dlss_quality_max_performance",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "performance",
						dlss_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						fsr2 = 0
					}
				}
			},
			{
				id = 4,
				display_name = "loc_setting_dlss_quality_balanced",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "balanced",
						dlss_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						fsr2 = 0
					}
				}
			},
			{
				id = 5,
				display_name = "loc_setting_dlss_quality_max_quality",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "quality",
						dlss_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						fsr2 = 0
					}
				}
			}
		},
		disable_rules = {
			{
				id = "anti_aliasing_solution",
				reason = "loc_disable_rule_dlss_aa",
				disable_value = 0,
				validation_function = function (value)
					return value > 0
				end
			}
		}
	},
	{
		require_apply = true,
		display_name = "loc_setting_dlss_g",
		indentation_level = 1,
		default_value = 0,
		apply_on_startup = true,
		id = "dlss_g",
		tooltip_text = "loc_setting_dlss_g_mouseover",
		save_location = "master_render_settings",
		validation_function = function ()
			return Application.render_caps("dlss_g_supported")
		end,
		options = {
			{
				id = 0,
				display_name = "loc_rt_setting_off",
				require_apply = false,
				require_restart = false,
				values = {
					render_settings = {
						dlss_g_enabled = false
					}
				}
			},
			{
				id = 1,
				display_name = "loc_rt_setting_on",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dlss_g_enabled = true
					},
					master_render_settings = {
						vsync = false,
						nv_reflex_low_latency = 1
					}
				}
			}
		},
		disable_rules = {
			{
				id = "vsync",
				reason = "loc_disable_rule_dlss_g_vsync",
				disable_value = false,
				validation_function = function (value)
					return value == 1
				end
			},
			{
				id = "nv_reflex_low_latency",
				reason = "loc_disable_rule_dlss_g_reflex",
				disable_value = 1,
				validation_function = function (value)
					return value == 1
				end
			}
		}
	},
	{
		id = "nv_reflex_low_latency",
		indentation_level = 1,
		display_name = "loc_setting_nv_reflex",
		default_value = 1,
		apply_on_startup = true,
		require_apply = true,
		tooltip_text = "loc_setting_nv_reflex_mouseover",
		save_location = "master_render_settings",
		validation_function = function ()
			return Application.render_caps("reflex_supported")
		end,
		options = {
			{
				id = 0,
				display_name = "loc_setting_nv_reflex_disabled",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_low_latency_mode = false,
						nv_low_latency_boost = false
					}
				}
			},
			{
				id = 1,
				display_name = "loc_setting_nv_reflex_low_latency_enabled",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_low_latency_mode = true,
						nv_low_latency_boost = false
					}
				}
			},
			{
				id = 2,
				display_name = "loc_setting_nv_reflex_low_latency_boost",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_low_latency_mode = true,
						nv_low_latency_boost = true
					}
				}
			}
		}
	},
	{
		default_value = 0,
		require_apply = true,
		display_name = "loc_setting_framerate_cap",
		id = "nv_reflex_framerate_cap",
		tooltip_text = "loc_setting_framerate_cap_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = 0,
				display_name = "loc_setting_nv_reflex_framerate_cap_unlimited",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 0
					}
				}
			},
			{
				id = 1,
				display_name = "loc_setting_nv_reflex_framerate_cap_30",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 30
					}
				}
			},
			{
				id = 2,
				display_name = "loc_setting_nv_reflex_framerate_cap_60",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 60
					}
				}
			},
			{
				id = 3,
				display_name = "loc_setting_nv_reflex_framerate_cap_120",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						nv_framerate_cap = 120
					}
				}
			}
		}
	},
	{
		id = "fsr2",
		display_name = "loc_setting_fsr2",
		require_apply = true,
		default_value = 0,
		apply_on_startup = true,
		tooltip_text = "loc_setting_fsr2_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = 0,
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr2_enabled = false
					}
				}
			},
			{
				id = 1,
				display_name = "loc_setting_dlss_quality_ultra_performance",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "ultra_performance",
						fsr2_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						dlss = 0
					}
				}
			},
			{
				id = 2,
				display_name = "loc_setting_dlss_quality_max_performance",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "performance",
						fsr2_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						dlss = 0
					}
				}
			},
			{
				id = 3,
				display_name = "loc_setting_dlss_quality_balanced",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "balanced",
						fsr2_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						dlss = 0
					}
				}
			},
			{
				id = 4,
				display_name = "loc_setting_dlss_quality_max_quality",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "quality",
						fsr2_enabled = true
					},
					master_render_settings = {
						xess = 0,
						fsr = 0,
						dlss = 0
					}
				}
			}
		},
		disable_rules = {
			{
				id = "anti_aliasing_solution",
				reason = "loc_disable_rule_fsr_aa",
				disable_value = 0,
				validation_function = function (value)
					return value > 0
				end
			}
		}
	},
	{
		id = "xess",
		display_name = "loc_setting_xess",
		require_apply = true,
		default_value = 0,
		apply_on_startup = true,
		tooltip_text = "loc_setting_xess_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = 0,
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						xess_enabled = false
					}
				}
			},
			{
				id = 1,
				display_name = "loc_setting_dlss_quality_max_performance",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "performance",
						xess_enabled = true
					},
					master_render_settings = {
						fsr2 = 0,
						fsr = 0,
						dlss = 0
					}
				}
			},
			{
				id = 2,
				display_name = "loc_setting_dlss_quality_balanced",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "balanced",
						xess_enabled = true
					},
					master_render_settings = {
						fsr2 = 0,
						fsr = 0,
						dlss = 0
					}
				}
			},
			{
				id = 3,
				display_name = "loc_setting_dlss_quality_max_quality",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "quality",
						xess_enabled = true
					},
					master_render_settings = {
						fsr2 = 0,
						fsr = 0,
						dlss = 0
					}
				}
			},
			{
				id = 4,
				display_name = "loc_setting_fsr_quality_ultra_quality",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						upscaling_quality = "ultra_quality",
						xess_enabled = true
					},
					master_render_settings = {
						fsr2 = 0,
						fsr = 0,
						dlss = 0
					}
				}
			}
		},
		disable_rules = {
			{
				id = "anti_aliasing_solution",
				reason = "loc_disable_rule_xess_aa",
				disable_value = 0,
				validation_function = function (value)
					return value > 0
				end
			}
		}
	},
	{
		id = "fsr",
		display_name = "loc_setting_fsr",
		require_apply = true,
		default_value = 0,
		apply_on_startup = true,
		tooltip_text = "loc_setting_fsr_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = 0,
				display_name = "loc_setting_fsr_quality_off",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = false,
						fsr_quality = 0
					}
				}
			},
			{
				id = 1,
				display_name = "loc_setting_fsr_quality_performance",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 1
					},
					master_render_settings = {
						dlss = 0,
						anti_aliasing_solution = 2,
						fsr2 = 0
					}
				}
			},
			{
				id = 2,
				display_name = "loc_setting_fsr_quality_balanced",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 2
					},
					master_render_settings = {
						dlss = 0,
						fsr2 = 0
					}
				}
			},
			{
				id = 3,
				display_name = "loc_setting_fsr_quality_quality",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 3
					},
					master_render_settings = {
						dlss = 0,
						fsr2 = 0
					}
				}
			},
			{
				id = 4,
				display_name = "loc_setting_fsr_quality_ultra_quality",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 4
					},
					master_render_settings = {
						dlss = 0,
						fsr2 = 0
					}
				}
			}
		},
		disable_rules = {
			{
				id = "anti_aliasing_solution",
				reason = "loc_disable_rule_fsr_aa",
				disable_value = 2,
				validation_function = function (value)
					return value > 0
				end
			}
		}
	},
	{
		id = "sharpen_enabled",
		value_type = "boolean",
		display_name = "loc_setting_sharpen_enabled",
		require_apply = false,
		require_restart = false,
		tooltip_text = "loc_setting_sharpen_enabled_mouseover",
		save_location = "render_settings"
	},
	{
		default_value = 0,
		require_apply = true,
		display_name = "loc_setting_anti_ailiasing",
		id = "anti_aliasing_solution",
		tooltip_text = "loc_setting_anti_ailiasing_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = 0,
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						taa_enabled = false,
						fxaa_enabled = false
					}
				}
			},
			{
				id = 1,
				display_name = "loc_setting_anti_ailiasing_fxaa",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						taa_enabled = false,
						fxaa_enabled = true
					}
				}
			},
			{
				id = 2,
				display_name = "loc_setting_anti_ailiasing_taa",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						taa_enabled = true,
						fxaa_enabled = false
					}
				}
			}
		}
	},
	{
		group_name = "ray_tracing",
		display_name = "loc_ray_tracing",
		widget_type = "group_header",
		validation_function = function ()
			return Application.render_caps("dxr")
		end
	},
	{
		id = "ray_tracing_quality",
		startup_prio = 2,
		display_name = "loc_setting_ray_tracing_quality",
		apply_on_startup = true,
		tooltip_text = "loc_setting_ray_tracing_quality_mouseover",
		save_location = "master_render_settings",
		default_value = DefaultGameParameters.default_ray_tracing_quality_quality,
		options = {
			{
				id = "off",
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dxr = false
					},
					master_render_settings = {
						rt_reflections_quality = "off",
						rtxgi_quality = "off"
					}
				}
			},
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dxr = true
					},
					master_render_settings = {
						rt_reflections_quality = "low",
						rtxgi_quality = "low"
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dxr = true
					},
					master_render_settings = {
						rt_reflections_quality = "low",
						rtxgi_quality = "medium"
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				values = {
					render_settings = {
						dxr = true
					},
					master_render_settings = {
						rt_reflections_quality = "high",
						rtxgi_quality = "high"
					}
				}
			},
			{
				id = "custom",
				display_name = "loc_setting_graphics_quality_option_custom"
			}
		},
		validation_function = function ()
			return Application.render_caps("dxr")
		end
	},
	{
		display_name = "loc_rt_reflections_quality",
		id = "rt_reflections_quality",
		tooltip_text = "loc_rt_reflections_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "off",
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					ray_tracing_quality = "custom"
				},
				values = {
					render_settings = {
						rt_checkerboard_reflections = false,
						rt_reflections_enabled = false,
						world_space_motion_vectors = false
					}
				}
			},
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					ray_tracing_quality = "custom"
				},
				values = {
					master_render_settings = {
						ssr_quality = "high"
					},
					render_settings = {
						rt_mixed_reflections = true,
						dxr = true,
						world_space_motion_vectors = true,
						rt_reflections_enabled = true,
						rt_checkerboard_reflections = true,
						ssr_enabled = true
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					ray_tracing_quality = "custom"
				},
				values = {
					master_render_settings = {
						ssr_quality = "off"
					},
					render_settings = {
						rt_mixed_reflections = false,
						dxr = true,
						rt_reflections_enabled = true,
						rt_checkerboard_reflections = true,
						world_space_motion_vectors = true
					}
				}
			}
		},
		validation_function = function ()
			return Application.render_caps("dxr")
		end,
		disable_rules = {
			{
				id = "ssr_quality",
				reason = "loc_disable_rule_rt_reflections_ssr",
				disable_value = "off",
				validation_function = function (value)
					return value == "high"
				end
			},
			{
				id = "ssr_quality",
				reason = "loc_disable_rule_rt_reflections_ssr",
				disable_value = "high",
				validation_function = function (value)
					return value == "low"
				end
			}
		}
	},
	{
		display_name = "loc_rtxgi_quality",
		default_value = "off",
		apply_on_startup = true,
		id = "rtxgi_quality",
		tooltip_text = "loc_rtxgi_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "off",
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					ray_tracing_quality = "custom"
				},
				values = {
					render_settings = {
						baked_ddgi = true,
						rtxgi_enabled = false
					}
				}
			},
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					ray_tracing_quality = "custom"
				},
				values = {
					render_settings = {
						baked_ddgi = true,
						rtxgi_enabled = true,
						dxr = true,
						rtxgi_scale = 0.5
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					ray_tracing_quality = "custom"
				},
				values = {
					render_settings = {
						baked_ddgi = false,
						rtxgi_enabled = true,
						dxr = true,
						rtxgi_scale = 0.5
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					ray_tracing_quality = "custom"
				},
				values = {
					render_settings = {
						baked_ddgi = false,
						rtxgi_enabled = true,
						dxr = true,
						rtxgi_scale = 1
					}
				}
			}
		},
		disable_rules = {
			{
				id = "gi_quality",
				reason = "loc_disable_rule_rtxgi_gi",
				disable_value = "high",
				validation_function = function (value)
					return value == "high"
				end
			},
			{
				id = "gi_quality",
				reason = "loc_disable_rule_rtxgi_gi",
				disable_value = "low",
				validation_function = function (value)
					return value == "low" or value == "medium"
				end
			}
		},
		validation_function = function ()
			return Application.render_caps("dxr")
		end
	},
	{
		group_name = "graphics",
		display_name = "loc_settings_menu_group_graphics_preset",
		widget_type = "group_header"
	},
	{
		apply_on_startup = true,
		display_name = "loc_setting_graphics_quality",
		startup_prio = 1,
		id = "graphics_quality",
		tooltip_text = "loc_setting_graphics_quality_mouseover",
		save_location = "master_render_settings",
		default_value = DefaultGameParameters.default_graphics_quality,
		options = {
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = false,
				values = {
					performance_settings = {
						max_blood_decals = 15,
						max_ragdolls = 5,
						max_impact_decals = 15,
						decal_lifetime = 10
					},
					master_render_settings = {
						ssr_quality = "off",
						lens_flare_quality = "off",
						dof_quality = "off",
						texture_quality = "low",
						volumetric_fog_quality = "low",
						gi_quality = "low",
						light_quality = "low",
						ambient_occlusion_quality = "low"
					},
					render_settings = {
						lens_quality_enabled = false,
						motion_blur_enabled = false,
						bloom_enabled = true,
						lod_scatter_density = 0.25,
						skin_material_enabled = false,
						rough_transparency_enabled = false,
						lod_object_multiplier = 0.7
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = true,
				require_restart = false,
				values = {
					performance_settings = {
						max_blood_decals = 30,
						max_ragdolls = 8,
						max_impact_decals = 30,
						decal_lifetime = 20
					},
					master_render_settings = {
						ssr_quality = "medium",
						lens_flare_quality = "sun_light_only",
						dof_quality = "medium",
						texture_quality = "medium",
						volumetric_fog_quality = "medium",
						gi_quality = "low",
						light_quality = "medium",
						ambient_occlusion_quality = "medium"
					},
					render_settings = {
						lens_quality_enabled = true,
						motion_blur_enabled = true,
						bloom_enabled = true,
						lod_scatter_density = 0.5,
						skin_material_enabled = false,
						rough_transparency_enabled = true,
						lod_object_multiplier = 1
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				values = {
					performance_settings = {
						max_blood_decals = 50,
						max_ragdolls = 12,
						max_impact_decals = 50,
						decal_lifetime = 40
					},
					master_render_settings = {
						ssr_quality = "high",
						lens_flare_quality = "all_lights",
						dof_quality = "high",
						texture_quality = "high",
						volumetric_fog_quality = "high",
						gi_quality = "high",
						light_quality = "high",
						ambient_occlusion_quality = "high"
					},
					render_settings = {
						lens_quality_enabled = true,
						motion_blur_enabled = true,
						bloom_enabled = true,
						lod_scatter_density = 1,
						skin_material_enabled = true,
						rough_transparency_enabled = true,
						lod_object_multiplier = 2
					}
				}
			},
			{
				id = "custom",
				display_name = "loc_setting_graphics_quality_option_custom"
			}
		}
	},
	{
		group_name = "render_settings",
		display_name = "loc_settings_menu_group_graphics_advanced",
		widget_type = "group_header"
	},
	{
		display_name = "loc_setting_texture_quality",
		id = "texture_quality",
		tooltip_text = "loc_setting_texture_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = true,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					texture_settings = {
						["content/texture_categories/character_nm"] = 2,
						["content/texture_categories/weapon_bc"] = 2,
						["content/texture_categories/weapon_bca"] = 2,
						["content/texture_categories/environment_bc"] = 2,
						["content/texture_categories/character_mask"] = 2,
						["content/texture_categories/character_orm"] = 2,
						["content/texture_categories/character_bc"] = 2,
						["content/texture_categories/environment_hm"] = 2,
						["content/texture_categories/character_mask2"] = 2,
						["content/texture_categories/environment_orm"] = 2,
						["content/texture_categories/character_bcm"] = 2,
						["content/texture_categories/character_bca"] = 2,
						["content/texture_categories/weapon_nm"] = 2,
						["content/texture_categories/environment_bca"] = 2,
						["content/texture_categories/environment_nm"] = 2,
						["content/texture_categories/character_hm"] = 2,
						["content/texture_categories/weapon_hm"] = 2,
						["content/texture_categories/weapon_mask"] = 2,
						["content/texture_categories/weapon_orm"] = 2
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = true,
				require_restart = true,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					texture_settings = {
						["content/texture_categories/character_nm"] = 1,
						["content/texture_categories/weapon_bc"] = 1,
						["content/texture_categories/weapon_bca"] = 1,
						["content/texture_categories/environment_bc"] = 1,
						["content/texture_categories/character_mask"] = 1,
						["content/texture_categories/character_orm"] = 1,
						["content/texture_categories/character_bc"] = 1,
						["content/texture_categories/environment_hm"] = 1,
						["content/texture_categories/character_mask2"] = 1,
						["content/texture_categories/environment_orm"] = 1,
						["content/texture_categories/character_bcm"] = 1,
						["content/texture_categories/character_bca"] = 1,
						["content/texture_categories/weapon_nm"] = 1,
						["content/texture_categories/environment_bca"] = 1,
						["content/texture_categories/environment_nm"] = 1,
						["content/texture_categories/character_hm"] = 1,
						["content/texture_categories/weapon_hm"] = 1,
						["content/texture_categories/weapon_mask"] = 1,
						["content/texture_categories/weapon_orm"] = 1
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = true,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					texture_settings = {
						["content/texture_categories/character_nm"] = 0,
						["content/texture_categories/weapon_bc"] = 0,
						["content/texture_categories/weapon_bca"] = 0,
						["content/texture_categories/environment_bc"] = 0,
						["content/texture_categories/character_mask"] = 0,
						["content/texture_categories/character_orm"] = 0,
						["content/texture_categories/character_bc"] = 0,
						["content/texture_categories/environment_hm"] = 0,
						["content/texture_categories/character_mask2"] = 0,
						["content/texture_categories/environment_orm"] = 0,
						["content/texture_categories/character_bcm"] = 0,
						["content/texture_categories/character_bca"] = 0,
						["content/texture_categories/weapon_nm"] = 0,
						["content/texture_categories/environment_bca"] = 0,
						["content/texture_categories/environment_nm"] = 0,
						["content/texture_categories/character_hm"] = 0,
						["content/texture_categories/weapon_hm"] = 0,
						["content/texture_categories/weapon_mask"] = 0,
						["content/texture_categories/weapon_orm"] = 0
					}
				}
			}
		}
	},
	{
		value_type = "number",
		id = "lod_object_multiplier",
		display_name = "loc_setting_lod_object_multiplier",
		num_decimals = 1,
		max = 5,
		require_restart = false,
		min = 0.5,
		step_size = 0.1,
		require_apply = true,
		tooltip_text = "loc_setting_lod_object_multiplier_mouseover",
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_lod_object_multiplier
	},
	{
		display_name = "loc_setting_ambient_occlusion_quality",
		id = "ambient_occlusion_quality",
		tooltip_text = "loc_setting_ambient_occlusion_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "off",
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						cacao_downsampled = false,
						cacao_quality = 0,
						ao_enabled = false
					}
				}
			},
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						cacao_downsampled = false,
						cacao_quality = 2,
						ao_enabled = true
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						cacao_downsampled = false,
						cacao_quality = 3,
						ao_enabled = true
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						cacao_downsampled = false,
						cacao_quality = 4,
						ao_enabled = true
					}
				}
			}
		}
	},
	{
		display_name = "loc_setting_light_quality",
		id = "light_quality",
		tooltip_text = "loc_setting_light_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						local_lights_shadow_map_filter_quality = "low",
						sun_shadows = false,
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_max_static_shadow_distance = 100,
						local_lights_shadows_enabled = true,
						sun_shadow_map_filter_quality = "low",
						static_sun_shadows = true,
						sun_shadow_map_size = {
							4,
							4
						},
						static_sun_shadow_map_size = {
							2048,
							2048
						},
						local_lights_shadow_atlas_size = {
							512,
							512
						}
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						local_lights_shadow_map_filter_quality = "low",
						sun_shadows = true,
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_max_static_shadow_distance = 100,
						local_lights_shadows_enabled = true,
						sun_shadow_map_filter_quality = "medium",
						static_sun_shadows = true,
						sun_shadow_map_size = {
							2048,
							2048
						},
						static_sun_shadow_map_size = {
							2048,
							2048
						},
						local_lights_shadow_atlas_size = {
							1024,
							1024
						}
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						local_lights_shadow_map_filter_quality = "high",
						sun_shadows = true,
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_max_static_shadow_distance = 100,
						local_lights_shadows_enabled = true,
						sun_shadow_map_filter_quality = "high",
						static_sun_shadows = true,
						sun_shadow_map_size = {
							2048,
							2048
						},
						static_sun_shadow_map_size = {
							2048,
							2048
						},
						local_lights_shadow_atlas_size = {
							2048,
							2048
						}
					}
				}
			},
			{
				id = "extreme",
				display_name = "loc_settings_menu_extreme",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						local_lights_shadow_map_filter_quality = "high",
						sun_shadows = true,
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_max_static_shadow_distance = 100,
						local_lights_shadows_enabled = true,
						sun_shadow_map_filter_quality = "high",
						static_sun_shadows = true,
						sun_shadow_map_size = {
							2048,
							2048
						},
						static_sun_shadow_map_size = {
							2048,
							2048
						},
						local_lights_shadow_atlas_size = {
							4096,
							4096
						}
					}
				}
			}
		}
	},
	{
		display_name = "loc_setting_volumetric_fog_quality",
		id = "volumetric_fog_quality",
		tooltip_text = "loc_setting_volumetric_fog_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						volumetric_extrapolation_volumetric_shadows = false,
						volumetric_extrapolation_high_quality = false,
						volumetric_volumes_enabled = true,
						volumetric_reprojection_amount = 0.875,
						light_shafts_enabled = false,
						volumetric_lighting_local_lights = false,
						volumetric_data_size = {
							80,
							64,
							96
						}
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						volumetric_extrapolation_volumetric_shadows = false,
						volumetric_extrapolation_high_quality = true,
						volumetric_volumes_enabled = true,
						volumetric_reprojection_amount = 0.625,
						light_shafts_enabled = true,
						volumetric_lighting_local_lights = true,
						volumetric_data_size = {
							96,
							80,
							128
						}
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						volumetric_extrapolation_volumetric_shadows = false,
						volumetric_extrapolation_high_quality = true,
						volumetric_volumes_enabled = true,
						volumetric_reprojection_amount = 0,
						light_shafts_enabled = true,
						volumetric_lighting_local_lights = true,
						volumetric_data_size = {
							128,
							96,
							160
						}
					}
				}
			},
			{
				id = "extreme",
				display_name = "loc_settings_menu_extreme",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						volumetric_extrapolation_volumetric_shadows = true,
						volumetric_extrapolation_high_quality = true,
						volumetric_volumes_enabled = true,
						volumetric_reprojection_amount = -0.875,
						light_shafts_enabled = true,
						volumetric_lighting_local_lights = true,
						volumetric_data_size = {
							144,
							112,
							196
						}
					}
				}
			}
		}
	},
	{
		display_name = "loc_setting_dof_quality",
		id = "dof_quality",
		tooltip_text = "loc_setting_dof_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "off",
				display_name = "loc_settings_menu_off",
				require_apply = false,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						dof_enabled = false,
						dof_high_quality = false
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = false,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						dof_enabled = true,
						dof_high_quality = false
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = false,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						dof_enabled = true,
						dof_high_quality = true
					}
				}
			}
		}
	},
	{
		display_name = "loc_setting_gi_quality",
		id = "gi_quality",
		tooltip_text = "loc_setting_gi_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "low",
				display_name = "loc_settings_menu_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						rtxgi_scale = 0.5
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						rtxgi_scale = 1
					}
				}
			}
		}
	},
	{
		id = "bloom_enabled",
		value_type = "boolean",
		display_name = "loc_setting_bloom_enabled",
		require_apply = false,
		require_restart = false,
		tooltip_text = "loc_setting_bloom_enabled_mouseover",
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "skin_material_enabled",
		value_type = "boolean",
		display_name = "loc_setting_skin_material_enabled",
		require_apply = true,
		require_restart = false,
		tooltip_text = "loc_setting_skin_material_enabled_mouseover",
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		value_type = "boolean",
		id = "motion_blur_enabled",
		display_name = "loc_setting_motion_blur_enabled",
		require_restart = false,
		require_apply = false,
		tooltip_text = "loc_setting_motion_blur_enabled_mouseover",
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = IS_XBS and true,
		supported_platforms = {
			win32 = true,
			xbs = true
		}
	},
	{
		display_name = "loc_setting_ssr_quality",
		id = "ssr_quality",
		tooltip_text = "loc_setting_ssr_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "off",
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						ssr_enabled = false,
						ssr_high_quality = false
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_settings_menu_medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					master_render_settings = {},
					render_settings = {
						ssr_enabled = true,
						ssr_high_quality = false
					}
				}
			},
			{
				id = "high",
				display_name = "loc_settings_menu_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					master_render_settings = {},
					render_settings = {
						ssr_enabled = true,
						ssr_high_quality = true
					}
				}
			}
		}
	},
	{
		value_type = "boolean",
		display_name = "loc_setting_lens_quality_enabled",
		id = "lens_quality_enabled",
		require_restart = false,
		require_apply = false,
		tooltip_text = "loc_setting_lens_quality_enabled_mouseover",
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		disable_rules = {
			{
				id = "lens_quality_color_fringe_enabled",
				reason = "loc_disable_rule_lens_quality_fringe",
				disable_value = false,
				validation_function = function (value)
					return value == false
				end
			},
			{
				id = "lens_quality_distortion_enabled",
				reason = "loc_disable_rule_lens_quality_distortion",
				disable_value = false,
				validation_function = function (value)
					return value == false
				end
			}
		}
	},
	{
		require_restart = false,
		indentation_level = 1,
		display_name = "loc_setting_lens_quality_color_fringe_enabled",
		id = "lens_quality_color_fringe_enabled",
		value_type = "boolean",
		require_apply = false,
		tooltip_text = "loc_setting_lens_quality_color_fringe_enabled_mouseover",
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		require_restart = false,
		indentation_level = 1,
		display_name = "loc_setting_lens_quality_distortion_enabled",
		id = "lens_quality_distortion_enabled",
		value_type = "boolean",
		require_apply = false,
		tooltip_text = "loc_setting_lens_quality_distortion_enabled_mouseover",
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		display_name = "loc_setting_lens_flare_quality",
		id = "lens_flare_quality",
		tooltip_text = "loc_setting_lens_flare_quality_mouseover",
		save_location = "master_render_settings",
		options = {
			{
				id = "off",
				display_name = "loc_settings_menu_off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						lens_flares_enabled = false,
						sun_flare_enabled = false
					}
				}
			},
			{
				id = "sun_light_only",
				display_name = "loc_setting_lens_flare_quality_setting_sun_light_only",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						lens_flares_enabled = false,
						sun_flare_enabled = true
					}
				}
			},
			{
				id = "all_lights",
				display_name = "loc_setting_lens_flare_quality_setting_all_lights",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						lens_flares_enabled = true,
						sun_flare_enabled = true
					}
				}
			}
		}
	},
	{
		value_type = "number",
		id = "lod_scatter_density",
		display_name = "loc_setting_lod_scatter_density",
		num_decimals = 2,
		max = 1,
		require_restart = false,
		min = 0,
		step_size = 0.01,
		require_apply = false,
		tooltip_text = "loc_setting_lod_scatter_density_mouseover",
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		value_type = "number",
		id = "max_ragdolls",
		display_name = "loc_setting_lod_max_ragdolls",
		num_decimals = 0,
		max = 50,
		require_restart = false,
		min = 3,
		step_size = 1,
		require_apply = false,
		tooltip_text = "loc_setting_lod_max_ragdolls_mouseover",
		save_location = "performance_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_max_ragdolls
	},
	{
		value_type = "number",
		id = "max_impact_decals",
		display_name = "loc_setting_max_impact_decals",
		num_decimals = 0,
		max = 100,
		require_restart = false,
		min = 5,
		step_size = 1,
		require_apply = false,
		tooltip_text = "loc_setting_max_impact_decals_mouseover",
		save_location = "performance_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_max_impact_decals
	},
	{
		value_type = "number",
		id = "max_blood_decals",
		display_name = "loc_setting_max_blood_decals",
		num_decimals = 0,
		max = 100,
		require_restart = false,
		min = 5,
		step_size = 1,
		require_apply = false,
		tooltip_text = "loc_setting_max_blood_decals_mouseover",
		save_location = "performance_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_max_blood_decals
	},
	{
		value_type = "number",
		id = "decal_lifetime",
		display_name = "loc_setting_decal_lifetime",
		num_decimals = 0,
		max = 60,
		require_restart = false,
		min = 10,
		step_size = 1,
		require_apply = false,
		tooltip_text = "loc_setting_decal_lifetime_mouseover",
		save_location = "performance_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_decal_lifetime
	},
	{
		group_name = "gore",
		display_name = "loc_settings_menu_group_gore",
		widget_type = "group_header"
	},
	{
		id = "blood_decals_enabled",
		value_type = "boolean",
		display_name = "loc_blood_decals_enabled",
		tooltip_text = "loc_blood_decals_enabled_mouseover",
		require_apply = false,
		require_restart = false,
		default_value = true,
		save_location = "gore_settings"
	},
	{
		id = "gibbing_enabled",
		value_type = "boolean",
		display_name = "loc_gibbing_enabled",
		tooltip_text = "loc_gibbing_enabled_mouseover",
		require_apply = false,
		require_restart = false,
		default_value = true,
		save_location = "gore_settings"
	},
	{
		id = "minion_wounds_enabled",
		value_type = "boolean",
		display_name = "loc_minion_wounds_enabled",
		tooltip_text = "loc_minion_wounds_enabled_mouseover",
		require_apply = false,
		require_restart = false,
		default_value = true,
		save_location = "gore_settings"
	},
	{
		id = "attack_ragdolls_enabled",
		value_type = "boolean",
		display_name = "loc_attack_ragdolls_enabled",
		tooltip_text = "loc_attack_ragdolls_enabled_mouseover",
		require_apply = false,
		require_restart = false,
		default_value = true,
		save_location = "gore_settings"
	}
}
local default_supported_platforms = {
	win32 = true
}

for _, template in ipairs(RENDER_TEMPLATES) do
	template.supported_platforms = template.supported_platforms or default_supported_platforms
end

local function create_render_settings_entry(template)
	local entry = nil
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
				local option = nil

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
				local current_value = template:get_function()

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
			end
		}
	elseif default_value_type == "number" then
		local function change_function(value, template)
			local dirty = false
			local current_value = template:get_function()

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
			on_value_changed_function = change_function
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
				local current_value = template:get_function()

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
			end
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
	group_name = "display",
	display_name = "loc_settings_menu_group_display",
	widget_type = "group_header"
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
					display_name = "n/a"
				}
			end
		end

		local options = {}
		local num_modes = DisplayAdapter.num_modes(adapter_index, output_screen)

		for i = 1, num_modes do
			local width, height = DisplayAdapter.mode(adapter_index, output_screen, i)

			if DefaultGameParameters.lowest_resolution <= width then
				local index = #options + 1
				options[index] = {
					ignore_localization = true,
					id = index,
					display_name = tostring(width) .. " x " .. tostring(height),
					adapter_index = adapter_index,
					output_screen = output_screen,
					width = width,
					height = height
				}
			end
		end

		if #options > 0 then
			options[resolution_undefined_return_value] = {
				height = 0,
				display_name = "loc_setting_resolution_undefined",
				width = 0,
				id = resolution_undefined_return_value,
				adapter_index = adapter_index,
				output_screen = output_screen
			}
			options[resolution_custom_return_value] = {
				display_name = "",
				height = 0,
				ignore_localization = true,
				width = 0,
				loc_display_name = "loc_setting_resolution_custom",
				id = resolution_custom_return_value,
				adapter_index = adapter_index,
				output_screen = output_screen
			}
		end

		return options
	end
end

local function _vfov_to_hfov(vfov)
	local width = RESOLUTION_LOOKUP.width
	local height = RESOLUTION_LOOKUP.height
	local aspect_ratio = width / height
	local hfov = math.round(2 * math.deg(math.atan(math.tan(math.rad(vfov) / 2) * aspect_ratio)))

	return hfov
end

local _fov_format_params = {}
local min_value = IS_XBS and DefaultGameParameters.min_console_vertical_fov or DefaultGameParameters.min_vertical_fov
local max_value = IS_XBS and DefaultGameParameters.max_console_vertical_fov or DefaultGameParameters.max_vertical_fov
local default_value = DefaultGameParameters.vertical_fov
render_settings[#render_settings + 1] = {
	apply_on_startup = false,
	display_name = "loc_settings_gameplay_fov",
	focusable = true,
	apply_on_drag = false,
	widget_type = "value_slider",
	num_decimals = 0,
	step_size_value = 1,
	mark_default_value = true,
	id = "gameplay_fov",
	tooltip_text = "loc_settings_gameplay_fov_mouseover",
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
	end
}
local resolution_options = generate_resolution_options()
render_settings[#render_settings + 1] = {
	id = "resolution",
	display_name = "loc_setting_resolution",
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
			height
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
		local resolution_width, resolution_height = nil

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
	end
}

if IS_XBS and Xbox.console_type() == Xbox.CONSOLE_TYPE_XBOX_SCARLETT_ANACONDA then
	render_settings[#render_settings + 1] = {
		require_apply = true,
		display_name = "loc_setting_xbs_quality_preset",
		id = "xbox_quality_preset",
		default_value = "performance",
		apply_on_startup = true,
		tooltip_text = "loc_setting_xbs_quality_preset_mouseover",
		options = {
			{
				id = "performance",
				display_name = "loc_setting_xbs_quality_preset_performance",
				data = {
					target_fps = 60,
					height = 1440,
					width = 2560
				}
			},
			{
				id = "quality",
				display_name = "loc_setting_xbs_quality_preset_quality",
				data = {
					target_fps = 40,
					height = 2160,
					width = 3840
				}
			}
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
		end
	}
end

local screen_mode_setting = {
	display_name = "loc_setting_screen_mode",
	tooltip_text = "loc_setting_screen_mode_mouseover",
	default_value = "window",
	apply_on_startup = true,
	id = "screen_mode",
	validation_function = function ()
		return IS_WINDOWS and DisplayAdapter.num_adapters() > 0
	end,
	get_function = function (template)
		local user_screen_mode = Application.user_setting("screen_mode")
		local screen_mode = user_screen_mode
		local is_fullscreen = Application.is_fullscreen and Application.is_fullscreen()
		local fullscreen = nil

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
		local option = nil

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
			id = "window",
			display_name = "loc_setting_screen_mode_window",
			require_apply = true,
			require_restart = false,
			values = {
				borderless_fullscreen = false,
				fullscreen = false
			}
		},
		{
			id = "borderless_fullscreen",
			display_name = "loc_setting_screen_mode_borderless_fullscreen",
			require_apply = true,
			require_restart = false,
			values = {
				borderless_fullscreen = true,
				fullscreen = false
			}
		},
		{
			id = "fullscreen",
			display_name = "loc_setting_screen_mode_fullscreen",
			require_apply = true,
			require_restart = false,
			values = {
				borderless_fullscreen = false,
				fullscreen = true
			}
		}
	},
	disable_rules = {
		{
			id = "resolution",
			reason = "loc_disable_rule_borderless_window",
			disable_value = 0,
			validation_function = function (value)
				return value == "borderless_fullscreen"
			end
		}
	}
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
		local is_valid = nil

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
	icon = "content/ui/materials/icons/system/settings/category_video",
	display_name = "loc_settings_menu_category_render",
	reset_function = reset_function,
	settings_utilities = SettingsUtilities,
	settings_by_id = SettingsUtilities.settings_by_id,
	settings = render_settings,
	can_be_reset = IS_XBS
}
