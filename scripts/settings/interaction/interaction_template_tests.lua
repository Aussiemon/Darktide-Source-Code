local function interaction_template_tests(templates)
	for name, template in pairs(templates) do
		local duration = template.duration

		if duration > 0 then
			local has_start_anim = template.start_anim_event_func or template.start_anim_event or not template.start_anim_event and template.start_anim_event_3p
			slot8 = template.stop_anim_event_func or template.stop_anim_event or not template.stop_anim_event and template.stop_anim_event_3p
		end
	end
end

return interaction_template_tests
