-- auto.lua
-- Auto-joiner that fetches latest job from GitHub every second

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local dataURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/latestserver.lua"
local lastJobId = nil

local function extractTeleportData(code)
	local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
	return tonumber(placeId), jobId
end

task.spawn(function()
	while true do
		local success, result = pcall(function()
			local code = game:HttpGet(dataURL)
			local placeId, jobId = extractTeleportData(code)

			if not placeId or not jobId then
				warn("⚠️ Could not parse teleport info from latestserver.lua")
				return
			end

			-- Clean jobId of hidden whitespace just in case
			jobId = string.gsub(jobId, "%s+", "")

			-- Debug comparison
			print("🧠 Current Job:", game.JobId)
			print("📦 GitHub Job:", jobId)

			if game.JobId == jobId then
				print("✅ Already in correct server.")
				return
			end

			print("🚀 Joining new job:", jobId)
			TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
		end)

		if not success then
			warn("❌ Error during loop:", result)
		end

		-- Check every second
		task.wait(1)
	end
end)
