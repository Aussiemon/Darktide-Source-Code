-- chunkname: @scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler.lua

require("scripts/ui/hud/elements/player_panel_base/hud_element_player_panel_base")

local definition_path = "scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_definitions"
local HudElementPersonalPlayerPanel = require("scripts/ui/hud/elements/personal_player_panel/hud_element_personal_player_panel")
local HudElementPersonalPlayerPanelHub = require("scripts/ui/hud/elements/personal_player_panel_hub/hud_element_personal_player_panel_hub")
local HudElementTeamPlayerPanelHub = require("scripts/ui/hud/elements/team_player_panel_hub/hud_element_team_player_panel_hub")
local HudElementTeamPlayerPanel = require("scripts/ui/hud/elements/team_player_panel/hud_element_team_player_panel")
local HudElementTeamPanelHandlerSettings = require("scripts/ui/hud/elements/team_panel_handler/hud_element_team_panel_handler_settings")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")
local HudElementTeamPanelHandler = class("HudElementTeamPanelHandler", "HudElementBase")

HudElementTeamPanelHandler.init = function (self, parent, draw_layer, start_scale)
	local definitions = require(definition_path)

	HudElementTeamPanelHandler.super.init(self, parent, draw_layer, start_scale, definitions)

	self._parent = parent
	self._player_panel_by_unique_id = {}
	self._player_panels_array = {}
	self._num_panels = 0
	self._max_panels = HudElementTeamPanelHandlerSettings.max_panels
	self._position_scenegraphs = self:_setup_position_scenegraphs()
	self._unique_id_by_scenegraph = {}

	local my_player = parent:player()

	self._my_player = my_player
	self._my_unique_id = my_player:unique_id()

	local game_mode_manager = Managers.state.game_mode
	local hud_settings = game_mode_manager:hud_settings()

	self._player_composition_name = hud_settings.player_composition

	Managers.event:register(self, PlayerCompositions.player_composition_changed_event, "_composition_changed")
end

HudElementTeamPanelHandler._composition_changed = function (self, composition_name)
	if composition_name ~= self._player_composition_name then
		-- Nothing
	end
end

HudElementTeamPanelHandler._setup_position_scenegraphs = function (self)
	local scenegraphs = {}

	for i = 1, self._max_panels - 1 do
		scenegraphs[i] = "player_" .. i
	end

	return scenegraphs
end

HudElementTeamPanelHandler._num_other_player_panels = function (self)
	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array
	local my_unique_id = self._my_unique_id
	local player_count = 0

	for i = 1, num_player_panels do
		local player_panel = player_panels_array[i]
		local unique_id = player_panel.unique_id

		if unique_id ~= my_unique_id then
			player_count = player_count + 1
		end
	end

	return player_count
end

HudElementTeamPanelHandler._get_available_scenegraph = function (self)
	local scenegraphs = self._position_scenegraphs
	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array

	for i = 1, #scenegraphs do
		local taken = false

		for j = 1, num_player_panels do
			local data = player_panels_array[j]

			if data.scenegraph_id == scenegraphs[i] then
				taken = true

				break
			end
		end

		if not taken then
			return scenegraphs[i]
		end
	end
end

local temp_team_players = {}
local temp_new_unique_ids = {}

