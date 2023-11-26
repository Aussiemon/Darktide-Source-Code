-- chunkname: @scripts/managers/world_interaction/world_interaction_manager.lua

local FoliageInteraction = require("scripts/managers/world_interaction/foliage_interaction")
local WorldInteractionSettings = require("scripts/managers/world_interaction/world_interaction_settings")
local WorldInteractionManager = class("WorldInteractionManager")

WorldInteractionManager.init = function (self, world)
	self._world = world
	self._water_timer = 0
	self._water_ripples = {}
	self._units = {}

	self:_setup_gui()

	self._foliage_interaction = FoliageInteraction:new(self._gui, WorldInteractionSettings.foliage)
end

WorldInteractionManager._setup_gui = function (self)
	self._gui = World.create_gui(self._world, {
		use_custom_dimension = true,
		height = 512,
		width = 512,
		immediate = true
	})
end

WorldInteractionManager.add_world_interaction = function (self, material, unit)
	self:remove_world_interaction(unit, material)

	self._units[material] = self._units[material] or {}
	self._units[material][unit] = self._units[material][unit] or Managers.time:time("gameplay")
end

WorldInteractionManager.remove_world_interaction = function (self, unit, material_to_ignore)
	for material, units in pairs(self._units) do
		if not material_to_ignore or material_to_ignore ~= material then
			units[unit] = nil
		end
	end
end

WorldInteractionManager._add_water_ripple = function (self, pos, angle, material, random_size_diff, stretch_multiplier, ref_time, size, multiplier)
	local water_settings = WorldInteractionSettings.water
	local random_ripple_size_diff = water_settings.random_ripple_size_diff

	self._water_ripples[#self._water_ripples + 1] = {
		timer = 0,
		pos = Vector3Box(pos),
		size_variable = 1 - random_ripple_size_diff * 0.5 + math.random() * random_ripple_size_diff,
		angle = angle,
		material = material or water_settings.default_ripple_material,
		stretch_multiplier = stretch_multiplier,
		ref_time = ref_time,
		default_size = size,
		multiplier = multiplier
	}
end

WorldInteractionManager.add_simple_effect = function (self, material, unit, position)
	local player_manager = Managers.player
	local local_player = player_manager:local_player(1)
	local player_unit = local_player and local_player.player_unit

	if Unit.alive(player_unit) then
		local material_settings = WorldInteractionSettings[material]
		local window_size = math.clamp(material_settings.window_size, 1, 100)
		local window_distance = window_size * 0.5
		local player_pos = POSITION_LOOKUP[player_unit]

		if Vector3.distance_squared(player_pos, position) < window_distance * window_distance then
			self["_add_simple_" .. material .. "_effect"](self, unit, position)
		end
	end
end

WorldInteractionManager._add_simple_water_effect = function (self, unit, position)
	local water_settings = WorldInteractionSettings.water
	local water_splash_settings = water_settings.splash
	local material = water_splash_settings.default_material
	local window_size = math.clamp(water_settings.window_size, 1, 100)
	local stretch_multiplier = water_splash_settings.stretch_multiplier
	local multiplier = water_splash_settings.multiplier
	local timer_ref = water_splash_settings.timer_ref
	local random_size_diff = water_splash_settings.random_size_diff
	local local_player = Managers.player:local_player(1)
	local player_unit = local_player and local_player.player_unit

	if Unit.alive(player_unit) then
		local window_distance = window_size * 0.5
		local player_pos = POSITION_LOOKUP[player_unit]
		local start_size = water_splash_settings.start_size

		if Vector3.distance_squared(position, player_pos) < window_distance * window_distance then
			self:_add_water_ripple(position, 0, material, random_size_diff, stretch_multiplier, timer_ref, start_size, multiplier)
		end
	end
end

WorldInteractionManager.update = function (self, dt, t)
	if DEDICATED_SERVER then
		return
	end

	self:_update_water(dt, t)
end

