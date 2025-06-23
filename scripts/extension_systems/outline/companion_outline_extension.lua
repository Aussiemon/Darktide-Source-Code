-- chunkname: @scripts/extension_systems/outline/companion_outline_extension.lua

local CompanionOutlineExtension = class("CompanionOutlineExtension")
local Missions = require("scripts/settings/mission/mission_templates")

CompanionOutlineExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data_or_game_session, nil_or_game_object_id, something)
	local is_server = extension_init_context.is_server

	self._is_server = is_server

	local mission_name = Managers.state.mission:mission_name()
	local mission_settings = Missions[mission_name]

	self._is_hub = mission_settings.is_hub

	if not is_server then
		self._game_session_id = game_object_data_or_game_session
		self._game_object_id = nil_or_game_object_id
	end

	self._world = extension_init_context.world
	self._unit = unit
	self._owner_player = extension_init_data.owner_player
	self._outline_started = true
	self._outline_system = Managers.state.extension:system("outline_system")
end

CompanionOutlineExtension.game_object_initialized = function (self, session, object_id)
	self._game_session_id = session
	self._game_object_id = object_id
end

CompanionOutlineExtension.extensions_ready = function (self, world, unit)
	local visual_loadout_extension = ScriptUnit.extension(unit, "visual_loadout_system")
	local is_slot_unit_spawned = visual_loadout_extension:is_slot_unit_spawned("slot_companion_gear_full")
	local is_slot_unit_valid = visual_loadout_extension:is_slot_unit_valid("slot_companion_gear_full")

	if is_slot_unit_spawned and is_slot_unit_valid then
		local save_data = Managers.save:account_data()
		local interface_settings = save_data.interface_settings

		self:_event_update_companion_outlines(interface_settings.companion_outlines)
	else
		self._outline_started = false

		Managers.event:register(self, "on_spawn_companion_item", "_on_spawn_companion_item")
	end

	Managers.event:register(self, "event_update_companion_outlines", "_event_update_companion_outlines")
end

CompanionOutlineExtension.hot_join_sync = function (self, unit, sender, channel_id)
	return
end

CompanionOutlineExtension.destroy = function (self)
	Managers.event:unregister(self, "on_spawn_companion_item")
	Managers.event:unregister(self, "event_update_companion_outlines")
end

CompanionOutlineExtension.update = function (self, unit, dt, t)
	return
end

CompanionOutlineExtension._start_outline = function (self)
	if self._outline_started then
		local local_player = Managers.player:local_player(1)
		local is_local_player = local_player == self._owner_player
		local outline_name = is_local_player and "owned_companion" or "allied_companion"
		local outline_system = self._outline_system

		if not outline_system:has_outline(self._unit, outline_name) then
			outline_system:add_outline(self._unit, outline_name)
		end
	end
end

CompanionOutlineExtension._stop_outline = function (self)
	local local_player = Managers.player:local_player(1)
	local is_local_player = local_player == self._owner_player
	local outline_name = is_local_player and "owned_companion" or "allied_companion"

	self._outline_system:remove_outline(self._unit, outline_name)
end

CompanionOutlineExtension._on_spawn_companion_item = function (self, slot_name, unit)
	if self._unit == unit and slot_name == "slot_companion_gear_full" then
		self._outline_started = true

		local save_data = Managers.save:account_data()
		local interface_settings = save_data.interface_settings

		self:_event_update_companion_outlines(interface_settings.companion_outlines)
	end
end

CompanionOutlineExtension._event_update_companion_outlines = function (self, value)
	if value == "both" then
		self:_start_outline()
	elseif value == "own" then
		local local_player = Managers.player:local_player(1)
		local is_local_player = local_player == self._owner_player

		if is_local_player then
			self:_start_outline()
		else
			self:_stop_outline()
		end
	elseif value == "allies" then
		local local_player = Managers.player:local_player(1)
		local is_local_player = local_player == self._owner_player

		if is_local_player then
			self:_stop_outline()
		else
			self:_start_outline()
		end
	else
		self:_stop_outline()
	end
end

return CompanionOutlineExtension
