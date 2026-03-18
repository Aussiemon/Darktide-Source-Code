-- chunkname: @scripts/backend/external_payment.lua

local BackendUtilities = require("scripts/foundation/managers/backend/utilities/backend_utilities")
local ExternalPaymentPlatformBase = require("scripts/backend/platform/external_payment_platform_base")
local ExternalPaymentPlatformSteam = require("scripts/backend/platform/external_payment_platform_steam")
local ExternalPaymentPlatformXbox = require("scripts/backend/platform/external_payment_platform_xbox")
local ExternalPaymentPlatformPlaystation = require("scripts/backend/platform/external_payment_platform_playstation")
local ExternalPaymentPlatform = {}

ExternalPaymentPlatform[Backend.AUTH_METHOD_STEAM] = ExternalPaymentPlatformSteam
ExternalPaymentPlatform[Backend.AUTH_METHOD_XBOXLIVE] = ExternalPaymentPlatformXbox
ExternalPaymentPlatform[Backend.AUTH_METHOD_PSN] = ExternalPaymentPlatformPlaystation

local ExternalPayment = {}

ExternalPayment.new = function (self)
	local authenticate_method = Backend:get_auth_method()

	Log.debug("ExternalPayment", "Using method: %s", authenticate_method)

	local payment_platform = ExternalPaymentPlatform[authenticate_method]

	if payment_platform == nil then
		Log.debug("ExternalPayment", "No external payment platform for auth method %s. Using base platform.", authenticate_method)

		payment_platform = ExternalPaymentPlatformBase
	end

	local instance = payment_platform:new()

	return instance
end

return ExternalPayment
