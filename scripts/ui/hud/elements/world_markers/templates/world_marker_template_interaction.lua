-- chunkname: @scripts/ui/hud/elements/world_markers/templates/world_marker_template_interaction.lua

local UIFontSettings = require("scripts/managers/ui/ui_font_settings")
local UIWidget = require("scripts/managers/ui/ui_widget")
local ColorUtilities = require("scripts/utilities/ui/colors")
local InputUtils = require("scripts/managers/input/input_utils")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local USE_HDR = true
local template = {}
local size = {
	128,
	128
}
local ping_size = {
	128,
	128
}
local arrow_size = {
	128,
	128
}
local icon_size = {
	64,
	64
}
local background_size = {
	128,
	128
}
local line_size = {
	250,
	5
}
local bar_size = {
	210,
	10
}
local scale_fraction = 0.75

template.size = size
template.unit_node = "ui_interaction_marker"
template.icon_size = icon_size
template.ping_size = ping_size
template.min_size = {
	size[1] * scale_fraction,
	size[2] * scale_fraction
}
template.max_size = {
	size[1],
	size[2]
}
template.icon_min_size = {
	icon_size[1] * scale_fraction,
	icon_size[2] * scale_fraction
}
template.icon_max_size = {
	icon_size[1],
	icon_size[2]
}
template.background_min_size = {
	background_size[1] * scale_fraction,
	background_size[2] * scale_fraction
}
template.background_max_size = {
	background_size[1],
	background_size[2]
}
template.ping_min_size = {
	ping_size[1] * scale_fraction,
	ping_size[2] * scale_fraction
}
template.ping_max_size = {
	ping_size[1],
	ping_size[2]
}
template.name = "interaction"
template.using_smart_tag_system = true
template.check_line_of_sight = true
template.screen_clamp = true
template.evolve_distance = 1
template.max_distance = 15
template.line_of_sight_speed = 15
template.position_offset = {
	0,
	0,
	0
}
template.screen_margins = {
	down = 0.23148148148148148,
	up = 0.23148148148148148,
	left = 0.234375,
	right = 0.234375
}
template.scale_settings = {
	scale_to = 1,
	scale_from = 0.4,
	distance_max = template.max_distance,
	distance_min = template.evolve_distance
}
template.fade_settings = {
	fade_to = 1,
	fade_from = 0,
	default_fade = 1,
	distance_max = template.max_distance,
	distance_min = template.max_distance - template.evolve_distance * 2,
	easing_function = math.easeCubic
}

