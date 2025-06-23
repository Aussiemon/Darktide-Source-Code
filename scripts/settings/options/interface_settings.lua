-- chunkname: @scripts/settings/options/interface_settings.lua

local OptionsUtilities = require("scripts/utilities/ui/options")
local SettingsUtilitiesFunction = require("scripts/settings/options/settings_utils")
local SettingsUtilities = {}

local function construct_interface_settings_boolean(template)
	local entry = {}

	entry.default_value = template.default_value
	entry.display_name = template.display_name
	entry.on_value_changed = template.on_value_changed
	entry.indentation_level = template.indentation_level
	entry.tooltip_text = template.tooltip_text
	entry.disable_rules = template.disable_rules
	entry.validation_function = template.validation_function
	entry.apply_on_startup = template.apply_on_startup

	local id = template.id
	local save_location = template.save_location
	local default_value = template.default_value

	entry.get_function = function ()
		local old_value

		if template.use_local_save then
			old_value = SettingsUtilities.get_local_settings(id)
		else
			old_value = SettingsUtilities.get_account_settings(save_location, id)
		end

		if old_value == nil then
			return default_value
		else
			return old_value
		end
	end

	entry.on_activated = function (new_value)
		local current_value

		if template.use_local_save then
			current_value = SettingsUtilities.get_local_settings(id)
		else
			current_value = SettingsUtilities.get_account_settings(save_location, id)
		end

		if current_value == nil then
			current_value = default_value
		end

		if not SettingsUtilities.is_same(current_value, new_value) then
			if template.use_local_save then
				SettingsUtilities.save_local_settings(id, new_value)
			else
				SettingsUtilities.save_account_settings(save_location, id, new_value)
			end

			if entry.on_value_changed then
				entry.on_value_changed(new_value)
			end
		end
	end

	return entry
end

local function construct_interface_settings_percent_slider(template)
	local min_value = template.min_value or 0
	local max_value = template.max_value or 100
	local value_range = max_value - min_value
	local conversion_value = value_range / 100
	local step_size = template.step_size_value or 1
	local percent_step_size = step_size / conversion_value
	local default_value = ((template.default_value or min_value) - min_value) / conversion_value
	local id = template.id
	local save_location = template.save_location

	local function explode_value(percent_value)
		local exploded_value = min_value + percent_value * conversion_value

		exploded_value = math.round(exploded_value / step_size) * step_size

		return exploded_value
	end

	local on_value_changed = template.on_value_changed

	local function on_value_changed_function(percent_value)
		local exploded_value = explode_value(percent_value)

		if template.use_local_save then
			SettingsUtilities.save_local_settings(id, exploded_value)
		else
			SettingsUtilities.save_account_settings(save_location, id, exploded_value)
		end

		if on_value_changed then
			on_value_changed(exploded_value)
		end
	end

	local value_get_function = template.get_function or function ()
		local exploded_value

		if template.use_local_save then
			exploded_value = SettingsUtilities.get_local_settings(id)
		else
			exploded_value = SettingsUtilities.get_account_settings(save_location, id)
		end

		if exploded_value == nil then
			exploded_value = default_value
		end

		local percent_value = (exploded_value - min_value) / conversion_value

		return percent_value
	end
	local format_value_function = template.format_value_function or function (current_value)
		local exploded_value = explode_value(current_value)
		local result = string.format("%d %%", exploded_value)

		return result
	end
	local params = {
		apply_on_drag = true,
		display_name = template.display_name,
		default_value = default_value,
		step_size_value = percent_step_size,
		value_get_function = value_get_function,
		on_value_changed_function = on_value_changed_function,
		format_value_function = format_value_function,
		indentation_level = template.indentation_level,
		validation_function = template.validation_function,
		tooltip_text = template.tooltip_text,
		disable_rules = template.disable_rules,
		apply_on_startup = template.apply_on_startup
	}

	return OptionsUtilities.create_percent_slider_template(params)
end

