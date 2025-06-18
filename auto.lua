-- auto.lua (final version: robust + real-time GitHub sync)

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local baseURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/latestserver.lua"
local lastJobId = nil

task.spawn(function()
	while true do
		local ok, err = pcall(function()
			local fullURL = baseURL .. "?nocache=" .. tick()
			local code = game:HttpGet(fullURL)

			print("🌐 Fetched latestserver.lua at " .. os.date())
			print("📄 Raw code:\n" .. code)

			local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
			if not placeId or not jobId then
				warn("⚠️ Failed to parse job info.")
				return
			end

			placeId = tonumber(placeId)
			jobId = jobId:gsub("%s+", "")
			local currentJob = game.JobId:gsub("%s+", "")

			print("🧠 You are in:", currentJob)
			print("📦 GitHub job:", jobId)

			if currentJob == jobId then
				print("✅ Already in the correct server.")
				return
			end

			if lastJobId ~= jobId then
				print("🚀 New job detected! Attempting teleport...")
				lastJobId = jobId
			else
				print("🔁 Retrying teleport to same job...")
			end

			local success, tpError = pcall(function()
				TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
			end)

			if not success then
				warn("❌ Teleport failed:", tpError)
			end
		end)

		if not ok then
			warn("❌ Loop error:", err)
		end

		task.wait(1)
	end
end)
