local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"fetch",
	"create",
	"delete",
	"equip_item_slot"
}
local Characters = class("Characters")

Characters.init = function (self)
	return
end

Characters.equip_item_slot = function (self, character_id, slot_name, gear_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/inventory/"):path(slot_name), {
		method = "PUT",
		body = {
			instanceId = gear_id
		}
	}):next(function (data)
		return data.body
	end)
end

Characters.create = function (self, new_character)
	assert(type(new_character) == "table", "Missing or invalid new_character")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(), {
		method = "POST",
		body = {
			newCharacter = new_character
		}
	}):next(function (data)
		return data.body
	end):next(function (result)
		if not result.characterId then
			local p = Promise:new()

			p:reject(BackendUtilities.create_error(BackendError.UnknownError, "Invalid characterId"))

			return p
		end

		local character_id = result.characterId

		return self:fetch(character_id)
	end)
end

local function _process_stats(stats)
	local result = {}

	for i, v in ipairs(stats) do
		local type_path = table.concat(v.typePath, "/")
		result[type_path] = v.value
	end

	return result
end

Characters.get_character_stats = function (self, account_id, character_id, stat_prefix)
	assert(account_id, "account_id must be specified")
	assert(character_id, "character_id must be specified")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/statistics/"):path(stat_prefix or "")):next(function (data)
		return _process_stats(data.body.statistics)
	end)
end

Characters.fetch_account_character = function (self, account_id, character_id, include_inventory, include_progression)
	assert(account_id, "account_id must be specified")
	assert(character_id, "character_id must be specified")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):query("includeInventoryDetails", include_inventory):query("includeProgressionDetails", include_progression), {}, account_id):next(function (data)
		return data.body
	end)
end

Characters.fetch = function (self, character_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id)):next(function (data)
		if character_id then
			return data.body.character
		else
			return data.body.characters
		end
	end)
end

Characters.delete_character = function (self, character_id)
	assert(type(character_id) == "string", "Missing or invalid character_id")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id), {
		method = "DELETE"
	}):next(function (data)
		return data.body
	end)
end

Characters.set_specialization = function (self, character_id, specialization)
	return self:set_data(character_id, "career", {
		specialization = specialization
	})
end

Characters.set_talents = function (self, character_id, talents)
	return self:set_data(character_id, "career", {
		talents = talents
	})
end

Characters.get_talents = function (self, character_id)
	return self:get_data(character_id, "career", "talents")
end

Characters.set_prologue_completed = function (self, character_id, completed)
	return self:set_data(character_id, "path_trust", {
		prologue_completed = completed
	})
end

Characters.get_prologue_completed = function (self, character_id)
	return self:get_data(character_id, "path_trust", "prologue_completed")
end

Characters.set_last_seen_path_of_trust = function (self, character_id, scene_id)
	return self:set_data(character_id, "path_trust", {
		last_seen_cutscene = scene_id
	})
end

Characters.get_last_seen_path_of_trust = function (self, character_id)
	return self:get_data(character_id, "path_trust", "last_seen_cutscene")
end

Characters.set_character_height = function (self, character_id, value)
	return self:set_data(character_id, "personal", {
		character_height = value
	})
end

Characters.get_character_height = function (self, character_id)
	return self:get_data(character_id, "personal", "character_height")
end

local function _process_narrative(data)
	local result = {}

	for i, v in ipairs(data) do
		local type_path = v.typePath[2]
		result[type_path] = v.value
	end

	return result
end

Characters.get_narrative = function (self, character_id)
	fassert(type(character_id) == "string", "Invalid character_id %s", character_id)

	return self:get_data(character_id, "narrative"):next(function (response)
		return _process_narrative(response.body.data)
	end)
end

Characters.set_narrative_story_chapter = function (self, character_id, story_name, chapter_id)
	fassert(type(character_id) == "string", "Invalid character_id %s", character_id)
	fassert(type(story_name) == "string", "Invalid story_name %s", story_name)
	fassert(type(chapter_id) == "number", "Invalid chapter_id %s", chapter_id)

	return self:set_data(character_id, "narrative|stories", {
		[story_name] = chapter_id
	})
end

Characters.set_data = function (self, character_id, section, data)
	assert(type(character_id) == "string", "Missing or invalid character_id")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/data/" .. section), {
		method = "PUT",
		body = {
			data = data
		}
	}):next(function (data)
		return nil
	end)
end

Characters.get_data = function (self, character_id, section, part)
	assert(type(character_id) == "string", "Missing or invalid character_id")

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/data/" .. section)):next(function (data)
		if part then
			if #data.body.data > 0 then
				return data.body.data[1].value[part]
			else
				return nil
			end
		else
			return data
		end
	end)
end

Characters.check_name = function (self, name)
	assert(type(name) == "string", "Missing or invalid name")

	local path = BackendUtilities.url_builder():path("/data/characters/name/" .. name .. "/check"):to_string()

	return Managers.backend:title_request(path):next(function (data)
		return data.body
	end)
end

implements(Characters, Interface)

return Characters
