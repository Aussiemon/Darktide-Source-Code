if IS_XBS then
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
