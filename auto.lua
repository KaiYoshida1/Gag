-- auto.lua
-- Auto teleport + chat 'hi' + no infinite join

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = 126884695634066
local jobId = "5f8fc57c-6d22-419c-b3ce-21e9942c9d17"

if game.JobId == jobId then
    print("✅ Already in the correct server.")
    return
end

TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)

Players.LocalPlayer.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.InProgress then
        game.Loaded:Wait()
        task.wait(2)
        task.wait(3)

        local chat = game:GetService("ReplicatedStorage")
            :WaitForChild("DefaultChatSystemChatEvents")
            :WaitForChild("SayMessageRequest")

        chat:FireServer("hi", "All")
    end
end)
