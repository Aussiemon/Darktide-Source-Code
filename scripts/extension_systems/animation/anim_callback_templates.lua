-- chunkname: @scripts/extension_systems/animation/anim_callback_templates.lua

local Blackboard = require("scripts/extension_systems/blackboard/utilities/blackboard")
local AnimCallbackTemplates = {
	server = {
		anim_cb_landing_finished = function (unit)
			local blackboard = BLACKBOARDS[unit]
			local vortex_grabbed_component = Blackboard.write_component(blackboard, "vortex_grabbed")

			vortex_grabbed_component.landing_finished = true
		end,
	},
	client = {},
}

return AnimCallbackTemplates
