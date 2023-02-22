local SaveData = class("SaveData")
local default_hold = PLATFORM == "win32"
SaveData.default_account_data = {
	input_settings = {
		controller_layout = "default",
		controller_look_scale = 1,
		controller_enable_acceleration = true,
		mouse_invert_look_y = false,
		com_wheel_delay = 0.3,
		controller_look_dead_zone = 0.1,
		mouse_look_scale = 1,
		controller_invert_look_y = false,
		stationary_dodge = false,
		diagonal_forward_dodge = true,
		hold_to_sprint = default_hold,
		hold_to_crouch = default_hold
	},
	interface_settings = {
		subtitle_background_opacity = 60,
		subtitle_enabled = true,
		subtitle_font_size = 32,
		news_enabled = true,
		subtitle_text_opacity = 100,
		camera_movement_offset_sway_intensity = 100,
		subtitle_speaker_enabled = true,
		profanity_filter_enabled = true
	},
	completed_profile_prologues = {},
	viewed_news_slides = {},
	key_bindings = {},
	character_data = {}
}
SaveData.default_character_data = {
	new_items = {},
	new_items_by_type = {},
	new_item_notifications = {},
	new_completed_contracts = {},
	new_unlocked_talent_groups = {},
	profile_presets = {
		intro_presented = true,
		loadout = {},
		talents = {}
	},
	favorite_items = {}
}

SaveData.init = function (self)
	self.save_loaded = false
	self.version = 3
	self.account_data_version = 3
	self.data = {
		account_data = {}
	}
end

SaveData.populate = function (self, save_data)
	if save_data then
		local version_match = self.version == save_data.version

		if version_match then
			local data = save_data.data

			if self.account_data_version == save_data.account_data_version then
				for account_id, account_data in pairs(data.account_data) do
					local new_data = table.clone(SaveData.default_account_data)
					data.account_data[account_id] = table.merge_recursive(new_data, account_data)
				end
			else
				for account_id, account_data in pairs(data.account_data) do
					local new_data = table.clone(SaveData.default_account_data)
					local saved_input_settings = account_data.input_settings
					local new_input_settings = new_data.input_settings

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

	if IS_XBS then
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
