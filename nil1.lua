_G.loadmap = true
function loadmap(x)
	if not _G.loadmap then return end
	x:Notification({Title = "Loading", Content = "Streaming is Enabled, Map is being loaded.", Time = 60})
	local main = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2922, 446, -2886)
	wait(2)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2724, 401, -2784)
	wait(2)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2785, 565, 2074)
	wait(2)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2555, 406, 2021)
	wait(2)
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = main
end
local running = true
local deleteconnection
local tpconnection
local lpconnection
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/Exec-UI-Library/main/src.lua'))()
local rbx_join = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/rbxscripts/main/roblox_join.lua'))()
_G.loadmap = true loadmap(Library) 
local UIS = game:GetService("UserInputService")
local Window = Library:Window({Name = "ESDRP", Script = "Admin", Creator = "Edd_E & Rylock", Hotkey = {Key = Enum.KeyCode.Semicolon, Enabled=true}, Saves = {Folder = "ES_BETA_SAVES", Enabled = true}, 
OnClose = function()
	running = false
	deleteconnection = nil
	tpconnection = nil
	lpconnection = nil
	game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception:Destroy()
	game.Players.LocalPlayer.PlayerGui.PrintersPerception:Destroy()
end,
Sounds = true
})

local Tab = Window:AddTab{Name="Local"}

local Sect = Tab:LeftSection("World")

local bypass = false

local tog1 = false

--Sect:AddLabel("World")
Sect:AddToggle({
	Name = "DISABLE NLR",
	Key = "0",
	Callback = function(v)
		tog1 = v
	end    
})
local dbTog = false
Sect:AddToggle({
	Name = "BYPASS DEATHBARRIER",
	Key = "1",
	Callback = function(v)
		dbTog = v
	end    
})
local dn = game.Players.LocalPlayer.Character.HumanoidRootPart.Size
_G.tog2 = false
Sect:AddToggle({
	Name = "HITBOX EXPANDER",
	Key = "2",
	Default = false,
	Callback = function(Value)
		_G.tog2 = Value
	end
})
local tog3
local tog4
Sect:AddToggle({
	Name = "PLAYER ESP",
	Key = "3",
	Default = false,
	Callback = function(Value)
		tog3 = Value
		for _, v in pairs(game:GetService("Players"):GetChildren()) do
			PlayerESP(v)
		end
	end
})
Sect:AddToggle({
	Name = "PRINTER ESP",
	Key = "4",
	Default = false,
	Callback = function(Value)
		tog4 = Value
		for _, v in pairs(game.Workspace:FindFirstChild("MoneyPrinters"):GetChildren()) do
			PrinterESP(v)
		end
	end
})


local tpsect = Tab:LeftSection("Teleports")
local tps={}
local dd
tpsect:AddTextBox({
	Name = "Save teleport location",
	Placeholder = "Name?",
	Callback = function(v)
		if not running then return end
		if v == "" or v == "Name?" then v = #tps+1 end
		if tps[v] then Library:Notification({Content = "This teleport name already exists"}) return end
		tps[v] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		dd:Refresh({v},false)
		Library:Notification({Title = "Teleports", Content = "Your current position for teleport is saved as '"..v.."'"})
	end
})
dd = tpsect:AddDropdown({
	Name = "Teleports",
	Placeholder = "Name..",
	Callback = function(Value)
		if not running then return end
		if tps[Value] then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tps[Value])
		end
	end
})

local plrsect = Tab:LeftSection("Player")
plrsect:AddToggle({
	Name = "INVIS JETPACK [Y]",
	Key = "5",
	Default = false,
	Callback = function(Value)
		if not running then return end
		if Value then
			local client = game:GetService("Players").LocalPlayer
			local model = Instance.new("Model")
			model.Name = "Jetpack"
			local main = Instance.new("Part")
			main.Name = "Main"
			main.Parent = model
			local str = Instance.new("StringValue")
			str.Parent = model
			str.Name = "RealValue"
			str.Value = "Static Jetpack"
			model.Parent = game:GetService("Workspace")[client.Name].Util
		else
			local client = game:GetService("Players").LocalPlayer
			game:GetService("Workspace")[client.Name].Util.Jetpack:Destroy()
		end
	end
})
local partTable = {}

