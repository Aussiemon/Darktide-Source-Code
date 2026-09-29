-- chunkname: @scripts/managers/mutator/mutators/mutator_gameplay/torment_light_flicker.lua

local TormentLightFlicker = class("TormentLightFlicker")
local DEFAULT_INNER_RADIUS = 25
local DEFAULT_OUTER_RADIUS = 50
local DEFAULT_STEP_FREQUENCY = 10
local DEFAULT_PATTERN = {
	1,
	1,
	0.2,
	1,
	1,
	1,
	0.1,
	1,
	0.6,
	1,
	1,
	0.3,
	1,
	0,
	1,
	0.4,
	1,
	1,
}

TormentLightFlicker.init = function (self, settings)
	settings = settings or {}
	self._inner_radius = settings.inner_radius or DEFAULT_INNER_RADIUS
	self._outer_radius = settings.outer_radius or DEFAULT_OUTER_RADIUS
	self._outer_radius_sq = self._outer_radius * self._outer_radius
	self._step_frequency = settings.step_frequency or DEFAULT_STEP_FREQUENCY
	self._pattern = settings.pattern or DEFAULT_PATTERN
	self._pattern_length = #self._pattern
	self._active = false
	self._start_t = nil
	self._duration = 0
	self._last_step = nil
	self._affected = {}
end

TormentLightFlicker.start = function (self, duration)
	if self._active then
		return
	end

	self._active = true
	self._start_t = nil
	self._duration = duration
	self._last_step = nil
	self._affected = {}
end

TormentLightFlicker.update = function (self, dt, t)
	if not self._active then
		return
	end

	if self._start_t == nil then
		self._start_t = t
	end

	local elapsed = t - self._start_t

	if elapsed >= self._duration then
		self:stop()

		return
	end

	local step = math.floor(elapsed * self._step_frequency)

	if step ~= self._last_step then
		self._last_step = step

		self:_tick(step)
	end
end

TormentLightFlicker._tick = function (self, step)
	local extension_manager = Managers.state.extension
	local light_system = extension_manager and extension_manager:system("light_controller_system")

	if not light_system then
		self:stop()

		return
	end

	local player_positions = self:_player_positions()
	local affected = self._affected
	local seen = {}
	local value = self._pattern[step % self._pattern_length + 1]
	local saved_temp = Script.temp_byte_count()

	for unit, extension in pairs(light_system:unit_to_extension_map()) do
		repeat
			if not Unit.alive(unit) then
				break
			end

			if not extension:is_enabled() then
				break
			end

			if extension:is_flicker_enabled() then
				break
			end

			local lx, ly, lz = Vector3.to_elements(Unit.world_position(unit, 1))
			local depth = self:_depth_at(lx, ly, lz, player_positions)

			if depth <= 0 then
				break
			end

			seen[unit] = true

			local entry = affected[unit]

			if not entry then
				entry = self:_capture(unit)
				affected[unit] = entry
			end

			self:_apply(entry, value, depth)
		until true

		Script.set_temp_byte_count(saved_temp)
	end

	self:_tick_local_player_lights(value, seen, affected)

	for unit, entry in pairs(affected) do
		if not seen[unit] then
			self:_restore(entry)

			affected[unit] = nil
		end
	end
end

TormentLightFlicker._player_positions = function (self)
	local positions = {}
	local players = Managers.player:players()

	for _, player in pairs(players) do
		if player:unit_is_alive() then
			local x, y, z = Vector3.to_elements(Unit.world_position(player.player_unit, 1))

			positions[#positions + 1] = {
				x,
				y,
				z,
			}
		end
	end

	return positions
end

TormentLightFlicker._depth_at = function (self, lx, ly, lz, player_positions)
	local best_dist_sq = math.huge

	for i = 1, #player_positions do
		local p = player_positions[i]
		local dx, dy, dz = lx - p[1], ly - p[2], lz - p[3]
		local dist_sq = dx * dx + dy * dy + dz * dz

		if dist_sq < best_dist_sq then
			best_dist_sq = dist_sq
		end
	end

	if best_dist_sq >= self._outer_radius_sq then
		return 0
	end

	local dist = math.sqrt(best_dist_sq)

	if dist <= self._inner_radius then
		return 1
	end

	return (self._outer_radius - dist) / (self._outer_radius - self._inner_radius)
end

TormentLightFlicker._tick_local_player_lights = function (self, value, seen, affected)
	local player = Managers.player:local_player(1)

	if not player or not player:unit_is_alive() then
		return
	end

	local first_person_unit = ScriptUnit.extension(player.player_unit, "first_person_system"):first_person_unit()

	if not first_person_unit or not Unit.alive(first_person_unit) then
		return
	end

	if Unit.num_lights(first_person_unit) == 0 then
		return
	end

	seen[first_person_unit] = true

	local entry = affected[first_person_unit]

	if not entry then
		entry = self:_capture(first_person_unit)
		affected[first_person_unit] = entry
	end

	self:_apply(entry, value, 1)
end

TormentLightFlicker._capture = function (self, unit)
	local lights = {}
	local num_lights = Unit.num_lights(unit)

	for i = 1, num_lights do
		local light = Unit.light(unit, i)

		lights[i] = {
			light = light,
			base = Light.intensity(light),
		}
	end

	return {
		unit = unit,
		lights = lights,
	}
end

TormentLightFlicker._apply = function (self, entry, value, depth)
	local scale = 1 - depth + depth * value
	local lights = entry.lights

	for i = 1, #lights do
		local light = lights[i]

		Light.set_intensity(light.light, light.base * scale)
	end
end

TormentLightFlicker._restore = function (self, entry)
	if not Unit.alive(entry.unit) then
		return
	end

	local lights = entry.lights

	for i = 1, #lights do
		local light = lights[i]

		Light.set_intensity(light.light, light.base)
	end
end

TormentLightFlicker.stop = function (self)
	for _, entry in pairs(self._affected) do
		self:_restore(entry)
	end

	self._affected = {}
	self._active = false
	self._start_t = nil
	self._last_step = nil
end

TormentLightFlicker.destroy = function (self)
	self:stop()
end

return TormentLightFlicker
