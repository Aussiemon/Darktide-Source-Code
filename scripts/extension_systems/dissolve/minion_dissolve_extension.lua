-- chunkname: @scripts/extension_systems/dissolve/minion_dissolve_extension.lua

local DISSOLVE_START_FLOW_EVENT = "dissolve_start"
local DISSOLVE_END_FLOW_EVENT = "dissolve_end"
local MinionDissolveExtension = class("MinionDissolveExtension")

MinionDissolveExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	self._unit = unit

	local breed = extension_init_data.breed

	self._breed = breed
	self._dissolve_config = breed.dissolve_config
	self._start_flow_event_triggered = false
	self._end_flow_event_triggered = false
end

MinionDissolveExtension.set_unit_local = function (self)
	local dissolve_config = self._dissolve_config
	local delay = dissolve_config.delay or 0
	local t = Managers.time:time("gameplay")

	self:_dissolve(delay, t)
end

MinionDissolveExtension.update = function (self, unit, dt, t)
	local dissolve_data = self._dissolve_data

	if not dissolve_data then
		return
	end

	local start_t = dissolve_data.start_t

	if t < start_t then
		return
	end

	if not ALIVE[unit] then
		return
	end

	local start_flow_event_triggered = self._start_flow_event_triggered

	if not start_flow_event_triggered then
		Unit.flow_event(unit, DISSOLVE_START_FLOW_EVENT)

		self._start_flow_event_triggered = true
	end

	local dissolve_config = self._dissolve_config
	local elapsed = dissolve_data.elapsed
	local duration = dissolve_config.duration

	if duration <= elapsed then
		local remove_ragdoll_when_done = dissolve_config.remove_ragdoll_when_done

		if remove_ragdoll_when_done then
			local minion_death_manager = Managers.state.minion_death
			local minion_ragdoll = minion_death_manager:minion_ragdoll()

			minion_ragdoll:remove_ragdoll_safe(unit)
		end

		local end_flow_event_triggered = self._end_flow_event_triggered

		if not end_flow_event_triggered then
			Unit.flow_event(unit, DISSOLVE_END_FLOW_EVENT)

			self._end_flow_event_triggered = true
		end

		self._dissolve_data = nil

		local Destroy_actor = Unit.destroy_actor
		local Unit_actor = Unit.actor
		local breed = self._breed
		local hit_zones = breed.hit_zones

		for ii = 1, #hit_zones do
			local hit_zone = hit_zones[ii]
			local actors = hit_zone.actors

			for jj = 1, #actors do
				local actor_name = actors[jj]
				local actor = Unit_actor(unit, actor_name)

				if actor then
					Destroy_actor(unit, actor)
				end
			end
		end

		return
	end

	elapsed = elapsed + dt
	dissolve_data.elapsed = elapsed

	local from = dissolve_config.from
	local to = dissolve_config.to
	local value = math.lerp(from, to, elapsed / duration)

	dissolve_data.value = value

	local dissolve_unit = dissolve_data.dissolve_unit
	local material_names = dissolve_config.material_names
	local material_variable_name = dissolve_config.material_variable_name

	for i = 1, #material_names do
		local material_name = material_names[i]

		Unit.set_scalar_for_material(dissolve_unit, material_name, material_variable_name, value)

		local stump_units = self._stump_units

		if stump_units then
			for j = 1, #stump_units do
				local stump_unit = stump_units[j]

				Unit.set_scalar_for_material(stump_unit, material_name, material_variable_name, value)
			end
		end
	end
end

MinionDissolveExtension._dissolve = function (self, delay, t)
	local unit = self._unit
	local dissolve_config = self._dissolve_config
	local slot_name = dissolve_config.slot_name
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local slot_unit = visual_loadout_extension:slot_unit(slot_name)

	self._dissolve_data = {
		elapsed = 0,
		start_t = t + delay,
		value = dissolve_config.from,
		dissolve_unit = slot_unit
	}
end

MinionDissolveExtension.register_stump_unit = function (self, stump_unit)
	if not self._stump_units then
		self._stump_units = {}
	end

	self._stump_units[#self._stump_units + 1] = stump_unit
end

return MinionDissolveExtension
