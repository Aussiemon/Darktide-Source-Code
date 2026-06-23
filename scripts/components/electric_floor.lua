-- chunkname: @scripts/components/electric_floor.lua

local ElectricFloor = component("ElectricFloor")
local STATES = table.enum("idle", "charging", "active")
local CHARGE_TIME = 1
local ELECTRIC_REFRESH_TIME = 1
local AWAKE_REFRESH_TIME = 1
local AWAKE_DISTANCE_SQUARED = 625

ElectricFloor.init = function (self, unit)
	self._awake = false
	self._awake_timer = 0
	self._on_sleep_state = nil

	local timed = self:get_data(unit, "timed")

	self._timed = timed

	local start_enabled = self:get_data(unit, "start_enabled")

	self._interactee_system = Managers.state.extension:system("interactee_system")
	self._electrified_interacts = {}
	self._state = start_enabled and STATES.active or STATES.idle
	self._time_on = self:get_data(unit, "time_on")
	self._time_off = self:get_data(unit, "time_off")

	local offset_time = self:get_data(unit, "offset_time")

	self._time = offset_time
	self._electric_refresh_timer = 0

	return timed or start_enabled
end

ElectricFloor.editor_init = function (self, unit)
	return false
end

ElectricFloor.enable = function (self, unit)
	return
end

ElectricFloor.disable = function (self, unit)
	return
end

ElectricFloor.destroy = function (self, unit)
	return
end

ElectricFloor.editor_validate = function (self, unit)
	local success = true
	local error_message = ""

	if self:get_data(unit, "time_on") <= CHARGE_TIME then
		return false, string.format("time_on needs to be larger than charging time (%s)", CHARGE_TIME)
	end

	return success, error_message
end

ElectricFloor.update = function (self, unit, dt, t)
	self._awake_timer = self._awake_timer - dt

	if self._awake_timer < 0 then
		local players = Managers.player:human_players()
		local position = POSITION_LOOKUP[unit]
		local should_be_awake = false

		for _, player in pairs(players) do
			if player.player_unit and ALIVE[player.player_unit] and Vector3.distance_squared(POSITION_LOOKUP[player.player_unit], position) < AWAKE_DISTANCE_SQUARED then
				should_be_awake = true

				break
			end
		end

		if should_be_awake ~= self._awake then
			self._awake = should_be_awake

			if should_be_awake and self._on_sleep_state ~= self._state then
				self:_trigger_event()
			else
				self._on_sleep_state = self._state
			end
		end

		self._awake_timer = AWAKE_REFRESH_TIME
	end

	self._time = self._time + dt

	if self._state == STATES.charging then
		if self._time >= CHARGE_TIME then
			self:_set_state(STATES.active)
		end
	elseif self._state == STATES.active then
		if self._timed and self._time >= self._time_on then
			self:_set_state(STATES.idle)

			self._time = self._time - self._time_on
		end
	elseif self._timed and self._time >= self._time_off then
		self:_set_state(STATES.charging)

		self._time = self._time - self._time_off
	end

	if self._awake then
		self._electric_refresh_timer = self._electric_refresh_timer + dt

		if self._electric_refresh_timer > ELECTRIC_REFRESH_TIME then
			self:_interaction_update()
		end
	end

	return true
end

ElectricFloor.editor_update = function (self, unit)
	return false
end

ElectricFloor._set_state = function (self, state)
	if state == self._state then
		return
	end

	self._state = state

	self:_trigger_event()
end

ElectricFloor._trigger_event = function (self)
	if not self._awake then
		return
	end

	if self._state == STATES.charging then
		Unit.flow_event(self.unit, "lua_electric_floor_charging")
	elseif self._state == STATES.active then
		Unit.flow_event(self.unit, "lua_electric_floor_on")
		self:_interaction_update()
	else
		Unit.flow_event(self.unit, "lua_electric_floor_off")
		self:_interaction_update()
	end
end

ElectricFloor._interaction_update = function (self)
	local electrified_interacts = self._electrified_interacts

	if self._state == STATES.active then
		local interactees = self._interactee_system:unit_to_extension_map()

		for interact_unit, interactee_extension in pairs(interactees) do
			if interactee_extension.set_electrified then
				local interaction_position = Unit.world_position(interact_unit, 1)

				if Unit.is_point_inside_volume(self.unit, "damage_volume", interaction_position) then
					electrified_interacts[interact_unit] = interactee_extension

					interactee_extension:set_electrified(true)
				elseif electrified_interacts[interact_unit] then
					interactee_extension:set_electrified(false)

					electrified_interacts[interact_unit] = nil
				end
			end
		end
	else
		for interact_unit, interactee_extension in pairs(electrified_interacts) do
			if ALIVE[interact_unit] then
				interactee_extension:set_electrified(false)

				electrified_interacts[interact_unit] = nil
			end
		end
	end

	self._electric_refresh_timer = 0
end

ElectricFloor.electric_floor_on = function (self)
	if self._state == STATES.idle then
		self:_set_state(STATES.charging)
	end

	self._time = 0

	return true
end

ElectricFloor.electric_floor_off = function (self)
	self:_set_state(STATES.idle)

	self._time = 0

	return true
end

ElectricFloor.electric_floor_disable = function (self)
	self:electric_floor_off()

	self._timed = false

	return false
end

ElectricFloor.component_data = {
	timed = {
		ui_name = "timed",
		ui_type = "check_box",
		value = false,
	},
	start_enabled = {
		ui_name = "start enabled",
		ui_type = "check_box",
		value = false,
	},
	time_on = {
		decimals = 2,
		ui_name = "time on",
		ui_type = "number",
		value = 4,
	},
	time_off = {
		decimals = 2,
		ui_name = "time off",
		ui_type = "number",
		value = 2,
	},
	offset_time = {
		decimals = 2,
		ui_name = "offset time",
		ui_type = "number",
		value = 0,
	},
	inputs = {
		electric_floor_on = {
			accessibility = "public",
			type = "event",
		},
		electric_floor_off = {
			accessibility = "public",
			type = "event",
		},
		electric_floor_disable = {
			accessibility = "public",
			type = "event",
		},
	},
}

return ElectricFloor