WorldInteractionManager._update_water = function (self, dt, t)
	local available_units = self._units.water
	local local_player = Managers.player:local_player(1)
	local player_unit = local_player and local_player.player_unit

	if Unit.alive(player_unit) and (#self._water_ripples > 0 or available_units and next(available_units)) then
		self:_cleanup_removed_units()
		self:_update_water_data(dt, t)
		self:_update_water_ripples(dt, t)
	end
end

local UNITS_TO_REMOVE = {}

WorldInteractionManager._cleanup_removed_units = function (self)
	table.clear(UNITS_TO_REMOVE)

	for material, units in pairs(self._units) do
		for unit, _ in pairs(units) do
			if not ALIVE[unit] then
				UNITS_TO_REMOVE[#UNITS_TO_REMOVE + 1] = unit
			end
		end
	end

	for material, units in pairs(self._units) do
		for _, unit in ipairs(UNITS_TO_REMOVE) do
			units[unit] = nil
		end
	end
end

local COLLECTED_UNITS = {}
local BROADPHASE_RESULTS = {}

local function collect_characters(available_units, player_pos, window_size)
	local broadphase_system = Managers.state.extension:system("broadphase_system")
	local broadphase = broadphase_system.broadphase
	local side_system = Managers.state.extension:system("side_system")
	local side_names = side_system:side_names()
	local num_results = broadphase.query(broadphase, player_pos, window_size * 0.5, BROADPHASE_RESULTS, side_names)

	for ii = 1, num_results do
		local unit = BROADPHASE_RESULTS[ii]

		if available_units[unit] then
			COLLECTED_UNITS[#COLLECTED_UNITS + 1] = unit
		end
	end
end

WorldInteractionManager._update_water_data = function (self, dt, t)
	local water_settings = WorldInteractionSettings.water
	local window_size = math.clamp(water_settings.window_size, 1, 100)
	local speed_limit = water_settings.water_speed_limit
	local ripple_time_step = water_settings.ripple_time_step
	local max_contributing_units = water_settings.max_contributing_units

	self._water_timer = self._water_timer or 0

	if ripple_time_step <= self._water_timer then
		table.clear(COLLECTED_UNITS)

		local available_units = self._units.water
		local local_player = Managers.player:local_player(1)
		local player_unit = local_player and local_player.player_unit
		local player_pos = Vector3.flat(POSITION_LOOKUP[player_unit])

		if Unit.alive(player_unit) and available_units and next(available_units) then
			collect_characters(available_units, player_pos, window_size)

			local origo = Vector3(0, 0, 0)
			local speed_limit_squared = speed_limit * speed_limit
			local contributing_units = 0

			for ii = 1, #COLLECTED_UNITS do
				local unit = COLLECTED_UNITS[ii]

				if ALIVE[unit] then
					local locomotion_extension = ScriptUnit.extension(unit, "locomotion_system")
					local dir = locomotion_extension:current_velocity()

					if dir and speed_limit_squared < Vector3.distance_squared(Vector3.flat(dir), origo) then
						local flat_dir = Vector3.normalize(Vector3(dir[1], dir[2], 0))
						local dot_value = Vector3.dot(flat_dir, Vector3(0, 1, 0))
						local safe_dot_value = math.clamp(dot_value, -1, 1)
						local angle = math.acos(safe_dot_value) * (flat_dir[1] > 0 and 1 or -1)
						local pos = POSITION_LOOKUP[unit]

						if angle == angle then
							self:_add_water_ripple(pos, angle)

							contributing_units = contributing_units + 1

							if max_contributing_units <= contributing_units then
								break
							end
						end
					end
				end
			end

			self._water_timer = 0
		end
	end

	self._water_timer = self._water_timer + dt
end

local function draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
	local tm = Rotation2D(Vector3(0, 0, 0), angle, offset + relative_texture_size * 0.5)

	Gui.bitmap_3d(gui, water_material, tm, offset, layer, relative_texture_size, Color(alpha, 255, 255, 255))
end

local DATA_TO_REMOVE = {}

WorldInteractionManager._update_water_ripples = function (self, dt, t)
	table.clear(DATA_TO_REMOVE)

	local gui = self._gui
	local water_settings = WorldInteractionSettings.water
	local default_ripple_start_size = water_settings.default_ripple_start_size
	local default_ripple_multiplier = water_settings.default_ripple_multiplier
	local default_ripple_timer = water_settings.default_ripple_timer
	local duplicate_edge_cases = water_settings.duplicate_edge_cases
	local ripple_stretch_multiplier = water_settings.ripple_stretch_multiplier
	local gui_width, gui_height = 512, 512
	local window_size = math.clamp(water_settings.window_size, 1, 100)
	local water_data
	local num_water_data = #self._water_ripples

	for idx = 1, num_water_data do
		water_data = self._water_ripples[idx]

		local ref_time = water_data.ref_time or default_ripple_timer
		local pos = water_data.pos:unbox()
		local stretch_multiplier = water_data.stretch_multiplier or ripple_stretch_multiplier
		local multiplier = water_data.multiplier or default_ripple_multiplier
		local default_size = water_data.default_size or default_ripple_start_size
		local start_size = default_size[1] * (water_data.size_variable or 0)
		local t_ease = math.easeOutCubic(water_data.timer / ref_time)
		local size = math.lerp(start_size, start_size * multiplier, t_ease)
		local relative_world_pos = Vector2(pos[1] % window_size, pos[2] % window_size)
		local relative_texture_pos = Vector2(relative_world_pos[1] / window_size, relative_world_pos[2] / window_size)
		local relative_screen_pos = Vector3(relative_texture_pos[1] * gui_width, relative_texture_pos[2] * gui_height, 0)
		local relative_texture_size = Vector2(size * stretch_multiplier[1] / window_size * gui_width, size * stretch_multiplier[2] / window_size * gui_height)
		local layer = 50
		local angle = water_data.angle
		local relative_start_pos = relative_screen_pos - relative_texture_size * 0.5
		local value = 1 - math.pow(water_data.timer / ref_time, 0.5)
		local alpha = value * 255
		local water_material = water_data.material
		local screen_material = "content/materials/default_water_ripple_screen"

		draw_water_bitmap(gui, relative_start_pos, angle, relative_texture_size, layer, alpha, water_material, screen_material)

		if duplicate_edge_cases then
			local outside_left = relative_start_pos.x - relative_texture_size.x < 0
			local outside_right = gui_width < relative_start_pos.x + relative_texture_size.x * 2
			local outside_down = relative_start_pos.y < 0
			local outside_up = gui_height < relative_start_pos.y + relative_texture_size.y

			if outside_left then
				local offset = relative_start_pos + Vector3(gui_width, 0, 0)

				draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
			elseif outside_right then
				local offset = relative_start_pos + Vector3(-gui_width, 0, 0)

				draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
			end

			if outside_down then
				local offset = relative_start_pos + Vector3(0, gui_height, 0)

				draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
			elseif outside_up then
				local offset = relative_start_pos + Vector3(0, -gui_height, 0)

				draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
			end

			if outside_left and outside_down then
				local offset = relative_start_pos + Vector3(gui_width, gui_height, 0)

				draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
			elseif outside_left and outside_up then
				local offset = relative_start_pos + Vector3(gui_width, -gui_height, 0)

				draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
			elseif outside_right and outside_down then
				local offset = relative_start_pos + Vector3(-gui_width, gui_height, 0)

				draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
			elseif outside_right and outside_up then
				local offset = relative_start_pos + Vector3(-gui_width, -gui_height, 0)

				draw_water_bitmap(gui, offset, angle, relative_texture_size, layer, alpha, water_material, screen_material)
			end
		end

		water_data.timer = water_data.timer + dt

		if ref_time <= water_data.timer then
			DATA_TO_REMOVE[#DATA_TO_REMOVE + 1] = idx
		end
	end

	for i = #DATA_TO_REMOVE, 1, -1 do
		local idx = DATA_TO_REMOVE[i]

		table.remove(self._water_ripples, idx)
	end
end

WorldInteractionManager.destroy = function (self)
	World.destroy_gui(self._world, self._gui)
end

return WorldInteractionManager
