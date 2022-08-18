local function syntax_check(game_mode_settings, file_name)
	local name = game_mode_settings.name

	fassert(name, "Game Mode Settings from %q needs a name.", file_name)
	fassert(game_mode_settings.class_file_name, "Game Mode %q is missing a class_file_name.", name)
	fassert(game_mode_settings.side_compositions, "Game Mode %q is missing side_compositions.", name)
	fassert(game_mode_settings.states, "Game Mode %q is missing states.", name)
	fassert(game_mode_settings.use_side_color ~= nil, "Game Mode %q is missing use_side_color setting.", name)
end

return syntax_check
