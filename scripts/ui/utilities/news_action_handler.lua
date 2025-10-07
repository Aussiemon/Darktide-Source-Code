-- chunkname: @scripts/ui/utilities/news_action_handler.lua

local PlayerSurveyView = require("scripts/ui/views/player_survey_view/player_survey_view")
local WebBrowser = require("scripts/utilities/web_browser/web_browser")
local NewsActionHandler = class("NewsActionHandler")

NewsActionHandler.handle = function (action_data)
	if action_data.action == "open_view" then
		NewsActionHandler._on_action_cb_open_view(action_data)

		return
	elseif action_data.action == "open_url" then
		WebBrowser.open(action_data.target)

		return
	elseif action_data.action == "open_store" then
		NewsActionHandler._on_action_cb_open_store(action_data)

		return
	elseif action_data.action == "open_survey" then
		NewsActionHandler._on_action_cb_open_survey(action_data)

		return
	end
end

NewsActionHandler._on_action_cb_open_view = function (action_data)
	Managers.ui:open_view(action_data.target, nil, nil, nil, nil, table.add_missing(action_data.view_context or {}, {
		pass_draw = false,
	}))
end

NewsActionHandler._on_action_cb_open_store = function (action_data)
	Managers.ui:open_view("store_view", nil, nil, nil, nil, table.add_missing(action_data.view_context or {}, {
		pass_draw = false,
		target_storefront = action_data.target,
	}))
end

NewsActionHandler._on_action_cb_open_survey = function (action_data)
	PlayerSurveyView.open(table.add_missing(action_data.view_context or {}, {
		pass_draw = false,
		survey_id = action_data.target,
	}))
end

return NewsActionHandler