plrsect:AddToggle({
	Name = "CTRL CLICK NOCLIP",
	Key = "6",
	Default = false,
	Callback = function(v)
		if not running then deleteconnection:Disconnect() return end
		local Mouse = game.Players.LocalPlayer:GetMouse()
		if v then
			Mouse.TargetFilter = game.Players.LocalPlayer.Character
			deleteconnection = UIS.InputBegan:Connect(function(input)
				if not running then deleteconnection:Disconnect() return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
					if not Mouse.Target then return end
					if Mouse.Target.ClassName == "Part" or Mouse.Target.ClassName == "MeshPart" then
						if not partTable[Mouse.Target] then
							Mouse.Target.CanCollide = false
							Mouse.Target.Transparency = 0.5
							partTable[Mouse.Target] = true
						else
							Mouse.Target.CanCollide = true
							Mouse.Target.Transparency = partTable[Mouse.Target.Transparency]
							partTable[Mouse.Target] = false
						end
					end
				end
			end)
		else
			deleteconnection:Disconnect()
		end
	end    
})
plrsect:AddToggle({
	Name = "ALT CLICK TP",
	Key = "7",
	Default = false,
	Callback = function(v)
		if not running then tpconnection:Disconnect() return end
		if v then
			local Player = game.Players.LocalPlayer
			local Mouse = Player:GetMouse()
			local function GetCharacter()
				return game.Players.LocalPlayer.Character
			end
			local function Teleport(pos)
				local Char = GetCharacter()
				if Char then
					Char:MoveTo(pos)
				end
			end
			tpconnection = UIS.InputBegan:Connect(function(input)
				if not running then tpconnection:Disconnect() return end
				if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftAlt) then
					Teleport(Mouse.Hit.p)
				end
			end)
		else
			tpconnection:Disconnect()
		end
	end
})
local lptog
function getClosestNotOwnedPrinter() -- thanks luna
	local Player = game.Players.LocalPlayer
	local Character = Player.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not (Character or HumanoidRootPart) then return end
	local TargetDistance = math.huge
	local Target
	for i,v in ipairs(game:GetService("Workspace").MoneyPrinters:GetChildren()) do
		pcall(function()
			local mesh = nil;	
			pcall(function()
				if v.PrimaryPart.Name ~= "" then
					mesh = v.PrimaryPart
				end
			end)
			pcall(function()
				if mesh == nil then
					mesh = v.PrimaryPart
				end
			end)
			if mesh then
				--if v.Int.Money.Value > 0 then
				if string.lower(tostring(v.TrueOwner.Value)) ~= tostring(string.lower(game.Players.LocalPlayer.Name)) then
					local TargetHRP = mesh
					local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
					if mag < TargetDistance then
						TargetDistance = mag
						Target = v
					end
				end
			end
		end)
	end
	return Target
end		
function initlp()
	lpconnection = UIS.InputBegan:Connect(function(input, pro)
		if not running then lpconnection:Disconnect() return end
		if pro then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local x = getClosestNotOwnedPrinter()
			local Mouse = game.Players.LocalPlayer:GetMouse()
			--if x.TrueOwner.Locked.Value == true then
			--	spawn(function()
			--		repeat
			game.ReplicatedStorage.Events.ToolsEvent:FireServer(1, Mouse.Target.Parent)
			game.ReplicatedStorage.Events.ToolsEvent:FireServer(9, Mouse.Target.Parent)
			--			wait(0.25)
			--		until x.TrueOwner.Locked.Value == false-- or retries == 5
			--	end)
			--end
			--local v = getClosestNotShipment()
			--if v.TrueOwner.Locked.Value == true then
			--	spawn(function()
			--		repeat
			--			game.ReplicatedStorage.Events.ToolsEvent:FireServer(1, v)
			--			game.ReplicatedStorage.Events.ToolsEvent:FireServer(9, v)
			--			wait(0.25)
			--		until x.TrueOwner.Locked.Value == false
			--	end)
			--end
		end
	end)

end
lptog = plrsect:AddToggle({
	Name = "INSTANT LOCKPICK",
	Key = "8",
	Default = false,
	Callback = function(v)
		--lpbool = v
		if v then
			local job = "["..game.Players.LocalPlayer.Job.Value .."]"

			if not game.Players.LocalPlayer.Character:FindFirstChild(job.." Lockpick") and not game.Players.LocalPlayer.Backpack:FindFirstChild(job.." Lockpick") then
				game:GetService("ReplicatedStorage").Events.MenuActionEvent:FireServer(49)
				wait(0.5)
				if game.Players.LocalPlayer.Backpack:FindFirstChild(job.." Lockpick") then
					local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(job.." Lockpick")
					game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
					initlp()
					Library:Notification({Title = "Insta-Lockpick", Content = "Click on printer to Insta-Lockpick"})
				else
					Library:Notification({Content = "You must wait to spawn a lockpick"})
					lptog:Set(false)
					lpconnection = nil
					return
				end

			elseif game.Players.LocalPlayer.Backpack:FindFirstChild(job.." Lockpick") then
				local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(job.." Lockpick")
				game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
				initlp()
				Library:Notification({Title = "Insta-Lockpick", Content = "Click on printer to Insta-Lockpick"})
			elseif game.Players.LocalPlayer.Character:FindFirstChild(job.." Lockpick") then
				initlp()
				Library:Notification({Title = "Insta-Lockpick", Content = "Click on printer to Insta-Lockpick"})
			end
		else
			lpconnection:Disconnect()
		end
	end
})
local statsect = Tab:RightSection("Stats")
statsect:AddButton({
	Name = "MAX AMMO",
	Callback = function()
		if not running then return end
		local Player = game:GetService("Players").LocalPlayer
		Player.PlayerData["Pistol Ammo"].Value = 300;
		Player.PlayerData["Pistol Ammo"].RobloxLocked = true;
		Player.PlayerData["SMG Ammo"].Value = 300;
		Player.PlayerData["SMG Ammo"].RobloxLocked = true;
		Player.PlayerData["Rifle Ammo"].Value = 300;
		Player.PlayerData["Rifle Ammo"].RobloxLocked = true;
		Player.PlayerData["Rifle Ammo"].Value = 300;
		Player.PlayerData["Rifle Ammo"].RobloxLocked = true;
		Player.PlayerData["Heavy Ammo"].Value = 300;
		Player.PlayerData["Heavy Ammo"].RobloxLocked = true;
	end
})
statsect:AddButton({
	Name = "FILL HUNGER",
	Callback = function()
		if not running then return end
		local Player = game:GetService("Players").LocalPlayer
		Player.PlayerData["Hunger"].Value = 100;
		Player.PlayerData["Hunger"].RobloxLocked = true;
	end
})
local speedbypass = false

