local TerrorEventTemplates = require("scripts/settings/terror_event/terror_event_templates")
local HordePacingTemplates = require("scripts/managers/pacing/horde_pacing/horde_pacing_templates")
local SpecialsPacingTemplates = require("scripts/managers/pacing/specials_pacing/specials_pacing_templates")
local sound_events = {}

for name, template in pairs(TerrorEventTemplates) do
	local events = template.events

	if events then
		for event_name, nodes in pairs(events) do
			for i = 1, #nodes do
				local node = nodes[i]
				local sound_event_name = node.sound_event_name

				if sound_event_name then
					sound_events[sound_event_name] = true
				end
			end
		end
	end
end

for name, template in pairs(HordePacingTemplates) do
	local resistance_templates = template.resistance_templates

	for _, resistance_template in pairs(resistance_templates) do
		local pre_stinger_sound_events = resistance_template.pre_stinger_sound_events

		for _, sound_event in pairs(pre_stinger_sound_events) do
			sound_events[sound_event] = true
		end
	end
end

for name, template in pairs(SpecialsPacingTemplates) do
	local resistance_templates = template.resistance_templates

	for _, resistance_template in pairs(resistance_templates) do
		local spawn_stingers = resistance_template.spawn_stingers

		for _, sound_event in pairs(spawn_stingers) do
			sound_events[sound_event] = true
		end
	end
end

return sound_events
