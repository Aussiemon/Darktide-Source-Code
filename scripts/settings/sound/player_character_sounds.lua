-- chunkname: @scripts/settings/sound/player_character_sounds.lua

local ExplosionTemplates = require("scripts/settings/damage/explosion_templates")
local PlayerCharacterSounds = {}

PlayerCharacterSounds.events = require("scripts/settings/sound/player_character_sound_event_aliases")

local resource_events = {}

PlayerCharacterSounds.resource_events = resource_events

local function _create_resource_events_lookup(root)
	for switch, value in pairs(root) do
		if type(value) == "table" and not value.conditional_func then
			_create_resource_events_lookup(value)
		elseif type(value) == "table" and value.conditional_func then
			resource_events[value.event] = true
		else
			resource_events[value] = true
		end
	end
end

for alias, value in pairs(PlayerCharacterSounds.events) do
	local events = value.events
	local conditional_events = value.conditional_events

	_create_resource_events_lookup(events or conditional_events)
end

local function _add_sfx_names_from_explosion_templates(explosion_templates)
	for _, explosion_template in pairs(explosion_templates) do
		local sfx_events = explosion_template.sfx

		if sfx_events then
			for i = 1, #sfx_events do
				local sfx_event = sfx_events[i]

				if type(sfx_event) == "table" then
					local event_name = sfx_event.event_name
					local has_husk_events = sfx_event.has_husk_events

					if has_husk_events and event_name then
						resource_events[event_name] = true
					end
				end
			end
		end
	end
end

_add_sfx_names_from_explosion_templates(ExplosionTemplates)

PlayerCharacterSounds.resolve_sound = function (sound_alias, properties, optional_external_properties)
	local settings = PlayerCharacterSounds.events[sound_alias]

	if settings then
		local is_conditional_sound = not not settings.conditional_events
		local events = is_conditional_sound and settings.conditional_events or settings.events
		local switches = settings.switch
		local default_switch_properties = settings.default_switch_properties
		local no_default = settings.no_default
		local has_husk_events = not not settings.has_husk_events
		local num_switches = #switches

		if num_switches == 0 then
			local event_name
			local default_event = events.default

			if type(default_event) == "string" then
				event_name = default_event
			elseif type(default_event) == "table" and default_event.conditional_func and default_event.conditional_func("default", properties, optional_external_properties) then
				event_name = default_event.event
			end

			return true, event_name, has_husk_events
		end

		for ii = 1, num_switches do
			local switch_name = switches[ii]
			local switch_property = properties[switch_name] or optional_external_properties and optional_external_properties[switch_name] or default_switch_properties and default_switch_properties[switch_name]

			if switch_property and events[switch_property] then
				events = events[switch_property]
			elseif not no_default then
				events = events.default
			end

			local event_name

			if type(events) == "string" then
				event_name = events
			elseif type(events) == "table" and events.conditional_func and events.conditional_func(switch_property, properties, optional_external_properties) then
				event_name = events.event
			end

			if event_name ~= nil then
				return true, event_name, has_husk_events
			end
		end
	else
		Log.warning("PlayerCharacterSounds", "No sound alias named %q", sound_alias)
	end

	local allow_default = settings and not settings.no_default
	local has_husk_events = not not settings and not not settings.has_husk_events
	local event = allow_default and settings.events and settings.events.default
	local default_conditional_event = allow_default and settings.conditional_events and settings.conditional_events.default

	if default_conditional_event and default_conditional_event.conditional_func("default", properties, optional_external_properties) then
		event = default_conditional_event.event
	end

	return allow_default, event, has_husk_events
end

local function _valid_events_recursive(events, relevant_events)
	for _, event_or_events in pairs(events) do
		if type(event_or_events) == "string" then
			relevant_events[event_or_events] = true
		elseif type(event_or_events) == "table" and event_or_events.conditional_func then
			relevant_events[event_or_events.event] = true
		else
			_valid_events_recursive(event_or_events, relevant_events)
		end
	end
end

local temp_relevant_events = {}
local sound_alias_relevant_events_temp = {}

PlayerCharacterSounds.find_relevant_events = function (profile_properties)
	table.clear(temp_relevant_events)

	for sound_alias, settings in pairs(PlayerCharacterSounds.events) do
		table.clear(sound_alias_relevant_events_temp)

		local is_conditional_sound = not not settings.conditional_events
		local events = is_conditional_sound and settings.conditional_events or settings.events
		local switches = settings.switch
		local no_default = settings.no_default
		local num_switches = #switches

		if num_switches == 0 then
			local default_event = events.default
			local resource_name = is_conditional_sound and default_event.event or default_event

			sound_alias_relevant_events_temp[resource_name] = true
		else
			for ii = 1, num_switches do
				local switch_name = switches[ii]
				local switch_property = profile_properties[switch_name]

				if switch_property then
					local default_events = events.default

					events = events[switch_property] or default_events or events
				else
					_valid_events_recursive(events, sound_alias_relevant_events_temp)

					break
				end

				if type(events) == "string" or type(events) == "table" and events.event then
					local resource_name = is_conditional_sound and events.event or events

					sound_alias_relevant_events_temp[resource_name] = true

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

return PlayerCharacterSounds