local template_visual_definitions = {
	default = {
		template_settings_overrides = {
			position_offset = {
				0,
				0,
				0
			}
		},
		colors = {
			background = Color.terminal_background(200, true),
			ring = {
				255,
				226,
				199,
				126
			},
			line = Color.ui_interaction_default(255, true),
			ping = Color.ui_terminal(200, true),
			arrow = Color.ui_interaction_default(255, true),
			icon = Color.ui_hud_green_super_light(255, true)
		},
		textures = {
			ping = "content/ui/materials/hud/interactions/frames/mission_tag",
			background = "content/ui/materials/hud/interactions/frames/mission_back",
			ring = "content/ui/materials/hud/interactions/frames/mission_top",
			icon = "content/ui/materials/hud/interactions/icons/default",
			line = "content/ui/materials/hud/interactions/frames/line",
			arrow = StrictNil
		}
	},
	pickup = {
		template_settings_overrides = {
			position_offset = {
				0,
				0,
				0.8
			}
		},
		colors = {
			background = Color.terminal_background(200, true),
			ring = {
				255,
				226,
				199,
				126
			},
			line = Color.ui_interaction_pickup(255, true),
			ping = Color.ui_terminal(200, true),
			arrow = Color.ui_hud_green_super_light(255, true),
			icon = Color.ui_hud_green_super_light(255, true)
		},
		textures = {
			ping = "content/ui/materials/hud/interactions/frames/mission_tag",
			background = "content/ui/materials/hud/interactions/frames/mission_back",
			ring = "content/ui/materials/hud/interactions/frames/mission_top",
			arrow = "content/ui/materials/hud/interactions/frames/direction",
			line = "content/ui/materials/hud/interactions/frames/line"
		}
	},
	point_of_interest = {
		template_settings_overrides = {
			position_offset = {
				0,
				0,
				0
			},
			min_size = {
				size[1] * scale_fraction * 1.5,
				size[2] * scale_fraction * 1.5
			},
			max_size = {
				size[1] * scale_fraction * 2,
				size[2] * scale_fraction * 2
			},
			icon_min_size = {
				icon_size[1] * scale_fraction * 1.5,
				icon_size[2] * scale_fraction * 1.5
			},
			icon_max_size = {
				icon_size[1] * scale_fraction * 2,
				icon_size[2] * scale_fraction * 2
			},
			background_min_size = {
				background_size[1] * 1,
				background_size[2] * 1
			},
			background_max_size = {
				background_size[1] * 1.25,
				background_size[2] * 1.25
			}
		},
		colors = {
			background = Color.terminal_background(200, true),
			ring = {
				255,
				226,
				199,
				126
			},
			line = Color.ui_interaction_point_of_interest(255, true),
			ping = Color.ui_terminal(200, true),
			arrow = Color.ui_hud_green_super_light(255, true),
			icon = Color.ui_hud_green_super_light(255, true)
		},
		textures = {
			ping = "content/ui/materials/hud/interactions/frames/point_of_interest_tag",
			background = "content/ui/materials/hud/interactions/frames/pickup_back",
			ring = "content/ui/materials/hud/interactions/frames/pickup_top",
			line = "content/ui/materials/hud/interactions/frames/line",
			arrow = StrictNil
		}
	},
	critical = {
		template_settings_overrides = {
			screen_clamp = true,
			check_line_of_sight = true,
			position_offset = {
				0,
				0,
				0
			},
			fade_settings = {
				fade_to = 1,
				fade_from = 0,
				default_fade = 1,
				distance_max = 5,
				distance_min = 5 - template.evolve_distance * 2,
				easing_function = math.easeCubic
			}
		},
		colors = {
			background = Color.terminal_background(200, true),
			ring = {
				255,
				226,
				199,
				126
			},
			line = Color.ui_interaction_default(255, true),
			ping = Color.ui_terminal(200, true),
			arrow = Color.ui_hud_green_super_light(255, true),
			icon = Color.ui_hud_green_super_light(255, true)
		},
		textures = {
			ping = "content/ui/materials/hud/interactions/frames/critical_tag",
			background = "content/ui/materials/hud/interactions/frames/mission_back",
			ring = "content/ui/materials/hud/interactions/frames/mission_top",
			arrow = "content/ui/materials/hud/interactions/frames/direction",
			line = "content/ui/materials/hud/interactions/frames/line"
		}
	},
	mission = {
		colors = {
			background = Color.ui_interaction_mission(200, true),
			ring = Color.ui_interaction_mission(255, true),
			line = Color.ui_interaction_mission(255, true),
			ping = Color.ui_terminal(200, true),
			arrow = Color.ui_hud_green_super_light(255, true),
			icon = Color.ui_hud_green_super_light(255, true)
		},
		textures = {
			ping = "content/ui/materials/hud/interactions/frames/mission_tag",
			background = "content/ui/materials/hud/interactions/frames/mission_back",
			ring = "content/ui/materials/hud/interactions/frames/mission_top",
			arrow = "content/ui/materials/hud/interactions/frames/direction",
			line = "content/ui/materials/hud/interactions/frames/line"
		}
	},
	player_interaction = {
		template_settings_overrides = {
			fade_settings = {
				fade_to = 1,
				fade_from = 0,
				default_fade = 1,
				distance_max = 7,
				distance_min = 7 - template.evolve_distance * 0.5,
				easing_function = math.easeCubic
			},
			position_offset = {
				0,
				0,
				0.8
			},
			background_min_size = {
				background_size[1] * 0.5,
				background_size[2] * 0.5
			},
			background_max_size = {
				background_size[1] * 0.75,
				background_size[2] * 0.75
			}
		},
		template_settings_overrides_by_breed = {
			human = {
				position_offset = {
					0,
					0,
					0.8
				}
			},
			ogryn = {
				position_offset = {
					0,
					0,
					0.3
				}
			},
			companion_dog = {
				position_offset = {
					0,
					0,
					0
				}
			}
		},
		colors = {
			background = Color.black(0, true),
			ring = Color.terminal_frame_hover(0, true),
			line = Color.ui_interaction_default(0, true),
			ping = Color.ui_terminal(0, true),
			arrow = Color.ui_interaction_default(0, true),
			icon = Color.terminal_text_body(0, true)
		},
		textures = {
			ping = "content/ui/materials/hud/interactions/frames/mission_tag",
			background = "content/ui/materials/hud/interactions/icons/default",
			ring = "content/ui/materials/hud/interactions/frames/mission_top",
			icon = "content/ui/materials/hud/interactions/icons/default",
			line = "content/ui/materials/hud/interactions/frames/line",
			arrow = StrictNil
		}
	},
	puzzle = {
		template_settings_overrides = {
			fade_settings = {
				fade_to = 1,
				fade_from = 0,
				default_fade = 1,
				distance_max = 5,
				distance_min = 5 - template.evolve_distance,
				easing_function = math.easeCubic
			},
			position_offset = {
				0,
				0,
				0
			}
		},
		colors = {
			background = Color.terminal_background(200, true),
			ring = {
				255,
				226,
				199,
				126
			},
			line = Color.ui_interaction_default(255, true),
			ping = Color.ui_terminal(200, true),
			arrow = Color.ui_interaction_default(255, true),
			icon = Color.ui_hud_green_super_light(255, true)
		},
		textures = {
			ping = "content/ui/materials/hud/interactions/frames/mission_tag",
			background = "content/ui/materials/hud/interactions/frames/mission_back",
			ring = "content/ui/materials/hud/interactions/frames/mission_top",
			icon = "content/ui/materials/hud/interactions/icons/default",
			line = "content/ui/materials/hud/interactions/frames/line",
			arrow = StrictNil
		}
	}
}

