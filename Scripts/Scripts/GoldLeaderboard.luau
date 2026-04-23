local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage:WaitForChild("GameConfig"))

-- Sistema simples de ouro com leaderboard
local function setupLeaderboard(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local gold = Instance.new("IntValue")
	gold.Name = "Ouro"
	gold.Value = GameConfig.GetDinheiro() -- Sincroniza com o GameConfig
	gold.Parent = leaderstats
end

Players.PlayerAdded:Connect(setupLeaderboard)

for _, player in Players:GetPlayers() do
	setupLeaderboard(player)
end