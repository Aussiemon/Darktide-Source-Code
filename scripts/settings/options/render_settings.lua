local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local OptionsUtilities = require("scripts/utilities/ui/options")

local function print_func(format, ...)
	print(string.format("[RenderSettings] " .. format, ...))
end

local function apply_user_settings()
	local perf_counter = Application.query_performance_counter()

	Application.apply_user_settings()

	local user_settings_apply_duration = Application.time_since_query(perf_counter)

	print_func("Time to apply settings: %.1fms", user_settings_apply_duration)
	Renderer.bake_static_shadows()

	local event_manager = rawget(_G, "Managers") and Managers.event

	if event_manager then
		event_manager:trigger("event_on_render_settings_applied")
	end
end

local function save_user_settings()
	local perf_counter = Application.query_performance_counter()

	Application.save_user_settings()

	local user_settings_save_duration = Application.time_since_query(perf_counter)

	print_func("Time to save settings: %.1fms", user_settings_save_duration)
end

local brightness_options = {
	{
		display_name = "loc_brightness_gamma_title",
		entries = {
			{
				display_name = "loc_setting_brightness_gamma_description",
				widget_type = "description"
			},
			{
				id = "checker",
				default_value = 1,
				widget_type = "gamma_texture",
				update = function (template)
					return Application.user_setting("gamma") + 1 or template.default_value
				end
			},
			{
				apply_on_drag = true,
				step_size_value = 0.01,
				min_value = -0.5,
				num_decimals = 2,
				focusable = true,
				max_value = 0.5,
				default_value = 0,
				widget_type = "value_slider",
				apply_on_startup = true,
				id = "min_brightness_value",
				get_function = function (template)
					return Application.user_setting("gamma") or template.default_value
				end,
				on_value_changed = function (value, template)
					if template.min_value > value or value > template.max_value then
						return Application.set_user_setting("gamma", template.default_value)
					end

					Application.set_user_setting("gamma", value)
				end,
				on_activated = function (value, template)
					template.on_value_changed(value, template)
				end,
				explode_function = function (normalized_value, template)
					local value_range = template.max_value - template.min_value
					local exploded_value = template.min_value + normalized_value * value_range
					local step_size = template.step_size_value or 0.1
					exploded_value = math.round(exploded_value / step_size) * step_size

					return exploded_value
				end,
				format_value_function = function (value)
					local number_format = string.format("%%.%sf", 2)

					return string.format(number_format, value)
				end,
				validation_function = function ()
					return true
				end
			}
		}
	}
}
local RENDER_TEMPLATES = {
	{
		require_restart = false,
		require_apply = true,
		display_name = "loc_vsync",
		id = "vsync",
		value_type = "boolean",
		default_value = "false"
	},
	{
		require_apply = true,
		display_name = "loc_setting_fsr",
		id = "fsr",
		default_value = 0,
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
					master_render_settings = {
						graphics_quality = "custom",
						anti_aliasing_solution = 2,
						dlss = 0
					},
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 1
					}
				}
			},
			{
				id = 2,
				display_name = "loc_setting_fsr_quality_balanced",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						graphics_quality = "custom",
						anti_aliasing_solution = 2,
						dlss = 0
					},
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 2
					}
				}
			},
			{
				id = 3,
				display_name = "loc_setting_fsr_quality_quality",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						graphics_quality = "custom",
						anti_aliasing_solution = 2,
						dlss = 0
					},
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 3
					}
				}
			},
			{
				id = 4,
				display_name = "loc_setting_fsr_quality_ultra_quality",
				require_apply = true,
				require_restart = false,
				values = {
					master_render_settings = {
						graphics_quality = "custom",
						anti_aliasing_solution = 2,
						dlss = 0
					},
					render_settings = {
						fsr_enabled = true,
						fsr_quality = 4
					}
				}
			}
		}
	},
	{
		save_location = "master_render_settings",
		display_name = "loc_setting_brightness",
		id = "brightness",
		widget_type = "button",
		pressed_function = function (parent, widget, template)
			Managers.ui:open_view("custom_settings_view", nil, nil, nil, nil, {
				pages = template.pages
			})
		end,
		pages = brightness_options
	},
	{
		group_name = "graphics",
		display_name = "loc_settings_menu_group_graphics_preset",
		widget_type = "group_header"
	},
	{
		apply_on_startup = true,
		display_name = "loc_setting_graphics_quality",
		id = "graphics_quality",
		save_location = "master_render_settings",
		default_value = DefaultGameParameters.default_graphics_quality,
		options = {
			{
				id = "low",
				display_name = "loc_setting_graphics_quality_option_low",
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
						particle_quality = "low",
						local_light_quality = "low",
						anti_aliasing_solution = 0,
						texture_quality = "low",
						volumetric_fog_quality = "low",
						sun_light_quality = "low",
						ambient_occlusion_quality = "low"
					},
					render_settings = {
						skin_material_enabled = false,
						sharpen_enabled = false,
						dof_high_quality = false,
						ssr_high_quality = false,
						lens_flares_enabled = false,
						light_shafts_enabled = false,
						lod_object_multiplier = 1,
						lens_quality_enabled = false,
						sun_flare_enabled = false,
						first_person_shadow_enabled = false,
						lod_scatter_density = 0.25,
						dof_enabled = false,
						motion_blur_enabled = false,
						ssr_enabled = false,
						bloom_enabled = true
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_setting_graphics_quality_option_medium",
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
						particle_quality = "medium",
						local_light_quality = "medium",
						anti_aliasing_solution = 1,
						texture_quality = "medium",
						volumetric_fog_quality = "medium",
						sun_light_quality = "medium",
						ambient_occlusion_quality = "medium"
					},
					render_settings = {
						skin_material_enabled = false,
						sharpen_enabled = true,
						dof_high_quality = false,
						ssr_high_quality = false,
						lens_flares_enabled = false,
						light_shafts_enabled = true,
						lod_object_multiplier = 1,
						lens_quality_enabled = false,
						sun_flare_enabled = true,
						first_person_shadow_enabled = true,
						lod_scatter_density = 0.5,
						dof_enabled = false,
						motion_blur_enabled = true,
						ssr_enabled = false,
						bloom_enabled = true
					}
				}
			},
			{
				id = "high",
				display_name = "loc_setting_graphics_quality_option_high",
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
						particle_quality = "high",
						local_light_quality = "high",
						anti_aliasing_solution = 2,
						texture_quality = "high",
						volumetric_fog_quality = "high",
						sun_light_quality = "high",
						ambient_occlusion_quality = "high"
					},
					render_settings = {
						skin_material_enabled = true,
						sharpen_enabled = true,
						dof_high_quality = true,
						ssr_high_quality = false,
						lens_flares_enabled = true,
						light_shafts_enabled = true,
						lod_object_multiplier = 1,
						lens_quality_enabled = true,
						sun_flare_enabled = true,
						first_person_shadow_enabled = true,
						lod_scatter_density = 1,
						dof_enabled = true,
						motion_blur_enabled = true,
						ssr_enabled = true,
						bloom_enabled = true
					}
				}
			},
			{
				id = "extreme",
				display_name = "loc_setting_graphics_quality_option_extreme",
				require_apply = true,
				require_restart = false,
				values = {
					performance_settings = {
						max_blood_decals = 75,
						max_ragdolls = 50,
						max_impact_decals = 75,
						decal_lifetime = 60
					},
					master_render_settings = {
						particle_quality = "high",
						local_light_quality = "extreme",
						anti_aliasing_solution = 2,
						texture_quality = "high",
						volumetric_fog_quality = "extreme",
						sun_light_quality = "high",
						ambient_occlusion_quality = "high"
					},
					render_settings = {
						skin_material_enabled = true,
						sharpen_enabled = true,
						dof_high_quality = true,
						ssr_high_quality = false,
						lens_flares_enabled = true,
						light_shafts_enabled = true,
						lod_object_multiplier = 1,
						lens_quality_enabled = true,
						sun_flare_enabled = true,
						first_person_shadow_enabled = true,
						lod_scatter_density = 1,
						dof_enabled = true,
						motion_blur_enabled = true,
						ssr_enabled = true,
						bloom_enabled = true
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
		group_name = "graphics",
		display_name = "loc_settings_menu_group_graphics",
		widget_type = "group_header"
	},
	{
		id = "anti_aliasing_solution",
		display_name = "loc_setting_anti_ailiasing",
		require_apply = true,
		save_location = "master_render_settings",
		options = {
			{
				id = 0,
				display_name = "loc_setting_anti_ailiasing_off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					master_render_settings = {
						fsr = 0
					},
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
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					master_render_settings = {
						fsr = 0,
						dlss = 0
					},
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
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					master_render_settings = {
						dlss = 0
					},
					render_settings = {
						taa_enabled = true,
						fxaa_enabled = false
					}
				}
			}
		}
	},
	{
		id = "texture_quality",
		display_name = "loc_setting_texture_quality",
		save_location = "master_render_settings",
		options = {
			{
				id = "low",
				display_name = "loc_setting_texture_quality_option_low",
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
				display_name = "loc_setting_texture_quality_option_medium",
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
						["content/texture_categories/character_orm"] = 2,
						["content/texture_categories/character_bc"] = 1,
						["content/texture_categories/environment_hm"] = 1,
						["content/texture_categories/character_mask2"] = 1,
						["content/texture_categories/environment_orm"] = 2,
						["content/texture_categories/character_bcm"] = 1,
						["content/texture_categories/character_bca"] = 1,
						["content/texture_categories/weapon_nm"] = 1,
						["content/texture_categories/environment_bca"] = 1,
						["content/texture_categories/environment_nm"] = 1,
						["content/texture_categories/character_hm"] = 1,
						["content/texture_categories/weapon_hm"] = 1,
						["content/texture_categories/weapon_mask"] = 1,
						["content/texture_categories/weapon_orm"] = 2
					}
				}
			},
			{
				id = "high",
				display_name = "loc_setting_texture_quality_option_high",
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
		id = "ambient_occlusion_quality",
		display_name = "loc_setting_ambient_occlusion_quality",
		save_location = "master_render_settings",
		options = {
			{
				id = "off",
				display_name = "loc_setting_ambient_occlusion_quality_off",
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
				display_name = "loc_setting_ambient_occlusion_quality_low",
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
			},
			{
				id = "medium",
				display_name = "loc_setting_ambient_occlusion_quality_medium",
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
			},
			{
				id = "high",
				display_name = "loc_setting_ambient_occlusion_quality_high",
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
		id = "local_light_quality",
		display_name = "loc_setting_local_light_quality",
		save_location = "master_render_settings",
		options = {
			{
				id = "low",
				display_name = "loc_setting_local_light_quality_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						local_lights_shadow_map_filter_quality = "low",
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_static_shadow_distance = 100,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_shadows_enabled = true,
						local_lights_shadow_atlas_size = {
							512,
							512
						},
						cached_local_lights_shadow_atlas_size = {
							1024,
							1024
						}
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_setting_local_light_quality_medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						local_lights_shadow_map_filter_quality = "low",
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_static_shadow_distance = 100,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_shadows_enabled = true,
						local_lights_shadow_atlas_size = {
							1024,
							1024
						},
						cached_local_lights_shadow_atlas_size = {
							2048,
							2048
						}
					}
				}
			},
			{
				id = "high",
				display_name = "loc_setting_local_light_quality_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						local_lights_shadow_map_filter_quality = "high",
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_static_shadow_distance = 100,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_shadows_enabled = true,
						local_lights_shadow_atlas_size = {
							2048,
							2048
						},
						cached_local_lights_shadow_atlas_size = {
							8192,
							8192
						}
					}
				}
			},
			{
				id = "extreme",
				display_name = "loc_setting_local_light_quality_extreme",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						local_lights_shadow_map_filter_quality = "high",
						local_lights_max_dynamic_shadow_distance = 50,
						local_lights_max_static_shadow_distance = 100,
						local_lights_max_non_shadow_casting_distance = 0,
						local_lights_shadows_enabled = true,
						local_lights_shadow_atlas_size = {
							4096,
							4096
						},
						cached_local_lights_shadow_atlas_size = {
							8192,
							8192
						}
					}
				}
			}
		}
	},
	{
		id = "sun_light_quality",
		display_name = "loc_setting_sun_light_quality",
		save_location = "master_render_settings",
		options = {
			{
				id = "low",
				display_name = "loc_setting_local_light_quality_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						sun_shadows = false,
						sun_shadow_map_filter_quality = "low",
						static_sun_shadows = true,
						sun_shadow_map_size = {
							4,
							4
						},
						static_sun_shadow_map_size = {
							2048,
							2048
						}
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_setting_local_light_quality_medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						sun_shadows = true,
						sun_shadow_map_filter_quality = "medium",
						static_sun_shadows = true,
						sun_shadow_map_size = {
							2048,
							2048
						},
						static_sun_shadow_map_size = {
							2048,
							2048
						}
					}
				}
			},
			{
				id = "high",
				display_name = "loc_setting_local_light_quality_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						sun_shadows = true,
						sun_shadow_map_filter_quality = "medium",
						static_sun_shadows = true,
						sun_shadow_map_size = {
							2048,
							2048
						},
						static_sun_shadow_map_size = {
							2048,
							2048
						}
					}
				}
			}
		}
	},
	{
		id = "volumetric_fog_quality",
		display_name = "loc_setting_volumetric_fog_quality",
		save_location = "master_render_settings",
		options = {
			{
				id = "off",
				display_name = "loc_setting_volumetric_fog_quality_off",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						volumetric_extrapolation_volumetric_shadows = false,
						volumetric_extrapolation_high_quality = false,
						volumetric_volumes_enabled = false,
						volumetric_reprojection_amount = 1,
						volumetric_lighting_local_lights = false,
						volumetric_data_size = {
							64,
							48,
							96
						}
					}
				}
			},
			{
				id = "low",
				display_name = "loc_setting_volumetric_fog_quality_low",
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
				display_name = "loc_setting_volumetric_fog_quality_medium",
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
				display_name = "loc_setting_volumetric_fog_quality_high",
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
				display_name = "loc_setting_volumetric_fog_quality_extreme",
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
		id = "particle_quality",
		display_name = "loc_setting_particle_quality",
		save_location = "master_render_settings",
		options = {
			{
				id = "low",
				display_name = "loc_setting_particle_quality_low",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						particles_simulation_lod = 1,
						particles_capacity_multiplier = 1
					}
				}
			},
			{
				id = "medium",
				display_name = "loc_setting_particle_quality_medium",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						particles_simulation_lod = 1,
						particles_capacity_multiplier = 1
					}
				}
			},
			{
				id = "high",
				display_name = "loc_setting_particle_quality_high",
				require_apply = true,
				require_restart = false,
				apply_values_on_edited = {
					graphics_quality = "custom"
				},
				values = {
					render_settings = {
						particles_simulation_lod = 0,
						particles_capacity_multiplier = 1
					}
				}
			}
		}
	},
	{
		group_name = "render_settings",
		display_name = "loc_settings_menu_group_graphics_advanced",
		widget_type = "group_header"
	},
	{
		id = "first_person_shadow_enabled",
		value_type = "boolean",
		display_name = "loc_setting_first_person_shadows",
		require_apply = true,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "dof_enabled",
		value_type = "boolean",
		display_name = "loc_setting_dof_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "dof_high_quality",
		value_type = "boolean",
		display_name = "loc_setting_dof_high_quality",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "bloom_enabled",
		value_type = "boolean",
		display_name = "loc_setting_bloom_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "light_shafts_enabled",
		value_type = "boolean",
		display_name = "loc_setting_light_shafts_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "skin_material_enabled",
		value_type = "boolean",
		display_name = "loc_setting_skin_material_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "motion_blur_enabled",
		value_type = "boolean",
		display_name = "loc_setting_motion_blur_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "ssr_enabled",
		value_type = "boolean",
		display_name = "loc_setting_ssr_enabled",
		require_apply = true,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "ssr_high_quality",
		value_type = "boolean",
		display_name = "loc_setting_ssr_high_quality",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "lens_quality_enabled",
		value_type = "boolean",
		display_name = "loc_setting_lens_quality_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "lens_quality_color_fringe_enabled",
		value_type = "boolean",
		display_name = "loc_setting_lens_quality_color_fringe_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "lens_quality_distortion_enabled",
		value_type = "boolean",
		display_name = "loc_setting_lens_quality_distortion_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "sun_flare_enabled",
		value_type = "boolean",
		display_name = "loc_setting_sun_flare_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "lens_flares_enabled",
		value_type = "boolean",
		display_name = "loc_setting_lens_flares_enabled",
		require_apply = true,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		id = "sharpen_enabled",
		value_type = "boolean",
		display_name = "loc_setting_sharpen_enabled",
		require_apply = false,
		require_restart = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		require_restart = false,
		id = "lod_scatter_density",
		display_name = "loc_setting_lod_scatter_density",
		num_decimals = 2,
		max = 1,
		value_type = "number",
		min = 0,
		step_size = 0.01,
		require_apply = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	},
	{
		require_restart = false,
		id = "max_ragdolls",
		display_name = "loc_setting_lod_max_ragdolls",
		num_decimals = 0,
		max = 50,
		value_type = "number",
		min = 3,
		step_size = 1,
		require_apply = false,
		save_location = "performance_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_max_ragdolls
	},
	{
		require_restart = false,
		id = "max_impact_decals",
		display_name = "loc_setting_max_impact_decals",
		num_decimals = 0,
		max = 100,
		value_type = "number",
		min = 5,
		step_size = 1,
		require_apply = false,
		save_location = "performance_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_max_impact_decals
	},
	{
		require_restart = false,
		id = "max_blood_decals",
		display_name = "loc_setting_max_blood_decals",
		num_decimals = 0,
		max = 100,
		value_type = "number",
		min = 5,
		step_size = 1,
		require_apply = false,
		save_location = "performance_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_max_blood_decals
	},
	{
		require_restart = false,
		id = "decal_lifetime",
		display_name = "loc_setting_decal_lifetime",
		num_decimals = 0,
		max = 60,
		value_type = "number",
		min = 10,
		step_size = 1,
		require_apply = false,
		save_location = "performance_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		},
		default_value = DefaultGameParameters.default_decal_lifetime
	},
	{
		require_restart = false,
		id = "lod_object_multiplier",
		display_name = "loc_setting_lod_object_multiplier",
		num_decimals = 2,
		max = 1,
		value_type = "number",
		min = 0.01,
		step_size = 0.01,
		require_apply = false,
		save_location = "render_settings",
		apply_values_on_edited = {
			graphics_quality = "custom"
		}
	}
}

