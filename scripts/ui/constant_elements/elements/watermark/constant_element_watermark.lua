-- Decompilation Error: _run_step(_unwarp_expressions, node)

-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local ConstantElementWatermarkSettings = require("scripts/ui/constant_elements/elements/watermark/constant_element_watermark_settings")
local Definitions = require("scripts/ui/constant_elements/elements/watermark/constant_element_watermark_definitions")
local QR = require("scripts/settings/ui/qr/qrencode")
local UIFonts = require("scripts/managers/ui/ui_fonts")
local UIRenderer = require("scripts/managers/ui/ui_renderer")
local UIScenegraph = require("scripts/managers/ui/ui_scenegraph")
local UIWorldSpawner = require("scripts/managers/ui/ui_world_spawner")
local _render_settings = {
	shading_environment = "content/shading_environments/ui_default",
	viewport_name = "watermark_viewport",
	timer_name = "ui",
	viewport_type = "ui_watermark_offscreen",
	world_layer = 999,
	viewport_layer = 999,
	renderer_name = "watermark_ui",
	world_name = "watermark_world",
	size = ConstantElementWatermarkSettings.size
}
local ConstantElementWatermark = class("ConstantElementWatermark", "ConstantElementBase")

ConstantElementWatermark.init = function (self, parent, draw_layer, start_scale)
	ConstantElementWatermark.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._qr_data = self:_generate_qr()
	self._description_text = (HAS_STEAM and Steam.user_id()) or "n/a"
	self._has_rendered = false
end

ConstantElementWatermark.destroy = function (self)
	if self._ui_watermark_renderer then
		Managers.ui:destroy_renderer(_render_settings.renderer_name)

		self._ui_watermark_renderer = nil
	end

	if self._world_spawner then
		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	ConstantElementWatermark.super.destroy()
end

ConstantElementWatermark._initialize_world = function (self)
	local world_name = _render_settings.world_name
	local world_layer = _render_settings.world_layer
	local world_timer_name = _render_settings.timer_name
	self._world_spawner = UIWorldSpawner:new(world_name, world_layer, world_timer_name)
	local viewport_name = _render_settings.viewport_name
	local viewport_type = _render_settings.viewport_type
	local viewport_layer = _render_settings.viewport_layer
	local shading_environment = _render_settings.shading_environment

	self._world_spawner:create_viewport(nil, viewport_name, viewport_type, viewport_layer, shading_environment)
end

ConstantElementWatermark._initialize_ui_renderer = function (self, world)
	self._ui_watermark_renderer = Managers.ui:create_renderer(_render_settings.renderer_name, world)
end

ConstantElementWatermark.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	ConstantElementWatermark.super.update(self, dt, t, ui_renderer, render_settings, input_service)

	if self._has_rendered then
		local world_spawner = self._world_spawner

		if world_spawner and not self._world_disabled then
			world_spawner:set_world_disabled(true)

			self._world_disabled = true
		end
	end

	if self._world_spawner then
		self._world_spawner:update(dt, t)
	end
end

ConstantElementWatermark.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	if not GameParameters.show_watermark_overlay then
		return
	end

	if not self._has_rendered then
		if not self._world_spawner then
			self:_initialize_world()
		end

		if not self._ui_watermark_renderer then
			local world = self._world_spawner:world()

			self:_initialize_ui_renderer(world)
		end

		ui_renderer = self._ui_watermark_renderer
	elseif self._world_spawner then
		Managers.ui:destroy_renderer(_render_settings.renderer_name)

		self._ui_watermark_renderer = nil

		self._world_spawner:destroy()

		self._world_spawner = nil
	end

	ConstantElementWatermark.super.draw(self, dt, t, ui_renderer, render_settings, input_service)
end

ConstantElementWatermark._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	if self._has_rendered then
		self._widgets_by_name.watermarks.alpha_multiplier = GameParameters.watermark_overlay_alpha_multiplier or 1

		ConstantElementWatermark.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
	else
		self:_render_qr_grid(ui_renderer)

		self._has_rendered = true
	end
end

local temp_size = {
	0,
	0
}
local temp_position = {
	0,
	0,
	0
}
local qr_color_alpha = 255
local qr_color_black = Color.black(qr_color_alpha, true)
local qr_color_white = Color.white(qr_color_alpha, true)

