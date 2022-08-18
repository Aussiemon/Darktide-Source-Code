local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local Promise = require("scripts/foundation/utilities/promise")
local VersionChecker = class("VersionChecker")
local version_checker_path = "/game-version/status"

VersionChecker.init = function (self)
	return
end

VersionChecker.status = function (self)
	local svn_rev = APPLICATION_SETTINGS.content_revision or LOCAL_CONTENT_REVISION

	if svn_rev == nil or svn_rev == "" then
		Log.error("Backend", "No svn revision found - svn hook has not been called?")

		svn_rev = 99999999
	end

	local game_version = APPLICATION_SETTINGS.game_version or "1.0.0"
	local platform = PLATFORM

	return Managers.backend:title_request(BackendUtilities.url_builder(version_checker_path):query("svnRev", svn_rev):query("gameVersion", game_version):query("platform", platform):to_string()):next(function (data)
		local status = data.body.allowed

		if not status then
			Log.warning("Backend", "Game version did not match, was: %s - %s(%s)", platform, game_version, svn_rev)
		end

		return data.body.allowed
	end)
end

return VersionChecker
