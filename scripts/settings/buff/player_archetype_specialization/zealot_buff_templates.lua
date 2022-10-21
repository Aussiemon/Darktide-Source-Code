local BuffSettings = require("scripts/settings/buff/buff_settings")
local proc_events = BuffSettings.proc_events
local stat_buffs = BuffSettings.stat_buffs
local templates = {
	zealot_damage_after_dash = {
		class_name = "proc_buff",
		active_duration = 4,
		proc_events = {
			[proc_events.on_lunge_end] = 1
		},
		proc_stat_buffs = {
			[stat_buffs.melee_damage] = 1
		},
		check_proc_func = function (params, template_data, template_context)
			local lunge_template_name = params.lunge_template_name

			if lunge_template_name == "zealot_dash" then
				return true
			end

			return false
		end
	}
}

return templates
