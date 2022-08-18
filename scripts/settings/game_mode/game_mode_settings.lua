local game_mode_settings = {}
local default_settings = {}

local function _add_game_mode_settings(file_name)
	local settings = require(file_name)

	for name, value in pairs(default_settings) do
		if not settings[name] then
			if type(value) == "table" then
				settings[name] = table.clone(value)
			else
				settings[name] = value
			end
		end
	end

	local side_compositions = settings.side_compositions

	for i = 1, #side_compositions do
		local definition = side_compositions[i]
		local name = definition.name
		local relations = definition.relations
		local allied_relations = relations.allied

		if not allied_relations then
			allied_relations = {}
			relations.allied = allied_relations
		end

		if not table.array_contains(allied_relations, name) then
			allied_relations[#allied_relations + 1] = name
		end
	end

	local hotkeys = settings.hotkeys

	if hotkeys then
		local hotkey_lookup = {}

		for hotkey, view_name in pairs(hotkeys) do
			hotkey_lookup[view_name] = hotkey
		end

		local hotkey_settings = {
			hotkeys = hotkeys,
			lookup = hotkey_lookup
		}
		settings.hotkeys = hotkey_settings
	end

	local game_mode_name = settings.name
	game_mode_settings[game_mode_name] = settings
end

_add_game_mode_settings("scripts/settings/game_mode/game_mode_settings_coop_complete_objective")
_add_game_mode_settings("scripts/settings/game_mode/game_mode_settings_default")
_add_game_mode_settings("scripts/settings/game_mode/game_mode_settings_hub")
_add_game_mode_settings("scripts/settings/game_mode/game_mode_settings_prologue")

game_mode_settings.hub_singleplay = table.clone(game_mode_settings.hub)
game_mode_settings.hub_singleplay.name = "hub_singleplay"
game_mode_settings.hub_singleplay.host_singleplay = true

return settings("GameModeSettings", game_mode_settings)