statsect:AddSlider({
	Name = "[RISKY] WalkSpeed",
	Min = 0,
	Max = 100,
	Key = "9",
	Default = game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed,
	Color = Color3.fromRGB(85, 170, 255),
	Callback = function(Value)
		if not running then return end
		if not speedbypass then Library:Notification({Content = "Failed to bypass property = 'WalkSpeed'"}) return end
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end
})
local misc = Tab:RightSection("Misc")
misc:AddButton({
	Name = "Enter Car",
	Callback = function()
		if not running then return end
		local function GetClosestVehicle()
			local Player = game.Players.LocalPlayer
			local Character = Player.Character
			local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
			if not (Character or HumanoidRootPart) then return end
			local TargetDistance = math.huge
			local Target
			for i,v in ipairs(game:GetService("Workspace").Vehicles:GetChildren()) do
				pcall(function()
					if v.Main then
						local TargetHRP = v.Main
						local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
						if mag < TargetDistance then
							TargetDistance = mag
							Target = v
						end
					end
				end)
			end

			return Target
		end
		game:GetService("ReplicatedStorage").Events.InteractEvent:FireServer(GetClosestVehicle().VehicleSeat);
	end
})
misc:AddButton({
	Name = "Make it Day",
	Callback = function()
		game.Lighting.Condition.Value = "Day"
		game.Lighting:SetMinutesAfterMidnight(720)
		game:GetService("Lighting").SunRays.Intensity = 0.25
		game:GetService("Lighting").SunRays.Spread = 1
		game:GetService("Lighting").Bloom.Intensity = 0.4
		game:GetService("Lighting").Sky.SkyboxBk = "rbxassetid://2677179366"
		game:GetService("Lighting").Sky.SkyboxDn = "rbxassetid://501313275"
		game:GetService("Lighting").Sky.SkyboxFt = "rbxassetid://2677179602"
		game:GetService("Lighting").Sky.SkyboxLf = "rbxassetid://2677179822"
		game:GetService("Lighting").Sky.SkyboxRt = "rbxassetid://2677179738"
		game:GetService("Lighting").Sky.SkyboxUp = "rbxassetid://247087559"
		game:GetService("Lighting").Brightness =  1.85
		game:GetService("Lighting").FogColor =  Color3.fromRGB(255, 247, 234)
		game:GetService("Lighting").OutdoorAmbient =  Color3.fromRGB(185, 178, 167)
		game:GetService("Lighting").FogEnd = 7000;
		game:GetService("Lighting").FogStart = 0;
	end
})
function GetClosestItem()
	local Player = game.Players.LocalPlayer
	local Character = Player.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not (Character or HumanoidRootPart) then return end
	local TargetDistance = math.huge
	local Target
	for i,v in ipairs(game:GetService("Workspace").Entities:GetChildren()) do
		pcall(function()
			local mesh = nil;	
			pcall(function()
				if v.ManualWeld.Name ~= "" then
					mesh = v.ManualWeld
				end
			end)
			if mesh == nil then
				mesh = v.Handle
			end
			if mesh then
				local TargetHRP = mesh
				local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
				if mag < TargetDistance then
					TargetDistance = mag
					Target = v
				end
			end
		end)
	end

	return Target
end
misc:AddButton({
	Name = "Store backpack",
	Callback = function()
		if not running then return end

		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local hum = character.Humanoid
		local rs = game:GetService("RunService")

		if hum.FloorMaterial ~= nil and hum.FloorMaterial ~= Enum.Material.Air then
			for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
				local amtInInv = tonumber(string.split(game:GetService("Players")[game.Players.LocalPlayer.Name].PlayerGui.Client.Inventory.Slots.Amt.Text, "/")[1]);
				if amtInInv >= 11 then

				else
					game.Players.LocalPlayer.Character.Humanoid:EquipTool(v)
					wait(0.1)
					game:GetService("ReplicatedStorage").Events.WeaponBackEvent:FireServer(true, v.Name)
					wait(0.1)
					game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer(1)
					wait(0.1)
					game:GetService("ReplicatedStorage").Events.WeaponBackEvent:FireServer(false, v.Name)
					wait(0.1)
					game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer(2, GetClosestItem())
					wait(0.1)
				end
			end
			wait(0.1)
			game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer(2, GetClosestItem())
			wait(0.1)
			game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer(2, GetClosestItem())
			wait(0.1)
			game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer(2, GetClosestItem())
			wait(0.1)
			game:GetService("ReplicatedStorage").Events.InventoryEvent:FireServer(2, GetClosestItem())
		else
		end
	end
})
misc:AddButton({
	Name = "Fix Backpack",
	Callback = function()
		if not running then return end
		local StarterGui = game:GetService("StarterGui")

		local success, errors = pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
		end)
		if not success then
			print(errors)
		end
	end
})

