-- ============================================
-- INTERFACE DE JOGO (TOWER DEFENSE)
-- ============================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- RemoteEvents
local healthChangedEvent = ReplicatedStorage:WaitForChild("HealthChanged")
local gameOverEvent = ReplicatedStorage:WaitForChild("GameOver")

-- Criar ScreenGui Principal
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "GameHUD"
mainGui.ResetOnSpawn = false
mainGui.Parent = playerGui

-- Container Superior (Dinheiro)
local topContainer = Instance.new("Frame")
topContainer.Name = "TopContainer"
topContainer.Size = UDim2.new(0, 200, 0, 40)
topContainer.Position = UDim2.new(0.5, -100, 0, 20)
topContainer.BackgroundTransparency = 1
topContainer.Parent = mainGui

-- Texto de Dinheiro
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(1, 0, 1, 0)
moneyLabel.BackgroundTransparency = 1
moneyLabel.Text = "$ 200"
moneyLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
moneyLabel.TextSize = 28
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.TextStrokeTransparency = 0.5
moneyLabel.Parent = topContainer

-- ============================================
-- FUNÇÃO: Tela de Game Over
-- ============================================
local function mostrarGameOver()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "GameOverGui"
	screenGui.IgnoreGuiInset = true
	screenGui.Parent = playerGui
	
	local bgFrame = Instance.new("Frame")
	bgFrame.Size = UDim2.new(1, 0, 1, 0)
	bgFrame.BackgroundColor3 = Color3.new(0, 0, 0)
	bgFrame.BackgroundTransparency = 1
	bgFrame.BorderSizePixel = 0
	bgFrame.Parent = screenGui
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 0, 100)
	textLabel.Position = UDim2.new(0, 0, 0.4, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "BASE DESTRUÍDA"
	textLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
	textLabel.Font = Enum.Font.GothamBlack
	textLabel.TextSize = 1
	textLabel.Parent = bgFrame
	
	-- Animação de entrada
	TweenService:Create(bgFrame, TweenInfo.new(1), {BackgroundTransparency = 0.3}):Play()
	TweenService:Create(textLabel, TweenInfo.new(1, Enum.EasingStyle.Elastic), {TextSize = 80}):Play()
end

-- Eventos
gameOverEvent.OnClientEvent:Connect(mostrarGameOver)

-- Dinheiro (opcional se tiver evento)
local moneyChangedEvent = ReplicatedStorage:FindFirstChild("MoneyChanged")
if moneyChangedEvent then
	moneyChangedEvent.OnClientEvent:Connect(function(novoValor)
		moneyLabel.Text = "$ " .. novoValor
	end)
end

-- Inicializa
local config = require(ReplicatedStorage:WaitForChild("GameConfig"))
moneyLabel.Text = "$ " .. config.dinheiro
