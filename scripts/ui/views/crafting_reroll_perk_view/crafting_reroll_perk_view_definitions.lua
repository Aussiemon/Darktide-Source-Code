local UIWorkspaceSettings = require("scripts/settings/ui/ui_workspace_settings")
local CraftingSettings = require("scripts/settings/item/crafting_settings")
local weapon_stats_context = CraftingSettings.weapon_stats_context
local weapon_stats_grid_size = weapon_stats_context.grid_size
local scenegraph_definition = {
	screen = UIWorkspaceSettings.screen,
	canvas = {
		vertical_alignment = "center",
		parent = "screen",
		horizontal_alignment = "center",
		size = {
			1920,
			1080
		},
		position = {
			0,
			0,
			0
		}
	},
	weapon_stats_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "right",
		size = {
			0,
			0
		},
		position = {
			-(weapon_stats_grid_size[1] + 110),
			-110,
			3
		}
	},
	crafting_recipe_pivot = {
		vertical_alignment = "bottom",
		parent = "canvas",
		horizontal_alignment = "left",
		size = {
			430,
			400
		},
		position = {
			110,
			-195,
			1
		}
	}
}
local widget_definitions = {}
local animations = {
	on_enter = {
		{
			name = "fade_in",
			end_time = 0.6,
			start_time = 0,
			init = function (parent, ui_scenegraph, scenegraph_definition, widgets, parent)
				parent._render_settings.alpha_multiplier = 0

				for i = 1, #widgets do
					local widget = widgets[i]
					widget.alpha_multiplier = 0
				end
			end
		},
		{
			name = "move",
			end_time = 0.8,
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
			end
		}
	}
}

return {
	animations = animations,
	widget_definitions = widget_definitions,
	scenegraph_definition = scenegraph_definition
}
