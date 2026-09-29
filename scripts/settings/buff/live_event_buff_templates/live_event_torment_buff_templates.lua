-- chunkname: @scripts/settings/buff/live_event_buff_templates/live_event_torment_buff_templates.lua

local GREEN_EYE_COLOR = {
	0.5176470588235295,
	0.611764705882353,
	0.38823529411764707,
}
local templates = {}

table.make_unique(templates)

templates.live_event_torment_eye_glow = {
	class_name = "buff",
	predicted = false,
	stat_buffs = {},
	start_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end
	end,
	stop_func = function (template_data, template_context)
		if not template_context.is_server then
			return
		end

		local unit = template_context.unit

		if not HEALTH_ALIVE[unit] then
			return
		end
	end,
	minion_effects = {
		node_effects = {
			{
				node_name = "j_lefteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = GREEN_EYE_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = GREEN_EYE_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = GREEN_EYE_COLOR,
						},
					},
				},
			},
			{
				node_name = "j_righteye",
				vfx = {
					orphaned_policy = "stop",
					particle_effect = "content/fx/particles/enemies/red_glowing_eyes",
					stop_type = "destroy",
					material_variables = {
						{
							material_name = "eye_flash_init",
							variable_name = "material_variable_21872256",
							value = GREEN_EYE_COLOR,
						},
						{
							material_name = "eye_glow",
							variable_name = "trail_color",
							value = GREEN_EYE_COLOR,
						},
						{
							material_name = "eye_socket",
							variable_name = "material_variable_21872256",
							value = GREEN_EYE_COLOR,
						},
					},
				},
			},
		},
	},
}

return templates
