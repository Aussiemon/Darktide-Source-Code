-- chunkname: @scripts/managers/privileges/privileges_manager_constants.lua

local PrivilegesManagerConstants = {}

PrivilegesManagerConstants.DenyReason = table.enum("NO_USER", "RESTRICTED", "BANNED", "PURCHASE_REQUIRED", "RESOLUTION_REQUIRED", "USER_ABORTED", "FAILED_TO_RESOLVE", "UNKNOWN")

return PrivilegesManagerConstants
