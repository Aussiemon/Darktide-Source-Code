-- chunkname: @scripts/extension_systems/dialogue/dialogue_system_wwise.lua

local DialogueSystemWwise = class("DialogueSystemWwise")

DialogueSystemWwise.init = function (self, world)
	self._wwise_world = Managers.world:wwise_world(world)
end

DialogueSystemWwise.make_unit_auto_source = function (self, unit, node_id)
	local source

	if node_id then
		source = WwiseWorld.make_auto_source(self._wwise_world, unit, node_id)
	else
		source = WwiseWorld.make_auto_source(self._wwise_world, unit)
	end

	return source
end

DialogueSystemWwise.trigger_resource_external_event = function (self, sound_event, sound_source, file_path, file_format, wwise_source_id)
	return WwiseWorld.trigger_resource_external_event(self._wwise_world, sound_event, sound_source, file_path, file_format, wwise_source_id)
end

DialogueSystemWwise.trigger_vorbis_external_event = function (self, sound_event, sound_source, file_path, wwise_source_id)
	return WwiseWorld.trigger_resource_external_event(self._wwise_world, sound_event, sound_source, file_path, 4, wwise_source_id)
end

DialogueSystemWwise.trigger_resource_event = function (self, wwise_event_name, unit_or_source_id)
	return WwiseWorld.trigger_resource_event(self._wwise_world, wwise_event_name, unit_or_source_id)
end

DialogueSystemWwise.set_switch_and_vo_center = function (self, source_id, switch_group, switch_value, vo_center_percent)
	WwiseWorld.set_switch(self._wwise_world, switch_group, switch_value, source_id)
	WwiseWorld.set_source_parameter(self._wwise_world, source_id, "vo_center_percent", vo_center_percent)
end

DialogueSystemWwise.is_playing = function (self, event_id)
	return WwiseWorld.is_playing(self._wwise_world, event_id)
end

DialogueSystemWwise.has_event = function (self, event_id)
	return Wwise.has_event(event_id)
end

DialogueSystemWwise.stop_if_playing = function (self, event_id)
	local is_playing = WwiseWorld.is_playing(self._wwise_world, event_id)

	if is_playing then
		WwiseWorld.stop_event(self._wwise_world, event_id)
	end
end

DialogueSystemWwise.set_switch = function (self, source_id, switch_group, value)
	WwiseWorld.set_switch(self._wwise_world, switch_group, value, source_id)
end

return DialogueSystemWwise
