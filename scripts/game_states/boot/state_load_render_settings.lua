require("scripts/game_states/boot/state_boot_sub_state_base")

local render_settings = require("scripts/settings/options/render_settings")
local StateLoadRenderSettings = class("StateLoadRenderSettings", "StateBootSubStateBase")

StateLoadRenderSettings._state_update = function (self, dt)
	local settings = render_settings.settings

	self:_apply_render_settings(settings)

	local error = false
	local done = true

	return done, error
end

StateLoadRenderSettings._apply_render_settings = function (self, settings)
	if not DEDICATED_SERVER then
		for _, setting in ipairs(settings) do
			if setting.pages then
				for i = 1, #setting.pages do
					local page_setting = setting.pages[i].entries

					self:_apply_render_settings(page_setting)
				end
			end

			local valid = not setting.validation_function or setting:validation_function()

			if valid then
				local apply_on_startup = setting.apply_on_startup

				if apply_on_startup then
					local get_function = setting.get_function

					if get_function then
						local value = get_function(setting)

						if value ~= nil then
							local on_activated = setting.on_activated

							if on_activated then
								on_activated(value, setting)
							end
						end
					end
				end
			end
		end
	end
end

return StateLoadRenderSettings
