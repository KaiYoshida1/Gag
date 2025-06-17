-- auto.lua
-- Generated automatically from Discord webhook
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local scriptURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/auto.lua"
local targetPlayerName = "UnknownPlayer"
local lastJobId = nil

local function extractTeleportInfo(code)
    local placeId, jobId = string.match(code, "TeleportToPlaceInstance%((%d+),%s*\"([^"]+)\"")
    return tonumber(placeId), jobId
end

task.spawn(function()
    while true do
        local success, result = pcall(function()
            local latestCode = game:HttpGet(scriptURL)
            local placeId, jobId = extractTeleportInfo(latestCode)

            if placeId and jobId and jobId ~= lastJobId then
                lastJobId = jobId
                print("🚀 New server: "..jobId)
                TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)

                Players.LocalPlayer.OnTeleport:Connect(function(state)
                    if state == Enum.TeleportState.InProgress then
                        game.Loaded:Wait()
                        task.wait(2)

                        local found = false
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player.Name == targetPlayerName then
                                found = true
                                break
                            end
                        end

                        if found then
                            print("✅ Player found:", targetPlayerName)
                        else
                            warn("❌ Player NOT found:", targetPlayerName)
                        end
                    end
                end)
            else
                print("⏳ Waiting for new job...")
            end
        end)

        if not success then
            warn("🔴 Error checking job:", result)
        end

        wait(20)
    end
end)
