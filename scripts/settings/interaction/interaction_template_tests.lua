-- chunkname: @scripts/settings/interaction/interaction_template_tests.lua

local function interaction_template_tests(templates)
	for name, template in pairs(templates) do
		local duration = template.duration

		if duration > 0 then
			local has_start_anim = template.start_anim_event_func or template.start_anim_event or not template.start_anim_event and template.start_anim_event_3p

			if not template.stop_anim_event_func and not template.stop_anim_event then
				if not template.stop_anim_event then
					local var_1_0 = template.stop_anim_event_3p
				else
					local var_1_1 = false
				end
			end

			if false then
				local has_stop_anim = true
			end
		end
	end
end

return interaction_template_tests
