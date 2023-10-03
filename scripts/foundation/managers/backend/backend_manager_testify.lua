local BackendManagerTestify = {}

BackendManagerTestify.fail_on_not_authenticated = function (backend_manager)
	if not backend_manager:authenticated() then
		ferror("The client is not authenticated. The test needs client authentification to run.\n" .. "Check that testify has correctly started Steam and that the steam_appid.txt file is present " .. "in the engine directory. eg: C:\\BitSquidBinaries\\bishop\\engine\\win64\\dev.\n" .. "If those 2 conditions are met and the problem persists, ping @TestAutomation on Slack.")
	end
end

BackendManagerTestify.load_mission_in_mission_board = function (backend_manager, params)
	local map = params.map
	local challenge = params.challenge
	local resistance = params.resistance
	local circumstance_name = params.circumstance_name
	local side_mission = params.side_mission

	Managers.backend.interfaces.mission_board:create_mission({
		xp = 0,
		credits = 0,
		map = map,
		flags = {},
		circumstance = circumstance_name,
		sideMission = side_mission,
		bonuses = {},
		challenge = challenge,
		resistance = resistance
	}):next(function (response)
		return response.mission
	end):next(function (mission)
		local mission_id = mission.id
		local party_manager = Managers.party_immaterium

		party_manager:wanted_mission_selected(mission_id)
	end):catch(function (error)
		Log.error("BackendManagerTestify", "Could not create debug mission " .. table.tostring(error, 5))
	end)
end

return BackendManagerTestify
