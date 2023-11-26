-- chunkname: @scripts/extension_systems/input/player_unit_input_extension.lua

local HumanUnitInput = require("scripts/extension_systems/input/human_unit_input")
local BotUnitInput = require("scripts/extension_systems/input/bot_unit_input")
local PlayerUnitInputExtension = class("PlayerUnitInputExtension")

PlayerUnitInputExtension.init = function (self, extension_init_context, unit, extension_init_data, ...)
	local player, input_handler = extension_init_data.player, extension_init_data.input_handler
	local fixed_frame = extension_init_context.fixed_frame

	self._human_unit_input = HumanUnitInput:new(player, input_handler, fixed_frame)
	self._player = player
	self._is_local_unit = extension_init_data.is_local_unit

	local is_server = extension_init_context.is_server

	if is_server then
		local physics_world = extension_init_context.physics_world

		self._bot_unit_input = BotUnitInput:new(physics_world, player)
	end

	self._is_server = is_server
end

PlayerUnitInputExtension.extensions_ready = function (self, world, unit)
	if self._is_server then
		self._bot_unit_input:extensions_ready(world, unit)
	end
end

PlayerUnitInputExtension.fixed_update = function (self, unit, dt, t, frame)
	if self._player:is_human_controlled() then
		self._human_unit_input:fixed_update(unit, dt, t, frame)
	else
		self._bot_unit_input:fixed_update(unit, dt, t, frame)
	end
end

PlayerUnitInputExtension.update = function (self, unit, dt, t)
	if not self._player:is_human_controlled() then
		self._bot_unit_input:update(unit, dt, t)
	end
end

PlayerUnitInputExtension.bot_unit_input = function (self)
	return self._bot_unit_input
end

PlayerUnitInputExtension.get_orientation = function (self)
	local yaw, pitch, roll

	if self._player:is_human_controlled() then
		yaw, pitch, roll = self._human_unit_input:get_orientation()
	else
		yaw, pitch, roll = self._bot_unit_input:get_orientation()
	end

	return yaw, pitch, roll
end

PlayerUnitInputExtension.get = function (self, action)
	local result

	if self._player:is_human_controlled() then
		result = self._human_unit_input:get(action)
	else
		result = self._bot_unit_input:get(action)
	end

	return result
end

PlayerUnitInputExtension.had_received_input = function (self, fixed_frame)
	local result

	if self._player:is_human_controlled() then
		result = self._human_unit_input:had_received_input(fixed_frame)
	else
		result = true
	end

	return result
end

return PlayerUnitInputExtension
