-- auto.lua (robust + real-time GitHub fetch)
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local baseURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/latestserver.lua"
local lastJobId = nil

task.spawn(function()
	while true do
		local success, err = pcall(function()
			local url = baseURL .. "?nocache=" .. tick()
			local code = game:HttpGet(url)

			print("📄 GitHub Content:\n", code)

			local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
			if not placeId or not jobId then
				warn("⚠️ Could not parse teleport info.")
				return
			end

			jobId = jobId:gsub("%s+", "")
			local currentJob = game.JobId:gsub("%s+", "")

			print("🧠 Current Job:", currentJob)
			print("📦 Target Job from GitHub:", jobId)

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

			local tpOK, tpErr = pcall(function()
				TeleportService:TeleportToPlaceInstance(tonumber(placeId), jobId, Players.LocalPlayer)
			end)

			if not tpOK then
				warn("❌ Teleport error:", tpErr)
			end
		end)

		if not success then
			warn("❌ Error in loop:", err)
		end

		task.wait(5)
	end
end)
