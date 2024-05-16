-- chunkname: @scripts/extension_systems/buff/buffs/active_time_offset_proc_buff.lua

require("scripts/extension_systems/buff/buffs/proc_buff")

local ActiveTimeOffsetProcBuff = class("ActiveTimeOffsetProcBuff", "ProcBuff")

ActiveTimeOffsetProcBuff._is_active = function (self, t)
	local active_duration = self:_active_duration()
	local active_start_time = self._active_start_time
	local offseted_active_start_time = active_start_time + self._template.active_time_offset

	return t < offseted_active_start_time + active_duration
end

return ActiveTimeOffsetProcBuff
