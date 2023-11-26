-- chunkname: @scripts/extension_systems/weapon/weapon_action_movement_drawer.lua

local ScriptGui = require("scripts/foundation/utilities/script_gui")
local SharedFunctions = require("scripts/extension_systems/weapon/weapon_action_movement_shared")
local _get_anchor_point
local WeaponActionMovementDrawer = class("WeaponActionMovementDrawer")

WeaponActionMovementDrawer.init = function (self, weapon_action_movement, unit_data_extension)
	self._weapon_action_movement = weapon_action_movement
	self._weapon_action_component = unit_data_extension:read_component("weapon_action")
	self._action_sweep_component = unit_data_extension:read_component("action_sweep")
	self._fixed_t = 0
end

WeaponActionMovementDrawer.update = function (self, dt, t)
	if not DevParameters.show_action_movement_curves or DEDICATED_SERVER then
		return
	end

	local movement_curve, start_t = SharedFunctions.action_movement_curve(self._weapon_action_component, self._action_sweep_component)

	if movement_curve then
		local weapon_action_component = self._weapon_action_component
		local is_infinite_duration = weapon_action_component.is_infinite_duration
		local end_t = is_infinite_duration and math.huge or weapon_action_component.end_t

		self:_draw_movement_curve(movement_curve, start_t, end_t, self._fixed_t)
	end
end

WeaponActionMovementDrawer.fixed_update = function (self, dt, t)
	self._fixed_t = t
end

local MOVEMENT_CURVE_EXTENTS = {
	400,
	300
}
local ANCHOR_POINT = {
	-50,
	50
}
local SCREEN_ALIGNMENT_X = "right"
local LAYER = 10

WeaponActionMovementDrawer._draw_movement_curve = function (self, movement_curve, start_t, end_t, current_t)
	local _end_t = end_t == 0 and math.huge or end_t
	local gui = Debug:debug_gui()
	local bg_color = Color.light_green(200)
	local line_color = Color.white()
	local font_size = 14
	local font_color = Color.white()
	local anchor_x, anchor_y = _get_anchor_point(SCREEN_ALIGNMENT_X, ANCHOR_POINT, MOVEMENT_CURVE_EXTENTS[1])
	local anchor_z = LAYER
	local extents_x = MOVEMENT_CURVE_EXTENTS[1]
	local extents_y = MOVEMENT_CURVE_EXTENTS[2]
	local bg_border_size = 30
	local bg_pos = Vector3(anchor_x - bg_border_size / 2, anchor_y - bg_border_size / 2, anchor_z)
	local bg_size = Vector2(extents_x + bg_border_size, extents_y + bg_border_size)

	Gui.rect(gui, bg_pos, bg_size, bg_color)

	local line_thickness = 2
	local x_line_size = Vector2(extents_x, line_thickness)
	local x_line_pos = Vector3(anchor_x, anchor_y + extents_y - line_thickness, anchor_z + 1)

	Gui.rect(gui, x_line_pos, x_line_size, line_color)

	local y_line_size = Vector2(line_thickness, extents_y)
	local y_line_pos = Vector3(anchor_x, anchor_y, anchor_z + 1)

	Gui.rect(gui, y_line_pos, y_line_size, line_color)

	local middle_line_extra = 0
	local middle_line_size = Vector2(extents_x + middle_line_extra * 2, line_thickness)
	local middle_line_pos = Vector3(anchor_x - middle_line_extra, anchor_y + extents_y / 2 - line_thickness / 2, anchor_z + 1)

	Gui.rect(gui, middle_line_pos, middle_line_size, line_color)

	local max_mod = 2
	local max_t = _end_t - start_t

	if _end_t == math.huge then
		local last_segment = movement_curve[#movement_curve]

		max_t = last_segment.t

		if max_t == 0 then
			max_t = 3
		end
	end

	local extent_x_start = "0.0"
	local min, max = Gui.slug_text_extents(gui, extent_x_start, DevParameters.debug_text_font, font_size)
	local x_range = max.x - min.x
	local extent_x_start_pos = x_line_pos + Vector3(-x_range / 2, 3, 0)

	Gui.slug_text(gui, extent_x_start, DevParameters.debug_text_font, font_size, extent_x_start_pos, font_color)

	local extent_x_end = string.format("%.1f", tostring(max_t))

	min, max = Gui.slug_text_extents(gui, extent_x_end, DevParameters.debug_text_font, font_size)
	x_range = max.x - min.x

	local extent_x_end_pos = x_line_pos + Vector3(extents_x - x_range / 2, 3, 0)

	Gui.slug_text(gui, extent_x_end, DevParameters.debug_text_font, font_size, extent_x_end_pos, font_color)

	local start_mod = movement_curve.start_modifier or 1
	local prev_mod = 1 - start_mod / max_mod
	local prev_t = 0 / max_t
	local p1
	local p2 = Vector2(x_line_pos.x + extents_x * prev_t, y_line_pos.y + extents_y * prev_mod)

	for i = 1, #movement_curve do
		p1 = p2

		local segment = movement_curve[i]
		local mod = segment.modifier
		local t = segment.t

		prev_mod = 1 - mod / max_mod
		prev_t = t / max_t
		p2 = Vector2(x_line_pos.x + extents_x * prev_t, y_line_pos.y + extents_y * prev_mod)

		ScriptGui.hud_line(gui, p1, p2, anchor_z + 1, line_thickness, line_color)
	end

	local progress = math.min((current_t - start_t) / max_t, 1)
	local progression_line_pos = Vector3(anchor_x + extents_x * progress, anchor_y, anchor_z + 1)

	Gui.rect(gui, progression_line_pos, y_line_size, line_color)
end

function _get_anchor_point(x_alignment, anchor_point, extents_x)
	if x_alignment == "right" then
		local w = Gui.resolution()
		local x = w - extents_x + anchor_point[1]
		local y = anchor_point[2]

		return x, y
	elseif x_alignment == "center" then
		local w = Gui.resolution()
		local x = w / 2 - extents_x / 2 + anchor_point[1]
		local y = anchor_point[2]

		return x, y
	else
		return anchor_point[1], anchor_point[2]
	end
end

return WeaponActionMovementDrawer