local function construct_interface_settings_value_slider(template)
	local min_value = template.min_value or 0
	local max_value = template.max_value or 100
	local default_value = template.default_value or min_value
	local step_size_value = template.step_size_value
	local num_decimals = template.num_decimals
	local on_value_changed = template.on_value_changed
	local id = template.id
	local save_location = template.save_location

	local function on_value_changed_function(value)
		if template.use_local_save then
			SettingsUtilities.save_local_settings(id, value)
		else
			SettingsUtilities.save_account_settings(save_location, id, value)
		end

		if on_value_changed then
			on_value_changed(value)
		end
	end

	local function value_get_function()
		local value

		if template.use_local_save then
			value = SettingsUtilities.get_local_settings(id)
		else
			value = SettingsUtilities.get_account_settings(save_location, id)
		end

		return value or default_value
	end

	local params = {
		apply_on_drag = true,
		min_value = min_value,
		max_value = max_value,
		display_name = template.display_name,
		default_value = default_value,
		num_decimals = num_decimals,
		step_size_value = step_size_value,
		value_get_function = value_get_function,
		on_value_changed_function = on_value_changed_function,
		indentation_level = template.indentation_level,
		validation_function = template.validation_function,
		tooltip_text = template.tooltip_text,
		disable_rules = template.disable_rules,
		apply_on_startup = template.apply_on_startup
	}

	return OptionsUtilities.create_value_slider_template(params)
end

local function construct_interface_settings_dropdown(template)
	local on_value_changed = template.on_value_changed
	local id = template.id
	local save_location = template.save_location

	local function value_get_function()
		return SettingsUtilities.get_account_settings(save_location, id)
	end

	local options = {}

	for i = 1, #template.options do
		local value = template.options[i]

		options[#options + 1] = {
			id = value.name,
			value = value.name,
			display_name = value.display_name,
			icon = value.icon
		}
	end

	local function on_activated(value, template)
		SettingsUtilities.verify_and_apply_changes(template, value)
	end

	local function on_changed(value, template)
		SettingsUtilities.save_account_settings(save_location, id, value)

		if on_value_changed then
			on_value_changed(value)
		end
	end

	local params = {
		display_name = template.display_name,
		get_function = value_get_function,
		options = options,
		on_activated = on_activated,
		on_changed = on_changed,
		indentation_level = template.indentation_level,
		validation_function = template.validation_function,
		id = template.id,
		tooltip_text = template.tooltip_text,
		disable_rules = template.disable_rules,
		default_value = template.default_value
	}

	return params
end

local template_functions = {
	boolean = construct_interface_settings_boolean,
	percent_slider = construct_interface_settings_percent_slider,
	value_slider = construct_interface_settings_value_slider,
	dropdown = construct_interface_settings_dropdown
}

local function _companion_outline_options()
	local options = {
		{
			display_name = "loc_setting_companion_outline_in_mission_all",
			name = "both"
		},
		{
			display_name = "loc_setting_companion_outline_in_mission_self",
			name = "own"
		},
		{
			display_name = "loc_setting_companion_outline_in_mission_allies",
			name = "allies"
		},
		{
			display_name = "loc_setting_companion_outline_in_mission_none",
			name = "none"
		}
	}

	return options
end

