local player_character_sounds = {
	events = require("scripts/settings/sound/player_character_sound_event_aliases")
}
local resource_events = {}
player_character_sounds.resource_events = resource_events

local function _create_resource_events_lookup(root)
	for switch, value in pairs(root) do
		if type(value) == "table" then
			_create_resource_events_lookup(value)
		else
			resource_events[value] = true
		end
	end
end

for alias, value in pairs(player_character_sounds.events) do
	local events = value.events

	_create_resource_events_lookup(events)
end

local DEFAULT_EXTERNAL_PROPERTIES = {}

player_character_sounds.resolve_sound = function (sound_alias, properties, optional_external_properties)
	local settings = player_character_sounds.events[sound_alias]

	if settings then
		local events = settings.events
		local switches = settings.switch
		local has_husk_events = settings.has_husk_events or false
		local num_switches = #switches

		if num_switches == 0 then
			return true, events.default, has_husk_events
		end

		for i = 1, num_switches, 1 do
			local switch_name = switches[i]

			if not properties[switch_name] then
				local switch_property = optional_external_properties or DEFAULT_EXTERNAL_PROPERTIES[switch_name]
			end

			if switch_property and events[switch_property] then
				events = events[switch_property]
			else
				events = events.default
			end

			if type(events) == "string" then
				return true, events, has_husk_events
			end
		end
	else
		Log.warning("PlayerCharacterSounds", "No sound alias named %q", sound_alias)
	end

	local allow_default = settings and not settings.no_default

	return allow_default, allow_default and settings.events.default, (settings and settings.has_husk_events) or false
end

local function _valid_events_recursive(events, relevant_events)
	for _, event_or_events in pairs(events) do
		if type(event_or_events) == "string" then
			relevant_events[event_or_events] = true
		else
			_valid_events_recursive(event_or_events, relevant_events)
		end
	end
end

local temp_relevant_events = {}
local sound_alias_relevant_events_temp = {}

player_character_sounds.find_relevant_events = function (profile_properties)
	table.clear(temp_relevant_events)

	for sound_alias, settings in pairs(player_character_sounds.events) do
		table.clear(sound_alias_relevant_events_temp)

		local events = settings.events
		local switches = settings.switch
		local num_switches = #switches

		if num_switches == 0 then
			local resource_name = events.default
			sound_alias_relevant_events_temp[resource_name] = true
		else
			for i = 1, num_switches, 1 do
				local switch_name = switches[i]
				local switch_property = profile_properties[switch_name]

				if switch_property then
					events = events[switch_property] or events.default
				else
					_valid_events_recursive(events, sound_alias_relevant_events_temp)

					break
				end

				if type(events) == "string" then
					sound_alias_relevant_events_temp[events] = true

					break
				end
			end
		end

		local has_husk_events = settings.has_husk_events or false

		for event, _ in pairs(sound_alias_relevant_events_temp) do
			temp_relevant_events[event] = true

			if has_husk_events then
				local husk_event = string.format("%s_husk", event)
				temp_relevant_events[husk_event] = true
			end
		end
	end

	return temp_relevant_events
end

return settings("PlayerCharacterSounds", player_character_sounds)