ConstantElementWatermark._render_qr_grid = function (self, ui_renderer)
	local scale = RESOLUTION_LOOKUP.scale
	local gui = ui_renderer.gui
	local font_size = 24
	local font_type = "arial"
	local _, _, font_max_y = UIFonts.font_height(gui, font_type, font_size)
	local box_size = {
		1000,
		math.abs(font_max_y)
	}
	local text_color_table = {
		255,
		255,
		255,
		255
	}
	local text_options = {
		"horizontal_align_center",
		"vertical_align_bottom",
		"shadow"
	}
	font_size = math.floor(16 * scale)
	local title_text = GameParameters.watermark_overlay_text or ""
	local description_text = self._description_text
	local qr_data = self._qr_data
	local rows = #qr_data
	local cols = #qr_data[1]
	local render_size = _render_settings.size
	local qr_total_width = render_size[1] * scale
	local qr_total_height = render_size[2] * scale
	local ui_scenegraph = self._ui_scenegraph

	for i = 1, ConstantElementWatermarkSettings.num_markers, 1 do
		local scenegraph_id = "watermark_" .. i
		local world_position = UIScenegraph.world_position(ui_scenegraph, scenegraph_id)
		local size_width, size_height = UIScenegraph.get_size(ui_scenegraph, scenegraph_id, scale)
		local start_pos_x = (world_position[1] + size_width * 0.5) - qr_total_width * 0.5
		local start_pos_y = (world_position[2] + size_height * 0.5) - qr_total_height * 0.5
		temp_size[1] = qr_total_width / rows
		temp_size[2] = qr_total_height / cols

		for y = 1, rows, 1 do
			local row = qr_data[y]
			local pos_y = start_pos_y + temp_size[2] * (y - 1)

			for x = 1, cols, 1 do
				temp_position[2] = pos_y
				local color = qr_color_black

				if row[x] < 0 then
					color = qr_color_white
				end

				temp_position[1] = start_pos_x + temp_size[1] * (x - 1)

				UIRenderer.draw_rect(ui_renderer, temp_position, temp_size, color)
			end
		end

		temp_position[1] = (start_pos_x + qr_total_width * 0.5) - box_size[1] * 0.5
		temp_position[2] = start_pos_y + qr_total_height

		UIRenderer.draw_text(ui_renderer, title_text, font_size, font_type, temp_position, box_size, text_color_table, text_options)

		temp_position[2] = temp_position[2] + 25

		UIRenderer.draw_text(ui_renderer, description_text, font_size, font_type, temp_position, box_size, text_color_table, text_options)
	end
end

ConstantElementWatermark._generate_qr = function (self)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-3, warpins: 1 ---
	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #1



	-- Decompilation error in this vicinity:
	--- BLOCK #1 5-8, warpins: 2 ---
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 10-15, warpins: 2 ---
	--- END OF BLOCK #2 ---

	FLOW; TARGET BLOCK #3



	-- Decompilation error in this vicinity:
	--- BLOCK #3 22-23, warpins: 2 ---
	--- END OF BLOCK #3 ---

	FLOW; TARGET BLOCK #4



	-- Decompilation error in this vicinity:
	--- BLOCK #4 25-26, warpins: 2 ---
	if not BUILD_IDENTIFIER then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 4-4, warpins: 1 ---
		local engine_revision_info = "n/a"
		--- END OF BLOCK #0 ---



	end

	if not APPLICATION_SETTINGS.content_revision then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 9-9, warpins: 1 ---
		local content_revision_info = LOCAL_CONTENT_REVISION
		--- END OF BLOCK #0 ---



	end

	slot3 = string.format
	slot4 = "%16s:%8s:%12s:%08x"

	if not HAS_STEAM or not Steam.user_id() then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 21-21, warpins: 2 ---
		slot5 = ""
		--- END OF BLOCK #0 ---



	end

	if not content_revision_info then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 24-24, warpins: 1 ---
		slot6 = ""
		--- END OF BLOCK #0 ---



	end

	slot7 = engine_revision_info or ""
	local message = slot3(slot4, slot5, slot6, engine_revision_info or "", os.time()):gsub(" ", "0")
	local ok, data_or_err = QR.qrcode(message)
	--- END OF BLOCK #4 ---

	FLOW; TARGET BLOCK #6



	-- Decompilation error in this vicinity:
	--- BLOCK #5 27-27, warpins: 1 ---
	slot7 = ""

	--- END OF BLOCK #5 ---

	FLOW; TARGET BLOCK #6



	-- Decompilation error in this vicinity:
	--- BLOCK #6 28-42, warpins: 2 ---
	if ok then

		-- Decompilation error in this vicinity:
		--- BLOCK #0 43-43, warpins: 1 ---
		return data_or_err
		--- END OF BLOCK #0 ---



	end

	--- END OF BLOCK #6 ---

	FLOW; TARGET BLOCK #7



	-- Decompilation error in this vicinity:
	--- BLOCK #7 44-47, warpins: 2 ---
	error(data_or_err)

	return
	--- END OF BLOCK #7 ---



end

return ConstantElementWatermark
