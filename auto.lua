-- auto.lua
-- Simple loop auto-joiner that always retries

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local scriptURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/auto.lua"
local lastJobId = nil

local function extractTeleportData(code)
	local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"%)")
	return tonumber(placeId), jobId
end

task.spawn(function()
	while true do
		local success, result = pcall(function()
			local latestCode = game:HttpGet(scriptURL)
			local placeId, jobId = extractTeleportData(latestCode)

			if not placeId or not jobId then
				warn("⚠️ Could not parse teleport info from GitHub.")
				return
			end

			if game.JobId == jobId then
				print("✅ Already in correct server.")
				return
			end

			print("🚀 Trying to join:", jobId)
			task.wait(1.5)
			TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
		end)

		if not success then
			warn("❌ Error during loop:", result)
		end

		task.wait(20)
	end
end)
