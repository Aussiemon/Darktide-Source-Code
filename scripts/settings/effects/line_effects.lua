local line_effects = {}

local function _include_effects(template_path)
	local effects = require(template_path)

	for name, effect in pairs(effects) do
		line_effects[name] = effect
	end
end

_include_effects("scripts/settings/effects/minion_line_effects")
_include_effects("scripts/settings/effects/player_line_effects")

for name, data in pairs(line_effects) do
	data.name = name
end

return line_effects
