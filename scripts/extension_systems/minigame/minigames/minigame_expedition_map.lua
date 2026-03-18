-- chunkname: @scripts/extension_systems/minigame/minigames/minigame_expedition_map.lua

local MinigameSettings = require("scripts/settings/minigame/minigame_settings")
local ScannerDisplayViewExpeditionMapSettings = require("scripts/ui/views/scanner_display_view/scanner_display_view_expedition_map_settings")

require("scripts/extension_systems/minigame/minigames/minigame_base")

local FX_SOURCE_NAME = "_speaker"
local MinigameExpeditionMap = class("MinigameExpeditionMap", "MinigameBase")

MinigameExpeditionMap.init = function (self, unit, is_server, seed, context)
	MinigameExpeditionMap.super.init(self, unit, is_server, seed, context)

	self._client_side = true
	self._register_input = false
	self._local_player = nil
	self._selected = nil
	self._selectable = {}
	self._selectable_position = {}
	self._last_move = 0
end

MinigameExpeditionMap.set_handler = function (self, handler)
	self._handler = handler
end

MinigameExpeditionMap.start = function (self, player, send_to_self_client)
	MinigameExpeditionMap.super.start(self, player, send_to_self_client)

	if player == Managers.player:local_player(1) then
		self._register_input = true
		self._local_player = player
	end

	if #self._selectable == 0 then
		self:add_selectable_levels(self._handler:get_registered_opportunities())
		self:add_selectable_levels(self._handler:get_registered_extractions())
		self:add_selectable_levels(self._handler:get_registered_exits())
	end

	if player then
		self:_setup_sound(player, FX_SOURCE_NAME)
	end
end

MinigameExpeditionMap.location_reset = function (self, player, send_to_self_client)
	MinigameExpeditionMap.super.start(self, player, send_to_self_client)

	self._selected = nil

	table.clear(self._selectable)
	table.clear(self._selectable_position)
end

MinigameExpeditionMap.add_selectable_levels = function (self, levels)
	local selectable = self._selectable
	local selectable_position = self._selectable_position

	for level_index, position in pairs(levels) do
		selectable[#selectable + 1] = level_index
		selectable_position[#selectable] = position
	end
end

MinigameExpeditionMap.update = function (self, dt, t)
	MinigameExpeditionMap.super.update(self, dt, t)

	if self._is_server then
		return
	end
end

MinigameExpeditionMap.on_action_pressed = function (self, t)
	MinigameExpeditionMap.super.on_action_pressed(self, t)

	if not self._register_input then
		return
	end

	local selected_level_index = self._selectable[self._selected]

	if selected_level_index then
		local impacted, assigned = self._handler:mark_level_by_player(selected_level_index, self._local_player)

		if impacted then
			if assigned then
				self:play_sound("sfx_minigame_map_select", false, true)
			else
				self:play_sound("sfx_minigame_map_deselect", false, true)
			end
		end
	end
end

MinigameExpeditionMap.escape_action = function (self, held)
	return false
end

MinigameExpeditionMap.uses_joystick = function (self)
	return true
end

MinigameExpeditionMap.unequip_on_exit = function (self)
	return false
end

MinigameExpeditionMap.on_axis_set = function (self, t, x, y)
	MinigameExpeditionMap.super.on_axis_set(self, t, x, y)

	if not self._register_input then
		return
	end

	if x == 0 and y == 0 then
		return
	end

	if t <= self._last_move + MinigameSettings.exp_map_move_delay then
		return
	end

	self._last_move = t

	local aim_radian = math.atan2(-y, x)
	local targets = self._selectable
	local closest_index, lowest_points = nil, math.huge
	local current_position

	if self._selected then
		current_position = self._selectable_position[self._selected]:unbox()
	else
		local local_player = Managers.player:local_player(1)
		local player_unit = local_player.player_unit
		local player_position = POSITION_LOOKUP[player_unit]

		current_position = {
			x = player_position.x,
			y = player_position.y,
		}
	end

	current_position.x, current_position.y = self:world_pos_to_map_pos(current_position.x, current_position.y)

	for i = 1, #targets do
		local level_index = targets[i]

		if i ~= self._selected and not self._handler:is_level_completed(level_index) then
			local target = self._selectable_position[i]:unbox()

			target.x, target.y = self:world_pos_to_map_pos(target.x, target.y)

			local radian = math.atan2(target.y - current_position.y, target.x - current_position.x)
			local angle = math.abs(radian - aim_radian)

			if angle > math.pi then
				angle = 2 * math.pi - angle
			end

			local distance = math.sqrt((current_position.x - target.x) * (current_position.x - target.x) + (current_position.y - target.y) * (current_position.y - target.y))
			local points = distance + angle * MinigameSettings.exp_map_move_distance_power

			if points < lowest_points and angle < math.pi / 3 then
				closest_index = i
				lowest_points = points
			end
		end
	end

	if closest_index then
		self._selected = closest_index

		self:play_sound("sfx_minigame_map_move", false, true)
	end
end

MinigameExpeditionMap.world_pos_to_map_pos = function (self, x, y)
	local local_player = Managers.player:local_player(1)
	local player_unit = local_player.player_unit
	local center = POSITION_LOOKUP[player_unit]
	local viewport_name = local_player.viewport_name
	local camera_rotation = Managers.state.camera:camera_rotation(viewport_name)
	local radian = math.atan2(x - center.x, y - center.y) + Quaternion.yaw(camera_rotation) - math.pi / 2
	local distance = math.min(math.sqrt(math.pow(x - center.x, 2) + math.pow(y - center.y, 2)) / ScannerDisplayViewExpeditionMapSettings.display_distance, 1)

	x = math.cos(radian) * distance
	y = math.sin(radian) * distance

	return x, y
end

MinigameExpeditionMap.selected_level = function (self)
	if not self._selected then
		return nil
	end

	return self._selectable[self._selected]
end

MinigameExpeditionMap.is_level_marked = function (self, level_index)
	if not self._marked_levels then
		return nil
	end

	return self._marked_levels[level_index]
end

MinigameExpeditionMap.local_player = function (self)
	return self._local_player
end

return MinigameExpeditionMap
