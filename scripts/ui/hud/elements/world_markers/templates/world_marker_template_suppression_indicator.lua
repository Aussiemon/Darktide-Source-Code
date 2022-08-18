local UIWidget = require("scripts/managers/ui/ui_widget")
local template = {}
local size = {
	16,
	16
}
local DEFAULT_BACKGROUND = "content/ui/vector_textures/hud/circle_full"
local DEFAULT_ICON = "content/ui/vector_textures/hud/icon_objective_warning"
local DEFAULT_COLOR = {
	85,
	255,
	70,
	15
}
template.size = size
template.name = "suppression_indicator"
template.unit_node = "j_head"
template.position_offset = {
	0,
	0,
	0.4
}
template.check_line_of_sight = true
template.max_distance = 200
template.screen_clamp = false
template.remove_on_death_duration = 1

template.create_widget_defintion = function (template, scenegraph_id)
	local size = template.size

	return UIWidget.create_definition({
		{
			value_id = "background",
			pass_type = "slug_icon",
			value = DEFAULT_BACKGROUND,
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = size,
				color = DEFAULT_COLOR
			}
		},
		{
			value_id = "icon",
			pass_type = "slug_icon",
			value = DEFAULT_ICON,
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = size,
				color = DEFAULT_COLOR
			}
		}
	}, scenegraph_id)
end

template.on_enter = function (widget, marker, template)
	local content = widget.content
	local unit = marker.unit
	local unit_data_extension = ScriptUnit.extension(unit, "unit_data_system")
	local breed = unit_data_extension:breed()

	fassert(breed, "No breed found for a suppressable unit: %s", tostring(unit))

	local breed_marker_icon = breed.suppress_config and breed.suppress_config.marker_icon

	if breed_marker_icon then
		content.icon = breed_marker_icon
	end
end

template.update_function = function (parent, ui_renderer, widget, marker, template, dt, t)
	local unit = marker.unit

	if not HEALTH_ALIVE[unit] then
		marker.remove = true

		return
	end
end

return template
