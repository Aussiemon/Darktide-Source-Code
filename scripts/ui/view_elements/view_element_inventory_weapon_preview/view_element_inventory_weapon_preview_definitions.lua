-- chunkname: @scripts/ui/view_elements/view_element_inventory_weapon_preview/view_element_inventory_weapon_preview_definitions.lua

local UIWidget = require("scripts/managers/ui/ui_widget")
local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen
}
local widget_definitions = {}
local anim_start_delay = 0
local animations = {
	on_enter = {
		{
			name = "init",
			end_time = 0,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, params)
				parent._alpha_multiplier = 0
			end
		},
		{
			name = "fade_in",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.5,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeOutCubic(progress)

				parent._alpha_multiplier = anim_progress
			end
		},
		{
			name = "experience_bar",
			start_time = anim_start_delay + 0,
			end_time = anim_start_delay + 0.7,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, params)
				local anim_progress = math.easeCubic(progress)
			end
		}
	}
}

return {
	animations = animations,
	background_widget_definition = UIWidget.create_definition({
		{
			pass_type = "rect",
			style = {
				offset = {
					0,
					0,
					0
				},
				color = Color.black(30, true)
			}
		}
	}, "screen"),
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
