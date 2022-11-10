local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Syed-gh/scripts/main/test.lua'))()
local UIS = game:GetService("UserInputService")
local Window = Library:Window({Name = "ESDRP", ScriptName = "Admin", Creator = "Edd_E & Rylock", Hotkey = {"Semicolon", false}})
local Tab = Window:AddTab("Local")

local Sect = Tab:AddSection("World")

local bypass = false
local running = true
local deleteconnection
local tpconnection
local tog1 = false

--Sect:AddLabel("World")
Sect:AddToggle({
	Text = "DISABLE NLR",
	Callback = function(v)
		tog1 = v
	end    
})
local dbTog = false
Sect:AddToggle({
	Text = "BYPASS DEATHBARRIER",
	Callback = function(v)
		dbTog = v
	end    
})
local dn = game.Players.LocalPlayer.Character.HumanoidRootPart.Size
local tog2 = false
Sect:AddToggle({
	Text = "HITBOX EXPANDER",
	Default = false,
	Callback = function(Value)
		tog2 = Value
	end
})
local tog3
local tog4
Sect:AddToggle({
	Text = "PLAYER ESP",
	Default = false,
	Callback = function(Value)
		tog3 = Value
		for _, v in pairs(game:GetService("Players"):GetChildren()) do
			PlayerESP(v)
		end
	end
})
Sect:AddToggle({
	Text = "PRINTER ESP",
	Default = false,
	Callback = function(Value)
		tog4 = Value
		for _, v in pairs(game.Workspace:FindFirstChild("MoneyPrinters"):GetChildren()) do
			PrinterESP(v)
		end
	end
})


local tpsect = Tab:AddSection("Teleports")
local tps={}
local dd
Sect:AddTextBox({
	Text = "Save teleport location",
	Default = "Name?",
	Callback = function(v)
		if v == "" or v == "Name?" then v = #tps+1 end
		if tps[v] then Library:Notification({Content = "This teleport name already exists"}) return end
		tps[v] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		dd:Refresh({v},false)
		Library:Notification({Title = "Teleports", Content = "Your teleport is saved as '"..v.."'"})
	end
})
dd = tpsect:AddDropDown({
	Text = "Teleports",
	Default = "0",
	Options = {},
	Callback = function(Value)
		if tps[Value] then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tps[Value])
		end
	end
})

local plrsect = Tab:AddSection("Player")
plrsect:AddToggle({
	Text = "INVIS JETPACK [Y]",
	Default = false,
	Callback = function(Value)
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
	Text = "CTRL CLICK NOCLIP",
	Default = false,
	Callback = function(v)
		if not running then return end
		local Mouse = game.Players.LocalPlayer:GetMouse()
		if v then
			Mouse.TargetFilter = game.Players.LocalPlayer.Character
			deleteconnection = UIS.InputBegan:Connect(function(input)
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
	Text = "ALT CLICK TP",
	Default = false,
	Callback = function(v)
		if not running then return end
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
				if input.UserInputType == Enum.UserInputType.MouseButton1 and UIS:IsKeyDown(Enum.KeyCode.LeftAlt) then
					Teleport(Mouse.Hit.p)
				end
			end)
		else
			tpconnection:Disconnect()
		end
	end
})
local lpconnection
local lptog
function initlp()
	lpconnection = UIS.InputBegan:Connect(function(input)
		if UIS:IsKeyDown(Enum.KeyCode.X) then
			for _,v in pairs(game.Workspace.MoneyPrinters:GetChildren()) do
				local x = getClosestOwnedPrinter()
				if x:FindFirstChild("Main") and x:FindFirstChild("Int") and x:FindFirstChild("TrueOwner") then
					game.ReplicatedStorage.Events.ToolsEvent:FireServer(1, x)
					game.ReplicatedStorage.Events.ToolsEvent:FireServer(9, x)
				end

			end
			for _,v in pairs(game.Workspace.Entities:GetChildren()) do
				local v = GetClosestItem()
				if v:FindFirstChild("MeshPart") or v:FindFirstChild("Handle") then
					game.ReplicatedStorage.Events.ToolsEvent:FireServer(1, v)
					game.ReplicatedStorage.Events.ToolsEvent:FireServer(9, v)
				end
			end
		end
	end)

