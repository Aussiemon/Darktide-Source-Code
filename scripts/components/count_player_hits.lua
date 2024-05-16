-- chunkname: @scripts/components/count_player_hits.lua

local CountPlayerHits = component("CountPlayerHits")

CountPlayerHits.init = function (self, unit, is_server)
	self._unit = unit
	self._is_server = is_server
	self._hit_count = 0
	self._target_hit_count = self:get_data(unit, "hit_count")
	self._level_flow_on_hit_count = self:get_data(unit, "level_flow_on_hit_count")
	self._unit_flow_on_hit_count = self:get_data(unit, "unit_flow_on_hit_count")
	self._unit_flow_on_unique_hit_count = self:get_data(unit, "unit_flow_on_unique_hit_count")
	self._unique_counting = self:get_data(unit, "unique_counting")
	self._enabled = self:get_data(unit, "enabled")
	self._set_hit_count_to_num_players = self:get_data(unit, "set_hit_count_to_num_players")
	self._min_unique_hit_count = self:get_data(unit, "min_unique_hit_count")
	self._attacking_units = {}

	if not not rawget(_G, "LevelEditor") then
		local level = Managers.state.mission:mission_level()

		self._level = level
	end
end

CountPlayerHits.editor_init = function (self)
	return
end

CountPlayerHits.editor_validate = function (self, unit)
	return true, ""
end

CountPlayerHits.enable = function (self, unit)
	return
end

CountPlayerHits.disable = function (self, unit)
	return
end

CountPlayerHits.destroy = function (self, unit)
	return
end

CountPlayerHits.events.on_hit = function (self, attack_direction, attacking_unit)
	if not self._enabled or not self._is_server or not attacking_unit then
		return
	end

	local target_hit_count = self._target_hit_count

	if self._set_hit_count_to_num_players then
		local player_unit_spawn_manager = Managers.state.player_unit_spawn
		local alive_players = player_unit_spawn_manager:alive_players()
		local num_alive_players = 0

		for i = 1, #alive_players do
			local player = alive_players[i]

			if player:is_human_controlled() then
				num_alive_players = num_alive_players + 1
			end
		end

		target_hit_count = num_alive_players
	end

	if self._unique_counting and self._min_unique_hit_count > 0 then
		target_hit_count = math.max(self._min_unique_hit_count, target_hit_count)
	end

	if self._unique_counting and not self._attacking_units[attacking_unit] or not self._unique_counting then
		self._hit_count = self._hit_count + 1

		if self._unit_flow_on_unique_hit_count ~= "none" then
			Unit.flow_event(self._unit, self._unit_flow_on_unique_hit_count)
		end
	end

	if not self._attacking_units[attacking_unit] then
		self._attacking_units[attacking_unit] = true
	end

	if target_hit_count <= self._hit_count then
		if self._level_flow_on_hit_count ~= "none" then
			Level.trigger_event(self._level, self._level_flow_on_hit_count)
		end

		if self._unit_flow_on_hit_count ~= "none" then
			Unit.flow_event(self._unit, self._unit_flow_on_hit_count)
		end
	end
end

CountPlayerHits.component_data = {
	enabled = {
		ui_name = "Enabled",
		ui_type = "check_box",
		value = false,
	},
	hit_count = {
		ui_name = "Hit Count",
		ui_type = "number",
		value = 1,
	},
	level_flow_on_hit_count = {
		ui_name = "Level Flow Event On Reached Hit Count",
		ui_type = "text_box",
		value = "none",
	},
	unit_flow_on_hit_count = {
		ui_name = "Unit Flow Event On Reached Hit Count",
		ui_type = "text_box",
		value = "none",
	},
	unit_flow_on_unique_hit_count = {
		ui_name = "Unique Unit Flow Event On Reached Hit Count",
		ui_type = "text_box",
		value = "none",
	},
	unique_counting = {
		ui_name = "Unique Counting",
		ui_type = "check_box",
		value = false,
	},
	set_hit_count_to_num_players = {
		ui_name = "Set Hit Count To Num Players",
		ui_type = "check_box",
		value = false,
	},
	min_unique_hit_count = {
		ui_name = "Min Unique Hit Count",
		ui_type = "number",
		value = 0,
	},
}

return CountPlayerHits