local Tab2 = Window:AddTab{Name="Farming"}
local sect2 = Tab2:LeftSection("Farming")
local nodePos = nil
local autoprinting = false
sect2:AddButton({
	Name = "Save my current position as printing farm position",
	Callback = function()
		if not running then return end
		nodePos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		Library:Notification({Title = "Auto-Printer", Content = "Your position is now set for printer farm"})
		print(nodePos)
	end
})
sect2:AddToggle({
	Name = "Auto-Printing",
	Default = false,
	Callback = function(Bool)
		if nodePos == nil then
			Library:Notification({Content = "[Auto-Printer] First set position for printer farm"})
		else
			autoprinting = Bool
		end
	end
})
local autoscav = false
sect2:AddToggle({
	Name = "Auto-Aureus",
	Default = false,
	Callback = function(Bool)
		autoscav = Bool
	end
})
--[[sect2:AddTextBox({
	Name = "Auto-Printer calculator",
	Default = "$ Target..",
	Callback = function(v)
		local Value = tonumber(v)
		if typeof(Value) == "number" then
			if Value < 14000 then Library:Notification({Content = "[Money] Number must be higher than 14000"}) return end
			local function round(num, numDecimalPlaces)
				return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
			end
			local Cost = printers*5000
			local printers = round((Value/14000), 1)
			if printers > math.floor((Value/14000)) then
				printers = math.floor(printers + 1)
			end
			local Time = math.round((printers*25/60))
			Library:Notification({Title = "Money", Content = "Farm "..Value .." in "..math.round(printers*25).." minutes or "..Time.." hours using ".."(".. (printers)..") advanced money printers, total cost : ".. Cost, Time = 10})
		end
	end
})
]]
function scavengeCycle()
	if not running then return end
	if not autoscav then return end
	pcall(function()
		if not game:GetService("Workspace").Buildings[game.Players.LocalPlayer.Name]["Scavenge Station"] then
			Library:Notification({Content = "[Auto-Aureus] Place a scavenge station in your node!"})
		else
			local scav_stat = game:GetService("Workspace").Buildings[game.Players.LocalPlayer.Name]["Scavenge Station"]
			local status = game.Players.LocalPlayer.PlayerGui.Client.Drone.Slots.Amt.Text
			if status == "Ready" then
				local Prev = game.Players.LocalPlayer.Character.HumanoidRootPart.Position;
				local Controls = require(game:GetService("Players").LocalPlayer.PlayerScripts.PlayerModule):GetControls()
				Controls:Disable()
				pcall(function()

					local Next = scav_stat.Union.Position
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Next)
					wait(1)
					game:GetService("ReplicatedStorage").Events.InteractEvent:FireServer(scav_stat)
					wait(1)
					game:GetService("ReplicatedStorage").Events.MenuAcitonEvent:FireServer(1, scav_stat)
					Next = game:GetService("Workspace").DroneShipment.MeshPart.Position
					wait(1)
					game:GetService("Workspace").Drones[game.Players.LocalPlayer.Name].Hull.CFrame = CFrame.new(Next)
					wait(1)
					game:GetService("ReplicatedStorage").Events.MenuAcitonEvent:FireServer(3)
					wait(1);
					game:GetService("Workspace").Drones[game.Players.LocalPlayer.Name].Hull.CFrame = game:GetService("Workspace").Buildings[game.Players.LocalPlayer.Name]["Scavenge Station"].Union.CFrame;
					wait(1);
					game:GetService("ReplicatedStorage").Events.MenuAcitonEvent:FireServer(4)
					wait();
					game:GetService("ReplicatedStorage").Events.InteractEvent:FireServer(scav_stat)
				end)
				wait(1)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Prev)
				wait(1)
				Controls:Enable()
				game:GetService("ReplicatedStorage").Events.ScavengeFunction:InvokeServer("Old-World Crate");
			end
		end
	end)
end
function getClosestOwnedPrinter() -- thanks luna
	local Player = game.Players.LocalPlayer
	local Character = Player.Character
	local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")
	if not (Character or HumanoidRootPart) then return end
	local TargetDistance = math.huge
	local Target
	for i,v in ipairs(game:GetService("Workspace").MoneyPrinters:GetChildren()) do
		pcall(function()
			local mesh = nil;	
			pcall(function()
				if v.PrimaryPart.Name ~= "" then
					mesh = v.PrimaryPart
				end
			end)
			pcall(function()
				if mesh == nil then
					mesh = v.PrimaryPart
				end
			end)
			if mesh then
				--if v.Int.Money.Value > 0 then
				if string.lower(tostring(v.TrueOwner.Value)) == tostring(string.lower(game.Players.LocalPlayer.Name)) then
					local TargetHRP = mesh
					local mag = (HumanoidRootPart.Position - TargetHRP.Position).magnitude
					if mag < TargetDistance then
						TargetDistance = mag
						Target = v
					end
				end
			end
		end)
	end
	return Target