end
lptog = plrsect:AddToggle({
	Text = "INSTANT LOCKPICK",
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
					Library:Notification({Title = "Insta-Lockpick", Content = "Press X to Insta-Lockpick nearby locked entities"})
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
				Library:Notification({Title = "Insta-Lockpick", Content = "Press X to Insta-Lockpick nearby locked entities"})
			end
		else
			lpconnection = nil
		end
	end
})
local statsect = Tab:AddSection("Stats")
statsect:AddButton({
	Text = "MAX AMMO",
	Callback = function()
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
	Text = "FILL HUNGER",
	Callback = function()
		local Player = game:GetService("Players").LocalPlayer
		Player.PlayerData["Hunger"].Value = 100;
		Player.PlayerData["Hunger"].RobloxLocked = true;
	end
})
local speedbypass = false

statsect:AddSlider({
	Text = "WalkSpeed",
	Min = 0,
	Max = 100,
	Default = game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed,
	Color = Color3.fromRGB(85, 170, 255),
	Callback = function(Value)
		if not speedbypass then Library:Notification({Content = "Failed to bypass property = 'WalkSpeed'"}) return end
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end
})
local misc = Tab:AddSection("Misc")
misc:AddButton({
	Text = "Enter Car",
	Callback = function()
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
	Text = "Store backpack",
	Callback = function()


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
	Text = "Fix Backpack",
	Callback = function()
		local StarterGui = game:GetService("StarterGui")

		local success, errors = pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
		end)
		if not success then
			print(errors)
		end
	end
})

misc:AddButton({
	Text = "Delete Interface",
	Callback = function()
		running = false
		deleteconnection = nil
		tpconnection = nil
		Library:Destroy()
		game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception:Destroy()
		game.Players.LocalPlayer.PlayerGui.PrintersPerception:Destroy()
	end
})
local Tab2 = Window:AddTab("Farming")
local sect2 = Tab2:AddSection("Farming")
local nodePos = nil
local autoprinting = false
sect2:AddButton({
	Text = "Save my current position as printing farm position",
	Callback = function()
		nodePos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		Library:Notification({Title = "Auto-Printer", Content = "Your position is now set for printer farm"})
		print(nodePos)
	end
})
sect2:AddToggle({
	Text = "Auto-Printing",
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
	Text = "Auto-Aureus",
	Default = false,
	Callback = function(Bool)
		autoscav = Bool
	end
})
--[[sect2:AddTextBox({
	Text = "Auto-Printer calculator",
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
local prints = Tab2:AddSection("Teleport to active printers")
local btns = {}
function addprinter(x, y)
	if not running then return end
	if x:FindFirstChild("Main") and x:FindFirstChild("Int") and x:FindFirstChild("TrueOwner") then
		local but = prints:AddButton({
			Text = tostring(x.TrueOwner.Value) .. "'s printer, $" .. x.Int.Money.Value,
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

local Tab3 = Window:AddTab("Loot")
local sect3 = Tab3:AddSection("Teleport to active Loot")
local btns2 = {}
function refreshent()
	if not running then return end
	for i,v in pairs(btns2) do
		v:Destroy()
	end
	local mps = game.Workspace.Entities
	for i, v in pairs(mps:GetChildren()) do
		if v:FindFirstChild("MeshPart") or v:FindFirstChild("Handle") then
			local text = 'nil'
			pcall(function()
				if v:FindFirstChild("TrueOwner") and v.Int.Uses.Value > 0 and v:FindFirstChild("Int") then
					text = tostring(v.TrueOwner.Value) .. "'s " .. v.Name
					local but = sect3:AddButton({
						Text = text,
						Callback = function()
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(v.MeshPart.Position)
						end
					})
					table.insert(btns2, but)
				end
			end)
			pcall(function()
				if v:FindFirstChild("ToolOwner") and v:FindFirstChild("Int") then
					text = tostring(v.ToolOwner.Value) .. "'s " .. v.Int.Value
					local but = sect3:AddButton({
						Text = text,
						Callback = function()
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(v.Handle.Position)
						end
					})
					table.insert(btns2, but)
				end
			end)

		end
	end

end

refreshent()
game.Workspace.Entities.ChildAdded:Connect(refreshent)
game.Workspace.Entities.ChildRemoved:Connect(refreshent)

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
			game.Players.LocalPlayer.PlayerGui.LocalPlayerPerception:FindFirstChild(player.Name).Adornee = player.Character.HumanoidRootPart
		end)

	else
		warn(e)
	end
end

local Tab4 = Window:AddTab("Players")
local sect4 = Tab4:AddSection("Players")
local btns3 = {}
local specTog = false
function refreshplrs(new)
	if not running then return end
	PlayerESP(new)
	if btns3[new.Name] then btns3[new.Name]:Destroy() return end
	local Dropdown = sect4:AddDropDown({
		Text = new.Name,
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
		if tog2 then
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
		refreshent()
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
speedbypass = false
