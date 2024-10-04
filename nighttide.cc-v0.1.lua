local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Kronos"))()

local window = library:Window({
    Title = "nighttide.cc",
    Accent = Color3.fromRGB(69, 69, 207),
    logo = 125737231476683,
    ToggleKey = Enum.KeyCode.RightShift
})

local tab = window:NewTab({
    Logo = 4483345998
})

local tabsection = tab:TabSection({
    Title = "Aim-Visuals"
})

local othersTab = window:NewTab({
    Title = "Others"
})

local othersSection = othersTab:TabSection({
    Title = "SOON"
})

local column = tabsection:AddColumn({
    Title = "Aim-Visuals"
})

local section = column:Section({
    Title = "Aim-Visuals"
})

local aimbotEnabled = false
local fovSize = 50
local espEnabled = false
local fovActive = false
local rightMouseHeld = false

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 2
fovCircle.Color = Color3.fromRGB(0, 255, 0)
fovCircle.Radius = fovSize

local function aimbot()
    local player = game.Players.LocalPlayer
    local camera = game.Workspace.CurrentCamera
    local mouse = player:GetMouse()
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if aimbotEnabled and rightMouseHeld then
            local closestEnemy = nil
            local closestDistance = fovSize
            
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                    local headPosition = v.Character.Head.Position
                    local screenPos, onScreen = camera:WorldToViewportPoint(headPosition)
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude
                    
                    if onScreen and distance < closestDistance then
                        closestDistance = distance
                        closestEnemy = v
                    end
                end
            end
            
            if closestEnemy and closestEnemy.Character and closestEnemy.Character:FindFirstChild("Head") then
                camera.CFrame = CFrame.new(camera.CFrame.Position, closestEnemy.Character.Head.Position)
            end
        end
    end)
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton2 then
      rightMouseHeld = true
   end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton2 then
      rightMouseHeld = false
   end
end)

section:Toggle({
   Text = "Enable Aimbot",
   State = false,
   Callback = function(state)
      aimbotEnabled = state
      if aimbotEnabled then
         print("Aimbot Enabled")
         aimbot()
      else
         print("Aimbot Disabled")
      end
   end
})

section:Toggle({
   Text = "Enable FOV",
   State = false,
   Callback = function(state)
      fovActive = state
      fovCircle.Visible = fovActive
      print("FOV Enabled: ", fovActive)
   end
})

section:Slider({
   Text = "FOV",
   Min = 0,
   Max = 100,
   def = 50,
   Callback = function(value)
      fovSize = value
      fovCircle.Radius = fovSize
      print("FOV set to: ", fovSize)
   end
})

game:GetService("RunService").RenderStepped:Connect(function()
   local player = game.Players.LocalPlayer
   local mouse = player:GetMouse()
   fovCircle.Position = Vector2.new(mouse.X, mouse.Y)
end)

local function createBoxESP(character)
   local player = game.Players.LocalPlayer
   local box = Drawing.new("Square")
   box.Thickness = 2
   box.Color = Color3.fromRGB(255, 0, 0)
   box.Filled = false

   game:GetService("RunService").RenderStepped:Connect(function()
      if espEnabled and character and character:FindFirstChild("HumanoidRootPart") and character ~= player.Character then
         local rootPart = character.HumanoidRootPart
         local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
         
         if onScreen then
            box.Size = Vector2.new(42, 84)
            box.Position = Vector2.new(screenPos.X - box.Size.X / 2, screenPos.Y - box.Size.Y / 2)
            box.Visible = true
         else
            box.Visible = false
         end
      else
         box.Visible = false
      end
   end)
end

local function createDotNetESP(character)
   local player = game.Players.LocalPlayer
   local headCircle = Drawing.new("Circle")
   headCircle.Thickness = 2
   headCircle.Color = Color3.fromRGB(0, 0, 255)
   headCircle.Filled = false
   headCircle.Radius = 10

   game:GetService("RunService").RenderStepped:Connect(function()
      if espEnabled and character and character:FindFirstChild("Head") and character ~= player.Character then
         local head = character.Head
         local screenPos, onScreen = game.Workspace.CurrentCamera:WorldToViewportPoint(head.Position)
         
         if onScreen then
            headCircle.Position = Vector2.new(screenPos.X, screenPos.Y)
            headCircle.Visible = true
         else
            headCircle.Visible = false
         end
      else
         headCircle.Visible = false
      end
   end)
end

section:Toggle({
   Text = "ESP (BoxESP)",
   State = false,
   Callback = function(state)
      espEnabled = state
      if espEnabled then
         print("BoxESP Enabled")
         for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character then
               createBoxESP(v.Character)
            end
         end
      else
         print("BoxESP Disabled")
      end
   end
})

section:Dropdown({
   Text = "ESP Type",
   List = {'DotNet', 'BoxESP'},
   Callback = function(selected)
      if selected == 'DotNet' then
         print("DotNet ESP Selected")
         for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character then
               createDotNetESP(v.Character)
            end
         end
      elseif selected == 'BoxESP' then
         print("BoxESP Selected")
         for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character then
               createBoxESP(v.Character)
            end
         end
      end
   end
})

-- TeamCheck Button
section:Button({
   Text = "Team Check",
   Callback = function()
      local player = game.Players.LocalPlayer
      local team = player.Team
      if team then
         print("You are in team: " .. team.Name)
      else
         print("You are not in any team.")
      end
   end
})

section:Button({
   Text = "Unload Script",
   Callback = function()
      aimbotEnabled = false
      fovActive = false
      espEnabled = false
      fovCircle.Visible = false
      print("Script Unloaded")

      for _, drawing in pairs(Drawing.get()) do
         drawing:Remove()
      end

      window:Destroy()
   end
})
