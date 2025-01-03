local din = "pee"

local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")
local camera = game.Workspace.CurrentCamera
local mouse = player:GetMouse()

function getRoot(char)
	local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
	return rootPart
end

-- Listen for character respawns to update references
player.CharacterAdded:Connect(function(char)
	character = char
	hrp = character:WaitForChild("HumanoidRootPart")
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "HD-GUI (din:"..din..")",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "HD-GUI",
	LoadingSubtitle = "Loading HD-GUI... (din:"..din..")",
	Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil, -- Create a custom folder for your hub/game
		FileName = "HD-GUI"
	},

	Discord = {
		Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
		Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
		RememberJoins = true -- Set this to false to make them join the discord every time they load it up
	},

	KeySystem = true, -- Set this to true to use our key system
	KeySettings = {
		Title = "HD-GUI Key",
		Subtitle = "Please enter the key.",
		Note = "Join our Discord to obtain the key.", -- Use this to tell the user how to get a key
		FileName = "HD-GUIKey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"devkey"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})

local WelcomeTab = Window:CreateTab("Welcome", 0) -- Title, Image
local WelcomeNoteSection = WelcomeTab:CreateSection("Notes")

local Paragraph = WelcomeTab:CreateParagraph({Title = "Thank you for using HD-GUI!", Content = "Thanks for using HD-GUI! If you know what you are doing, feel free to skip this note. Everything should work in all games, but if something doesn’t, feel free to let us know on our Discord server (which currently does not exist). Since this GUI is made with Rayfield, you can click the settings icon in the top-right corner to change the key that opens and closes the GUI. <b>HD-GUI is not responsible for any in-game or platform bans. If you’re reckless enough to use this on your main account and get banned, that’s entirely on you. Use an alternative account or face the consequences.</b> Proudly made with Rayfield."})

local MovementTab = Window:CreateTab("Movement", 0) -- Title, Image
local MovementCharacterSection = MovementTab:CreateSection("Character")

local WalkSpeedInput = MovementTab:CreateInput({
	Name = "WalkSpeed",
	CurrentValue = "16",
	PlaceholderText = "16",
	RemoveTextAfterFocusLost = false,
	Flag = "WalkSpeedInput",
	Callback = function(Text)
		local speed = tonumber(Text)
		if speed then
			character.Humanoid.WalkSpeed = speed
		else
			Rayfield:Notify({
				Title = "Invalid Input",
				Content = "Please enter a number.",
				Duration = 6.5,
				Image = 0,
			})
		end
	end,
})

local JumpPowerInput = MovementTab:CreateInput({
	Name = "JumpPower",
	CurrentValue = "50",
	PlaceholderText = "50",
	RemoveTextAfterFocusLost = false,
	Flag = "JumpPowerInput",
	Callback = function(Text)
		local jump = tonumber(Text)
		if jump then
			character.Humanoid.JumpPower = jump
		else
			Rayfield:Notify({
				Title = "Invalid Input",
				Content = "Please enter a number.",
				Duration = 6.5,
				Image = 0,
			})
		end
	end,
})

local GravityInput = MovementTab:CreateInput({
	Name = "Gravity",
	CurrentValue = "196.2",
	PlaceholderText = "196.2",
	RemoveTextAfterFocusLost = false,
	Flag = "GravityInput",
	Callback = function(Text)
		local gravity = tonumber(Text)
		if gravity then
			workspace.Gravity = gravity
		else
			Rayfield:Notify({
				Title = "Invalid Input",
				Content = "Please enter a number.",
				Duration = 6.5,
				Image = 0,
			})
		end
	end,
})

local MovementModificationsSection = MovementTab:CreateSection("Modifications")

-- Declare jumpConnection outside the callback to maintain its state
local infJump
infJumpDebounce = false

local InfiniteJumpToggle = MovementTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "InfiniteJumpToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		if Value then
			-- Connect the JumpRequest event and store the connection
			if infJump then infJump:Disconnect() end
			infJumpDebounce = false
			infJump = uis.JumpRequest:Connect(function()
				if not infJumpDebounce then
					infJumpDebounce = true
					player.Character:FindFirstChildWhichIsA("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
					wait()
					infJumpDebounce = false
				end
			end)
		else
			-- Disconnect the JumpRequest connection when toggled off
			if infJump then infJump:Disconnect() end
			infJumpDebounce = false
		end
	end,
})

-- Handling character respawn while Infinite Jump is enabled
--[[player.CharacterAdded:Connect(function(char)
	character = char
	hrp = character:WaitForChild("HumanoidRootPart")
	if InfiniteJumpToggle:Get() then
		-- Re-establish the connection if the toggle is on
		if not jumpConnection then
			jumpConnection = uis.JumpRequest:Connect(function()
				local humanoid = character:FindFirstChildOfClass("Humanoid")
				if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Jumping then
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
			end)
		end
	end
end)]]--

