local CutscenePlayerLoadout = require("scripts/extension_systems/cutscene_character/utilities/cutscene_player_loadout")
local CinematicSceneTemplates = require("scripts/settings/cinematic_scene/cinematic_scene_templates")

require("scripts/extension_systems/cutscene_character/cutscene_character_extension")

local CutsceneCharacterSystem = class("CutsceneCharacterSystem", "ExtensionSystemBase")

CutsceneCharacterSystem.init = function (self, extension_init_context, system_init_data, ...)
	CutsceneCharacterSystem.super.init(self, extension_init_context, system_init_data, ...)

	self._cinematic_to_extensions = {}
	self._cinematic_to_player_loadouts = {}
end

CutsceneCharacterSystem.destroy = function (self, ...)
	Managers.event:unregister(self, "assign_player_unit_ownership")
	CutsceneCharacterSystem.super.destroy(self, ...)
end

CutsceneCharacterSystem.register_cutscene_character = function (self, extension)
	local cinematic_name = extension:cinematic_name()

	if cinematic_name ~= "none" then
		self._cinematic_to_extensions[cinematic_name] = self._cinematic_to_extensions[cinematic_name] or {}
		local cinematic_to_extensions = self._cinematic_to_extensions[cinematic_name]
		cinematic_to_extensions[#cinematic_to_extensions + 1] = extension
	end
end

CutsceneCharacterSystem.unregister_cutscene_character = function (self, extension)
	local cinematic_to_extensions = self._cinematic_to_extensions

	for cinematic_name, extension_list in pairs(cinematic_to_extensions) do
		for index = #extension_list, 1, -1 do
			local registered_extension = extension_list[index]

			if registered_extension == extension then
				table.swap_delete(extension_list, index)
			end
		end
	end
end

CutsceneCharacterSystem.initialize_characters_for_cinematic = function (self, cinematic_name)
	local player_loadouts = self:_fetch_players_loadout(cinematic_name)
	local template = CinematicSceneTemplates[cinematic_name]
	local extensions = self._cinematic_to_extensions[cinematic_name] or {}
	local extensions_per_level = {}
	local unit_level = Unit.level

	for i = 1, #extensions do
		local extension = extensions[i]

		extension:unassign_player_loadout()

		local level = unit_level(extension._unit)
		local list = extensions_per_level[level] or {}
		list[#list + 1] = extension
		extensions_per_level[level] = list
	end

	local player_unique_ids = {}
	local num_players = 0

	for unique_id, _ in pairs(player_loadouts) do
		num_players = num_players + 1
		player_unique_ids[num_players] = unique_id
	end

	if template.randomize_weapon then
		table.shuffle(player_unique_ids)

		for i = 1, num_players do
			local unique_id = player_unique_ids[i]

			if i <= 2 then
				player_loadouts[unique_id].items.slot_primary = nil
			elseif i <= 4 then
				player_loadouts[unique_id].items.slot_secondary = nil
			else
				Log.warning("More than 4 players added to cutscene. This could cause duplicate walking animations")

				if math.random() < 0.5 then
					player_loadouts[unique_id].items.slot_primary = nil
				else
					player_loadouts[unique_id].items.slot_secondary = nil
				end
			end
		end
	end

	local walk_animations = {
		"hero_walk_01",
		"hero_walk_02"
	}
	local slots_taken = {}
	local none_slot = "none"

	for i = 1, num_players do
		local unique_id = player_unique_ids[i]
		local loadout_info = player_loadouts[unique_id]

		for level, extensions_list in pairs(extensions_per_level) do
			for j = 1, #extensions_list do
				local extension = extensions_list[j]
				local slot = extension:slot()

				if extension:character_type() == "player" and not extension:has_player_assigned() and extension:breed_name() == loadout_info.breed_name and (slot == none_slot or not slots_taken[slot]) then
					local items = loadout_info.items

					extension:assign_player_loadout(unique_id, items)

					loadout_info.extension = extension
					slots_taken[slot] = true

					if template.randomize_weapon then
						local weapon = items.slot_primary or items.slot_secondary

						if weapon then
							extension:override_animation_state_machine(weapon, walk_animations[i % 2 + 1])
						end
					end

					break
				end
			end
		end

		self:_hide_player(unique_id)
	end

	self._cinematic_to_player_loadouts[cinematic_name] = player_loadouts
	self._hide_players = true

	Managers.event:register(self, "assign_player_unit_ownership", "_on_assign_player_unit_ownership")
end

CutsceneCharacterSystem.uninitialize_characters_for_cinematic = function (self, cinematic_name)
	local player_loadouts = self._cinematic_to_player_loadouts[cinematic_name] or {}

	for unique_id, loadout_info in pairs(player_loadouts) do
		local extension = loadout_info.extension

		if extension then
			extension:unassign_player_loadout()
		end

		self:_show_player(unique_id)
	end

	table.clear(player_loadouts)

	self._hide_players = false

	Managers.event:unregister(self, "assign_player_unit_ownership")
end

local function create_loadout(cinematic_name, player)
	local new_player_loadout = {}
	local items = CutscenePlayerLoadout.fetch_player_items(cinematic_name, player)
	new_player_loadout.breed_name = player:breed_name()
	new_player_loadout.items = items

	return new_player_loadout
end

CutsceneCharacterSystem._fetch_players_loadout = function (self, cinematic_name)
	local player_manager = Managers.player
	local player_loadouts = {}
	local template = CinematicSceneTemplates[cinematic_name]

	fassert(template ~= nil, "Unable to find cinematic scene template for %s", cinematic_name)

	local local_player = player_manager:local_player(1)
	local local_unique_id = local_player and local_player:unique_id()
	local local_player_only = template.local_player_only
	local num_slots = local_player_only and 1 or GameParameters.max_players
	local slots_taken = 0
	local package_synchronizer_client = Managers.package_synchronization:synchronizer_client()
	local human_players = player_manager:human_players()

	for unique_id, player in pairs(human_players) do
		if (not local_player_only or unique_id == local_unique_id) and package_synchronizer_client:peer_enabled(player:peer_id()) then
			player_loadouts[unique_id] = create_loadout(cinematic_name, player)
			slots_taken = slots_taken + 1
		end
	end

	if not local_player_only and slots_taken < num_slots then
		local bot_players = player_manager:bot_players()

		for unique_id, player in pairs(bot_players) do
			player_loadouts[unique_id] = create_loadout(cinematic_name, player)
			slots_taken = slots_taken + 1

			if num_slots <= slots_taken then
				break
			end
		end
	end

	return player_loadouts
end

CutsceneCharacterSystem._show_player = function (self, unique_id)
	local player_manager = Managers.player
	local player = player_manager:player_from_unique_id(unique_id)

	if player then
		local player_unit = player.player_unit

		if ALIVE[player_unit] then
			local player_visibility_ext = ScriptUnit.extension(player_unit, "player_visibility_system")

			player_visibility_ext:show()
		end
	end
end

CutsceneCharacterSystem._hide_player = function (self, unique_id)
	local player_manager = Managers.player
	local player = player_manager:player_from_unique_id(unique_id)

	self:_hide_player_unit(player)
end

CutsceneCharacterSystem._hide_player_unit = function (self, player)
	local player_unit = player.player_unit

	if ALIVE[player_unit] then
		local player_visibility_ext = ScriptUnit.extension(player_unit, "player_visibility_system")

		if player_visibility_ext:visible() then
			player_visibility_ext:hide()
		end
	end
end

CutsceneCharacterSystem._on_assign_player_unit_ownership = function (self, player, player_unit)
	if self._hide_players then
		self:_hide_player_unit(player)
	end
end

return CutsceneCharacterSystem