local function get_interactee_unit_breed(marker)
	local marker_unit = marker.unit
	local player = Managers.player:player_by_unit(marker_unit)

	if player then
		local breed_name = player:breed_name()

		return breed_name
	end

	local marker_unit_data_extension = ScriptUnit.has_extension(marker_unit, "unit_data_system")

	if marker_unit_data_extension then
		local breed_name = marker_unit_data_extension:breed_name()

		return breed_name
	end
end

local function setup_marker_by_interaction_type(widget, marker, ui_interaction_type)
	local content = widget.content
	local style = widget.style
	local visual_definition = template_visual_definitions[ui_interaction_type]
	local default_color = visual_definition.colors
	local default_textures = visual_definition.textures
	local template_settings_overrides = visual_definition.template_settings_overrides

	if template_settings_overrides then
		local new_template = table.clone(marker.template)

		marker.template = table.merge_recursive(new_template, template_settings_overrides)
	end

	local template_settings_overrides_by_breed = visual_definition.template_settings_overrides_by_breed

	if template_settings_overrides_by_breed then
		local breed_name = get_interactee_unit_breed(marker)
		local override_settings = breed_name and template_settings_overrides_by_breed[breed_name]

		if override_settings then
			local new_template = table.clone(marker.template)

			marker.template = table.merge_recursive(new_template, override_settings)
		end
	end

	for style_id, pass_style in pairs(style) do
		local color = default_color[style_id]

		if color then
			ColorUtilities.color_copy(color, pass_style.color or pass_style.text_color)
		end
	end

	for content_id, value in pairs(default_textures) do
		content[content_id] = value ~= StrictNil and value or nil
	end
end

template.get_smart_tag_id = function (marker)
	local unit = marker.unit
	local smart_tag_system = Managers.state.extension:system("smart_tag_system")

	if smart_tag_system:is_unit_tagged(unit) then
		local tag = smart_tag_system:unit_tag(unit)

		return tag:id()
	end
end

