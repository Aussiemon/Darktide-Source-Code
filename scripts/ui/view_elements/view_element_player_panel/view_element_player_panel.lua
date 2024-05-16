-- chunkname: @scripts/ui/view_elements/view_element_player_panel/view_element_player_panel.lua

local Definitions = require("scripts/ui/view_elements/view_element_player_panel/view_element_player_panel_definitions")
local ViewElementPlayerPanelSettings = require("scripts/ui/view_elements/view_element_player_panel/view_element_player_panel_settings")
local ViewElementPlayerPanel = class("ViewElementPlayerPanel", "ViewElementBase")

ViewElementPlayerPanel.init = function (self, parent, draw_layer, start_scale, context)
	ViewElementPlayerPanel.super.init(self, parent, draw_layer, start_scale, Definitions)

	self._pivot_offset = {
		0,
		0,
	}
	self._preview_profile = context.preview_profile
	self._widgets_by_name.character_insigna.content.visible = false
end

ViewElementPlayerPanel.set_pivot_offset = function (self, x, y)
	self:_set_scenegraph_position("pivot", x, y)
end

ViewElementPlayerPanel.update = function (self, dt, t, input_service)
	local preview_items = self._preview_profile.loadout

	if preview_items then
		if not self._portrait_loaded_info then
			self:_request_player_icon()
		end

		local frame_item = preview_items.slot_portrait_frame
		local frame_item_gear_id = frame_item and frame_item.gear_id

		if frame_item_gear_id ~= self._frame_item_gear_id then
			self._frame_item_gear_id = frame_item_gear_id

			self:_request_player_frame(frame_item)
		end

		local insignia_item = preview_items.slot_insignia
		local insignia_item_gear_id = insignia_item and insignia_item.gear_id

		if insignia_item_gear_id ~= self._insignia_item_gear_id then
			self._insignia_item_gear_id = insignia_item_gear_id

			self:_request_player_insignia(insignia_item)
		end
	end

	return ViewElementPlayerPanel.super.update(self, dt, t, input_service)
end

ViewElementPlayerPanel._draw_widgets = function (self, dt, t, input_service, ui_renderer, render_settings)
	ViewElementPlayerPanel.super._draw_widgets(self, dt, t, input_service, ui_renderer, render_settings)
end

ViewElementPlayerPanel._request_player_insignia = function (self, item)
	self:_unload_insignia()
	self:_load_insignia(item)
end

ViewElementPlayerPanel._load_insignia = function (self, item)
	local cb = callback(self, "_cb_set_player_insignia")
	local icon_load_id = Managers.ui:load_item_icon(item, cb)

	self._insignia_loaded_info = {
		icon_load_id = icon_load_id,
	}
end

ViewElementPlayerPanel._unload_insignia = function (self)
	local insignia_loaded_info = self._insignia_loaded_info

	if not insignia_loaded_info then
		return
	end

	if not self.destroyed then
		local material_values = self._widgets_by_name.character_insigna.style.texture.material_values

		material_values.texture_map = "content/ui/textures/nameplates/insignias/default"
	end

	local icon_load_id = insignia_loaded_info.icon_load_id

	Managers.ui:unload_item_icon(icon_load_id)

	self._insignia_loaded_info = nil
	self._widgets_by_name.character_insigna.content.visible = false
end

ViewElementPlayerPanel._cb_set_player_insignia = function (self, item)
	local loadout = self._preview_profile.loadout
	local frame_item = loadout.slot_insignia
	local frame_item_gear_id = frame_item and frame_item.gear_id
	local icon

	if frame_item_gear_id == item.gear_id then
		icon = item.icon
	else
		icon = "content/ui/textures/nameplates/insignias/default"
	end

	local material_values = self._widgets_by_name.character_insigna.style.texture.material_values

	material_values.texture_map = icon
	self._widgets_by_name.character_insigna.content.visible = true
end

ViewElementPlayerPanel._request_player_frame = function (self, item)
	self:_unload_portrait_frame()
	self:_load_portrait_frame(item)
end

ViewElementPlayerPanel._load_portrait_frame = function (self, item)
	local cb = callback(self, "_cb_set_player_frame")
	local icon_load_id = Managers.ui:load_item_icon(item, cb)

	self._frame_loaded_info = {
		icon_load_id = icon_load_id,
	}
end

ViewElementPlayerPanel._unload_portrait_frame = function (self)
	local frame_loaded_info = self._frame_loaded_info

	if not frame_loaded_info then
		return
	end

	if not self.destroyed then
		local material_values = self._widgets_by_name.character_portrait.style.texture.material_values

		material_values.portrait_frame_texture = "content/ui/textures/nameplates/portrait_frames/default"
	end

	local icon_load_id = frame_loaded_info.icon_load_id

	Managers.ui:unload_item_icon(icon_load_id)

	self._frame_loaded_info = nil
end

ViewElementPlayerPanel._cb_set_player_frame = function (self, item)
	local loadout = self._preview_profile.loadout
	local frame_item = loadout.slot_portrait_frame
	local frame_item_gear_id = frame_item and frame_item.gear_id
	local icon

	if frame_item_gear_id == item.gear_id then
		icon = item.icon
	else
		icon = "content/ui/textures/nameplates/portrait_frames/default"
	end

	local material_values = self._widgets_by_name.character_portrait.style.texture.material_values

	material_values.portrait_frame_texture = icon
end

ViewElementPlayerPanel._request_player_icon = function (self)
	local material_values = self._widgets_by_name.character_portrait.style.texture.material_values

	material_values.use_placeholder_texture = 1

	self:_load_portrait_icon()
end

ViewElementPlayerPanel._load_portrait_icon = function (self)
	local profile = self._preview_profile
	local load_cb = callback(self, "_cb_set_player_icon")
	local unload_cb = callback(self, "_cb_unset_player_icon")
	local icon_load_id = Managers.ui:load_profile_portrait(profile, load_cb, nil, unload_cb)

	self._portrait_loaded_info = {
		icon_load_id = icon_load_id,
	}
end

ViewElementPlayerPanel._unload_portrait_icon = function (self)
	local portrait_loaded_info = self._portrait_loaded_info

	if not portrait_loaded_info then
		return
	end

	local icon_load_id = portrait_loaded_info.icon_load_id

	Managers.ui:unload_profile_portrait(icon_load_id)

	self._portrait_loaded_info = nil
end

ViewElementPlayerPanel._cb_set_player_icon = function (self, grid_index, rows, columns)
	local widget = self._widgets_by_name.character_portrait

	widget.content.texture = "content/ui/materials/base/ui_portrait_frame_base"

	local material_values = widget.style.texture.material_values

	material_values.use_placeholder_texture = 0
	material_values.rows = rows
	material_values.columns = columns
	material_values.grid_index = grid_index - 1
end

ViewElementPlayerPanel._cb_unset_player_icon = function (self)
	local widget = self._widgets_by_name.character_portrait
	local material_values = widget.style.texture.material_values

	material_values.use_placeholder_texture = nil
	material_values.rows = nil
	material_values.columns = nil
	material_values.grid_index = nil
	material_values.texture_icon = nil
	widget.content.texture = "content/ui/materials/base/ui_portrait_frame_base_no_render"
end

return ViewElementPlayerPanel
