local ProfileSynchronizationManagerTestify = GameParameters.testify and require("scripts/managers/loading/profile_synchronization_manager_testify")
local ProfileSynchronizationManager = class("ProfileSynchronizationManager")

ProfileSynchronizationManager.init = function (self)
	self._profile_synchronizer_client = nil
	self._profile_synchronizer_host = nil
end

ProfileSynchronizationManager.destroy = function (self)
	return
end

ProfileSynchronizationManager.update = function (self, dt)
	if self._profile_synchronizer_host then
		self._profile_synchronizer_host:update(dt)
	end

	if GameParameters.testify then
		Testify:poll_requests_through_handler(ProfileSynchronizationManagerTestify, self)
	end
end

ProfileSynchronizationManager.set_profile_synchroniser_client = function (self, profile_synchronizer_client)
	self._profile_synchronizer_client = profile_synchronizer_client
end

ProfileSynchronizationManager.set_profile_synchroniser_host = function (self, profile_synchronizer_host)
	self._profile_synchronizer_host = profile_synchronizer_host
end

ProfileSynchronizationManager.is_ready = function (self)
	return self._profile_synchronizer_client or self._profile_synchronizer_host
end

ProfileSynchronizationManager.synchronizer_host = function (self)
	return self._profile_synchronizer_host
end

ProfileSynchronizationManager.synchronizer_client = function (self)
	return self._profile_synchronizer_client
end

return ProfileSynchronizationManager
