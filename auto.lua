-- auto.lua
-- Auto teleport + say hi

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local placeId = 126884695634066
local jobId = "3c6593c7-4756-48d5-aa2f-214581f4be95"

if placeId > 0 and jobId ~= "" then
    TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)

    Players.LocalPlayer.OnTeleport:Connect(function(state)
        if state == Enum.TeleportState.InProgress then
            game.Loaded:Wait()
            task.wait(2)

            task.wait(3)
            game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents")
                :WaitForChild("SayMessageRequest"):FireServer("hi", "All")
        end
    end)
end
