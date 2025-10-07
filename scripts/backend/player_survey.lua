-- chunkname: @scripts/backend/player_survey.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local PlayerSurvey = class("PlayerSurvey")

PlayerSurvey.get_account_surveys = function (self)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/data/"):path(account.sub):path("/surveys/")

		return Managers.backend:title_request(builder:to_string(), {
			method = "GET",
		})
	end)
end

PlayerSurvey.get_survey = function (self, survey_id)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/data/"):path(account.sub):path("/surveys/"):path(survey_id)

		return Managers.backend:title_request(builder:to_string(), {
			method = "GET",
		})
	end)
end

PlayerSurvey.submit_survey = function (self, survey_id, survey_result)
	return Managers.backend:authenticate():next(function (account)
		local builder = BackendUtilities.url_builder():path("/data/"):path(account.sub):path("/surveys/"):path(survey_id)

		return Managers.backend:title_request(builder:to_string(), {
			method = "POST",
			body = survey_result,
		})
	end)
end

return PlayerSurvey
