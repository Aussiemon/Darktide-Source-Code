-- chunkname: @scripts/settings/smart_tag/double_tag_settings.lua

local double_tag_settings = {}

local function _create_entry(archetype_name, path)
	double_tag_settings[archetype_name] = require(path)
end

_create_entry("adamant", "scripts/settings/smart_tag/double_tag/adamant_double_tag_settings")
_create_entry("cryptic", "scripts/settings/smart_tag/double_tag/cryptic_double_tag_settings")

return settings("DoubleTagSettings", double_tag_settings)
