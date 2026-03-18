-- chunkname: @scripts/managers/imgui/imgui_settings.lua

local IS_RELEASE = BUILD == "release"
local view_groups = {}

view_groups.StateGame = {}
view_groups.GameplayStateRun = {}
view_groups.ImguiManager = {
	{
		name = "Lua Memory Snapshot",
		require = "scripts/managers/imgui/guis/imgui_lua_memory_snapshot",
		flags = {
			"always_auto_resize",
		},
	},
}

local imgui_settings = {
	view_groups = view_groups,
}

return settings("ImguiSettings", imgui_settings)
