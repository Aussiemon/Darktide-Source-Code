local UIResolution = require("scripts/managers/ui/ui_resolution")
BLACKBOARDS = BLACKBOARDS or Script.new_map(256)
HEALTH_ALIVE = HEALTH_ALIVE or Script.new_map(1024)
RESOLUTION_LOOKUP = RESOLUTION_LOOKUP or {}
local resolution_lookup = RESOLUTION_LOOKUP

function UPDATE_RESOLUTION_LOOKUP(force_update, optional_scale_multiplier)
	local w, h, is_fullscreen = nil

	if DEDICATED_SERVER then
		h = 600
		w = 800
		is_fullscreen = true
	else
		w, h = Application.back_buffer_size()
		is_fullscreen = Application.is_fullscreen and Application.is_fullscreen()
	end

	local resolution_modified = w ~= resolution_lookup.width or h ~= resolution_lookup.height
	local fullscreen_modified = is_fullscreen ~= resolution_lookup.fullscreen
	local width_scale = w / UIResolution.width_fragments()
	local height_scale = h / UIResolution.height_fragments()
	local scale = math.min(width_scale, height_scale)

	if Application.user_setting("hud_clamp_ui_scaling") then
		scale = math.min(scale, 1) or scale
	end

	if optional_scale_multiplier then
		scale = scale * optional_scale_multiplier
	end

	if resolution_modified or force_update or fullscreen_modified or resolution_lookup.scale ~= scale then
		resolution_lookup.width = w
		resolution_lookup.height = h
		resolution_lookup.scale = scale
		resolution_lookup.inverse_scale = 1 / scale
		resolution_lookup.fullscreen = is_fullscreen
	end

	resolution_lookup.modified = resolution_modified or force_update or fullscreen_modified
end

UPDATE_RESOLUTION_LOOKUP()

GLOBAL_RESOURCES = {
	"wwise/packages/vo_dependencies",
	"content/characters/enemy/enemy_character_assets",
	"content/liquid_area/liquid_area_assets",
	"content/smoke_fog/smoke_fog_assets",
	"content/pickups/pickup_assets",
	"content/weapons/weapon_assets"
}
