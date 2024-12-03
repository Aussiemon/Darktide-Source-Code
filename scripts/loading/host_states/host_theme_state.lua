-- chunkname: @scripts/loading/host_states/host_theme_state.lua

local CircumstanceTemplates = require("scripts/settings/circumstance/circumstance_templates")
local Havoc = require("scripts/utilities/havoc")
local ThemePackage = require("scripts/foundation/managers/package/utilities/theme_package")
local ThemeStateTestify = GameParameters.testify and require("scripts/loading/host_states/theme_state_testify")
local HostThemeState = class("HostThemeState")

local function _apply_theme(world, themes, level_name, theme_tag, circumstance_name)
	local theme_names = ThemePackage.level_resource_dependency_packages(level_name, theme_tag)

	if GameParameters.testify and circumstance_name then
		Testify:poll_requests_through_handler(ThemeStateTestify, theme_names, level_name, circumstance_name)
	end

	for _, theme_name in pairs(theme_names) do
		local theme = World.create_theme(world, theme_name)

		themes[#themes + 1] = theme
	end
end

HostThemeState.init = function (self, state_machine, shared_state)
	self._shared_state = shared_state
	self._level_spawner = nil

	local world = shared_state.world

	self._world = world

	local themes = shared_state.themes
	local havoc_data = shared_state.havoc_data

	if havoc_data then
		local parsed_data = Havoc.parse_data(havoc_data)
		local theme_tag = parsed_data.theme
		local level_name = shared_state.level_name
		local theme_names = ThemePackage.level_resource_dependency_packages(level_name, theme_tag)

		for _, theme_name in pairs(theme_names) do
			local theme = World.create_theme(world, theme_name)

			themes[#themes + 1] = theme
		end

		return
	end

	local circumstance_name = shared_state.circumstance_name

	if circumstance_name then
		local level_name = shared_state.level_name
		local circumstance_template = CircumstanceTemplates[circumstance_name]
		local theme_tag = circumstance_template.theme_tag
		local theme_names = ThemePackage.level_resource_dependency_packages(level_name, theme_tag)

		if GameParameters.testify then
			Testify:poll_requests_through_handler(ThemeStateTestify, theme_names, level_name, circumstance_name)
		end

		for _, theme_name in pairs(theme_names) do
			local theme = World.create_theme(world, theme_name)

			themes[#themes + 1] = theme
		end
	else
		Log.error("HostThemeState", "[init] 'default' circumstance name is not provided. %s", Script.callstack())
	end
end

HostThemeState.update = function (self, dt)
	return "load_done"
end

return HostThemeState