local function _is_same(current, new)
	if current == new then
		return true
	elseif type(current) == "table" and type(new) == "table" then
		for k, v in pairs(current) do
			if new[k] ~= v then
				return false
			end
		end

		for k, v in pairs(new) do
			if current[k] ~= v then
				return false
			end
		end

		return true
	else
		return false
	end
end

local function create_render_settings_entry(template)
	local entry = nil
	local id = template.id
	local display_name = template.display_name
	local value_type = template.value_type
	local default_value = template.default_value
	local default_value_type = value_type or default_value ~= nil and type(default_value) or nil
	local options = template.options
	local save_location = template.save_location

	local function get_user_setting(location, key)
		if location then
			return Application.user_setting(location, key)
		else
			return Application.user_setting(key)
		end
	end

	local function set_user_setting(location, key, value)
		local perf_counter = Application.query_performance_counter()

		if location then
			Application.set_user_setting(location, key, value)

			if location == "render_settings" and type(value) ~= "table" then
				Application.set_render_setting(key, tostring(value))
			end
		else
			Application.set_user_setting(key, value)
		end

		local settings_parse_duration = Application.time_since_query(perf_counter)

		print_func("Time to parse setting [%s] with new value (%s): %.1fms.", key, value, settings_parse_duration)
	end

	local apply_values = nil

	local function parse_settings_for_option_values(setting_id, option_id)
		local dirty = false

		for i = 1, #RENDER_TEMPLATES do
			local template = RENDER_TEMPLATES[i]

			if template.id == setting_id then
				local options = template.options

				if options then
					for j = 1, #options do
						local option = options[j]

						if option.id == option_id then
							local values = option.values

							if values then
								dirty = apply_values(values)

								return dirty
							end
						end
					end
				end

				break
			end
		end
	end

	local function on_setting_edited_function(values)
		for value_id, value in pairs(values) do
			for i = 1, #RENDER_TEMPLATES do
				local template = RENDER_TEMPLATES[i]

				if template.id == value_id then
					local save_location = template.save_location

					if save_location then
						set_user_setting(save_location, value_id, value)

						break
					end

					set_user_setting(nil, value_id, value)

					break
				end
			end
		end
	end

	function apply_values(values)
		local dirty = false

		for value_save_location, location_values in pairs(values) do
			if type(location_values) == "table" then
				for location_value_id, location_value in pairs(location_values) do
					local current_value = get_user_setting(value_save_location, location_value_id)

					if not _is_same(current_value, location_value) then
						set_user_setting(value_save_location, location_value_id, location_value)

						dirty = true
					end

					if parse_settings_for_option_values(location_value_id, location_value) then
						dirty = true
					end
				end
			else
				local current_value = get_user_setting(nil, value_save_location)

				if not _is_same(current_value, location_values) then
					set_user_setting(nil, value_save_location, location_values)

					dirty = true
				end

				if parse_settings_for_option_values(value_save_location, location_values) then
					dirty = true
				end
			end
		end

		return dirty
	end

	if options then
		entry = {
			options = options,
			display_name = display_name,
			on_activated = function (new_value)
				local option = nil

				for i = 1, #options do
					if options[i].id == new_value then
						option = options[i]

						break
					end
				end

				local apply_values_on_edited = option.apply_values_on_edited

				if apply_values_on_edited then
					on_setting_edited_function(apply_values_on_edited)
				end

				local dirty = false
				local current_value = get_user_setting(save_location, id) or default_value

				if not _is_same(current_value, new_value) then
					set_user_setting(save_location, id, new_value)

					dirty = true
				end

				local values = option.values

				if values and apply_values(values) then
					dirty = true
				end

				if dirty then
					save_user_settings()

					if option.require_apply then
						apply_user_settings()
					end
				end
			end,
			get_function = function ()
				local old_value = get_user_setting(save_location, id)

				if old_value == nil then
					return default_value
				else
					return old_value
				end
			end
		}
	elseif default_value_type == "number" then
		local function change_function(new_value)
			local dirty = false
			local apply_values_on_value = template.apply_values_on_value
			local values_to_apply = apply_values_on_value and apply_values_on_value[tostring(new_value)]

			if values_to_apply and apply_values(values_to_apply) then
				dirty = true
			end

			local apply_values_on_edited = template.apply_values_on_edited

			if apply_values_on_edited then
				apply_values(apply_values_on_edited)
			end

			local current_value = get_user_setting(save_location, id) or default_value

			if not _is_same(current_value, new_value) then
				dirty = true
			end

			if dirty then
				set_user_setting(save_location, id, new_value)
				save_user_settings()

				if template.require_apply then
					apply_user_settings()
				end
			end
		end

		local function get_function()
			return get_user_setting(save_location, id) or default_value
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
	elseif default_value_type == "boolean" then
		entry = {
			display_name = display_name,
			on_activated = function (new_value)
				local dirty = false
				local apply_values_on_value = template.apply_values_on_value
				local values_to_apply = apply_values_on_value and apply_values_on_value[tostring(new_value)]

				if values_to_apply and apply_values(values_to_apply) then
					dirty = true
				end

				local apply_values_on_edited = template.apply_values_on_edited

				if apply_values_on_edited then
					on_setting_edited_function(apply_values_on_edited)
				end

				local current_value = get_user_setting(save_location, id) or default_value

				if not _is_same(current_value, new_value) then
					dirty = true
				end

				if dirty then
					set_user_setting(save_location, id, new_value)
					save_user_settings()

					if template.require_apply then
						apply_user_settings()
					end
				end
			end,
			get_function = function ()
				local old_value = get_user_setting(save_location, id)

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

	return entry
end

local new_settings = {}

if PLATFORM == "win32" then
	new_settings[#new_settings + 1] = {
		group_name = "display",
		display_name = "loc_settings_menu_group_display",
		widget_type = "group_header"
	}

	local function generate_resolution_options()
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

			return options
		end
	end

	local resolution_options = generate_resolution_options()
	local resolution_undefiend_return_value = {
		display_name = "loc_setting_resolution_undefined"
	}
	new_settings[#new_settings + 1] = {
		display_name = "loc_setting_resolution",
		options = resolution_options,
		validation_function = function ()
			return DisplayAdapter.num_adapters() > 0
		end,
		on_activated = function (new_value)
			local option = resolution_options[new_value]
			local output_screen = option.output_screen
			local adapter_index = option.adapter_index
			local width = option.width
			local height = option.height
			local resolution = {
				width,
				height
			}

			Application.set_user_setting("adapter_index", adapter_index - 1)
			Application.set_user_setting("screen_resolution", resolution)
			Application.save_user_settings()
			apply_user_settings()
		end,
		get_function = function ()
			local resolution = Application.user_setting("screen_resolution")
			local resolution_width = resolution[1]
			local resolution_height = resolution[2]

			for i = 1, #resolution_options do
				local option = resolution_options[i]

				if option.width == resolution_width and option.height == resolution_height then
					return i
				end
			end

			return resolution_undefiend_return_value
		end
	}
	local screen_mode_setting = {
		default_value = "window",
		display_name = "loc_setting_screen_mode",
		id = "screen_mode",
		validation_function = function ()
			return DisplayAdapter.num_adapters() > 0
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
		}
	}
	new_settings[#new_settings + 1] = create_render_settings_entry(screen_mode_setting)
end

for i = 1, #RENDER_TEMPLATES do
	local template = RENDER_TEMPLATES[i]
	new_settings[#new_settings + 1] = create_render_settings_entry(template)
end

return {
	icon = "content/ui/materials/icons/system/settings/category_video",
	display_name = "loc_settings_menu_category_render",
	settings = new_settings
}
