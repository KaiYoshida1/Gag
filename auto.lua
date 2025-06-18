-- auto.lua
-- Smart auto-joiner with full-server detection

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local scriptURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/auto.lua"

local lastJobId = nil
local skippedFullJobs = {}

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
				print("✅ Already in correct server.")
				return
			end

			if jobId == lastJobId or skippedFullJobs[jobId] then
				print("⏳ No new join target.")
				return
			end

			print("🚀 New server found:", jobId)
			lastJobId = jobId

			local isFull = false

			local check = pcall(function()
				local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100", placeId)
				local response = HttpService:JSONDecode(game:HttpGet(url))
				for _, server in ipairs(response.data) do
					if server.id == jobId then
						if server.playing >= server.maxPlayers then
							isFull = true
							skippedFullJobs[jobId] = true
							warn("🟥 Server full. Skipping this jobId.")
							break
						end
					end
				end
			end)

			if isFull then
				print("🛑 Skipping full server.")
				return
			end

			task.wait(1.5)
			TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
		end)

		if not success then
			warn("❌ Error in auto-join loop:", result)
		end

		task.wait(20)
	end
end)
