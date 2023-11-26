-- chunkname: @scripts/extension_systems/cutscene_character/utilities/cutscene_player_loadout.lua

local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")
local PlayerCharacterConstants = require("scripts/settings/player_character/player_character_constants")
local CutscenePlayerLoadout = {}

CutscenePlayerLoadout.fetch_player_items = function (cinematic_name, player)
	local slot_configuration = PlayerCharacterConstants.slot_configuration
	local template = CinematicSceneTemplates[cinematic_name]
	local ignored_slots = template.ignored_slots
	local profile = player:profile()
	local visual_loadout = profile.visual_loadout
	local items = {}

	for slot_name, _ in pairs(slot_configuration) do
		if not ignored_slots[slot_name] then
			local item = visual_loadout[slot_name]

			if item then
				items[slot_name] = item

				if not item.name then
					local item_name = ""
				end
			end
		end

		if false then
			-- Nothing
		end
	end

	return items
end

return CutscenePlayerLoadout
