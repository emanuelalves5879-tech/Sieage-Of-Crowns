local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Animações de walk para cada tipo de mob
local walkAnimations = {
	["Dark Skeletons"] = "rbxassetid://108665050183291", -- Skeleton walk do link fornecido
	["Golem"] = "rbxassetid://81330220302315", -- Golem walk do link fornecido
}

-- Tabela para rastrear animações ativas
local activeAnimations = {}

local function animateMob(mob)
	-- Verifica se é um mob (não é jogador)
	if Players:GetPlayerFromCharacter(mob) then return end
	
	local humanoid = mob:FindFirstChild("Humanoid")
	if not humanoid then return end

	-- Desativa script de animação interno (Animate) se existir
	local animateScript = mob:FindFirstChild("Animate")
	if animateScript then
		animateScript.Enabled = false
	end
	
	-- Cria Animator se não existir
	local animator = humanoid:FindFirstChild("Animator")
	if not animator then
		animator = Instance.new("Animator")
		animator.Parent = humanoid
	end

	-- Carrega a animação de walk
	local animId = walkAnimations[mob.Name]
	if not animId then return end

	local anim = Instance.new("Animation")
	anim.AnimationId = animId

	local walkTrack = animator:LoadAnimation(anim)
	walkTrack.Priority = Enum.AnimationPriority.Movement

	-- Detecta quando o mob está se movendo
	local isMoving = false

	humanoid.Running:Connect(function(speed)
		if speed > 0.5 and not isMoving then
			isMoving = true
			walkTrack:Play()
		elseif speed <= 0.5 and isMoving then
			isMoving = false
			walkTrack:Stop()
		end
	end)

	-- Para a animação quando morrer
	humanoid.Died:Connect(function()
		walkTrack:Stop()
	end)
end

-- Observa novos mobs no Workspace
workspace.ChildAdded:Connect(function(child)
	-- Pequeno delay para garantir que o Humanoid foi criado
	task.wait(0.1)
	if child:FindFirstChild("Humanoid") then
		animateMob(child)
	end
end)

-- Processa mobs que já existem no workspace (caso o script carregue depois)
for _, child in workspace:GetChildren() do
	if child:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(child) then
		animateMob(child)
	end
end