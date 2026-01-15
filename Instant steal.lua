local whitelist = {
    "kak997774",
    "Jahrelloveshugs",
    "Bekm2009",
    "AL3XMARIAN24678SSS",
    "foolslaf",
    "Skibinatrees",
    "SosatelBrainrotov2",
    "bblankpaged",
    "Empty_sab51",
    "situalitism",
    "imtuffthe3rd",
    "Gddhhddnd9",
    "cristian_juega71",
    "Adrianflash2010",
}

local function isWhitelisted(name)
	for _, v in ipairs(whitelist) do
		if string.lower(v) == string.lower(name) then
			return true
		end
	end
	return false
end

local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
if not isWhitelisted(player.Name) then
	player:Kick("Not Whitelisted Go Buy It Broke Dont Tryna Skid It 😭🙏 (BUY HERE discord.gg/YJaajAeuD)")
	return
end

if _G.NexHubInstantStealLoaded then return end
_G.NexHubInstantStealLoaded = true

local pos1, pos2 = nil, nil
local spawnPosition = nil
local beam1, beam2
local part1, part2
local noWalkEnabled = false
local positionMarker = nil

local FFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000,
    LargeReplicatorWrite5 = true,
    LargeReplicatorEnabled9 = true,
    AngularVelociryLimit = 360,
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646,
    S2PhysicsSenderRate = 15000,
    DisableDPIScale = true,
    MaxDataPacketPerSend = 2147483647,
    PhysicsSenderMaxBandwidthBps = 20000,
    TimestepArbiterHumanoidLinearVelThreshold = 21,
    MaxMissedWorldStepsRemembered = -2147483648,
    PlayerHumanoidPropertyUpdateRestrict = true,
    SimDefaultHumanoidTimestepMultiplier = 0,
    StreamJobNOUVolumeLengthCap = 2147483647,
    DebugSendDistInSteps = -2147483648,
    GameNetDontSendRedundantNumTimes = 1,
    CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
    LargeReplicatorSerializeRead3 = true,
    ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
    CheckPVCachedVelThresholdPercent = 10,
    CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
    GameNetDontSendRedundantDeltaPositionMillionth = 1,
    InterpolationFrameVelocityThresholdMillionth = 5,
    StreamJobNOUVolumeCap = 2147483647,
    InterpolationFrameRotVelocityThresholdMillionth = 5,
    CheckPVCachedRotVelThresholdPercent = 10,
    WorldStepMax = 30,
    InterpolationFramePositionThresholdMillionth = 5,
    TimestepArbiterHumanoidTurningVelThreshold = 1,
    SimOwnedNOUCountThresholdMillionth = 2147483647,
    GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
    NextGenReplicatorEnabledWrite4 = true,
    TimestepArbiterOmegaThou = 1073741823,
    MaxAcceptableUpdateDelay = 1,
    LargeReplicatorSerializeWrite4 = true
}

local defaultFFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = 8,
    LargeReplicatorWrite5 = false,
    LargeReplicatorEnabled9 = false,
    AngularVelociryLimit = 180,
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 100,
    S2PhysicsSenderRate = 60,
    DisableDPIScale = false,
    MaxDataPacketPerSend = 1024,
    PhysicsSenderMaxBandwidthBps = 10000,
    TimestepArbiterHumanoidLinearVelThreshold = 10,
    MaxMissedWorldStepsRemembered = 10,
    PlayerHumanoidPropertyUpdateRestrict = false,
    SimDefaultHumanoidTimestepMultiplier = 1,
    StreamJobNOUVolumeLengthCap = 1000,
    DebugSendDistInSteps = 10,
    GameNetDontSendRedundantNumTimes = 10,
    CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 50,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 100,
    LargeReplicatorSerializeRead3 = false,
    ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 100,
    CheckPVCachedVelThresholdPercent = 50,
    CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 100,
    GameNetDontSendRedundantDeltaPositionMillionth = 100,
    InterpolationFrameVelocityThresholdMillionth = 100,
    StreamJobNOUVolumeCap = 1000,
    InterpolationFrameRotVelocityThresholdMillionth = 100,
    CheckPVCachedRotVelThresholdPercent = 50,
    WorldStepMax = 60,
    InterpolationFramePositionThresholdMillionth = 100,
    TimestepArbiterHumanoidTurningVelThreshold = 10,
    SimOwnedNOUCountThresholdMillionth = 1000,
    GameNetPVHeaderLinearVelocityZeroCutoffExponent = 8,
    NextGenReplicatorEnabledWrite4 = false,
    TimestepArbiterOmegaThou = 1000,
    MaxAcceptableUpdateDelay = 10,
    LargeReplicatorSerializeWrite4 = false
}

