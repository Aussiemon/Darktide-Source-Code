-- chunkname: @scripts/managers/data_service/services/player_survey_service.lua

local Promise = require("scripts/foundation/utilities/promise")
local PlayerSurveyService = class("PlayerSurveyService")

PlayerSurveyService.init = function (self, backend_interface)
	self._backend_interface = backend_interface
	self._available_surveys = {}
end

PlayerSurveyService.refresh_account_surveys = function (self)
	return self._backend_interface.player_survey:get_account_surveys():next(function (response)
		self._available_surveys = response.body.surveys

		return true
	end, function (error)
		self._available_surveys = {}

		return false
	end)
end

PlayerSurveyService.has_survey = function (self, survey_id)
	if self._available_surveys then
		for i = 1, #self._available_surveys do
			if self._available_surveys[i].id == survey_id then
				return true
			end
		end
	end

	return false
end

PlayerSurveyService.get_survey = function (self, survey_id)
	if self._available_surveys then
		for i = 1, #self._available_surveys do
			if self._available_surveys[i].id == survey_id then
				return Promise.resolved(table.clone(self._available_surveys[i]))
			end
		end
	end

	return self._backend_interface.player_survey:get_survey(survey_id):next(function (data)
		return data.body.survey
	end, function (error)
		return Promise.rejected(error)
	end)
end

PlayerSurveyService.submit_survey = function (self, survey_id, survey_result)
	return self._backend_interface.player_survey:submit_survey(survey_id, survey_result):next(function (response)
		for i = #self._available_surveys, 1, -1 do
			if self._available_surveys[i].id == survey_id then
				self._available_surveys[i] = nil
			end
		end
	end)
end

return PlayerSurveyService