end
local ownedPrinters = 0
function printerCycle()
	if not running then return end
	if autoprinting then
		pcall(function()
			ownedPrinters = 0
			for i,v in pairs(game:GetService("Workspace").MoneyPrinters:GetChildren()) do
				if tostring(v.TrueOwner.Value) == game.Players.LocalPlayer.Name then
					ownedPrinters = ownedPrinters + 1;
				end
			end
			if ownedPrinters >= 2 then
			else
				pcall(function()
					if workspace.Buildings[game.Players.LocalPlayer.Name].Node.Node then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(workspace.Buildings[game.Players.LocalPlayer.Name].Node.Node.Position) * CFrame.new(90,1,1)
						wait(2)
						game:GetService("ReplicatedStorage").Events.MenuEvent:FireServer(2, "Money Printer Advanced", nil, 8)
						wait(3)
						local v = getClosestOwnedPrinter();
						game:GetService("ReplicatedStorage").Events.PickUpEvent:FireServer(v, true)
						wait(2)
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(nodePos)
						wait(2)
						game:GetService("ReplicatedStorage").Events.PickUpEvent:FireServer(v, false)
						ownedPrinters += 1
						wait(2)
						v.Int.Money.Changed:Connect(function(val)
							print(val)
							if not running then return end
							if not autoprinting and ownedPrinters < 2 then return end

							pcall(function()
								if tonumber(v.Int.Money.Value) > 0 then
									local toPrinter = CFrame.new(v.PrimaryPart.CFrame.X, v.PrimaryPart.CFrame.Y + 3, v.PrimaryPart.CFrame.Z)
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = toPrinter
									wait(2);
									game:GetService("ReplicatedStorage").Events.InteractEvent:FireServer(v)
								end
							end)
						end)
						printerCycle()
					else
						Library:Notification({Content = "[Auto-Printer] Place a node first"})
					end
				end)
			end
		end)

	end

end

local printerespFolder = Instance.new("Folder")
printerespFolder.Parent = game.Players.LocalPlayer.PlayerGui
printerespFolder.Name = "PrintersPerception"
local function AddPrinterGui(printer)
	local temp = Instance.new("BillboardGui")
	temp.Parent = printerespFolder
	temp.AlwaysOnTop = true
	temp.Size = UDim2.new(4.5,0,5,0)
	temp.StudsOffset = Vector3.new(0,0,0)
	temp.Name = printer.Name
	temp.Adornee = printer.Main
	local highlightframe = Instance.new("Frame")
	highlightframe.Parent = temp
	highlightframe.AnchorPoint = Vector2.new(0,1)
	highlightframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	highlightframe.BackgroundTransparency = 0.75
	highlightframe.BorderSizePixel = 0
	highlightframe.Position = UDim2.new(0,0,1,0)
	highlightframe.Size = UDim2.new(1,0,0.8,0)
	highlightframe.Visible = false
	local stroke1 = Instance.new("UIStroke")
	stroke1.Parent = highlightframe
	stroke1.Thickness = 3
	stroke1.Transparency = 0.65
	stroke1.Color = Color3.fromRGB(155,155,155)
	local dataframe = Instance.new("Frame")
	dataframe.Parent = temp
	dataframe.AnchorPoint = Vector2.new(0.5,0.5)
	dataframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dataframe.BackgroundTransparency = 1
	dataframe.Position = UDim2.new(0.5,0,0.1,0)
	dataframe.Size = UDim2.new(0,100,0,35)
	local nametag = Instance.new("TextButton")
	nametag.Parent = dataframe
	nametag.Text = printer.Name
	nametag.BackgroundTransparency = 1
	nametag.Size = UDim2.new(1,0,0.5,0)
	nametag.Font = Enum.Font.GothamMedium
	nametag.TextSize = 14
	nametag.TextColor3 = Color3.fromRGB(0, 255, 127)
	local stroke2 = Instance.new("UIStroke")
	stroke2.Parent = nametag
	stroke2.Thickness = 2
	stroke2.Transparency = 0.65
	stroke2.Color = Color3.fromRGB(0, 195, 94)
	local datatag = Instance.new("TextButton")
	datatag.Parent = dataframe
	datatag.AnchorPoint = Vector2.new(0.5,0)
	local txt =  "$" .. 0
	datatag.Text = txt
	datatag.BackgroundTransparency = 1
	datatag.Position = UDim2.new(0.5,0,0.5,0)
	datatag.Size = UDim2.new(1,0,0.5,0)
	datatag.Font = Enum.Font.GothamMedium
	datatag.TextScaled = true
	datatag.TextColor3 = Color3.fromRGB(0, 255, 127)
	local stroke3 = Instance.new("UIStroke")
	stroke3.Parent = datatag
	stroke3.Thickness = 2
	stroke3.Transparency = 0.65
	stroke3.Color = Color3.fromRGB(0, 195, 94)

	local function updatedataTag()
		repeat wait() until printer:FindFirstChild("Int") and printer.Int:FindFirstChild("Money")
		datatag.Text = "$" .. printer.Int.Money.Value
	end

	spawn(function()
		while wait(0.1) do
			updatedataTag()
		end
	end)
	return temp
end

local bills = {}

function PrinterESP(x)
	if not running then return end
	if not tog4 then -- disabled printeresp check
		for _, v in pairs(bills) do
			if bills[x] then bills[x]:Destroy() return end
		end
		return 
	end
	--
	if x:FindFirstChild("Main") and x:FindFirstChild("Int") and x:FindFirstChild("TrueOwner") then
		repeat wait() until x:FindFirstChild("Int") and x.Int:FindFirstChild("Money")
		local bill = AddPrinterGui(x)
		bills[x] = bill
	end