local desyncActive = false
local firstActivation = true
local isActivating = false

local function applyFFlags(flags)
    for name, value in pairs(flags) do
        pcall(function()
            setfflag(tostring(name), tostring(value))
        end)
    end
end

local function respawn(plr)
    local char = plr.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Dead)
        end
        char:ClearAllChildren()
        local newChar = Instance.new("Model")
        newChar.Parent = workspace
        plr.Character = newChar
        task.wait()
        plr.Character = char
        newChar:Destroy()
    end
end

-- Function to create position marker
local function createPositionMarker(position)
	-- Remove old marker if it exists
	if positionMarker then
		positionMarker:Destroy()
	end
	
	-- Create the marker model
	positionMarker = Instance.new("Model", workspace)
	positionMarker.Name = "PositionMarker"
	
	-- Create green square base
	local base = Instance.new("Part", positionMarker)
	base.Size = Vector3.new(5, 0.2, 5)
	base.CFrame = CFrame.new(position.X, position.Y, position.Z)
	base.Anchored = true
	base.CanCollide = false
	base.Material = Enum.Material.Neon
	base.Color = Color3.fromRGB(0, 255, 0)
	base.Transparency = 0.3
	
	-- Create "HERE" text above the base
	local textPart = Instance.new("Part", positionMarker)
	textPart.Size = Vector3.new(3, 3, 0.1)
	textPart.CFrame = CFrame.new(position.X, position.Y + 2, position.Z)
	textPart.Anchored = true
	textPart.CanCollide = false
	textPart.Transparency = 1
	
	local surfaceGui = Instance.new("SurfaceGui", textPart)
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.AlwaysOnTop = true
	surfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	surfaceGui.PixelsPerStud = 50
	
	local textLabel = Instance.new("TextLabel", surfaceGui)
	textLabel.Size = UDim2.fromScale(1, 1)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "HERE"
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextScaled = true
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeTransparency = 0.5
	textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	
	-- Make text face camera
	RunService.RenderStepped:Connect(function()
		if textPart and textPart.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local camCFrame = workspace.CurrentCamera.CFrame
			textPart.CFrame = CFrame.new(textPart.Position, camCFrame.Position)
		end
	end)
	
	-- Bouncing animation
	task.spawn(function()
		local startY = position.Y + 2
		while positionMarker and positionMarker.Parent do
			-- Bounce up
			TweenService:Create(textPart, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
				CFrame = CFrame.new(position.X, startY + 1, position.Z)
			}):Play()
			task.wait(0.5)
			
			-- Bounce down
			TweenService:Create(textPart, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
				CFrame = CFrame.new(position.X, startY, position.Z)
			}):Play()
			task.wait(0.5)
		end
	end)
	
	-- Spinning animation for the base
	task.spawn(function()
		while base and base.Parent do
			base.CFrame = base.CFrame * CFrame.Angles(0, math.rad(2), 0)
			task.wait()
		end
	end)
end

local targetPositions = {
	Vector3.new(-481.88, -3.79, 138.02),
	Vector3.new(-481.75, -3.79, 89.18),
	Vector3.new(-481.82, -3.79, 30.95),
	Vector3.new(-481.75, -3.79, -17.79),
	Vector3.new(-481.80, -3.79, -76.06),
	Vector3.new(-481.72, -3.79, -124.70),
	Vector3.new(-337.45, -3.85, -124.72),
	Vector3.new(-337.37, -3.85, -76.07),
	Vector3.new(-337.46, -3.79, -17.72),
	Vector3.new(-337.41, -3.79, 30.92),
	Vector3.new(-337.32, -3.79, 89.02),
	Vector3.new(-337.27, -3.79, 137.90),
	Vector3.new(-337.45, -3.79, 196.29),
	Vector3.new(-337.37, -3.79, 244.91),
	Vector3.new(-481.72, -3.79, 196.21),
	Vector3.new(-481.76, -3.79, 244.92)
}

task.spawn(function()
	repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	task.wait(0.5)
	local hrp = player.Character.HumanoidRootPart
	spawnPosition = hrp.Position
	print("Spawn position detected:", spawnPosition)
end)

