﻿-- chunkname: @scripts/managers/save/save_data.lua

local SaveData = class("SaveData")
local default_hold = PLATFORM == "win32"

SaveData.default_account_data = {
	crossplay_accepted = false,
	latest_backend_migration_index = -1,
	profile_preset_intro_presented = false,
	input_settings = {
		always_dodge = false,
		com_wheel_delay = 0.3,
		com_wheel_double_tap = "none",
		com_wheel_single_tap = "none",
		controller_aim_assist = "new_full",
		controller_enable_acceleration = true,
		controller_invert_look_y = false,
		controller_layout = "default",
		controller_look_dead_zone = 0.1,
		controller_look_scale = 1,
		controller_look_scale_ranged = 1,
		controller_look_scale_ranged_alternate_fire = 1,
		controller_look_scale_vertical = 1,
		controller_look_scale_vertical_ranged = 1,
		controller_look_scale_vertical_ranged_alternate_fire = 1,
		controller_response_curve = "linear",
		controller_response_curve_ranged = "linear",
		controller_response_curve_strength = 50,
		controller_response_curve_strength_ranged = 50,
		diagonal_forward_dodge = true,
		mouse_invert_look_y = false,
		mouse_look_scale = 1,
		mouse_look_scale_ranged = 1,
		mouse_look_scale_ranged_alternate_fire = 1,
		rumble_enabled = true,
		rumble_intensity = 50,
		rumble_intensity_gameplay = 100,
		rumble_intensity_immersive = 100,
		stationary_dodge = false,
		toggle_ads = false,
		weapon_switch_scroll_wrap = true,
		hold_to_sprint = default_hold,
		hold_to_crouch = default_hold,
	},
	interface_settings = {
		aim_trajectory_enabled = true,
		assist_notification_type = "notification",
		camera_movement_offset_sway_intensity = 100,
		character_nameplates_in_mission_type = "name_and_title",
		character_titles_color_type = "rarity_colors",
		character_titles_in_mission_color_type = "rarity_colors",
		combat_feed_enabled = true,
		combat_feed_max_messages = 8,
		combat_feed_message_duration = 5,
		crafting_pickup_notification_type = "notification",
		crosshair_enabled = true,
		crosshair_type_override = "weapon",
		crossplay_enabled = true,
		forced_dot_crosshair_enabled = false,
		group_buff_icon_in_categories = true,
		hit_indicator_duration = 0.5,
		hit_indicator_enabled = true,
		input_hints_enabled = true,
		my_title_in_hub = false,
		news_enabled = true,
		penance_list_setting_show_list_view = false,
		penance_unlock_chat_message_type = "none",
		portrait_rendering_enabled = true,
		profanity_filter_enabled = true,
		secondary_subtitle_enabled = true,
		secondary_subtitle_font_size = 24,
		show_aura_buff_icons = true,
		subtitle_background_opacity = 60,
		subtitle_enabled = true,
		subtitle_font_size = 32,
		subtitle_speaker_enabled = true,
		subtitle_text_opacity = 100,
		telemetry_enabled = true,
		voice_chat_visible_all_time = true,
		warp_charge_effects_intensity = 100,
		flash_taskbar_enabled = IS_WINDOWS,
	},
	completed_profile_prologues = {},
	viewed_news_slides = {},
	key_bindings = {},
	character_data = {},
	new_account_items_by_archetype = {},
	favorite_achievements = {},
	selected_sort_options = {},
}
SaveData.default_character_data = {
	new_items = {},
	new_items_by_type = {},
	new_item_notifications = {},
	new_completed_contracts = {},
	view_settings = {},
	profile_presets = {
		profile_presets_version = 1,
	},
	favorite_items = {},
	group_finder_search_tags = {},
}

SaveData.init = function (self)
	self.save_loaded = false
	self.version = 3
	self.account_data_version = 3
	self.data = {
		account_data = {},
	}
end

SaveData.populate = function (self, save_data)
	Log.info("SaveData", "Populating save data.")

	if save_data then
		local version_match = self.version == save_data.version

		if version_match then
			local data = save_data.data

			if self.account_data_version == save_data.account_data_version then
				for account_id, account_data in pairs(data.account_data) do
					local new_data = table.clone(SaveData.default_account_data)

					data.account_data[account_id] = table.merge_recursive(new_data, account_data)

					local character_data = data.account_data[account_id].character_data

					if character_data then
						local default_character_data = SaveData.default_character_data

						for character_id, character_id_data in pairs(character_data) do
							if not character_id_data.view_settings then
								character_id_data.view_settings = table.clone_instance(default_character_data.view_settings)
							end

							if not character_id_data.group_finder_search_tags then
								character_id_data.group_finder_search_tags = table.clone_instance(default_character_data.group_finder_search_tags)
							end

							local profile_presets = character_id_data.profile_presets
							local incorrect_profile_presets_version = not profile_presets or profile_presets.profile_presets_version ~= default_character_data.profile_presets.profile_presets_version

							Log.info("SaveData", "Current saved profile preset version for character (%s) is: %s. Our default is: %s", tostring(character_id), tostring(profile_presets and profile_presets.profile_presets_version), tostring(default_character_data.profile_presets.profile_presets_version))

							if incorrect_profile_presets_version then
								Log.info("SaveData", "Clearing out profile presets for for character (%s)", tostring(character_id))

								character_id_data.active_profile_preset_id = nil
								character_id_data.profile_presets = table.clone_instance(default_character_data.profile_presets)
							end
						end
					end
				end
			else
				Log.info("SaveData", "Incorrect account data version is being used: %s. The new one is: %s ", tostring(save_data.account_data_version), tostring(self.account_data_version))

				for account_id, account_data in pairs(data.account_data) do
					local new_data = table.clone(SaveData.default_account_data)
					local saved_input_settings, new_input_settings = account_data.input_settings, new_data.input_settings

					for setting, default_value in pairs(new_input_settings) do
						local saved_value = saved_input_settings[setting]

						if saved_value ~= nil then
							new_input_settings[setting] = saved_value
						end
					end

					data.account_data[account_id] = new_data
				end
			end

			self.data = data
		else
			Log.info("SaveData", "Wrong version for save file, saved: %q current: %q", save_data.version, self.version)
		end
	end

	if IS_XBS or IS_PLAYSTATION then
		if self.data.user_settings then
			UserSettings = self.data.user_settings
		else
			self.data.user_settings = UserSettings
		end
	end

	self.save_loaded = true
end

SaveData.account_data = function (self, account_id)
	local account_data = self.data.account_data[account_id]

	if account_data then
		return account_data
	else
		account_data = table.clone(SaveData.default_account_data)
		self.data.account_data[account_id] = account_data

		return account_data
	end
end

SaveData.character_data = function (self, account_id, character_id)
	local account_data = self:account_data(account_id)
	local character_data = account_data.character_data

	if character_data[character_id] then
		return character_data[character_id]
	else
		character_data[character_id] = table.clone(SaveData.default_character_data)

		return character_data[character_id]
	end
end

return SaveData
