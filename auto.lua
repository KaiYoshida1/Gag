local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local dataURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/latestserver.lua"

task.spawn(function()
	while true do
		local success, result = pcall(function()
			local code = game:HttpGet(dataURL)

			local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
			if not placeId or not jobId then
				warn("⚠️ Could not parse teleport info from latestserver.lua")
				return
			end

			jobId = string.gsub(jobId, "%s+", "")
			local currentJob = string.gsub(game.JobId, "%s+", "")

			if currentJob == jobId then
				print("✅ Already in correct server.")
				return
			end

			print("🚀 Trying to join job:", jobId)

			local tpSuccess, tpErr = pcall(function()
				TeleportService:TeleportToPlaceInstance(tonumber(placeId), jobId, Players.LocalPlayer)
			end)

			if not tpSuccess then
				warn("❌ Teleport failed (script-side):", tpErr)
			end
		end)

		if not success then
			warn("❌ Error in loop:", result)
		end

		task.wait(1)
	end
end)
