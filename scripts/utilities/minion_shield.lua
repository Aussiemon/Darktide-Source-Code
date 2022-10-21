local MinionShield = {}

MinionShield.init_block_timings = function (scratchpad, action_data, anim_event, t)
	local disable_shield_block_timing = action_data.disable_shield_block_timing and action_data.disable_shield_block_timing[anim_event]

	if not disable_shield_block_timing then
		return
	end

	local enable_shield_block_timing = action_data.enable_shield_block_timing and action_data.enable_shield_block_timing[anim_event]
	scratchpad.disable_shield_block_t = t + disable_shield_block_timing
	scratchpad.enable_shield_block_t = t + enable_shield_block_timing
end

MinionShield.reset_block_timings = function (scratchpad, unit)
	if scratchpad.disable_shield_block_t then
		return
	end

	local enable_shield_block_t = scratchpad.enable_shield_block_t

	if enable_shield_block_t then
		local shield_extension = ScriptUnit.extension(unit, "shield_system")

		shield_extension:set_blocking(true)
	end
end

MinionShield.update_block_timings = function (scratchpad, unit, t)
	local disable_shield_block_t = scratchpad.disable_shield_block_t

	if disable_shield_block_t and disable_shield_block_t <= t then
		local shield_extension = ScriptUnit.extension(unit, "shield_system")

		shield_extension:set_blocking(false)

		scratchpad.disable_shield_block_t = nil
	end

	local enable_shield_block_t = scratchpad.enable_shield_block_t

	if enable_shield_block_t and enable_shield_block_t <= t then
		local shield_extension = ScriptUnit.extension(unit, "shield_system")

		shield_extension:set_blocking(true)

		scratchpad.enable_shield_block_t = nil
	end
end

return MinionShield
