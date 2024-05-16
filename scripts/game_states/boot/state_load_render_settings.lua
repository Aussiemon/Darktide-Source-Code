-- chunkname: @scripts/game_states/boot/state_load_render_settings.lua

require("scripts/game_states/boot/state_boot_sub_state_base")

local render_options = require("scripts/settings/options/render_settings")
local StateLoadRenderSettings = class("StateLoadRenderSettings", "StateBootSubStateBase")

local function sort_function(setting_a, setting_b)
	local prio_a = setting_a.startup_prio or math.huge
	local prio_b = setting_b.startup_prio or math.huge

	return prio_a < prio_b
end

StateLoadRenderSettings._state_update = function (self, dt)
	local render_settings = render_options.settings
	local settings = {
		render_settings,
	}

	for i = 1, #settings do
		local setting = settings[i]
		local settings_to_run = {}

		self:_check_settings_to_tun(setting, settings_to_run)
		table.sort(settings_to_run, sort_function)

		for i = 1, #settings_to_run do
			local setting = settings_to_run[i]
			local value = setting.get_function(setting)

			setting.on_activated(value, setting)
		end

		self:_verify_disabled_status(setting)
	end

	local error = false
	local done = true

	return done, error
end

StateLoadRenderSettings._check_settings_to_tun = function (self, settings, settings_to_run)
	if not DEDICATED_SERVER then
		for _, setting in ipairs(settings) do
			if setting.pages then
				for i = 1, #setting.pages do
					local page_setting = setting.pages[i].entries

					self:_check_settings_to_tun(page_setting, settings_to_run)
				end
			end

			local apply_on_startup = setting.apply_on_startup

			if apply_on_startup then
				local valid = not setting.validation_function or setting.validation_function(setting)

				if valid then
					local get_function = setting.get_function

					if get_function then
						local value = get_function(setting)

						if value ~= nil then
							local on_activated = setting.on_activated

							if on_activated then
								settings_to_run[#settings_to_run + 1] = setting
							end
						end
					end
				end
			end
		end
	end
end

StateLoadRenderSettings._verify_disabled_status = function (self, settings)
	if not DEDICATED_SERVER then
		local valid_disables = {}

		for i = 1, #settings do
			local setting = settings[i]

			if setting.disable_rules and setting.get_function then
				local value = setting:get_function(setting)

				for i = 1, #setting.disable_rules do
					local disable_rule = setting.disable_rules[i]

					if disable_rule.validation_function and disable_rule.validation_function(value) and (not valid_disables[disable_rule.id] or not valid_disables[disable_rule.id][setting.id]) then
						valid_disables[disable_rule.id] = valid_disables[disable_rule.id] or {}
						valid_disables[disable_rule.id][setting.id] = disable_rule
					end
				end
			end
		end

		for i = 1, #settings do
			local setting = settings[i]
			local id = setting.id

			if setting.get_function and valid_disables[id] then
				local value = setting:get_function(setting)

				for origin_id, disable_rule in pairs(valid_disables[id]) do
					if disable_rule.disable_value == value then
						setting.disabled = true
						setting.disabled_by = setting.disabled_by or {}
						setting.disabled_by[origin_id] = disable_rule.reason
						setting.value_on_enabled = setting.value_on_enabled or value
					end
				end
			end
		end
	end
end

return StateLoadRenderSettings
