-- auto.lua
-- Auto teleport to server + say hi once

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = 126884695634066
local jobId = "62fb10de-c646-4dd4-bbbd-6e20e685df4c"

-- Prevent rejoining same server
if game.JobId == jobId then
    print("✅ Already in correct server.")
    return
end

TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)

Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.InProgress then
        game.Loaded:Wait()
        task.wait(4)

        local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
        if chatService then
            local say = chatService:FindFirstChild("SayMessageRequest")
            if say then
                say:FireServer("hi", "All")
                print("💬 Sent chat message: hi")
            else
                warn("⚠️ SayMessageRequest not found.")
            end
        else
            warn("⚠️ DefaultChatSystemChatEvents not found.")
        end
    end
end)
