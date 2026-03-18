-- chunkname: @scripts/settings/interaction/interaction_template_tests.lua

local function interaction_template_tests(templates)
	for name, template in pairs(templates) do
		local duration = template.duration

		if duration > 0 then
			local start_anim_event_func = template.start_anim_event_func
			local has_start_anim = start_anim_event_func or template.start_anim_event or not template.start_anim_event and template.start_anim_event_3p

			if template.start_anim_event_validation_func then
				template.start_anim_event_validation_func(template)
			end

			local stop_anim_event_func = template.stop_anim_event_func
			local has_stop_anim = stop_anim_event_func or template.stop_anim_event or not template.stop_anim_event and template.stop_anim_event_3p

			if template.stop_anim_event_validation_func then
				template.stop_anim_event_validation_func(template)
			end
		end
	end
end

return interaction_template_tests