local gui = Instance.new("ScreenGui")
gui.Name = "!MyskypUI!"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromOffset(225, 185)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(24, 23, 28)
frame.BackgroundTransparency = 0.05
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- RAINBOW SPINNING BORDER
local rainbowBorder = Instance.new("UIStroke", frame)
rainbowBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
rainbowBorder.Thickness = 2
rainbowBorder.Color = Color3.fromRGB(255, 0, 0)

-- GLOW EFFECT (Shine)
local glowFrame = Instance.new("ImageLabel", frame)
glowFrame.Size = UDim2.fromScale(1.15, 1.15)
glowFrame.Position = UDim2.fromScale(0.5, 0.5)
glowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
glowFrame.BackgroundTransparency = 1
glowFrame.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
glowFrame.ImageColor3 = Color3.fromRGB(255, 255, 255)
glowFrame.ImageTransparency = 0.5
glowFrame.ScaleType = Enum.ScaleType.Slice
glowFrame.SliceCenter = Rect.new(10, 10, 118, 118)
glowFrame.ZIndex = 0

-- Create a custom glow using UIGradient
local glowGradient = Instance.new("UIGradient", glowFrame)
glowGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 1),
	NumberSequenceKeypoint.new(0.5, 0.7),
	NumberSequenceKeypoint.new(1, 1)
})

-- RAINBOW ANIMATION
task.spawn(function()
	local hue = 0
	while true do
		hue = (hue + 0.01) % 1
		rainbowBorder.Color = Color3.fromHSV(hue, 1, 1)
		glowFrame.ImageColor3 = Color3.fromHSV(hue, 1, 1)
		RunService.RenderStepped:Wait()
	end
end)

-- SHINE EFFECT ANIMATION
task.spawn(function()
	while true do
		TweenService:Create(glowFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			ImageTransparency = 0.3
		}):Play()
		task.wait(1.5)
		TweenService:Create(glowFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
			ImageTransparency = 0.7
		}):Play()
		task.wait(1.5)
	end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -12, 0, 28)
title.Position = UDim2.fromOffset(5, 5)
title.BackgroundTransparency = 1
title.Text = "♥ MYSKYP INSTA STEAL ♥"
title.Font = Enum.Font.GothamBold
title.TextSize = 12
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.TextXAlignment = Enum.TextXAlignment.Center
title.ZIndex = 2

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, -12, 0, 22)
status.Position = UDim2.fromOffset(6, 20)
status.BackgroundTransparency = 1
status.Text = "❗ Waiting for Steal ❗"
status.Font = Enum.Font.GothamBold
status.TextSize = 7
status.TextColor3 = Color3.fromRGB(220, 220, 220)
status.TextXAlignment = Enum.TextXAlignment.Center
status.ZIndex = 2

task.spawn(function()
	while true do
		TweenService:Create(status, TweenInfo.new(1.2), {TextTransparency = 0.4}):Play()
		task.wait(1.2)
		TweenService:Create(status, TweenInfo.new(1.2), {TextTransparency = 0}):Play()
		task.wait(1.2)
	end
end)

local function makeButton(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.new(1, -24, 0, 36)
	b.Position = UDim2.fromOffset(12, y)
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.BackgroundTransparency = 0.05
	b.Text = text
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.TextColor3 = Color3.fromRGB(230, 230, 230)
	b.AutoButtonColor = false
	b.ZIndex = 2
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

	b.MouseEnter:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
	end)
	b.MouseLeave:Connect(function()
		TweenService:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.05}):Play()
	end)

	return b
end

local btn1 = makeButton("Set Position", 40)
local btnNoWalk = makeButton("No Walk: OFF", 80)
local btnDesync = makeButton("Activate", 120)

local function pressAnim(button)
	local origSize = button.Size
	local origPos = button.Position

	TweenService:Create(button, TweenInfo.new(0.08), {
		Size = UDim2.new(origSize.X.Scale, origSize.X.Offset - 4, origSize.Y.Scale, origSize.Y.Offset - 3),
		Position = UDim2.new(origPos.X.Scale, origPos.X.Offset + 2, origPos.Y.Scale, origPos.Y.Offset + 1)
	}):Play()

	task.wait(0.08)

	TweenService:Create(button, TweenInfo.new(0.12), {
		Size = origSize,
		Position = origPos
	}):Play()
end

