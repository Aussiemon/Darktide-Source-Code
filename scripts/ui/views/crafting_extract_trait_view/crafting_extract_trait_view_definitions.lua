-- chunkname: @scripts/ui/views/crafting_extract_trait_view/crafting_extract_trait_view_definitions.lua

local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local weapon_stats_context = CraftingSettings.weapon_stats_context
local weapon_stats_grid_size = weapon_stats_context.grid_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		horizontal_alignment = "center",
		parent = "screen",
		vertical_alignment = "center",
		size = {
			1920,
			1080,
		},
		position = {
			0,
			0,
			0,
		},
	},
	weapon_stats_pivot = {
		horizontal_alignment = "right",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			0,
			0,
		},
		position = {
			-(weapon_stats_grid_size[1] + 110),
			-110,
			3,
		},
	},
	crafting_recipe_pivot = {
		horizontal_alignment = "left",
		parent = "canvas",
		vertical_alignment = "bottom",
		size = {
			430,
			400,
		},
		position = {
			110,
			-195,
			1,
		},
	},
}
local widget_definitions = {}
local animations = {
	on_enter = {
		{
			end_time = 0.6,
			name = "fade_in",
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent._render_settings.alpha_multiplier = 0

				for i = 1, #widgets do
					local widget = widgets[i]

					widget.alpha_multiplier = 0
				end
			end,
		},
		{
			end_time = 0.8,
			name = "move",
			start_time = 0.35,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				return
			end,
			update = function (parent, ui_scenegraph, scenegraph_definition, widgets, progress, parent)
				local anim_progress = math.easeOutCubic(progress)

				for i = 1, #widgets do
					local widget = widgets[i]

					widget.alpha_multiplier = anim_progress
				end

				parent._render_settings.alpha_multiplier = anim_progress

				local x_anim_distance_max = 50
				local x_anim_distance = x_anim_distance_max - x_anim_distance_max * anim_progress

				parent:_set_scenegraph_position("crafting_recipe_pivot", scenegraph_definition.crafting_recipe_pivot.position[1] - x_anim_distance)
				parent:_set_scenegraph_position("weapon_stats_pivot", scenegraph_definition.weapon_stats_pivot.position[1] + x_anim_distance)
				parent:_force_update_scenegraph()
			end,
		},
	},
}

return {
	animations = animations,
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
}
