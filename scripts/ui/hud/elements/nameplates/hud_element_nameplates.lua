local HudElementNameplatesSettings = require("scripts/ui/hud/elements/nameplates/hud_element_nameplates_settings")
local HudElementNameplates = class("HudElementNameplates")
local Missions = require("scripts/settings/mission/mission_templates")
local PlayerCompositions = require("scripts/utilities/players/player_compositions")

HudElementNameplates.init = function (self, parent, draw_layer, start_scale)
	self._parent = parent
	self._nameplate_units = {}
	self._scan_delay = HudElementNameplatesSettings.scan_delay
	self._scan_delay_duration = 0
	local mission_name = Managers.state.mission:mission_name()
	local mission_settings = Missions[mission_name]
	self._is_mission_hub = mission_settings.is_hub
end

HudElementNameplates.update = function (self, dt, t)
	if self._scan_delay_duration > 0 then
		self._scan_delay_duration = self._scan_delay_duration - dt
	else
		self:_nameplate_extension_scan()

		self._scan_delay_duration = self._scan_delay
	end
end

HudElementNameplates._nameplate_extension_scan = function (self)
	local parent = self._parent
	local my_player = parent:player()
	local marker_type = nil
	local event_manager = Managers.event
	local nameplate_units = self._nameplate_units
	local extensions = self:_player_extensions(my_player)
	local has_disable_nameplates_buff = false

	if extensions then
		local buff_extension = extensions.buff
		has_disable_nameplates_buff = buff_extension and buff_extension:has_keyword("hud_nameplates_disabled")
	end

	local player_manager = Managers.player
	local players = player_manager:players()
	local ALIVE = ALIVE

	for _, player in pairs(players) do
		if player ~= my_player then
			if self._is_mission_hub then
				local peer_id = player:peer_id()
				local is_player_party_member = player:is_human_controlled() and PlayerCompositions.party_member_by_peer_id(peer_id)

				if is_player_party_member then
					marker_type = "nameplate_party_hud"
				else
					marker_type = "nameplate"
				end
			else
				marker_type = "nameplate_party"
			end

			local unit = player.player_unit
			local active = ALIVE[unit]

			if active and not has_disable_nameplates_buff then
				if nameplate_units[unit] and has_disable_nameplates_buff then
					nameplate_units[unit].synced = false
				elseif not nameplate_units[unit] then
					nameplate_units[unit] = {
						synced = true
					}
					local marker_callback = callback(self, "_on_nameplate_marker_spawned", unit)

					event_manager:trigger("add_world_marker_unit", marker_type, unit, marker_callback, player)
				elseif nameplate_units[unit] == marker_type then
					nameplate_units[unit].synced = marker_type
				end
			elseif nameplate_units[unit] and has_disable_nameplates_buff then
				nameplate_units[unit].synced = false
			end
		end
	end

	for unit, data in pairs(nameplate_units) do
		if not data.synced then
			local marker_id = data.marker_id

			if marker_id then
				event_manager:trigger("remove_world_marker", marker_id)

				nameplate_units[unit] = nil
			end
		end
	end
end

HudElementNameplates._player_extensions = function (self, player)
	local player_unit = player.player_unit

	if Unit.alive(player_unit) then
		if not self._extensions then
			self._extensions = self._parent:get_all_player_extensions(player, {})
		end
	elseif self._extensions then
		self._extensions = nil
	end

	return self._extensions
end

HudElementNameplates._on_nameplate_marker_spawned = function (self, unit, id)
	self._nameplate_units[unit].marker_id = id
end

HudElementNameplates.destroy = function (self)
	local event_manager = Managers.event
	local nameplate_units = self._nameplate_units

	for _, data in pairs(nameplate_units) do
		local marker_id = data.marker_id

		if marker_id then
			event_manager:trigger("remove_world_marker", marker_id)
		end
	end

	self._nameplate_units = nil
end

return HudElementNameplates
