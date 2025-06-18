-- auto.lua
-- Smart looping joiner with full-server check

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
				warn("⚠️ Could not parse teleport info")
				return
			end

			if game.JobId == jobId then
				print("⏳ Already in target server.")
				return
			end

			if jobId == lastJobId then
				print("⏳ No new job ID.")
				return
			end

			lastJobId = jobId
			print("🚀 New server found:", jobId)

			local check = pcall(function()
				local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", placeId)
				local response = HttpService:JSONDecode(game:HttpGet(url))
				for _, server in ipairs(response.data) do
					if server.id == jobId then
						if server.playing >= server.maxPlayers then
							warn("🟥 Target server is full.")
							return
						end
					end
				end
			end)

			TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
		end)

		if not success then
			warn("❌ Error during loop:", result)
		end

		task.wait(20)
	end
end)
