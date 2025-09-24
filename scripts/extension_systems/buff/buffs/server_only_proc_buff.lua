-- chunkname: @scripts/extension_systems/buff/buffs/server_only_proc_buff.lua

require("scripts/extension_systems/buff/buffs/proc_buff")

local ServerOnlyProcBuff = class("ServerOnlyProcBuff", "ProcBuff")

ServerOnlyProcBuff.skip_send_active_time_rpc = function (self)
	return true
end

return ServerOnlyProcBuff