local function createBeam(position, color, index)
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local part = Instance.new("Part", workspace)
	part.Size = Vector3.new(1, 1, 1)
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = 1
	part.CFrame = CFrame.new(position)

	local a0 = Instance.new("Attachment", part)
	local a1 = Instance.new("Attachment", char.HumanoidRootPart)

	local beam = Instance.new("Beam", workspace)
	beam.Attachment0 = a0
	beam.Attachment1 = a1
	beam.Width0 = 0.12
	beam.Width1 = 0.12
	beam.FaceCamera = true
	beam.Color = ColorSequence.new(color)

	if index == 1 then
		if beam1 then beam1:Destroy() end
		if part1 then part1:Destroy() end
		beam1, part1 = beam, part
	else
		if beam2 then beam2:Destroy() end
		if part2 then part2:Destroy() end
		beam2, part2 = beam, part
	end
end

local function EnableNoWalk()
	local Character = player.Character
	if not Character then return end
	
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	if not Humanoid then return end
	
	local Animate = Character:FindFirstChild("Animate")
	if Animate then
		Animate.Disabled = true
	end
	
	for _, track in pairs(Humanoid:GetPlayingAnimationTracks()) do
		track:Stop()
	end
	
	btnNoWalk.Text = "No Walk: ON"
	btnNoWalk.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
end

local function DisableNoWalk()
	local Character = player.Character
	if not Character then return end
	
	local Animate = Character:FindFirstChild("Animate")
	if Animate then
		Animate.Disabled = false
	end
	
	btnNoWalk.Text = "No Walk: OFF"
	btnNoWalk.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end

btn1.MouseButton1Click:Connect(function()
	pressAnim(btn1)
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		pos1 = hrp.CFrame
		createBeam(pos1.Position, Color3.fromRGB(0, 170, 255), 1)
		createPositionMarker(hrp.Position)
	end
end)

btnNoWalk.MouseButton1Click:Connect(function()
	pressAnim(btnNoWalk)
	noWalkEnabled = not noWalkEnabled
	
	if noWalkEnabled then
		EnableNoWalk()
	else
		DisableNoWalk()
	end
end)

local function animateDots(button)
	isActivating = true
	task.spawn(function()
		local dots = {".", "..", "..."}
		local index = 1
		while isActivating do
			button.Text = "Activating" .. dots[index]
			index = index + 1
			if index > 3 then index = 1 end
			task.wait(0.4)
		end
	end)
end

btnDesync.MouseButton1Click:Connect(function()
	pressAnim(btnDesync)
	desyncActive = not desyncActive
	
	if desyncActive then
		applyFFlags(FFlags)
		if firstActivation then
			animateDots(btnDesync)
			respawn(player)
			task.wait(3)
			isActivating = false
			firstActivation = false
		end
		btnDesync.Text = "Desync: ON"
		btnDesync.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
	else
		applyFFlags(defaultFFlags)
		btnDesync.Text = "Desync: OFF"
		btnDesync.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	end
end)

task.spawn(function()
	while true do
		task.wait(1)
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local closestDist = math.huge
			local closestPos = nil
			for _, v in ipairs(targetPositions) do
				local dist = (hrp.Position - v).Magnitude
				if dist < closestDist then
					closestDist = dist
					closestPos = v
				end
			end
			if closestPos then
				pos2 = CFrame.new(closestPos)
				createBeam(pos2.Position, Color3.fromRGB(255,140,0), 2)
			end
		end
	end
end)

ProximityPromptService.PromptButtonHoldEnded:Connect(function(prompt, who)
	if who ~= player then return end
	if prompt.Name ~= "Steal" and prompt.ActionText ~= "Steal" then return end

	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		local carpet = backpack:FindFirstChild("Flying Carpet")
		if carpet and player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid:EquipTool(carpet)
		end
	end

	if pos1 then hrp.CFrame = pos1 end
	if pos2 then task.wait(0.0853); hrp.CFrame = pos2 end
end)

player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if noWalkEnabled then
		EnableNoWalk()
	end
	
	local hrp = char:WaitForChild("HumanoidRootPart")
	task.wait(0.5)
	spawnPosition = hrp.Position
	print("Spawn position updated:", spawnPosition)
end)

local discord = Instance.new("TextLabel", frame)
discord.Size = UDim2.new(1, 0, 0, 16)
discord.Position = UDim2.fromOffset(0, 160)
discord.BackgroundTransparency = 1
discord.Text = "♥ Zener2000 ♥"
discord.Font = Enum.Font.GothamBold
discord.TextSize = 13
discord.TextXAlignment = Enum.TextXAlignment.Center
discord.TextColor3 = Color3.fromRGB(180, 180, 180)
discord.ZIndex = 2

local h = 0
RunService.RenderStepped:Connect(function(dt)
	h = (h + dt * 0.3) % 1
	discord.TextColor3 = Color3.fromHSV(h, 1, 1)
end)