local SpinToggle = MovementTab:CreateToggle({
	Name = "Spin",
	CurrentValue = false,
	Flag = "SpinToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		local power = 500 -- Modify this to adjust the spin force

		if Value then
			local spinSpeed = power
			for i,v in pairs(getRoot(player.Character):GetChildren()) do
				if v.Name == "Spinning" then
					v:Destroy()
				end
			end
			local Spin = Instance.new("BodyAngularVelocity")
			Spin.Name = "Spinning"
			Spin.Parent = getRoot(player.Character)
			Spin.MaxTorque = Vector3.new(0, math.huge, 0)
			Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
		else
			for i,v in pairs(getRoot(player.Character):GetChildren()) do
				if v.Name == "Spinning" then
					v:Destroy()
				end
			end
		end
	end,
})

local MovementModificationsFlySection = MovementTab:CreateSection("Modifications - Fly")

-- Variables to track state
_G.FlySpeed = 100
_G.FlyKeybind = Enum.KeyCode.F
_G.FlyEnabled = false
local isFlying = false

-- Function to stop flying
local function stopFlying()
	if isFlying then
		isFlying = false
		local character = game.Players.LocalPlayer.Character
		if character then
			local rootPart = character:FindFirstChild("HumanoidRootPart")
			local humanoid = character:FindFirstChildOfClass("Humanoid")
			if rootPart then
				local velocityHandler = rootPart:FindFirstChild("VelocityHandler")
				local gyroHandler = rootPart:FindFirstChild("GyroHandler")
				if velocityHandler then velocityHandler:Destroy() end
				if gyroHandler then gyroHandler:Destroy() end
			end
			if humanoid then
				humanoid.PlatformStand = false
			end
		end
	end
end

-- Function to start flying
local function startFlying()
	if not _G.FlyEnabled or isFlying then return end
	isFlying = true
	local character = game.Players.LocalPlayer.Character
	if character then
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if rootPart and humanoid then
			-- Create handlers
			local velocityHandler = Instance.new("BodyVelocity", rootPart)
			local gyroHandler = Instance.new("BodyGyro", rootPart)

			velocityHandler.Name = "VelocityHandler"
			velocityHandler.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			velocityHandler.Velocity = Vector3.zero

			gyroHandler.Name = "GyroHandler"
			gyroHandler.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
			gyroHandler.P = 1000
			gyroHandler.D = 50

			humanoid.PlatformStand = true

			-- Flight loop
			while isFlying and _G.FlyEnabled do
				local moveVector = require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector()
				local camera = workspace.CurrentCamera
				gyroHandler.CFrame = camera.CFrame
				velocityHandler.Velocity = (camera.CFrame.RightVector * moveVector.X + camera.CFrame.LookVector * moveVector.Z) * _G.FlySpeed
				task.wait()
			end

			-- Cleanup if flying stops
			stopFlying()
		end
	end
end

-- Rayfield Fly Speed Input
local FlySpeedInput = MovementTab:CreateInput({
	Name = "Fly Speed",
	CurrentValue = "100",
	PlaceholderText = "100",
	RemoveTextAfterFocusLost = false,
	Flag = "FlySpeedInput",
	Callback = function(Text)
		local speed = tonumber(Text)
		if speed and speed > 0 then
			_G.FlySpeed = speed
		else
			warn("Invalid fly speed entered. Please enter a positive number.")
		end
	end,
})

-- Rayfield Keybind Input
local FlyKeybind = MovementTab:CreateKeybind({
	Name = "Fly Keybind",
	CurrentKeybind = "F",
	HoldToInteract = false,
	Flag = "FlyKeybind",
	Callback = function(Keybind)
		_G.FlyKeybind = Keybind
	end,
})

-- Rayfield Toggle for Fly
local FlyToggle = MovementTab:CreateToggle({
	Name = "Enable Fly",
	CurrentValue = false,
	Flag = "FlyToggle",
	Callback = function(Value)
		_G.FlyEnabled = Value
		if not Value then
			stopFlying()
		end
	end,
})

-- Keybind Activation Logic
uis.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == _G.FlyKeybind then
		if _G.FlyEnabled then
			if isFlying then
				stopFlying()
			else
				startFlying()
			end
		end
	end
end)

local PlayerTab = Window:CreateTab("Player", 0) -- Title, Image
local PlayerSection = PlayerTab:CreateSection("Remove")

local HDGUITab = Window:CreateTab("HD-GUI", 0) -- Title, Image
local HDGUIRemoveSection = HDGUITab:CreateSection("Remove")

local Button = HDGUITab:CreateButton({
	Name = "Remove HD-GUI",
	Callback = function()
		-- The function that takes place when the button is pressed
		Rayfield:Destroy()
	end,
})
