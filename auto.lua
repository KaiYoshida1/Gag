-- auto.lua with deep debug and forced refresh

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

-- ✅ Use jsDelivr + timestamp to prevent caching
local dataURL = "https://cdn.jsdelivr.net/gh/KaiYoshida1/Gag@main/latestserver.lua"

task.spawn(function()
    while true do
        local ok, err = pcall(function()
            local url = dataURL .. "?t=" .. tostring(tick())
            print("🔄 Fetching:", url)
            local code = game:HttpGet(url)
            print("📄 Fetched content at", os.date(), ":\n", code)

            local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^\"]+)\"")
            if not placeId or not jobId then
                warn("⚠️ Could not parse teleport info.")
                return
            end

            jobId = jobId:gsub("%s+", "")
            local currentJob = game.JobId and game.JobId:gsub("%s+", "") or "nil"
            print("🧠 Current Job:", currentJob)
            print("📦 Target Job from GitHub:", jobId)

            if currentJob == jobId then
                print("✅ Already in correct server.")
                return
            end

            print("🚀 Attempting to teleport to", jobId)
            local tpOk, tpErr = pcall(function()
                TeleportService:TeleportToPlaceInstance(tonumber(placeId), jobId, Players.LocalPlayer)
            end)
            if not tpOk then
                warn("❌ Teleport error:", tpErr)
            end
        end)

        if not ok then
            warn("🚨 Loop error:", err)
        end

        task.wait(5)
    end
end)
