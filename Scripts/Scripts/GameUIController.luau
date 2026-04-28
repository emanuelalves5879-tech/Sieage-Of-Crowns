local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Esperar UI carregar
local GameGui = PlayerGui:WaitForChild("GameGui", 5)

-- Função para reiniciar o jogo
local function restartGame()
	print("[Client] Reiniciando jogo...")
	
	-- Esconder telas primeiro
	if GameGui then
		local gameOverFrame = GameGui:FindFirstChild("GameOverFrame")
		local victoryFrame = GameGui:FindFirstChild("VictoryFrame")
		if gameOverFrame then gameOverFrame.Visible = false end
		if victoryFrame then victoryFrame.Visible = false end
	end
	
	-- Remover GameOverGui criado dinamicamente
	local gameOverGui = PlayerGui:FindFirstChild("GameOverGui")
	if gameOverGui then
		gameOverGui:Destroy()
		print("[Client] GameOverGui removido!")
	end
	
	-- Solicitar reinício ao servidor
	local requestRestart = ReplicatedStorage:FindFirstChild("RequestRestart")
	if requestRestart then
		requestRestart:FireServer()
	end
	
	-- Recarregar o personagem
	task.wait(0.5)
	Players.LocalPlayer:LoadCharacter()
end

-- Conectar botões de reiniciar
local function connectRestartButtons()
	if GameGui then
		-- Botão de reiniciar na tela de Game Over
		local gameOverFrame = GameGui:FindFirstChild("GameOverFrame")
		if gameOverFrame then
			local restartButton = gameOverFrame:FindFirstChild("RestartButton", true)
			if restartButton then
				restartButton.MouseButton1Click:Connect(restartGame)
			end
		end
		
		-- Botão de reiniciar na tela de Vitória
		local victoryFrame = GameGui:FindFirstChild("VictoryFrame")
		if victoryFrame then
			local victoryRestartButton = victoryFrame:FindFirstChild("VictoryRestartButton", true)
			if victoryRestartButton then
				victoryRestartButton.MouseButton1Click:Connect(restartGame)
			end
		end
	end
end

-- Escutar evento de Game Over
local gameOverEvent = ReplicatedStorage:FindFirstChild("GameOver")
if gameOverEvent then
	gameOverEvent.OnClientEvent:Connect(function()
		print("[Client] Game Over recebido!")
		if GameGui then
			local gameOverFrame = GameGui:FindFirstChild("GameOverFrame")
			if gameOverFrame then
				gameOverFrame.Visible = true
				
				-- Remover o GameOverFrame após 5 segundos
				task.spawn(function()
					task.wait(5)
					gameOverFrame.Visible = false
					print("[Client] GameOverFrame removido após 5s")
				end)
			end
		end
	end)
end

-- Escutar evento de Vitória
local victoryEvent = ReplicatedStorage:FindFirstChild("Victory")
if victoryEvent then
	victoryEvent.OnClientEvent:Connect(function()
		print("[Client] Vitória recebida!")
		if GameGui then
			local victoryFrame = GameGui:FindFirstChild("VictoryFrame")
			if victoryFrame then
				victoryFrame.Visible = true
			end
		end
	end)
end

-- Escutar evento de reinício
local restartEvent = ReplicatedStorage:FindFirstChild("RestartGame")
if restartEvent then
	restartEvent.OnClientEvent:Connect(function()
		print("[Client] Reinício recebido!")
		restartGame()
	end)
end

-- Conectar botões
task.wait(1)
connectRestartButtons()

print("[Client] GameUIController carregado!")