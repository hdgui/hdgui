local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "HD-GUI",
	Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
	LoadingTitle = "HD-GUI",
	LoadingSubtitle = "by david, made with rayfield",
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

	KeySystem = false, -- Set this to true to use our key system
	KeySettings = {
		Title = "Untitled",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
		FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
		SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
		GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
		Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
	}
})

local MovementTab = Window:CreateTab("Movement", 0) -- Title, Image
local MovementCharacterSection = MovementTab:CreateSection("Character")

local WalkSpeedInput = MovementTab:CreateInput({
	Name = "WalkSpeed",
	CurrentValue = "16",
	PlaceholderText = "16",
	RemoveTextAfterFocusLost = false,
	Flag = "WalkSpeedInput",
	Callback = function(Text)
		-- The function that takes place when the input is changed
		-- The variable (Text) is a string for the value in the text box
		game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed = Text
	end,
})

local JumpPowerInput = MovementTab:CreateInput({
	Name = "JumpPower",
	CurrentValue = "50",
	PlaceholderText = "50",
	RemoveTextAfterFocusLost = false,
	Flag = "JumpPowerInput",
	Callback = function(Text)
		-- The function that takes place when the input is changed
		-- The variable (Text) is a string for the value in the text box
		game:GetService("Players").LocalPlayer.Character.Humanoid.JumpPower = Text
	end,
})

local GravityInput = MovementTab:CreateInput({
	Name = "Gravity",
	CurrentValue = "196.2",
	PlaceholderText = "196.2",
	RemoveTextAfterFocusLost = false,
	Flag = "GravityInput",
	Callback = function(Text)
		-- The function that takes place when the input is changed
		-- The variable (Text) is a string for the value in the text box
		game:GetService("Workspace").Gravity = Text
	end,
})

local MovementModificationsSection = MovementTab:CreateSection("Modifications")

local InfiniteJumpToggle = MovementTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
	Flag = "InfiniteJumpToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		-- The function that takes place when the toggle is pressed
		-- The variable (Value) is a boolean on whether the toggle is true or false

		if Value == true then
			if _G.infinJumpStarted == nil then
				--Ensures this only runs once to save resources
				_G.infinJumpStarted = true

				--The actual infinite jump
				local plr = game:GetService('Players').LocalPlayer
				local m = plr:GetMouse()
				m.KeyDown:connect(function(k)
					if _G.infinjump then
						if k:byte() == 32 then
							humanoid = game:GetService'Players'.LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
							humanoid:ChangeState('Jumping')
							wait()
							humanoid:ChangeState('Seated')
						end
					end
				end)
			end
		else
			
		end
	end,
})

local SpinToggle = MovementTab:CreateToggle({
	Name = "Spin",
	CurrentValue = false,
	Flag = "SpinToggle", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
	Callback = function(Value)
		-- The function that takes place when the toggle is pressed
		-- The variable (Value) is a boolean on whether the toggle is true or false
		power = 5000 -- change this to make it more or less powerful
		
		local thrust = Instance.new("BodyThrust")
		thrust.Parent = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
		thrust.Force = Vector3.new(power,0,power)
		thrust.Location = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position
		
		--[[game:GetService('RunService').Stepped:connect(function()
			game.Players.LocalPlayer.Character.Head.CanCollide = false
			game.Players.LocalPlayer.Character.UpperTorso.CanCollide = false
			game.Players.LocalPlayer.Character.LowerTorso.CanCollide = false
			game.Players.LocalPlayer.Character.HumanoidRootPart.CanCollide = false
		end)
		wait(.1)]]--
		
		if Value == true then
			thrust.Force = Vector3.new(power,0,power)
		else
			thrust.Force = Vector3.new(0,0,0)
		end
	end,
})
