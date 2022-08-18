local Promise = require("scripts/foundation/utilities/promise")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local GameSettings = class("GameSettings")
local game_settings_path = "/game-settings"

GameSettings.init = function (self)
	return
end

GameSettings.get = function (self)
	return Managers.backend:title_request(BackendUtilities.url_builder(game_settings_path):to_string()):next(function (data)
		return data.body
	end)
end

GameSettings.resolve_backend_game_settings = function (self)
	return self:get():next(function (data)
		local parsed = {}

		for param, value in pairs(data.properties) do
			local parsed_value = nil

			if value.S then
				parsed_value = value.S
			elseif value.N then
				parsed_value = tonumber(value.N)
			elseif value.B then
				parsed_value = value.B == "true"
			end

			parsed[param] = parsed_value
		end

		ParameterResolver.resolve_dynamic_game_parameters(parsed)

		return nil
	end)
end

return GameSettings
