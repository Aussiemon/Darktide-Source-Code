require("scripts/foundation/utilities/table")

local BackendError = table.enum("NotInitialized", "AuthenticationFailed", "NoIdentifier", "NotImplemented", "BadRequest", "InvalidResponse", "UnknownError")

return BackendError
