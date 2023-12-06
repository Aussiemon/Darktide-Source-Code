local FoliageInteraction = class("FoliageInteraction")

FoliageInteraction.init = function (self, gui, settings)
	self._gui = gui
	self._settings = settings
end

FoliageInteraction.update = function (self, dt, t)
	local local_player = Managers.player:local_player(1)
	local local_player_unit = local_player and local_player.player_unit

	if Unit.alive(local_player_unit) then
		self:_update_foliage_players(dt, t)
		self:_update_foliage_ai(local_player_unit, dt, t)
	end
end

local TEXTURE_SIZE = {}

FoliageInteraction._update_foliage_players = function (self, dt, t)
	local foliage_settings = self._settings
	local material_name = foliage_settings.default_foliage_material
	local window_size = math.clamp(foliage_settings.window_size, 1, 100)
	local texture_world_size = foliage_settings.default_texture_world_size
	local duplicate_edge_cases = foliage_settings.duplicate_edge_cases
	local local_player_multiplier = foliage_settings.local_player_multiplier
	local players = Managers.player:players()
	local w, h = Gui.resolution()

	for _, player in pairs(players) do
		local player_unit = player.player_unit
		local unit_pos = POSITION_LOOKUP[player_unit]

		if unit_pos then
			local mover = Unit.mover(player_unit)

			if Mover.collides_down(mover) then
				local texture_size = nil

				if player.local_player then
					TEXTURE_SIZE[1] = texture_world_size[1] * local_player_multiplier
					TEXTURE_SIZE[2] = texture_world_size[2] * local_player_multiplier
					texture_size = TEXTURE_SIZE
				else
					texture_size = texture_world_size
				end

				local relative_world_pos = Vector2(unit_pos[1] % window_size, unit_pos[2] % window_size)
				local relative_texture_pos = Vector2(relative_world_pos[1] / window_size, relative_world_pos[2] / window_size)
				local relative_screen_pos = Vector3(relative_texture_pos[1] * w, relative_texture_pos[2] * h, 0)
				local relative_texture_size = Vector2(texture_size[1] / window_size * w, texture_size[2] / window_size * h)
				local relative_start_pos = relative_screen_pos - relative_texture_size * 0.5

				Gui.bitmap(self._gui, material_name, relative_start_pos, relative_texture_size, Color(255, 255, 255, 255))

				if duplicate_edge_cases then
					if relative_start_pos.x < 0 then
						local offset = relative_start_pos + Vector3(w, 0, 0)

						Gui.bitmap(self._gui, material_name, offset, relative_texture_size, Color(255, 255, 255, 255))
					elseif w < relative_start_pos.x + relative_texture_size.x then
						local offset = relative_start_pos + Vector3(-w, 0, 0)

						Gui.bitmap(self._gui, material_name, offset, relative_texture_size, Color(255, 255, 255, 255))
					end

					if relative_start_pos.y < 0 then
						local offset = relative_start_pos + Vector3(0, h, 0)

						Gui.bitmap(self._gui, material_name, offset, relative_texture_size, Color(255, 255, 255, 255))
					elseif h < relative_start_pos.y + relative_texture_size.x then
						local offset = relative_start_pos + Vector3(0, -h, 0)

						Gui.bitmap(self._gui, material_name, offset, relative_texture_size, Color(255, 255, 255, 255))
					end
				end
			end
		end
	end
end

FoliageInteraction._update_foliage_ai = function (self, local_player_unit, dt, t)
	local foliage_settings = self._settings
	local material_name = foliage_settings.default_foliage_material
	local window_size = math.clamp(foliage_settings.window_size, 1, 100)
	local texture_world_size = foliage_settings.default_texture_world_size
	local duplicate_edge_cases = foliage_settings.duplicate_edge_cases
	local w, h = Gui.resolution()
	local player_pos = Unit.local_position(local_player_unit, 1)

	if not Managers.state.entity then
		return
	end

	local ai_broadphase = Managers.state.entity:system("ai_system").broadphase
	local num_enemies = Broadphase.query(ai_broadphase, player_pos, window_size * 0.5, ENEMIES)

	for i = 1, num_enemies do
		local ai_unit = ENEMIES[i]

		if Unit.alive(ai_unit) then
			local unit_pos = POSITION_LOOKUP[ai_unit]
			local relative_world_pos = Vector2(unit_pos[1] % window_size, unit_pos[2] % window_size)
			local relative_texture_pos = Vector2(relative_world_pos[1] / window_size, relative_world_pos[2] / window_size)
			local relative_screen_pos = Vector3(relative_texture_pos[1] * w, h - relative_texture_pos[2] * h, 0)
			local relative_texture_size = Vector2(texture_world_size[1] / window_size * w, texture_world_size[2] / window_size * h)
			local relative_start_pos = relative_screen_pos - relative_texture_size * 0.5

			Gui.bitmap(self._gui, material_name, relative_start_pos, relative_texture_size, Color(255, 255, 255, 255))

			if duplicate_edge_cases then
				if relative_start_pos.x < 0 then
					local offset = relative_start_pos + Vector3(w, 0, 0)

					Gui.bitmap(self._gui, material_name, offset, relative_texture_size, Color(255, 255, 255, 255))
				elseif w < relative_start_pos.x + relative_texture_size.x then
					local offset = relative_start_pos + Vector3(-w, 0, 0)

					Gui.bitmap(self._gui, material_name, offset, relative_texture_size, Color(255, 255, 255, 255))
				end

				if relative_start_pos.y < 0 then
					local offset = relative_start_pos + Vector3(0, h, 0)

					Gui.bitmap(self._gui, material_name, offset, relative_texture_size, Color(255, 255, 255, 255))
				elseif h < relative_start_pos.y + relative_texture_size.x then
					local offset = relative_start_pos + Vector3(0, -h, 0)

					Gui.bitmap(self._gui, material_name, offset, relative_texture_size, Color(255, 255, 255, 255))
				end
			end
		end
	end
end

return FoliageInteraction
