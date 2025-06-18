-- auto.lua
-- Auto-joiner with robust parser (handles varied formats)
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local scriptURL = "https://raw.githubusercontent.com/KaiYoshida1/Gag/main/auto.lua"
local lastJobId = nil

local function extractTeleportData(code)
  local pattern = "TeleportToPlaceInstance%s*%(%s*(%d+)%s*,%s*['\"]([%w%-]+)['\"]"
  return tonumber(string.match(code, pattern)), string.match(code, pattern)
end

task.spawn(function()
  while true do
    local ok, err = pcall(function()
      local code = game:HttpGet(scriptURL)
      local placeId, jobId = extractTeleportData(code)

      if not placeId or not jobId then
        warn("⚠️ Could not parse teleport info from GitHub.")
        return
      end

      if game.JobId == jobId then
        print("✅ Already in correct server.")
        return
      end

      print("🚀 Trying to join:", jobId)
      task.wait(1.5)
      TeleportService:TeleportToPlaceInstance(placeId, jobId, Players.LocalPlayer)
    end)

    if not ok then
      warn("❌ Error during loop:", err)
    end

    task.wait(20)
  end
end)
