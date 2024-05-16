-- chunkname: @scripts/managers/stats/utility/stat_config_parser.lua

local StatConfigs = require("scripts/settings/stats/stat_configs")
local StatConfigParser = {}

StatConfigParser.validate = function (config_type, config)
	local template = StatConfigs[config_type]

	if template == nil then
		return string.format("No config of type '%s'.", config_type)
	end

	if type(config) ~= "table" then
		return "config must be a table"
	end

	for name, data in pairs(template) do
		if data.required and config[name] == nil then
			return string.format("'%s' is required but wasn't defined.", name)
		end
	end

	for name, _ in pairs(config) do
		if template[name] == nil then
			return string.format("'%s' is defined in config but not in template.", name)
		end
	end
end

StatConfigParser.modify = function (config_type, config, optional_old_config)
	local config_error = StatConfigParser.validate(config_type, config)

	if config_error then
		return nil, config_error
	end

	local template = StatConfigs[config_type]

	for name, data in pairs(template) do
		if data.default ~= nil and config[name] == nil then
			config[name] = data.default
		end

		if optional_old_config and data.inherit then
			config[name] = optional_old_config[name]
		end
	end

	return config, nil
end

return StatConfigParser