end
function DelPrinterESP(x)
	if bills[x] then bills[x]:Destroy() return end
end
local prints = Tab2:RightSection("Teleport to active printers")
local btns = {}
function addprinter(x, y)
	if not running then return end
	if x:FindFirstChild("Main") and x:FindFirstChild("Int") and x:FindFirstChild("TrueOwner") then
		local but = prints:AddButton({
			Name = tostring(x.TrueOwner.Value) .. "'s printer, $" .. x.Int.Money.Value,
			Callback = function()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(x.Main.Position)
			end
		})
		btns[x] = but
		repeat wait() until x:FindFirstChild("Int") and x.Int:FindFirstChild("Money")
		x.Int.Money.Changed:Connect(function(val)
			but.Text(tostring(x.TrueOwner.Value) .. "'s printer, $" .. x.Int.Money.Value)
		end)
	end
end
function delprinter(x, y)
	if btns[x] then btns[x]:Destroy() return end
end
for _, v in pairs(game:GetService("Workspace").MoneyPrinters:GetChildren()) do
	addprinter(v, nil)
end
game.Workspace.MoneyPrinters.ChildAdded:Connect(function(x)
	repeat wait() until x:FindFirstChild("TrueOwner")
	if x:FindFirstChild("TrueOwner") then
		local s, e = pcall(function()
			return x.TrueOwner
		end)
		if s then
			addprinter(x, nil)
			PrinterESP(x)
		else
			wait(3)
			warn("Retry attempt: " .. x.Name)
			addprinter(x, nil)
		end
	end
end)
game.Workspace.MoneyPrinters.ChildRemoved:Connect(function(x)
	delprinter(x, nil)
	DelPrinterESP(x)
end)

local Tab3 = Window:AddTab({Name="Loot"})
local sect3 = Tab3:LeftSection("Teleport to active Loot")
local btns2 = {}


function addent(x, y)
	if not running then return end
	if x:FindFirstChild("MeshPart") or x:FindFirstChild("Handle") then

		local text = 'nil'
		pcall(function()
			if x:FindFirstChild("TrueOwner") and x.Int.Uses.Value > 0 and x:FindFirstChild("Int") then
				text = tostring(x.TrueOwner.Value) .. "'s " .. x.Name
				local but = sect3:AddButton({
					Name = text,
					Callback = function()
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(x.MeshPart.Position)
					end
				})
				btns2[x] = but
			end
		end)
		pcall(function()
			if x:FindFirstChild("ToolOwner") and x:FindFirstChild("Int") then
				text = tostring(x.ToolOwner.Value) .. "'s " .. x.Int.Value
				local but = sect3:AddButton({
					Name = text,
					Callback = function()
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(x.Handle.Position)
					end
				})
				btns2[x] = but
			end
		end)
	end
end
function delent(x, y)
	if btns2[x] then btns2[x]:Destroy() return end
end
for _, v in pairs(game:GetService("Workspace").Entities:GetChildren()) do
	addent(v, nil)
end
game.Workspace.Entities.ChildAdded:Connect(function(x)
	repeat wait() until x:FindFirstChild("TrueOwner") or x:FindFirstChild("ToolOwner")
	if x:FindFirstChild("TrueOwner") or x:FindFirstChild("ToolOwner") then
		local s, e = pcall(function()
			return x.TrueOwner
		end)
		if s then
			addent(x, nil)
		else
			wait(3)
			warn("Retry attempt: " .. x.Name)
			addent(x, nil)
		end
	end
end)
game.Workspace.Entities.ChildRemoved:Connect(function(x)
	delent(x, nil)
end)

