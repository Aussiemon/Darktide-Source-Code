-- chunkname: @scripts/extension_systems/companion_tag_manager/companion_tag_manager_servo_skull_extension.lua

local CompanionTagManagerServoSkullExtension = class("CompanionTagManagerServoSkullExtension", "CompanionTagManagerBaseExtension")

CompanionTagManagerServoSkullExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	CompanionTagManagerServoSkullExtension.super.init(self, extension_init_context, unit, extension_init_data, game_object_data)

	self._optional_tag_marker_type = "unit_threat_companion"
	self._tagged_units_output[self._optional_tag_marker_type] = Script.new_map(2)
end

CompanionTagManagerServoSkullExtension.extensions_ready = function (self, world, unit)
	CompanionTagManagerServoSkullExtension.super.extensions_ready(self, world, unit)

	self._ability_extension = ScriptUnit.extension(self._owner_unit, "ability_system")
end

CompanionTagManagerServoSkullExtension.set_whistle_component_target = function (self, companion_unit, companion_blackboard, player_unit, game_session, game_object_id)
	local tagged_units_output = self._tagged_units_output
	local tag_marker_type_table = tagged_units_output[self._optional_tag_marker_type]
	local marker_type_tagged_unit = tag_marker_type_table.target_unit

	if not HEALTH_ALIVE[marker_type_tagged_unit] then
		self._whistle_component.current_target = nil
	end
end

return CompanionTagManagerServoSkullExtension
