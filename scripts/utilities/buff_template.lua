-- chunkname: @scripts/utilities/buff_template.lua

local BuffTemplate = {}

local function _calculate_buff_values(buff_values, i)
	for key, buff_value in pairs(buff_values) do
		if type(buff_value) == "function" then
			buff_values[key] = buff_value(i)
		end
	end
end

BuffTemplate.generate_weapon_trait_buff_templates = function (templates, template, amount)
	for i = 1, amount do
		local template_clone = table.clone(template)
		local stat_buffs = template_clone.stat_buffs

		if stat_buffs then
			_calculate_buff_values(stat_buffs, i)
		end

		local conditional_stat_buffs = template_clone.conditional_stat_buffs

		if conditional_stat_buffs then
			_calculate_buff_values(conditional_stat_buffs, i)
		end

		local lerped_stat_buffs = template_clone.lerped_stat_buffs

		if lerped_stat_buffs then
			_calculate_buff_values(lerped_stat_buffs, i)
		end

		local active_duration = template_clone.active_duration

		if active_duration and type(active_duration) == "function" then
			template_clone.active_duration = active_duration(i)
		end

		local cooldown_duration = template_clone.cooldown_duration

		if cooldown_duration and type(cooldown_duration) == "function" then
			template_clone.active_duration = cooldown_duration(i)
		end

		local proc_events = template_clone.proc_events

		if proc_events then
			_calculate_buff_values(proc_events, i)
		end

		local proc_stat_buffs = template_clone.proc_stat_buffs

		if proc_stat_buffs then
			_calculate_buff_values(proc_stat_buffs, i)
		end

		local name = template.name .. "_" .. i

		template_clone.name = name
		templates[name] = template_clone
	end
end

return BuffTemplate
