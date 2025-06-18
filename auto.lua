-- auto.lua
-- Auto-joiner with cache-busting GitHub request

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local baseURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/latestserver.lua"
local lastJobId = nil

task.spawn(function()
	while true do
		local success, result = pcall(function()
			local url = baseURL .. "?v=" .. HttpService:GenerateGUID(false)
			local code = game:HttpGet(url)

			local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
			if not placeId or not jobId then
				warn("⚠️ Could not parse teleport info from latestserver.lua")
				return
			end

			jobId = string.gsub(jobId, "%s+", "")
			local currentJob = string.gsub(game.JobId, "%s+", "")

			print("🧠 Current Job:", currentJob)
			print("📦 GitHub Job:", jobId)

			if currentJob == jobId then
				print("✅ Already in correct server.")
				return
			end

			if lastJobId ~= jobId then
				print("🚀 New job detected:", jobId)
				lastJobId = jobId
			else
				print("🔁 Retrying join:", jobId)
			end

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
