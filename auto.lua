-- auto.lua
-- Auto-joiner with cache-busting and no stale data via jsDelivr

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- ✅ Uses jsDelivr CDN to bypass raw.githubusercontent cache
local dataURL = "https://cdn.jsdelivr.net/gh/KaiYoshida1/Gag@main/latestserver.lua"
local lastJobId = nil

task.spawn(function()
	while true do
		local success, err = pcall(function()
			local url = dataURL .. "?t=" .. tick() -- extra no-cache tag
			local code = game:HttpGet(url)

			local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
			if not placeId or not jobId then
				warn("⚠️ Could not parse teleport info.")
				return
			end

			jobId = string.gsub(jobId, "%s+", "")
			local currentJob = string.gsub(game.JobId, "%s+", "")

			print("🧠 Current Job:", currentJob)
			print("📦 Target Job:", jobId)

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

			local ok, tpErr = pcall(function()
				TeleportService:TeleportToPlaceInstance(tonumber(placeId), jobId, Players.LocalPlayer)
			end)

			if not ok then
				warn("❌ Teleport failed (engine):", tpErr)
			end
		end)

		if not success then
			warn("❌ Error in loop:", err)
		end

		task.wait(5)
	end
end)
