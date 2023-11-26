-- chunkname: @scripts/backend/characters.lua

local Promise = require("scripts/foundation/utilities/promise")
local BackendError = require("scripts/foundation/managers/backend/backend_error")
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Interface = {
	"fetch",
	"create",
	"delete",
	"equip_items_in_slots"
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

Characters.equip_items_in_slots = function (self, character_id, item_gear_ids_by_slots, item_gear_names_by_slots)
	local body = {}

	for slot_id, gear_id in pairs(item_gear_ids_by_slots) do
		body[#body + 1] = {
			instanceId = gear_id,
			slotId = slot_id
		}
	end

	for slot_id, name in pairs(item_gear_names_by_slots) do
		body[#body + 1] = {
			masterId = name,
			slotId = slot_id
		}
	end

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/inventory/"), {
		method = "PUT",
		body = body
	}):next(function (data)
		return data.body
	end)
end

Characters.unequip_slots = function (self, character_id, slots)
	local promises = {}

	for slot_name, _ in pairs(slots) do
		promises[#promises + 1] = BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/inventory/"):path(slot_name), {
			method = "DELETE"
		})
	end

	return Promise.all(unpack(promises))
end

Characters.equip_master_items_in_slots = function (self, character_id, item_master_ids_by_slots)
	local body = {}

	for slot_id, master_id in pairs(item_master_ids_by_slots) do
		body[#body + 1] = {
			masterId = master_id,
			slotId = slot_id
		}
	end

	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/inventory/"), {
		method = "PUT",
		body = body
	}):next(function (data)
		return data.body
	end)
end

Characters.create = function (self, new_character)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(), {
		method = "POST",
		body = {
			newCharacter = new_character
		}
	}):next(function (data)
		return data.body
	end):next(function (result)
		local character = result.character

		if not character or not character.id then
			local p = Promise:new()

			p:reject(BackendUtilities.create_error(BackendError.UnknownError, "Invalid characterId"))

			return p
		end

		return character
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
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/statistics/"):path(stat_prefix or "")):next(function (data)
		return _process_stats(data.body.statistics)
	end)
end

Characters.fetch_account_character = function (self, account_id, character_id, include_inventory, include_progression)
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

Characters.set_talents_v2 = function (self, character_id, talents)
	return self:set_data(character_id, "vocation", {
		talents = talents
	})
end

Characters.get_talents_v2 = function (self, character_id)
	return self:get_data(character_id, "vocation", "talents")
end

Characters.set_talents = function (self, character_id, talents)
	return self:set_data(character_id, "career", {
		talents = talents
	})
end

Characters.get_talents = function (self, character_id)
	return self:get_data(character_id, "career", "talents")
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
	return self:get_data(character_id, "narrative"):next(function (response)
		return _process_narrative(response.body.data)
	end)
end

Characters.set_narrative_story_chapter = function (self, character_id, story_name, chapter_id)
	return self:set_data(character_id, "narrative|stories", {
		[story_name] = chapter_id
	})
end

Characters.set_narrative_event_completed = function (self, character_id, event_name, is_completed)
	return self:set_data(character_id, "narrative|events", {
		[event_name] = is_completed ~= false and "true" or "false"
	})
end

Characters.get_narrative_event = function (self, character_id, event_name, optional_account_id)
	return self:get_data(character_id, "narrative|events", event_name, optional_account_id):next(function (value)
		return value == "true" or value == true
	end)
end

Characters.set_data = function (self, character_id, section, data)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/data/" .. section), {
		method = "PUT",
		body = {
			data = data
		}
	}):next(function (data)
		return nil
	end)
end

Characters.get_data = function (self, character_id, section, part, optional_account_id)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/data/" .. section), nil, optional_account_id):next(function (data)
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
	return Managers.backend:title_request("/data/characters/names/check", {
		method = "POST",
		body = {
			names = {
				name
			}
		}
	}):next(function (data)
		return data.body.results[1]
	end)
end

implements(Characters, Interface)

return Characters
