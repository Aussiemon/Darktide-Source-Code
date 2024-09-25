-- chunkname: @scripts/foundation/utilities/patches.lua

if IS_XBS or IS_PLAYSTATION then
	PATCHED_USER_SETTINGS = PATCHED_USER_SETTINGS or false

	if not PATCHED_USER_SETTINGS then
		UserSettings = UserSettings or {}

		Application.set_user_setting = function (...)
			if not rawget(_G, "Managers") then
				return
			end

			local save_manager = Managers.save

			if not save_manager then
				return
			end

			local t = UserSettings
			local num_args = select("#", ...)

			for i = 1, num_args - 2 do
				local key = select(i, ...)

				t[key] = type(t[key]) == "table" and t[key] or {}
				t = t[key]
			end

			local set_key = select(num_args - 1, ...)
			local set_value = select(num_args, ...)

			t[set_key] = set_value
		end

		Application.user_setting = function (...)
			if not rawget(_G, "Managers") then
				return
			end

			local save_manager = Managers.save

			if not save_manager then
				return
			end

			local t = UserSettings
			local num_args = select("#", ...)

			for i = 1, num_args - 1 do
				local key = select(i, ...)

				t = t[key]

				if type(t) ~= "table" then
					return
				end
			end

			return t[select(num_args, ...)]
		end

		Application.save_user_settings = function ()
			if not rawget(_G, "Managers") then
				return
			end

			local save_manager = Managers.save

			if not save_manager then
				return
			end

			if GameParameters.testify then
				return
			end

			save_manager:queue_save()
		end

		PATCHED_USER_SETTINGS = true
	end
end

if BUILD ~= "dev" and BUILD ~= "debug" then
	local function scrub_library(lib)
		rawset(_G, lib, nil)

		package.loaded[lib] = nil
		package.preload[lib] = nil
	end

	scrub_library("ffi")
	scrub_library("io")

	os = {
		clock = os.clock,
		date = os.date,
		difftime = os.difftime,
		time = os.time,
		getenv = os.getenv,
	}
	package.loadlib = nil
	package.loaders[3] = nil
	package.loaders[4] = nil
	loadfile = nil
	loadstring = nil
	load = nil
end
