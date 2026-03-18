-- chunkname: @scripts/ui/views/loading_view/loading_view_settings.lua

local NUM_LOADING_HINTS = 310
local loading_hints = Script.new_array(NUM_LOADING_HINTS)

for ii = 1, NUM_LOADING_HINTS do
	loading_hints[ii] = string.format("loc_loading_hint_%03d", ii)
end

local loading_view_settings = {
	entry_duration = 1,
	hint_text_update_duration = 0.3,
	background_end_size = {
		2500,
		2500,
	},
	background_start_size = {
		2800,
		2800,
	},
	loading_hints = loading_hints,
}

return settings("LoadingViewSettings", loading_view_settings)
