-- chunkname: @scripts/extension_systems/companion_tag_manager/companion_tag_manager_base_extension.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local CompanionTagManagerBaseExtension = class("CompanionTagManagerBaseExtension")

CompanionTagManagerBaseExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	local blackboard = BLACKBOARDS[unit]

	self._blackboard = blackboard
	self._whistle_component = Blackboard.write_component(blackboard, "whistle")

	local smart_tag_system = Managers.state.extension:system("smart_tag_system")

	self._smart_tag_system = smart_tag_system
	self._tagged_units_output = Script.new_map(2)
	self._optional_tag_marker_type = nil
	self._optional_name = nil
end

CompanionTagManagerBaseExtension.game_object_initialized = function (self, session, object_id)
	self._game_session = session
	self._game_object_id = object_id
end

CompanionTagManagerBaseExtension.extensions_ready = function (self, world, unit)
	local owner = Managers.state.player_unit_spawn:owner(unit)
	local owner_unit = owner and owner.player_unit

	self._owner_unit = owner_unit
end

CompanionTagManagerBaseExtension.update = function (self, unit, dt, t)
	local blackboard = self._blackboard
	local smart_tag_system = self._smart_tag_system
	local tagged_units_output = self._tagged_units_output

	smart_tag_system:unit_tagged_by_player_unit(self._owner_unit, self._optional_tag_marker_type, self._optional_name, tagged_units_output)
	self:set_whistle_component_target(unit, blackboard, self._owner_unit, self._game_session, self._game_object_id)

	local optional_tag_marker_type = self._optional_tag_marker_type
	local optional_name = self._optional_name

	if optional_tag_marker_type then
		table.clear(tagged_units_output[optional_tag_marker_type])
	end

	if optional_name then
		table.clear(tagged_units_output[optional_name])
	end
end

CompanionTagManagerBaseExtension.set_whistle_component_target = function (self, companion_unit, companion_blackboard, player_unit, tagged_unit, game_session, game_object_id)
	return
end

return CompanionTagManagerBaseExtension