local _notification_options = {
	{
		display_name = "loc_setting_notification_type_none",
		name = "none"
	},
	{
		display_name = "loc_setting_notification_type_combat_feed",
		name = "combat_feed"
	},
	{
		display_name = "loc_setting_notification_type_notification",
		name = "notification"
	}
}
local settings_definitions = {
	{
		group_name = "gameplay_settings",
		display_name = "loc_settings_menu_group_gameplay_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_player_outlines_enabled",
		id = "player_outlines",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			return
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_companion_outline_in_mission",
		id = "companion_outlines",
		default_value = "none",
		widget_type = "dropdown",
		options = _companion_outline_options(),
		on_value_changed = function (value)
			Managers.event:trigger("event_update_companion_outlines", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_setting_hit_indicator_enabled",
		id = "hit_indicator_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_hit_indicator_enabled", value)
		end
	},
	{
		step_size_value = 0.1,
		min_value = 0.5,
		display_name = "loc_setting_hit_indicator_duration",
		num_decimals = 1,
		max_value = 1.5,
		default_value = 0.5,
		widget_type = "value_slider",
		id = "hit_indicator_duration",
		save_location = "interface_settings",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_hit_indicator_duration", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_setting_crosshair_enabled",
		id = "crosshair_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_crosshair_enabled", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_setting_aim_trajectory_enabled",
		id = "aim_trajectory_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_aim_trajectory_enabled", value)
		end
	},
	{
		save_location = "interface_settings",
		default_value = false,
		display_name = "loc_interface_setting_forced_dot_crosshair",
		id = "forced_dot_crosshair_enabled",
		tooltip_text = "loc_settings_forced_dot_crosshair_mouseover",
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_forced_dot_crosshair", value)
		end
	},
	{
		save_location = "interface_settings",
		default_value = "weapon",
		display_name = "loc_setting_crosshair_type_override",
		id = "crosshair_type_override",
		tooltip_text = "loc_settings_crosshair_type_override_mouseover",
		widget_type = "dropdown",
		options = {
			{
				display_name = "loc_setting_crosshair_type_override_weapon",
				name = "weapon"
			},
			{
				icon = "content/ui/materials/icons/system/settings/dropdown/icon_crosshair_killshot",
				name = "cross",
				display_name = "loc_setting_crosshair_type_override_killshot"
			},
			{
				icon = "content/ui/materials/icons/system/settings/dropdown/icon_crosshair_assault",
				name = "assault",
				display_name = "loc_setting_crosshair_type_override_assault"
			},
			{
				icon = "content/ui/materials/icons/system/settings/dropdown/icon_crosshair_bfg",
				name = "bfg",
				display_name = "loc_setting_crosshair_type_override_bfg"
			},
			{
				icon = "content/ui/materials/icons/system/settings/dropdown/icon_crosshair_shotgun",
				name = "shotgun",
				display_name = "loc_setting_crosshair_type_override_shotgun"
			},
			{
				icon = "content/ui/materials/icons/system/settings/dropdown/icon_crosshair_spray_n_pray",
				name = "spray_n_pray",
				display_name = "loc_setting_crosshair_type_override_spray_n_pray"
			},
			{
				icon = "content/ui/materials/icons/system/settings/dropdown/icon_crosshair_dot",
				name = "dot",
				display_name = "loc_setting_crosshair_type_override_dot"
			}
		},
		on_value_changed = function (value)
			Managers.event:trigger("event_update_crosshair_type_override", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_input_hints_enabled",
		id = "input_hints_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_input_hints_enabled", value)
		end
	},
	{
		group_name = "buff_interface_settings",
		display_name = "loc_settings_menu_group_buff_interface_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		default_value = true,
		display_name = "loc_interface_setting_show_group_buff_icon_in_categories",
		id = "group_buff_icon_in_categories",
		tooltip_text = "loc_interface_setting_show_group_buff_icon_in_categories_mouseover",
		widget_type = "boolean",
		on_value_changed = function (value)
			return
		end
	},
	{
		save_location = "interface_settings",
		default_value = true,
		display_name = "loc_interface_setting_show_show_aura_buff_icons",
		id = "show_aura_buff_icons",
		tooltip_text = "loc_interface_setting_show_show_aura_buff_icons_mouseover",
		widget_type = "boolean",
		on_value_changed = function (value)
			return
		end
	},
	{
		group_name = "combat_feed_settings",
		display_name = "loc_settings_menu_group_combat_feed_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		display_name = "loc_setting_combat_feed_enabled",
		id = "combat_feed_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_combat_feed_enabled", value)
		end
	},
	{
		step_size_value = 1,
		min_value = 4,
		display_name = "loc_setting_combat_feed_max_messages",
		num_decimals = 0,
		max_value = 12,
		default_value = 8,
		widget_type = "value_slider",
		id = "combat_feed_max_messages",
		save_location = "interface_settings",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_combat_feed_max_messages", value)
		end
	},
	{
		step_size_value = 1,
		min_value = 3,
		display_name = "loc_setting_combat_feed_message_duration",
		num_decimals = 0,
		max_value = 10,
		default_value = 5,
		widget_type = "value_slider",
		id = "combat_feed_message_duration",
		save_location = "interface_settings",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_combat_feed_message_duration", value)
		end
	},
	{
		group_name = "notification_settings",
		display_name = "loc_setting_menu_group_notification_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		display_name = "loc_setting_notification_assist_notification_type",
		id = "assist_notification_type",
		default_value = "notification",
		widget_type = "dropdown",
		options = _notification_options,
		on_value_changed = function (value)
			Managers.event:trigger("event_update_assist_notification_type", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_setting_notification_crafting_pickup_notification_type",
		id = "crafting_pickup_notification_type",
		default_value = "notification",
		widget_type = "dropdown",
		options = _notification_options,
		on_value_changed = function (value)
			Managers.event:trigger("event_update_crafting_pickup_notification_type", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_penance_unlock_chat_message_type",
		id = "penance_unlock_chat_message_type",
		default_value = "others",
		widget_type = "dropdown",
		options = {
			{
				display_name = "loc_setting_notification_type_none",
				name = "none"
			},
			{
				display_name = "loc_setting_notification_type_mine",
				name = "mine"
			},
			{
				display_name = "loc_setting_notification_type_others",
				name = "others"
			},
			{
				display_name = "loc_setting_notification_type_all",
				name = "all"
			}
		},
		on_value_changed = function (value)
			Managers.event:trigger("event_update_penance_unlock_chat_message_type", value)
		end
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_settings_voice_chat_visible_all_time_mouseover",
		display_name = "loc_interface_setting_voice_chat_visible_all_time",
		id = "voice_chat_visible_all_time",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("voice_chat_visible_setting_update", value)
		end,
		validation_function = function ()
			return not IS_PLAYSTATION
		end
	},
	{
		group_name = "subtitle_settings",
		display_name = "loc_settings_menu_group_subtitle_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_subtitle_enabled",
		id = "subtitle_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitles_enabled", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_subtitle_secondary_enabled",
		id = "secondary_subtitle_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_secondary_subtitles_enabled", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_subtitle_speaker_enabled",
		id = "subtitle_speaker_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitle_speaker_enabled", value)
		end
	},
	{
		save_location = "interface_settings",
		min_value = 0,
		display_name = "loc_interface_setting_subtitle_background_opacity",
		id = "subtitle_background_opacity",
		default_value = 60,
		widget_type = "percent_slider",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitles_background_opacity", value)
		end
	},
	{
		save_location = "interface_settings",
		min_value = 10,
		display_name = "loc_interface_setting_subtitle_text_opacity",
		id = "subtitle_text_opacity",
		default_value = 100,
		widget_type = "percent_slider",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitle_text_opacity", value)
		end
	},
	{
		step_size_value = 1,
		min_value = 12,
		display_name = "loc_interface_setting_subtitle_font_size",
		num_decimals = 0,
		max_value = 72,
		default_value = 32,
		widget_type = "value_slider",
		id = "subtitle_font_size",
		save_location = "interface_settings",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_subtitles_font_size", value)
		end
	},
	{
		step_size_value = 1,
		min_value = 12,
		display_name = "loc_interface_setting_subtitle_secondary_font_size",
		num_decimals = 0,
		max_value = 72,
		default_value = 28,
		widget_type = "value_slider",
		id = "secondary_subtitle_font_size",
		save_location = "interface_settings",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_secondary_subtitles_font_size", value)
		end
	},
	{
		group_name = "other_settings",
		display_name = "loc_settings_menu_group_accessibility_settings",
		widget_type = "group_header"
	},
	{
		step_size_value = 1,
		min_value = 50,
		display_name = "loc_interface_setting_hud_scale",
		max_value = 100,
		default_value = 100,
		widget_type = "percent_slider",
		id = "hud_scale",
		save_location = "interface_settings",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_hud_scale", value)
		end
	},
	{
		save_location = "interface_settings",
		min_value = 0,
		display_name = "loc_interface_setting_camera_sway_intensity",
		id = "camera_movement_offset_sway_intensity",
		default_value = 100,
		widget_type = "percent_slider"
	},
	{
		save_location = "interface_settings",
		min_value = 0,
		display_name = "loc_settings_menu_peril_effect",
		id = "warp_charge_effects_intensity",
		default_value = 100,
		widget_type = "percent_slider",
		on_value_changed = function (value)
			Wwise.set_parameter("psyker_overload_global", (value or 100) / 100)
			Application.set_user_setting("interface_settings", "psyker_overload_intensity", value)
			Application.save_user_settings()
		end
	},
	{
		group_name = "nameplate_settings",
		display_name = "loc_settings_menu_group_nameplate_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_interface_setting_nameplates_in_mission_mouseover",
		display_name = "loc_interface_setting_nameplates_in_mission",
		id = "character_nameplates_in_mission_type",
		default_value = "name_and_title",
		widget_type = "dropdown",
		options = {
			{
				display_name = "loc_setting_nameplates_in_mission_name_and_title",
				name = "name_and_title"
			},
			{
				display_name = "loc_setting_nameplates_in_mission_name",
				name = "name"
			},
			{
				display_name = "loc_setting_nameplates_in_mission_none",
				name = "none"
			}
		},
		on_value_changed = function (value)
			Managers.event:trigger("event_titles_in_mission_setting_changed", value)
		end
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_interface_setting_my_title_in_hub_mouseover",
		display_name = "loc_interface_setting_my_title_in_hub",
		id = "my_title_in_hub",
		default_value = false,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_titles_my_title_in_hub_setting_changed", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_title_color_type",
		id = "character_titles_color_type",
		default_value = "rarity_colors",
		widget_type = "dropdown",
		options = {
			{
				display_name = "loc_setting_title_color_type_rarities",
				name = "rarity_colors"
			},
			{
				display_name = "loc_setting_title_color_type_no_colors",
				name = "no_colors"
			}
		},
		on_value_changed = function (value)
			Managers.event:trigger("event_hub_title_color_type_changed", value)
			Managers.event:trigger("event_titles_my_title_in_hub_setting_changed", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_title_in_mission_color_type",
		id = "character_titles_in_mission_color_type",
		default_value = "rarity_colors",
		widget_type = "dropdown",
		options = {
			{
				display_name = "loc_setting_title_color_type_rarities",
				name = "rarity_colors"
			},
			{
				display_name = "loc_setting_title_color_type_no_colors",
				name = "no_colors"
			}
		},
		on_value_changed = function (value)
			Managers.event:trigger("event_in_mission_title_color_type_changed", "color_changed")
		end
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_interface_setting_companion_nameplate_in_mission_mouseover",
		display_name = "loc_interface_setting_companion_nameplate_in_mission",
		id = "companion_nameplate_in_mission_type",
		default_value = "mine_only",
		widget_type = "dropdown",
		options = {
			{
				display_name = "loc_setting_notification_type_all",
				name = "all"
			},
			{
				display_name = "loc_setting_notification_type_mine",
				name = "mine_only"
			},
			{
				display_name = "loc_setting_nameplates_in_mission_none",
				name = "none"
			}
		},
		on_value_changed = function (value)
			Managers.event:trigger("event_companion_nameplate_in_mission_setting_changed", value)
		end
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_interface_setting_companion_nameplate_in_hub_mouseover",
		display_name = "loc_interface_setting_companion_nameplate_in_hub",
		id = "companion_nameplate_in_hub_type",
		default_value = "mine_only",
		widget_type = "dropdown",
		options = {
			{
				display_name = "loc_setting_notification_type_all",
				name = "all"
			},
			{
				display_name = "loc_setting_notification_type_mine",
				name = "mine_only"
			},
			{
				display_name = "loc_setting_nameplates_in_mission_none",
				name = "none"
			}
		},
		on_value_changed = function (value)
			Managers.event:trigger("event_companion_nameplate_in_hub_setting_changed", value)
		end
	},
	{
		group_name = "other_settings",
		display_name = "loc_settings_menu_group_other_settings",
		widget_type = "group_header"
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_profanity_filter_enabled",
		id = "profanity_filter_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_update_profanity_filter_enabled", value)
		end
	},
	{
		save_location = "interface_settings",
		display_name = "loc_interface_setting_intro_cinematic_enabled",
		id = "intro_cinematic_enabled",
		use_local_save = true,
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			return
		end,
		validation_function = function ()
			return not IS_XBS and not IS_PLAYSTATION
		end
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_settings_portrait_rendering_mouseover",
		display_name = "loc_interface_setting_portrait_rendering_enabled",
		id = "portrait_rendering_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_portrait_render_change", value)
		end
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_interface_settings_flash_taskbar_mouseover",
		display_name = "loc_interface_setting_flash_taskbar_enabled",
		id = "flash_taskbar_enabled",
		default_value = true,
		widget_type = "boolean",
		validation_function = function ()
			return IS_WINDOWS
		end
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_settings_crossplay",
		display_name = "loc_interface_setting_crossplay_enabled",
		id = "crossplay_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_crossplay_change", value, "loc_settings_menu_category_interface", "crossplay_enabled")
		end,
		validation_function = function ()
			return IS_PLAYSTATION
		end
	},
	{
		save_location = "interface_settings",
		tooltip_text = "loc_interface_settings_telemetry_mouseover",
		display_name = "loc_interface_setting_telemetry_enabled",
		id = "telemetry_enabled",
		default_value = true,
		widget_type = "boolean",
		on_value_changed = function (value)
			Managers.event:trigger("event_telemetry_change", value)
		end,
		validation_function = function ()
			return IS_PLAYSTATION
		end
	}
}
local settings = {}

for i = 1, #settings_definitions do
	local definition = settings_definitions[i]
	local widget_type = definition.widget_type
	local template_function = template_functions[widget_type]

	if template_function then
		settings[#settings + 1] = template_function(definition)
		settings[#settings].id = definition.id
	else
		settings[#settings + 1] = definition
	end
end

SettingsUtilities = SettingsUtilitiesFunction(settings)

return {
	icon = "content/ui/materials/icons/system/settings/category_interface",
	display_name = "loc_settings_menu_category_interface",
	settings_utilities = SettingsUtilities,
	settings_by_id = SettingsUtilities.settings_by_id,
	settings = settings
}
