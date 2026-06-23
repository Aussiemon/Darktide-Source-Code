-- chunkname: @scripts/extension_systems/companion_tag_manager/companion_tag_manager_dog_extension.lua

local CompanionTagManagerDogExtension = class("CompanionTagManagerDogExtension", "CompanionTagManagerBaseExtension")

CompanionTagManagerDogExtension.init = function (self, extension_init_context, unit, extension_init_data, game_object_data)
	CompanionTagManagerDogExtension.super.init(self, extension_init_context, unit, extension_init_data, game_object_data)

	self._optional_tag_marker_type = "unit_threat_companion"
	self._tagged_units_output[self._optional_tag_marker_type] = Script.new_map(2)
end

CompanionTagManagerDogExtension.set_whistle_component_target = function (self, companion_unit, companion_blackboard, player_unit, game_session, game_object_id)
	local movable_platform_component = companion_blackboard and companion_blackboard.movable_platform
	local is_in_platform = movable_platform_component and movable_platform_component.unit_reference ~= nil
	local companion_whistle_component = self._whistle_component
	local tagged_units_output = self._tagged_units_output
	local tag_marker_type_table = tagged_units_output[self._optional_tag_marker_type]
	local target_unit = tag_marker_type_table.target_unit
	local tag = tag_marker_type_table.tag

	if is_in_platform then
		local smart_tag_system = self._smart_tag_system
		local tag_id = tag and tag:id()

		if tag_id then
			local exernal_removal = true

			smart_tag_system:cancel_tag(tag_id, player_unit, exernal_removal)
		end

		companion_whistle_component.current_target = nil

		return
	end

	if HEALTH_ALIVE[target_unit] then
		local invalid_target = false
		local unit_data_extension = ScriptUnit.has_extension(target_unit, "unit_data_system")
		local breed = unit_data_extension and unit_data_extension:breed()
		local daemonhost = breed and breed.tags.witch

		if daemonhost then
			local daemonhost_blackboard = BLACKBOARDS[target_unit]
			local daemonhost_perception_component = daemonhost_blackboard.perception
			local is_aggroed = daemonhost_perception_component.aggro_state == "aggroed"

			invalid_target = not is_aggroed
		end

		if not invalid_target then
			companion_whistle_component.current_target = target_unit
		end
	elseif companion_whistle_component then
		companion_whistle_component.current_target = nil
	end
end

return CompanionTagManagerDogExtension
