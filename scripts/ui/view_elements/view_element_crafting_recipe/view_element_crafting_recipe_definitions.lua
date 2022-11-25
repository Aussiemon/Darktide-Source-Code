local UIWidget = require("scripts/managers/ui/ui_widget")
local scenegraph_definition = {
	grid_divider_top_border = {
		vertical_alignment = "top",
		parent = "grid_divider_top",
		horizontal_alignment = "center",
		size = {
			480,
			140
		},
		position = {
			0,
			-100,
			12
		}
	},
	crafting_recipe_background = {
		vertical_alignment = "top",
		parent = "grid_divider_top_border",
		horizontal_alignment = "center",
		size = {
			890,
			620
		},
		position = {
			5,
			-400,
			-50
		}
	}
}
local widget_definitions = {
	grid_background = UIWidget.create_definition({
		{
			value = "content/ui/materials/backgrounds/terminal_basic",
			pass_type = "texture",
			style = {
				vertical_alignment = "center",
				scale_to_material = true,
				horizontal_alignment = "center",
				size_addition = {
					18,
					16
				},
				color = Color.terminal_grid_background(255, true)
			}
		},
		{
			style_id = "crafting_recipe_background",
			scenegraph_id = "crafting_recipe_background",
			pass_type = "texture",
			value = "content/ui/materials/effects/crafting_recipe_background",
			style = {
				material_values = {
					intensity = 0,
					intensity_boost = 0
				}
			}
		}
	}, "grid_background"),
	grid_divider_top = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/crafting_recipe_top",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "top"
			}
		},
		{
			value_id = "texture_effect",
			style_id = "texture_effect",
			pass_type = "texture",
			value = "content/ui/materials/effects/crafting_recipe_top_candles",
			style = {
				vertical_alignment = "top",
				horizontal_alignment = "center",
				offset = {
					0,
					0,
					1
				}
			}
		}
	}, "grid_divider_top_border"),
	grid_divider_bottom = UIWidget.create_definition({
		{
			value_id = "texture",
			style_id = "texture",
			pass_type = "texture",
			value = "content/ui/materials/frames/item_info_lower",
			style = {
				horizontal_alignment = "center",
				vertical_alignment = "center"
			}
		}
	}, "grid_divider_bottom")
}
local animations = {}
animations.on_enter = {
	{
		name = "intensity",
		end_time = 0.75,
		start_time = 0,
		update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
			widgets.grid_background.style.crafting_recipe_background.material_values.intensity = math.ease_sine(progress)
		end
	}
}
animations.on_craft = {
	{
		name = "intensity_boost_increase",
		end_time = 0.5,
		start_time = 0,
		update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
			widgets.grid_background.style.crafting_recipe_background.material_values.intensity_boost = math.ease_sine(progress)
		end
	},
	{
		name = "intensity_boost_decrease",
		end_time = 4,
		start_time = 1,
		update = function (parent, ui_scenegraph, _scenegraph_definition, widgets, progress, params)
			widgets.grid_background.style.crafting_recipe_background.material_values.intensity_boost = 1 - math.ease_sine(progress)
		end
	}
}

return {
	scenegraph_definition = scenegraph_definition,
	widget_definitions = widget_definitions,
	animations = animations
}
