local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local AimbotButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local UnloadButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)

AimbotButton.Parent = MainFrame
AimbotButton.Text = "Aimbot"
AimbotButton.Size = UDim2.new(0, 180, 0, 30)
AimbotButton.Position = UDim2.new(0, 10, 0, 10)

ESPButton.Parent = MainFrame
ESPButton.Text = "WALLHACk"
ESPButton.Size = UDim2.new(0, 180, 0, 30)
ESPButton.Position = UDim2.new(0, 10, 0, 50)

UnloadButton.Parent = MainFrame
UnloadButton.Text = "Unload"
UnloadButton.Size = UDim2.new(0, 180, 0, 30)
UnloadButton.Position = UDim2.new(0, 10, 0, 90)

local aimbotActive = false
local fovRadius = 80
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Radius = fovRadius
fovCircle.Color = Color3.new(1, 0, 0)
fovCircle.Transparency = 0.5
fovCircle.Visible = false
local connection

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = fovRadius

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local headPos = game.Workspace.CurrentCamera:WorldToScreenPoint(player.Character.Head.Position)
            local mousePos = game.Players.LocalPlayer:GetMouse()
            local distance = (Vector2.new(mousePos.X, mousePos.Y) - Vector2.new(headPos.X, headPos.Y)).Magnitude
            
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end

    return closestPlayer
end

local function aimbot()
    aimbotActive = not aimbotActive
    fovCircle.Visible = aimbotActive

    if aimbotActive then
        connection = game:GetService("RunService").RenderStepped:Connect(function()
            local mouse = game.Players.LocalPlayer:GetMouse()
            fovCircle.Position = Vector2.new(mouse.X, mouse.Y)

            if game.UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                local closestPlayer = getClosestPlayer()

                if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("Head") then
                    local headPos = game.Workspace.CurrentCamera:WorldToScreenPoint(closestPlayer.Character.Head.Position)
                    mousemoverel(headPos.X - mouse.X, headPos.Y - mouse.Y)
                end
            end
        end)
    else
        if connection then
            connection:Disconnect()
        end
    end
end

local function esp()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            local highlight = Instance.new("Highlight", player.Character)
            highlight.FillColor = Color3.new(0, 1, 0)
            highlight.FillTransparency = 0.9
            highlight.OutlineTransparency = 1
        end
    end
end

local function unload()
    if connection then
        connection:Disconnect()
    end
    ScreenGui:Destroy()
    fovCircle:Remove()
end

AimbotButton.MouseButton1Click:Connect(aimbot)
ESPButton.MouseButton1Click:Connect(esp)
UnloadButton.MouseButton1Click:Connect(unload)
