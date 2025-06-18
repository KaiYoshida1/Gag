-- auto.lua
-- Robust auto-joiner that checks latestserver.lua every second

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- ✅ Reads teleport data from this file (NOT itself)
local dataURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/latestserver.lua"

task.spawn(function()
	while true do
		local success, result = pcall(function()
			local code = game:HttpGet(dataURL)

			-- Extract PlaceId and JobId from the Lua line
			local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
			if not placeId or not jobId then
				warn("⚠️ Could not parse teleport info from latestserver.lua")
				return
			end

			-- 🧼 Normalize both IDs (remove whitespace)
			local currentJob = string.gsub(game.JobId, "%s+", "")
			local newJob = string.gsub(jobId, "%s+", "")

			print("🧠 Current Job:", currentJob)
			print("📦 GitHub Job:", newJob)

			if currentJob == newJob then
				print("✅ Already in correct server.")
				return
			end

			print("🚀 Joining new job:", newJob)
			TeleportService:TeleportToPlaceInstance(tonumber(placeId), newJob, Players.LocalPlayer)
		end)

		if not success then
			warn("❌ Error during loop:", result)
		end

		task.wait(1)
	end
end)