template.create_widget_defintion = function (self, scenegraph_id)
	local size = self.size
	local evolve_distance = self.evolve_distance

	return UIWidget.create_definition({
		{
			style_id = "background",
			value_id = "background",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/frames/point_of_interest_back",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = background_size,
				offset = {
					0,
					0,
					1
				},
				color = {
					150,
					80,
					80,
					80
				}
			},
			visibility_function = function (content, style)
				return content.background ~= nil
			end
		},
		{
			style_id = "ring",
			value_id = "ring",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/frames/point_of_interest_top",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = size,
				offset = {
					0,
					0,
					5
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			visibility_function = function (content, style)
				return content.ring ~= nil
			end
		},
		{
			style_id = "ping",
			value_id = "ping",
			pass_type = "rotated_texture",
			value = "content/ui/materials/hud/interactions/frames/point_of_interest_tag",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = ping_size,
				offset = {
					0,
					0,
					0
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			visibility_function = function (content, style)
				return content.tagged
			end
		},
		{
			style_id = "icon",
			value_id = "icon",
			pass_type = "texture",
			value = "content/ui/materials/hud/interactions/icons/default",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = icon_size,
				offset = {
					0,
					0,
					3
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			visibility_function = function (content, style)
				return content.icon ~= nil
			end
		},
		{
			value_id = "arrow",
			pass_type = "rotated_texture",
			value = "content/ui/materials/hud/interactions/icons/default",
			style_id = "arrow",
			style = {
				vertical_alignment = "center",
				horizontal_alignment = "center",
				size = arrow_size,
				offset = {
					0,
					0,
					2
				},
				color = {
					255,
					255,
					255,
					255
				}
			},
			visibility_function = function (content, style)
				return content.is_clamped and content.arrow ~= nil
			end,
			change_function = function (content, style)
				style.angle = content.angle
			end
		}
	}, scenegraph_id)
end

template.on_enter = function (widget, marker, self)
	local content = widget.content

	content.spawn_progress_timer = 0
end

template.update_function = function (parent, ui_renderer, widget, marker, self, dt, t)
	local content = widget.content
	local style = widget.style
	local distance = content.distance
	local evolve_distance = self.evolve_distance
	local data = marker.data
	local ui_interaction_type = data:ui_interaction_type() or "default"
	local interaction_icon = data:interaction_icon()

	if interaction_icon ~= content.icon then
		content.icon = interaction_icon
	end

	local is_tagged = marker.template.get_smart_tag_id(marker) ~= nil

	content.tagged = is_tagged
	marker.block_fade_settings = is_tagged
	marker.block_max_distance = is_tagged
	marker.block_screen_clamp = not is_tagged

	if ui_interaction_type ~= marker.ui_interaction_type then
		setup_marker_by_interaction_type(widget, marker, ui_interaction_type)

		marker.ui_interaction_type = ui_interaction_type
	end

	local can_interact = false
	local hud = parent._parent
	local player_unit = hud:player_unit()
	local visible = data:show_marker(player_unit)

	if distance <= evolve_distance or is_tagged then
		local player_extensions = hud:player_extensions()
		local interactor_extension = player_extensions and player_extensions.interactor
		local show_interaction_ui = interactor_extension and interactor_extension:show_interaction_ui()
		local show_counter_ui = interactor_extension and interactor_extension:show_counter_ui()

		if show_interaction_ui or show_counter_ui then
			local target_unit = interactor_extension:target_unit()
			local marker_unit = marker.unit

			if target_unit == marker_unit then
				can_interact = data:can_interact(player_unit)
			end
		end
	end

	local scale_speed = 8
	local scale_progress = content.scale_progress or 0
	local line_of_sight_progress = content.line_of_sight_progress or 0

	if distance <= evolve_distance and can_interact then
		scale_progress = math.min(scale_progress + dt * scale_speed, 1)
	else
		scale_progress = math.max(scale_progress - dt * scale_speed, 0)
	end

	marker.ignore_scale = content.is_clamped

	local global_scale = marker.ignore_scale and 1 or marker.scale

	if marker.raycast_initialized then
		local raycast_result = marker.raycast_result
		local line_of_sight_speed = 8

		if raycast_result and not can_interact and not is_tagged then
			line_of_sight_progress = math.max(line_of_sight_progress - dt * line_of_sight_speed, 0)
		else
			line_of_sight_progress = math.min(line_of_sight_progress + dt * line_of_sight_speed, 1)
		end
	elseif not self.check_line_of_sight then
		line_of_sight_progress = 1
	end

	local default_size = self.min_size
	local max_size = self.max_size
	local ring_size = style.ring.size

	ring_size[1] = (default_size[1] + (max_size[1] - default_size[1]) * scale_progress) * global_scale
	ring_size[2] = (default_size[2] + (max_size[2] - default_size[2]) * scale_progress) * global_scale

	local ping_min_size = self.ping_min_size
	local ping_max_size = self.ping_max_size
	local ping_style = style.ping
	local ping_size = ping_style.size
	local ping_speed = 7
	local ping_anim_progress = 0.5 + math.sin(Application.time_since_launch() * ping_speed) * 0.5
	local ping_pulse_size_increase = ping_anim_progress * 15

	ping_size[1] = (ping_min_size[1] + (ping_max_size[1] - ping_min_size[1]) * scale_progress + ping_pulse_size_increase) * global_scale
	ping_size[2] = (ping_min_size[2] + (ping_max_size[2] - ping_min_size[2]) * scale_progress + ping_pulse_size_increase) * global_scale

	local ping_pivot = ping_style.pivot

	ping_pivot[1] = ping_size[1] * 0.5
	ping_pivot[2] = ping_size[2] * 0.5

	local icon_max_size = self.icon_max_size
	local icon_min_size = self.icon_min_size
	local background_max_size = self.background_max_size
	local background_min_size = self.background_min_size
	local icon_size = style.icon.size

	icon_size[1] = (icon_min_size[1] + (icon_max_size[1] - icon_min_size[1]) * scale_progress) * global_scale
	icon_size[2] = (icon_min_size[2] + (icon_max_size[2] - icon_min_size[2]) * scale_progress) * global_scale

	local background_size = style.background.size

	background_size[1] = (background_min_size[1] + (background_max_size[1] - background_min_size[1]) * scale_progress) * global_scale
	background_size[2] = (background_min_size[2] + (background_max_size[2] - background_min_size[2]) * scale_progress) * global_scale

	local animating = scale_progress ~= content.scale_progress

	content.line_of_sight_progress = line_of_sight_progress
	content.scale_progress = scale_progress
	widget.alpha_multiplier = line_of_sight_progress
	widget.visible = visible

	return animating
end

return template
