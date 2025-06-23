-- chunkname: @scripts/managers/save/utilities/save.lua

local ScriptSaveToken

if IS_PLAYSTATION then
	ScriptSaveToken = require("scripts/managers/save/script_save_token_ps5")
else
	ScriptSaveToken = require("scripts/managers/save/script_save_token")
end

local Save = {}
local SaveDummy = {
	COMPLETED = true,
	save = function ()
		return {}
	end,
	load = function ()
		return {}
	end,
	status = function ()
		return true
	end,
	auto_save = function ()
		return {}
	end,
	auto_load = function ()
		return {}
	end,
	progress = function ()
		return {
			done = true,
			data = {}
		}
	end,
	close = function ()
		return
	end
}

Save.implementation = function (use_cloud)
	if PLATFORM == "xbs" or PLATFORM == "linux" then
		return SaveDummy
	elseif use_cloud and HAS_STEAM and Cloud.enabled() then
		return Cloud
	else
		return SaveSystem
	end
end

Save.abort = function (save_token)
	Managers.token:abort(save_token)
end

Save.save = function (save_info, callback)
	local system = Save.implementation(false)
	local token = system.save(save_info)
	local is_loading = false
	local save_token = ScriptSaveToken:new(system, token, is_loading)

	Managers.token:register_token(save_token, callback)

	return save_token
end

Save.load = function (load_info, optional_callback)
	local system = Save.implementation(false)
	local token = system.load(load_info)
	local is_loading = true
	local save_token = ScriptSaveToken:new(system, token, is_loading)

	Managers.token:register_token(save_token, optional_callback)

	return save_token
end

Save.auto_save = function (file_name, data, callback, use_cloud)
	local system = Save.implementation(use_cloud)
	local token = system.auto_save(file_name, data)
	local save_token = ScriptSaveToken:new(system, token)

	Managers.token:register_token(save_token, callback)

	return save_token
end

Save.auto_load = function (file_name, callback, use_cloud)
	local system = Save.implementation(use_cloud)
	local token = system.auto_load(file_name)
	local save_token = ScriptSaveToken:new(system, token)

	Managers.token:register_token(save_token, callback)

	return save_token
end

return Save
