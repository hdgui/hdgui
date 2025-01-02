local din = "314"

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

local Paragraph = WelcomeTab:CreateParagraph({Title = "Thank you for using HD-GUI!", Content = "Thanks for using HD-GUI! If you know what you are doing, feel free to skip this note. Everything should work in all games, but if something doesn’t, feel free to let us know on our Discord server (which currently does not exist). Since this GUI is made with Rayfield, you can click the settings icon in the top-right corner to change the key that opens and closes the GUI. HD-GUI is not responsible for any in-game or platform bans. If you’re reckless enough to use this on your main account and get banned, that’s entirely on you. Use an alternative account or face the consequences. Proudly made with Rayfield."})

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

_G.SetSpeedFly

local FlySpeedInput = MovementTab:CreateInput({
	Name = "Fly Speed",
	CurrentValue = "100",
	PlaceholderText = "100",
	RemoveTextAfterFocusLost = false,
	Flag = "FlySpeedInput",
	Callback = function(Text)
		-- The function that takes place when the input is changed
		-- The variable (Text) is a string for the value in the text box
		local flyspeed = tonumber(Text)
		_G.SetSpeedFly = flyspeed
	end,
})

local FlyKeybind = MovementTab:CreateKeybind({
	Name = "Fly",
	CurrentKeybind = "F",
	HoldToInteract = false,
	Flag = "FlyKeybind", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Keybind)
		-- The function that takes place when the keybind is pressed
		-- The variable (Keybind) is a boolean for whether the keybind is being held or not (HoldToInteract needs to be true)
		_G.FlyKeybind = Keybind
	end,
})

local FlyToggle = MovementTab:CreateToggle({
	Name = "Fly",
	CurrentValue = false,
	Flag = "FlyToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		-- The function that takes place when the toggle is pressed
		-- The variable (Value) is a boolean on whether the toggle is true or false
		local flyspeed = Value
		_G.StartFly = Value
		if _G.StartFly == false then
			if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
				game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler:Destroy()
				game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler:Destroy()
				game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
			end
		end
		while _G.StartFly do
			uis.InputBegan:Connect(function(input)
				if input.KeyCode == Enum.KeyCode[string.upper(input)] then
					if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") then
						game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.MaxForce = Vector3.new(9e9,9e9,9e9)
						game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.MaxTorque = Vector3.new(9e9,9e9,9e9)
						game.Players.LocalPlayer.Character.Humanoid.PlatformStand = true
						game.Players.LocalPlayer.Character.HumanoidRootPart.GyroHandler.CFrame = workspace.CurrentCamera.CoordinateFrame
						game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = Vector3.new()
						if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X > 0 then
							game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X * _G.SetSpeedFly)
						end
						if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X < 0 then
							game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity + game.Workspace.CurrentCamera.CFrame.RightVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().X * _G.SetSpeedFly)
						end
						if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z > 0 then
							game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z * _G.SetSpeedFly)
						end
						if require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z < 0 then
							game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity = game.Players.LocalPlayer.Character.HumanoidRootPart.VelocityHandler.Velocity - game.Workspace.CurrentCamera.CFrame.LookVector * (require(game.Players.LocalPlayer.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule")):GetMoveVector().Z * _G.SetSpeedFly)
						end
					elseif game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and game.Players.LocalPlayer.Character.Humanoid.RootPart and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("VelocityHandler") == nil and game.Players.LocalPlayer.Character.HumanoidRootPart:FindFirstChild("GyroHandler") == nil then
						local bv = Instance.new("BodyVelocity")
						local bg = Instance.new("BodyGyro")

						bv.Name = "VelocityHandler"
						bv.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
						bv.MaxForce = Vector3.new(0,0,0)
						bv.Velocity = Vector3.new(0,0,0)

						bg.Name = "GyroHandler"
						bg.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
						bg.MaxTorque = Vector3.new(0,0,0)
						bg.P = 1000
						bg.D = 50
					end
				end
			end)
			task.wait()
		end
	end,
})

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
