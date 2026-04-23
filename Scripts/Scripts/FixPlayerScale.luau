-- Script para corrigir a escala e propriedades de movimento dos jogadores
-- Problemas corrigidos:
-- 1. Escala muito pequena (0.77) afetando JumpHeight e HipHeight
-- 2. JumpHeight muito baixo (0.48) impedindo pulo correto
-- 3. Gravidade muito baixa (35) fazendo parecer que está na lua

local Players = game:GetService("Players")

local function fixPlayerScale(player)
	player.CharacterAdded:Connect(function(character)
		-- Aguarda um pouco para garantir que o Humanoid foi criado
		task.wait(0.5)
		
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		
		-- Reseta as escalas para 1.0
		local bodyHeightScale = humanoid:FindFirstChild("BodyHeightScale")
		local bodyWidthScale = humanoid:FindFirstChild("BodyWidthScale")
		local bodyDepthScale = humanoid:FindFirstChild("BodyDepthScale")
		local headScale = humanoid:FindFirstChild("HeadScale")
		
		if bodyHeightScale then bodyHeightScale.Value = 1 end
		if bodyWidthScale then bodyWidthScale.Value = 1 end
		if bodyDepthScale then bodyDepthScale.Value = 1 end
		if headScale then headScale.Value = 1 end
		
		-- Reseta o HipHeight para o valor padrão
		humanoid.HipHeight = 2
		
		-- Corrige o JumpHeight e JumpPower
		humanoid.JumpHeight = 7.2
		humanoid.JumpPower = 50
		
		print("[FixPlayerScale] Escala e pulo corrigidos para " .. player.Name)
	end)
end

-- Aplica para jogadores que já estão no jogo
for _, player in Players:GetPlayers() do
	fixPlayerScale(player)
end

-- Aplica para novos jogadores
Players.PlayerAdded:Connect(fixPlayerScale)