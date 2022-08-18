-- Decompilation Error: _run_step(_unwarp_expressions, node)

-- Decompilation Error: _glue_flows(node)

-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
-- WARNING: Error occurred during decompilation.
--   Code may be incomplete or incorrect.
local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local MailBox = class("MailBox")

local function _decorate_mail(mail, character_id)
	mail.mark_read = function (self)
		return Managers.backend.interfaces.mailbox:mark_mail_read(character_id, self.id)
	end

	mail.mark_unread = function (self)
		return Managers.backend.interfaces.mailbox:mark_mail_unread(character_id, self.id)
	end

	mail.mark_claimed = function (self, reward_idx)
		return Managers.backend.interfaces.mailbox:mark_mail_claimed(character_id, self.id, reward_idx)
	end
end

local function _patch_mail(character_id, mail_id, body)
	return BackendUtilities.make_account_title_request("characters", BackendUtilities.url_builder(character_id):path("/mail/"):path(mail_id), {
		method = "PATCH",
		body = body
	}):next(function (data)
		local result = data.body

		if result.reward then
			result.reward.gear_id = result.reward.gearId
			result.reward.gearId = nil
		end

		_decorate_mail(result.mail)

		return result
	end)
end

MailBox.get_mail_paged = function (self, character_id, limit, source)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-21, warpins: 1 ---
	slot4 = BackendUtilities.make_account_title_request
	slot5 = "characters"
	slot7 = BackendUtilities.url_builder(character_id):path("/mail"):query("source", source)
	slot6 = BackendUtilities.url_builder(character_id).path("/mail").query("source", source).query
	slot8 = "limit"
	slot9 = limit or 50

	return BackendUtilities.make_account_title_request(slot5, slot6(slot7, slot8, slot9)):next(function (data)

		-- Decompilation error in this vicinity:
		--- BLOCK #0 1-12, warpins: 1 ---
		local result = BackendUtilities.wrap_paged_response(data.body)
		result.globals = data.body._embedded.globals

		--- END OF BLOCK #0 ---

		FLOW; TARGET BLOCK #1



		-- Decompilation error in this vicinity:
		--- BLOCK #1 13-18, warpins: 0 ---
		for i, v in ipairs(result.items) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 13-16, warpins: 1 ---
			_decorate_mail(v, character_id)
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 17-18, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #1 ---

		FLOW; TARGET BLOCK #2



		-- Decompilation error in this vicinity:
		--- BLOCK #2 19-22, warpins: 1 ---
		--- END OF BLOCK #2 ---

		FLOW; TARGET BLOCK #3



		-- Decompilation error in this vicinity:
		--- BLOCK #3 23-28, warpins: 0 ---
		for i, v in ipairs(result.globals) do

			-- Decompilation error in this vicinity:
			--- BLOCK #0 23-26, warpins: 1 ---
			_decorate_mail(v, character_id)
			--- END OF BLOCK #0 ---

			FLOW; TARGET BLOCK #1



			-- Decompilation error in this vicinity:
			--- BLOCK #1 27-28, warpins: 2 ---
			--- END OF BLOCK #1 ---



		end

		--- END OF BLOCK #3 ---

		FLOW; TARGET BLOCK #4



		-- Decompilation error in this vicinity:
		--- BLOCK #4 29-29, warpins: 1 ---
		return result
		--- END OF BLOCK #4 ---



	end)

	--- END OF BLOCK #0 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #1 22-22, warpins: 1 ---
	slot9 = 50
	--- END OF BLOCK #1 ---

	FLOW; TARGET BLOCK #2



	-- Decompilation error in this vicinity:
	--- BLOCK #2 23-29, warpins: 2 ---
	--- END OF BLOCK #2 ---



end

MailBox.mark_mail_read = function (self, character_id, mail_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	return _patch_mail(character_id, mail_id, {
		read = true
	})
	--- END OF BLOCK #0 ---



end

MailBox.mark_mail_unread = function (self, character_id, mail_id)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-5, warpins: 1 ---
	return _patch_mail(character_id, mail_id, {
		read = false
	})
	--- END OF BLOCK #0 ---



end

MailBox.mark_mail_claimed = function (self, character_id, mail_id, reward_idx)

	-- Decompilation error in this vicinity:
	--- BLOCK #0 1-6, warpins: 1 ---
	return _patch_mail(character_id, mail_id, {
		claimed = true,
		rewardIndex = reward_idx
	})
	--- END OF BLOCK #0 ---



end

return MailBox