HudElementTeamPanelHandler._player_scan = function (self, ui_renderer)
	local player_composition_name = self._player_composition_name
	local players = PlayerCompositions.players(player_composition_name, temp_team_players)
	local player_panel_by_unique_id = self._player_panel_by_unique_id
	local player_panels_array = self._player_panels_array
	local num_composition_players = 0

	for unique_id, player in pairs(players) do
		num_composition_players = num_composition_players + 1

		if not player_panel_by_unique_id[unique_id] then
			temp_new_unique_ids[#temp_new_unique_ids + 1] = unique_id
		else
			player_panel_by_unique_id[unique_id].synced = true
		end
	end

	local panel_removed = false

	for i = #player_panels_array, 1, -1 do
		local data = player_panels_array[i]
		local unique_id = data.unique_id
		local player = data.player
		local player_deleted = player.__deleted

		if not data.synced or player_deleted then
			self:_remove_panel(unique_id, ui_renderer)

			panel_removed = true
		else
			data.synced = false
		end
	end

	if panel_removed then
		self:_on_panels_removed()
	end

	local num_players_to_add = #temp_new_unique_ids
	local max_panels = self._max_panels
	local players_added = false

	if num_players_to_add > 0 then
		for i = 1, num_players_to_add do
			local current_num_panels = self._num_panels

			if max_panels <= current_num_panels then
				break
			end

			local should_add = false
			local num_other_player_panels = self:_num_other_player_panels()
			local max_other_player_panels = max_panels - 1
			local unique_id = temp_new_unique_ids[i]
			local fixed_scenegraph_id

			if unique_id == self._my_unique_id then
				fixed_scenegraph_id = "local_player"
				should_add = true
			else
				should_add = num_other_player_panels < max_other_player_panels and true or should_add
			end

			if should_add then
				self:_add_panel(unique_id, ui_renderer, fixed_scenegraph_id)

				players_added = true
			end
		end

		table.clear(temp_new_unique_ids)
	end

	if players_added then
		self:_align_panels()
	end
end

HudElementTeamPanelHandler._add_panel = function (self, unique_id, ui_renderer, fixed_scenegraph_id)
	local player_composition_name = self._player_composition_name
	local player = PlayerCompositions.player_from_unique_id(player_composition_name, unique_id)
	local scale = ui_renderer.scale or 1
	local scenegraph_id = fixed_scenegraph_id or self:_get_available_scenegraph()
	local draw_layer = self._draw_layer
	local parent = self._parent
	local is_my_player = self._my_player == player
	local data = {
		synced = false,
		unique_id = unique_id,
		player = player,
		is_my_player = is_my_player,
		local_player = self._my_player,
		scenegraph_id = scenegraph_id,
		using_fixed_scenegraph_id = fixed_scenegraph_id ~= nil,
	}
	local panel
	local host_type = Managers.connection:host_type()
	local game_mode_name = Managers.state.game_mode and Managers.state.game_mode:game_mode_name()
	local is_in_hub = host_type == "hub_server" or game_mode_name == "hub"
	local is_in_training_grounds = game_mode_name == "shooting_range" or game_mode_name == "training_grounds"

	if is_in_training_grounds then
		if is_my_player then
			panel = HudElementPersonalPlayerPanel:new(parent, draw_layer, scale, data)
		else
			panel = HudElementTeamPlayerPanelHub:new(parent, draw_layer, scale, data)
		end
	elseif is_in_hub then
		if is_my_player then
			panel = HudElementPersonalPlayerPanelHub:new(parent, draw_layer, scale, data)
		else
			panel = HudElementTeamPlayerPanelHub:new(parent, draw_layer, scale, data)
		end
	elseif is_my_player then
		panel = HudElementPersonalPlayerPanel:new(parent, draw_layer, scale, data)
	else
		panel = HudElementTeamPlayerPanel:new(parent, draw_layer, scale, data)
	end

	data.panel = panel
	self._player_panels_array[#self._player_panels_array + 1] = data
	self._player_panel_by_unique_id[unique_id] = data
	self._unique_id_by_scenegraph[scenegraph_id] = unique_id
	self._num_panels = self._num_panels + 1
end

HudElementTeamPanelHandler._remove_panel = function (self, unique_id, ui_renderer)
	local player_panels_array = self._player_panels_array
	local panel_data
	local num_player_panels = #player_panels_array

	for i = 1, num_player_panels do
		local data = player_panels_array[i]

		if data.unique_id == unique_id then
			panel_data = table.remove(player_panels_array, i)

			break
		end
	end

	local scenegraph_id = panel_data.scenegraph_id
	local panel = panel_data.panel

	panel:destroy(ui_renderer)

	self._unique_id_by_scenegraph[scenegraph_id] = nil
	self._player_panel_by_unique_id[unique_id] = nil
	self._num_panels = self._num_panels - 1
end

HudElementTeamPanelHandler._on_panels_removed = function (self)
	self:_refresh_assigned_scenegraph_ids()
	self:_align_panels()
end

HudElementTeamPanelHandler._refresh_assigned_scenegraph_ids = function (self)
	local index = 1
	local scenegraphs = self._position_scenegraphs
	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array

	table.clear(self._unique_id_by_scenegraph)

	for i = 1, num_player_panels do
		local data = player_panels_array[i]
		local unique_id = data.unique_id

		if not data.using_fixed_scenegraph_id then
			data.scenegraph_id = scenegraphs[index]
			index = index + 1
		end

		local scenegraph_id = data.scenegraph_id

		self._unique_id_by_scenegraph[scenegraph_id] = unique_id
	end
end

HudElementTeamPanelHandler.set_scenegraph_position = function (self, scenegraph_id, x, y, z, horizontal_alignment, vertical_alignment)
	HudElementTeamPanelHandler.super.set_scenegraph_position(self, scenegraph_id, x, y, z, horizontal_alignment, vertical_alignment)

	local unique_id = self._unique_id_by_scenegraph[scenegraph_id]

	if unique_id then
		local panel_data = self._player_panel_by_unique_id[unique_id]
		local panel = panel_data.panel

		panel:set_scenegraph_position("background", x, y, z, horizontal_alignment, vertical_alignment)
	end
end

HudElementTeamPanelHandler._align_panels = function (self)
	local ui_scenegraph = self._ui_scenegraph
	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array

	for i = 1, num_player_panels do
		local data = player_panels_array[i]
		local scenegraph_id = data.scenegraph_id
		local panel = data.panel
		local scenegraph_settings = ui_scenegraph[scenegraph_id]
		local position = scenegraph_settings.position
		local x = position[1]
		local y = position[2]
		local horizontal_alignment = scenegraph_settings.horizontal_alignment
		local vertical_alignment = scenegraph_settings.vertical_alignment

		panel:set_scenegraph_position("background", x, y, nil, horizontal_alignment, vertical_alignment)
		panel:set_dirty()
	end
end

HudElementTeamPanelHandler.destroy = function (self, ui_renderer)
	local player_panels_array = self._player_panels_array

	for i = #player_panels_array, 1, -1 do
		local data = player_panels_array[i]
		local unique_id = data.unique_id

		self:_remove_panel(unique_id, ui_renderer)
	end

	Managers.event:unregister(self, PlayerCompositions.player_composition_changed_event)

	self._player_panels_array = nil
	self._player_panel_by_unique_id = nil

	HudElementTeamPanelHandler.super.destroy(self, ui_renderer)
end

HudElementTeamPanelHandler.set_visible = function (self, visible, ui_renderer, use_retained_mode)
	HudElementTeamPanelHandler.super.set_visible(self, visible, ui_renderer, use_retained_mode)

	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array

	for i = 1, num_player_panels do
		local data = player_panels_array[i]
		local panel = data.panel

		if panel.set_visible then
			panel:set_visible(visible, ui_renderer, use_retained_mode)
		end
	end
end

HudElementTeamPanelHandler.set_retained_visibility = function (self, visible, ui_renderer)
	HudElementTeamPanelHandler.super.set_visible(self, visible)

	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array

	for i = 1, num_player_panels do
		local data = player_panels_array[i]
		local panel = data.panel

		if panel.set_retained_visibility then
			panel:set_retained_visibility(visible, ui_renderer)
		end
	end
end

HudElementTeamPanelHandler.on_resolution_modified = function (self)
	HudElementTeamPanelHandler.super.on_resolution_modified(self)

	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array

	for i = 1, num_player_panels do
		local data = player_panels_array[i]
		local panel = data.panel

		panel:on_resolution_modified()
	end
end

HudElementTeamPanelHandler.update = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementTeamPanelHandler.super.update(self, dt, t, ui_renderer, render_settings, input_service)
	self:_player_scan(ui_renderer)

	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array

	for i = 1, num_player_panels do
		local data = player_panels_array[i]
		local panel = data.panel

		panel:update(dt, t, ui_renderer, render_settings, input_service)
	end
end

HudElementTeamPanelHandler.draw = function (self, dt, t, ui_renderer, render_settings, input_service)
	HudElementTeamPanelHandler.super.draw(self, dt, t, ui_renderer, render_settings, input_service)

	local player_panels_array = self._player_panels_array
	local num_player_panels = #player_panels_array

	for i = 1, num_player_panels do
		local data = player_panels_array[i]
		local panel = data.panel

		panel:draw(dt, t, ui_renderer, render_settings, input_service)
	end
end

return HudElementTeamPanelHandler
