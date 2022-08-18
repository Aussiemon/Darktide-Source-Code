local StatStorage = require("scripts/managers/stats/storage/stat_storage")
local StatNoSave = class("StatNoSave", "StatStorage")

StatNoSave.set_value = function (self)
	return
end

StatNoSave.get_value = function (self)
	return
end

implements(StatNoSave, StatStorage.INTERFACE)

return StatNoSave