local plrespFolder = Instance.new("Folder")
plrespFolder.Parent = game.Players.LocalPlayer.PlayerGui
plrespFolder.Name = "LocalPlayerPerception"
local function AddGui(player)
	local temp = Instance.new("BillboardGui")
	temp.Parent = plrespFolder
	temp.AlwaysOnTop = true
	temp.Size = UDim2.new(4.5,0,7,0)
	temp.StudsOffset = Vector3.new(0,0.2,0)
	temp.Name = player.Name
	repeat wait() until player.Character
	repeat wait() until player.Character.Humanoid
	temp.Adornee = player.Character.HumanoidRootPart
	local highlightframe = Instance.new("Frame")
	highlightframe.Parent = temp
	highlightframe.AnchorPoint = Vector2.new(0,1)
	highlightframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	highlightframe.BackgroundTransparency = 0.75
	highlightframe.BorderSizePixel = 0
	highlightframe.Position = UDim2.new(0,0,1,0)
	highlightframe.Size = UDim2.new(1,0,0.8,0)
	local stroke1 = Instance.new("UIStroke")
	stroke1.Parent = highlightframe
	stroke1.Thickness = 3
	stroke1.Transparency = 0.65
	stroke1.Color = Color3.fromRGB(155,155,155)
	local dataframe = Instance.new("Frame")
	dataframe.Parent = temp
	dataframe.AnchorPoint = Vector2.new(0.5,0.5)
	dataframe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dataframe.BackgroundTransparency = 1
	dataframe.Position = UDim2.new(0.5,0,0.1,0)
	dataframe.Size = UDim2.new(0,100,0,35)
	local nametag = Instance.new("TextButton")
	nametag.Parent = dataframe
	nametag.Text = player.Name
	nametag.BackgroundTransparency = 1
	nametag.Size = UDim2.new(1,0,0.5,0)
	nametag.Font = Enum.Font.GothamMedium
	nametag.TextSize = 14
	nametag.TextColor3 = Color3.fromRGB(255,255,255)
	local stroke2 = Instance.new("UIStroke")
	stroke2.Parent = nametag
	stroke2.Thickness = 2
	stroke2.Transparency = 0.65
	stroke2.Color = Color3.fromRGB(155,155,155)
	local datatag = Instance.new("TextButton")
	datatag.Parent = dataframe
	datatag.AnchorPoint = Vector2.new(0.5,0)
	local distance = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude)
	datatag.Text = ""
	datatag.BackgroundTransparency = 1
	datatag.Position = UDim2.new(0.5,0,0.5,0)
	datatag.Size = UDim2.new(1,0,0.5,0)
	datatag.Font = Enum.Font.GothamMedium
	datatag.TextScaled = true
	datatag.TextColor3 = Color3.fromRGB(255,255,255)
	local stroke3 = Instance.new("UIStroke")
	stroke3.Parent = datatag
	stroke3.Thickness = 2
	stroke3.Transparency = 0.65
	stroke3.Color = Color3.fromRGB(155,155,155)

	local function updatedataTag()
		if player.Flagged.Value and not player:IsFriendsWith(player.UserId) then
			stroke1.Color = Color3.fromRGB(255, 0, 0)
			stroke2.Color = Color3.fromRGB(255, 0, 0)
			stroke3.Color = Color3.fromRGB(255, 0, 0)
		else
			stroke1.Color = Color3.fromRGB(155, 155, 155)
			stroke2.Color = Color3.fromRGB(155, 155, 155)
			stroke3.Color = Color3.fromRGB(155, 155, 155)
		end
		pcall(function()
			repeat wait() until player.Character
			repeat wait() until player.Character.Humanoid
			local distance = math.floor((game.Players.LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude)
			local tool = ""
			if player.Character:FindFirstChildOfClass("Tool") then
				tool = player.Character:FindFirstChildOfClass("Tool").Name
			end
			datatag.Text = "Health "..math.floor((player.Character.Humanoid.Health/player.Character.Humanoid.MaxHealth)*100) .. "%, ".. distance .. " studs, " .. tool
		end)	
	end

	spawn(function()
		while wait(0.1) do
			updatedataTag()
		end
	end)
	return temp
end

function PlayerESP(player)
	if not running then return end
	if not tog3 then
		for _, v in pairs(game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception:GetChildren()) do
			v:Destroy()
		end
		return 
	end
	if player.Name == game.Players.LocalPlayer.Name then return end
	if game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception and game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception:FindFirstChild(player.Name) then
		game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception:FindFirstChild(player.Name):Destroy()
		return
	end
	repeat wait() until player:HasAppearanceLoaded()
	local s, e = pcall(function()
		return player.Character.HumanoidRootPart
	end)
	if s then
		local tag = AddGui(player)
		player.CharacterAdded:Connect(function()
			repeat wait() until player.Character.Humanoid
			if not game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception then return end
			game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception:FindFirstChild(player.Name).Adornee = player.Character.HumanoidRootPart
		end)

	else
		warn(e)
	end
end

local Tab4 = Window:AddTab({Name="Players"})

local sect4a = Tab4:LeftSection("Game")
sect4a:AddTextBox({
	Name = "Join Player",
	Default = "UserId",
	PressEnter = true,
	Callback = function(userid)
		Library:Notification({Title = 'Join Player', Content = "Searching..."})
		local var = rbx_join.Join(userid)
		if var.Success then
			Library:Notification({Title = '<font color="rgb(85, 170, 127)">Join Player</font>', Content = var.Message})
		elseif not var.Success then
			Library:Notification({Title = '<font color="rgb(227, 67, 67)">Join Player</font>', Content = var.Message})
		end
	end
})
local plrdrop = sect4a:AddDropdown({
	Name = "Kill Player",
	Default = "",
	Options = {},
	Placeholder = "Player..",
	Callback = function(opt)
		Library:Notification({Title = "Auto-Kill", Content = "Make sure to flag up when killing a friendly"})
		local Target = game.Players[opt]--GetClosestPlayer()
		local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - Target.Character.HumanoidRootPart.Position).magnitude
		if mag < 250 then
			if game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool") and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Handle.Reload then
				repeat wait()
					game:GetService("ReplicatedStorage").Events.MenuActionEvent:FireServer(33, game:GetService("Workspace")[Target.Name].HumanoidRootPart.CFrame, 1, game:GetService("Workspace")[Target.Name].Humanoid, 100, game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool"))
				until game:GetService("Workspace")[Target.Name].Humanoid.Health == 0
			else
				Library:Notification({Title = "Auto-Kill", Content = "Equip a weapon to kill"})
			end
		else
			Library:Notification({Title = "Auto-Kill", Content = "Maximum range is 250 studs"})
		end

	end
})

local function loadplrlist()
	local ServerPlayers = {}
	for _, v in pairs(game:GetService("Players"):GetChildren()) do
		if v.Name ~= game.Players.LocalPlayer.Name then
			table.insert(ServerPlayers, v.Name)
		end
	end
	plrdrop:Refresh(ServerPlayers, true)
end
loadplrlist()

local sect4 = Tab4:RightSection("Players")
local btns3 = {}
local specTog = false
function refreshplrs(new)
	if not running then return end
	PlayerESP(new) 
	loadplrlist()
	if btns3[new.Name] then btns3[new.Name]:Destroy() return end
	local Dropdown = sect4:AddDropdown({
		Name = new.Name,
		Placeholder = "option..",
		Options = {"Teleport", "Spectate/Unspectate", "Stats"},
		Callback = function(opt)
			if opt == "Teleport" then
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(new.Character.HumanoidRootPart.Position)
			end
			if opt == "Spectate/Unspectate" then
				if not specTog then
					local PlayerToSpec = game:GetService("Players")[new.Name]
					game.Workspace.CurrentCamera.CameraSubject = PlayerToSpec.Character.Humanoid
					specTog = true
				else
					local PlayerToSpec = game:GetService("Players").LocalPlayer
					game.Workspace.CurrentCamera.CameraSubject = PlayerToSpec.Character.Humanoid
					specTog = false
				end
			end
			if opt == "Stats" then
				new = game:GetService("Players")[new.Name]
				local username = new.Name
				local Money = "$" .. new.PlayerData.Currency.Value .. ", "
				local Aureus = "A$" .. new.PlayerData.PCurrency.Value .. ", "
				local Karma = "Karma: " .. new.PlayerData.Karma.Value .. ", "
				local Playtime = "Playtime: " .. math.floor(new.PlayerData.PlayTime.Value/3600) .. " hours, "
				local Inventory = "Inventory: " .. new.PlayerData.Inventory.Value .. ". "
				local Bank = "Bank: " .. new.PlayerData.Bank.Value .. ". "
				local Flagged = "?Flagged?"
				if new.Flagged.Value then
					username = "<font color='rgb(255, 255, 127)'>"..username.."</font>"
				end
				Library:Notification({Title = "Stats", Content = username .. "'s Stats: " .. Money .. Aureus .. Karma .. Playtime .. Inventory .. Bank, Time = 10})
			end
		end
	})
	btns3[new.Name] = Dropdown
end

game.Players.ChildAdded:Connect(refreshplrs)
game.Players.ChildRemoved:Connect(refreshplrs)

for _, v in pairs(game:GetService("Players"):GetChildren()) do
	refreshplrs(v)
end

spawn(function()
	while true do
		if not running then return end
		if tog1 then
			for i, v in pairs(game.Workspace:GetChildren()) do
				if v.Name == "NL" then
					v.NL.CanCollide = false
					v.NL.Transparency = 1
					v.NL.RobloxLocked = true;
					v.NL.NL.CanCollide = false
					v.NL.NL.Transparency = 1
					v.NL.NL.RobloxLocked = true;
				end
			end
		else

		end
		if _G.tog2 then
			local Players = game.Players
			for i, v in pairs(Players:GetChildren()) do
				repeat wait() until game.Players.LocalPlayer:HasAppearanceLoaded()
				if v.Name ~= game.Players.LocalPlayer.Name then
					local s, e = pcall(function()
						return v.Character.HumanoidRootPart
					end)
					if s then
						local n = v.Character.HumanoidRootPart
						n.Transparency = 0.3
						n.CanCollide = false
						n.Size = Vector3.new(45, 45, 45)
					else
						warn(e)
					end

				end
			end
		else
			local Players = game.Players
			for i, v in pairs(Players:GetChildren()) do
				repeat wait() until game.Players.LocalPlayer:HasAppearanceLoaded()
				if v.Name ~= game.Players.LocalPlayer.Name then
					local s, e = pcall(function()
						return v.Character.HumanoidRootPart
					end)
					if s then
						local n = v.Character.HumanoidRootPart
						n.Transparency = 1
						n.CanCollide = true
						n.Size = dn
					else

					end
				end
			end	
		end
		wait(1)
	end
end)

spawn(function()
	while true do
		if not running then return end
		printerCycle()
		scavengeCycle()
		wait(5)
	end
end)
local mt = getrawmetatable(game);
local backup = mt.__namecall;
if setreadonly then setreadonly(mt, false) else make_writeable(mt, true) end

mt.__namecall = newcclosure(function(...)
	local method = getnamecallmethod()
	local args = {...}
	if method == "FindPartOnRayWithWhitelist" then
		if dbTog then
			local getScript = getfenv(2).script
			if getScript == nil then
				getScript = ""
			end
			if tostring(getScript:GetFullName()) == "game.Players.LocalPlayer.PlayerScripts.LocalScript" then
				args[2].Y = 144;
				return backup(unpack(args))
			else
				return backup(...)
			end
		else
			return backup(...)
		end
	end
	return backup(...)
end)
local mmindex = mt.__index
mt.__index = function(Instance, string)
	if string == "WalkSpeed" then
		return (1)
	end
	return mmindex(Instance, string)
end
bypass = true
speedbypass = true
