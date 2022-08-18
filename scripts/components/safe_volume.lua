local SafeVolume = component("SafeVolume")

SafeVolume.init = function (self, unit)
	local trigger_extension = ScriptUnit.fetch_component_extension(unit, "trigger_system")

	if trigger_extension then
		local component_guid = self.guid

		fassert(component_guid, "[Trigger] Missing component guid.")
		trigger_extension:setup_from_component(self.guid, "all_players_inside", false, "safe_volume", {
			action_player_side = "heroes",
			action_target = NetworkLookup.trigger_action_targets.none,
			action_machine_target = NetworkLookup.trigger_machine_targets.server_and_client,
			component_guid = component_guid
		}, NetworkLookup.trigger_only_once.none, true)

		self._trigger_extension = trigger_extension
	end
end

SafeVolume.editor_init = function (self, unit)
	return
end

SafeVolume.enable = function (self, unit)
	return
end

SafeVolume.disable = function (self, unit)
	return
end

SafeVolume.destroy = function (self, unit)
	return
end

SafeVolume.activate = function (self)
	local trigger_extension = self._trigger_extension

	if trigger_extension then
		trigger_extension:activate(true)
	end
end

SafeVolume.deactivate = function (self)
	local trigger_extension = self._trigger_extension

	if trigger_extension then
		trigger_extension:activate(false)
	end
end

SafeVolume.component_data = {
	inputs = {
		activate = {
			accessibility = "public",
			type = "event"
		},
		deactivate = {
			accessibility = "public",
			type = "event"
		}
	},
	extensions = {
		"TriggerExtension"
	}
}

return SafeVolume
