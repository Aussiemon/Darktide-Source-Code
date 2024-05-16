-- chunkname: @scripts/extension_systems/animation/anim_callback_templates.lua

local AnimCallbackTemplates = {
	server = {
		anim_cb_new_random_variation = function (unit)
			ScriptUnit.extension(unit, "animation_system"):anim_event("random_anim")
		end,
	},
	client = {},
}

return AnimCallbackTemplates
