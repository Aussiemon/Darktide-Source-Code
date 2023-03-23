local DefaultGameParameters = require("scripts/foundation/utilities/parameters/default_game_parameters")
local OptionsUtilities = require("scripts/utilities/ui/options")
local render_settings = {}
local render_settings_by_id = {}

local function print_func(format, ...)
	print(string.format("[RenderSettings] " .. format, ...))
end

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

local function remove_repeated_entries(changes_list, start_index)
	if not changes_list or #changes_list < 1 then
		return {}
	end

	local start_index = start_index or 1

	if start_index >= #changes_list then
		return changes_list
	else
		local occurences = {}
		local entry = changes_list[start_index]

		for i = start_index + 1, #changes_list do
			local stored_change = changes_list[i]

			if stored_change and stored_change.id == entry.id then
				occurences[#occurences + 1] = i
			end
		end

		local new_table = {}

		if #occurences > 0 then
			local count = #changes_list

			for i = 1, #occurences do
				local index = occurences[i]
				changes_list[index] = nil
			end

			for i = 1, count do
				if changes_list[i] then
					new_table[#new_table + 1] = changes_list[i]
				end
			end
		else
			new_table = changes_list
		end

		return remove_repeated_entries(new_table, start_index + 1)
	end
end

local function verify_and_apply_changes(changed_setting, new_value, affected_settings, origin_id)
	local changes_list = {}
	local first_level = not affected_settings

	if first_level then
		changes_list[#changes_list + 1] = {
			id = changed_setting.id,
			value = new_value,
			save_location = changed_setting.save_location,
			require_apply = changed_setting.require_apply
		}
	end

	local settings_list = affected_settings or {}

	if not changed_setting.disabled or changed_setting.disabled and changed_setting.disabled_origin == origin_id then
		if changed_setting.disable_rules then
			local disabled_by_id = {}
			local enabled_by_id = {}
			local affected_ids = {}

			for i = 1, #changed_setting.disable_rules do
				local disabled_rule = changed_setting.disable_rules[i]
				local disabled_setting = render_settings_by_id[disabled_rule.id]

				if disabled_setting and (not disabled_setting.validation_function or disabled_setting.validation_function and disabled_setting.validation_function()) then
					if disabled_rule.validation_function(new_value) then
						if not disabled_by_id[disabled_rule.id] then
							affected_ids[disabled_rule.id] = true
							disabled_by_id[disabled_rule.id] = {
								disabled_origin_id = changed_setting.id,
								affected_setting = disabled_setting,
								disabled_rule = disabled_rule
							}
						end
					elseif not disabled_rule.validation_function(new_value) and (not disabled_setting.disabled_by or disabled_setting.disabled_by and disabled_setting.disabled_by[changed_setting.id]) and not enabled_by_id[disabled_rule.id] then
						affected_ids[disabled_rule.id] = true
						enabled_by_id[disabled_rule.id] = {
							disabled_origin_id = changed_setting.id,
							affected_setting = disabled_setting,
							disabled_rule = disabled_rule
						}
					end
				end
			end

			for id, _ in pairs(affected_ids) do
				local disabled_data = disabled_by_id[id]
				local enabled_data = enabled_by_id[id]

				if disabled_data then
					local disabled_setting = disabled_data.affected_setting
					local disabled_origin_id = disabled_data.disabled_origin_id
					local disabled_rule = disabled_data.disabled_rule
					disabled_setting.disabled_by = disabled_setting.disabled_by or {}

					if table.is_empty(disabled_setting.disabled_by) then
						disabled_setting.value_on_enabled = disabled_setting:get_function()
						disabled_setting.disabled_origin = disabled_origin_id
					end

					disabled_setting.disabled_by[changed_setting.id] = disabled_rule.reason
					disabled_setting.disabled = true
					changes_list[#changes_list + 1] = {
						id = disabled_rule.id,
						value = disabled_rule.disable_value,
						save_location = disabled_setting.save_location,
						require_apply = disabled_setting.require_apply
					}
				elseif enabled_data then
					local enabled_setting = enabled_data.affected_setting
					local enabled_origin_id = enabled_data.disabled_origin_id
					local disabled_rule = enabled_data.disabled_rule

					if enabled_setting.disabled_by and enabled_setting.disabled_by[enabled_origin_id] then
						enabled_setting.disabled_by[enabled_origin_id] = nil
						enabled_setting.disabled = not table.is_empty(enabled_setting.disabled_by)
					end

					if enabled_setting.disabled == false then
						enabled_setting.disabled_origin = nil
						changes_list[#changes_list + 1] = {
							id = disabled_rule.id,
							value = enabled_setting.value_on_enabled,
							save_location = enabled_setting.save_location,
							require_apply = enabled_setting.require_apply
						}
					end
				end
			end
		end

		if changed_setting.options then
			for i = 1, #changed_setting.options do
				local option = changed_setting.options[i]

				if option.id == new_value then
					if option.values then
						for id, value in pairs(option.values) do
							if type(value) == "table" then
								for inner_id, inner_value in pairs(value) do
									if render_settings_by_id[inner_id] and (not render_settings_by_id[inner_id].validation_function or render_settings_by_id[inner_id].validation_function and render_settings_by_id[inner_id].validation_function()) then
										if not render_settings_by_id[inner_id].disabled then
											changes_list[#changes_list + 1] = {
												id = inner_id,
												value = inner_value,
												save_location = render_settings_by_id[inner_id].save_location,
												require_apply = render_settings_by_id[inner_id].require_apply
											}
										elseif render_settings_by_id[inner_id].disabled then
											render_settings_by_id[inner_id].value_on_enabled = inner_value
										end
									elseif not render_settings_by_id[inner_id] then
										changes_list[#changes_list + 1] = {
											id = inner_id,
											value = inner_value,
											save_location = id
										}
									end
								end
							elseif render_settings_by_id[id] and (not render_settings_by_id[id].validation_function or render_settings_by_id[id].validation_function and render_settings_by_id[id].validation_function()) then
								if not render_settings_by_id[id].disabled then
									changes_list[#changes_list + 1] = {
										id = id,
										value = value,
										save_location = render_settings_by_id[id].save_location,
										require_apply = render_settings_by_id[id].require_apply
									}
								elseif render_settings_by_id[id].disabled then
									render_settings_by_id[id].value_on_enabled = value
								end
							elseif not render_settings_by_id[id] then
								changes_list[#changes_list + 1] = {
									id = id,
									value = value
								}
							end
						end
					end

					if option.apply_values_on_edited then
						for id, value in pairs(option.apply_values_on_edited) do
							if render_settings_by_id[id] and (not render_settings_by_id[id].validation_function or render_settings_by_id[id].validation_function and render_settings_by_id[id].validation_function()) then
								if not render_settings_by_id[id].disabled then
									changes_list[#changes_list + 1] = {
										id = id,
										value = value,
										save_location = render_settings_by_id[id].save_location,
										require_apply = render_settings_by_id[id].require_apply
									}
								elseif render_settings_by_id[id] and render_settings_by_id[id].disabled then
									render_settings_by_id[id].value_on_enabled = value
								end
							end
						end
					end

					break
				end
			end
		end

		if changed_setting.apply_values_on_edited then
			for id, value in pairs(changed_setting.apply_values_on_edited) do
				if render_settings_by_id[id] and (not render_settings_by_id[id].validation_function or render_settings_by_id[id].validation_function and render_settings_by_id[id].validation_function()) then
					if not render_settings_by_id[id].disabled then
						changes_list[#changes_list + 1] = {
							id = id,
							value = value,
							save_location = render_settings_by_id[id].save_location,
							require_apply = render_settings_by_id[id].require_apply
						}
					elseif render_settings_by_id[id].disabled then
						render_settings_by_id[id].value_on_enabled = value
					end
				end
			end
		end

		for i = 1, #changes_list do
			local change = changes_list[i]
			settings_list[#settings_list + 1] = change

			if render_settings_by_id[change.id] then
				local should_verifiy = first_level and i > 1 or not first_level

				if should_verifiy then
					verify_and_apply_changes(render_settings_by_id[change.id], change.value, settings_list, changed_setting.id)
				end
			end
		end
	end

	if first_level then
		local filtered_changes = remove_repeated_entries(settings_list)
		local dirty = true
		local require_apply = nil

		for i = 1, #filtered_changes do
			local setting_changed = filtered_changes[i]

			if setting_changed.require_apply then
				require_apply = true
			end

			local id = setting_changed.id
			local new_value = setting_changed.value

			if render_settings_by_id[id] and render_settings_by_id[id].on_changed then
				local saved, needs_apply = render_settings_by_id[id].on_changed(new_value, render_settings_by_id[id])
				dirty = dirty or saved

				if not require_apply then
					require_apply = needs_apply
				end
			else
				local save_location = setting_changed.save_location
				local current_value = get_user_setting(save_location, id)

				if not _is_same(current_value, new_value) then
					set_user_setting(save_location, id, new_value)

					dirty = true
					require_apply = require_apply or setting_changed.require_apply
				end
			end
		end

		if dirty then
			if require_apply then
				apply_user_settings()
			end

			save_user_settings()
		end
	end
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
				apply_on_startup = true,
				widget_type = "value_slider",
				focusable = true,
				num_decimals = 2,
				max_value = 1,
				default_value = 0,
				min_value = -1,
				step_size_value = 0.01,
				apply_on_drag = true,
				id = "min_brightness_value",
				get_function = function (template)
					return Application.user_setting("gamma") or template.default_value
				end,
				on_value_changed = function (value, template)
					if template.min_value > value or value > template.max_value then
						Application.set_user_setting("gamma", template.default_value)
					else
						Application.set_user_setting("gamma", value)
					end

					if template.changed_callback then
						template.changed_callback(value)
					end

					save_user_settings()
				end,
				on_activated = function (value, template)
					template.on_changed(value, template)
				end,
				on_changed = function (value, template)
					return template.on_value_changed(value, template)
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
			Managers.ui:open_view("custom_settings_view", nil, nil, nil, nil, {
				pages = template.pages
			})
		end,
		pages = brightness_options
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
		default_value = "off",
		display_name = "loc_rtxgi_quality",
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
	local default_value_type = value_type or default_value ~= nil and type(default_value) or nil
	local options = template.options
	local save_location = template.save_location

	if options then
		entry = {
			options = options,
			display_name = display_name,
			on_activated = function (value, template)
				verify_and_apply_changes(template, value)
			end,
			on_changed = function (value, template)
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

				if not _is_same(current_value, value) then
					set_user_setting(template.save_location, template.id, value)

					if template.changed_callback then
						template.changed_callback(value)
					end

					dirty = true
				end

				return dirty, option.require_apply
			end,
			get_function = function (template)
				local old_value = get_user_setting(template.save_location, template.id)

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

			if not _is_same(current_value, value) then
				dirty = true
			end

			if dirty then
				set_user_setting(template.save_location, template.id, value)

				if template.require_apply then
					apply_user_settings()
				end

				save_user_settings()
			end
		end

		local function get_function(template)
			return get_user_setting(template.save_location, template.id) or default_value
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
			verify_and_apply_changes(template, value)
		end

		entry.type = "slider"
	elseif default_value_type == "boolean" then
		entry = {
			display_name = display_name,
			on_activated = function (value, template)
				verify_and_apply_changes(template, value)
			end,
			on_changed = function (value, template)
				local dirty = false
				local current_value = template:get_function()

				if current_value == nil then
					current_value = template.default_value
				end

				if not _is_same(current_value, value) then
					set_user_setting(template.save_location, template.id, value)

					dirty = true
				end

				return dirty, template.require_apply
			end,
			get_function = function (template)
				local old_value = get_user_setting(template.save_location, template.id)

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
	entry.id = template.id
	entry.save_location = save_location
	entry.apply_values_on_edited = template.apply_values_on_edited
	entry.startup_prio = template.startup_prio
	entry.require_apply = template.require_apply

	return entry
end

render_settings[#render_settings + 1] = {
	group_name = "display",
	display_name = "loc_settings_menu_group_display",
	widget_type = "group_header"
}

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
		verify_and_apply_changes(template, value)
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
local resolution_undefiend_return_value = {
	display_name = "loc_setting_resolution_undefined"
}
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
		verify_and_apply_changes(template, value)
	end,
	on_changed = function (value, template)
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
		local resolution = Application.user_setting("screen_resolution")
		local resolution_width = resolution[1]
		local resolution_height = resolution[2]

		for i = 1, #resolution_options do
			local option = resolution_options[i]

			if option.width == resolution_width and option.height == resolution_height then
				return i
			end
		end

		if #resolution_options > 0 then
			return 1
		end

		return resolution_undefiend_return_value
	end
}
local screen_mode_setting = {
	tooltip_text = "loc_setting_screen_mode_mouseover",
	display_name = "loc_setting_screen_mode",
	id = "screen_mode",
	default_value = "window",
	apply_on_startup = true,
	validation_function = function ()
		return IS_WINDOWS and DisplayAdapter.num_adapters() > 0
	end,
	get_function = function (template)
		local screen_mode = Application.user_setting("screen_mode")
		local fullscreen = Application.user_setting("fullscreen")
		local borderless_fullscreen = Application.user_setting("borderless_fullscreen")

		if borderless_fullscreen then
			screen_mode = "borderless_fullscreen"
		elseif fullscreen then
			screen_mode = "fullscreen"
		elseif not borderless_fullscreen and not fullscreen then
			screen_mode = "window"
		end

		return screen_mode or template.default_value
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
render_settings[#render_settings + 1] = create_render_settings_entry(screen_mode_setting)
local platform = PLATFORM

for i = 1, #RENDER_TEMPLATES do
	local template = RENDER_TEMPLATES[i]

	if template.supported_platforms[platform] then
		render_settings[#render_settings + 1] = create_render_settings_entry(template)
	end
end

for i = 1, #render_settings do
	local render_setting = render_settings[i]

	if render_setting.id then
		render_settings_by_id[render_setting.id] = render_setting
	end
end

return {
	icon = "content/ui/materials/icons/system/settings/category_video",
	display_name = "loc_settings_menu_category_render",
	can_be_reset = false,
	settings = render_settings
}
