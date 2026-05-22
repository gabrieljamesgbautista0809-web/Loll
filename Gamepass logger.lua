local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LP = Players.LocalPlayer

local TrackedIDs = {}

-- Safe Canvas Parent Initialization (Survives Character Reset/Respawn)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GAMEPASS_LOGGER_REMASTERED"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LP:WaitForChild("PlayerGui")

-- Remade Modern Neon Frame
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(11, 14, 18)
Main.BackgroundTransparency = 0.12
Main.Size = UDim2.new(0, 380, 0, 280)
Main.Position = UDim2.new(0.5, -190, 0.5, -140)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 16)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(0, 240, 255)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Smooth Fluid Drag Engine
local Dragging, DragInput, DragStart, StartPos
local function UpdateDrag(input)
    local delta = input.Position - DragStart
    Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
end

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then Dragging = false end
        end)
    end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then DragInput = input end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then UpdateDrag(input) end
end)

-- Polished Entrance Pop Animation
Main.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.new(0, 380, 0, 280)}):Play()

-- Premium Title Layout
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(0.6, 0, 0, 55)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Text = "GAMEPASS LOGGER"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1

local TitleGrad = Instance.new("UIGradient", Title)
TitleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 255, 240)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 120)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 240))
}

task.spawn(function()
    while Main and Main.Parent do
        TweenService:Create(TitleGrad, TweenInfo.new(4, Enum.EasingStyle.Linear), {Rotation = TitleGrad.Rotation + 360}):Play()
        task.wait(4)
    end
end)

-- Optimized Controls Layout Panel
local ControlGroup = Instance.new("Frame", Main)
ControlGroup.Size = UDim2.new(0.35, 0, 0, 55)
ControlGroup.Position = UDim2.new(0.65, -16, 0, 0)
ControlGroup.BackgroundTransparency = 1

local ControlLayout = Instance.new("UIListLayout", ControlGroup)
ControlLayout.FillDirection = Enum.FillDirection.Horizontal
ControlLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
ControlLayout.VerticalAlignment = Enum.VerticalAlignment.Center
ControlLayout.Padding = UDim.new(0, 8)

local Minimized = false

local MiniBtn = Instance.new("TextButton", ControlGroup)
MiniBtn.Size = UDim2.new(0, 28, 0, 28)
MiniBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 255)
MiniBtn.BackgroundTransparency = 0.85
MiniBtn.Text = "—"
MiniBtn.TextColor3 = Color3.fromRGB(0, 230, 255)
MiniBtn.Font = Enum.Font.GothamBold
MiniBtn.TextSize = 12
Instance.new("UICorner", MiniBtn).CornerRadius = UDim.new(0, 8)

local Close = Instance.new("TextButton", ControlGroup)
Close.Size = UDim2.new(0, 28, 0, 28)
Close.BackgroundColor3 = Color3.fromRGB(255, 60, 90)
Close.BackgroundTransparency = 0.85
Close.Text = "X"
Close.TextColor3 = Color3.fromRGB(255, 80, 100)
Close.Font = Enum.Font.GothamBold
Close.TextSize = 13
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 8)

local function ApplyGlowHover(btn, baseColor)
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85, TextColor3 = baseColor}):Play() end)
end
ApplyGlowHover(MiniBtn, Color3.fromRGB(0, 230, 255))
ApplyGlowHover(Close, Color3.fromRGB(255, 80, 100))

-- Interactive System Minimization
MiniBtn.MouseButton1Click:Connect(function()
    Minimized = not Minimized
    local targetSize = Minimized and UDim2.new(0, 380, 0, 55) or UDim2.new(0, 380, 0, 280)
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    MiniBtn.Text = Minimized and "+" or "—"
end)

Close.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    ScreenGui:Destroy()
end)

-- Keyboard Toggle Visibility Shortcut Bind (RightControl Key)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

-- Clean Elements List Container Frame
local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1, -32, 1, -75)
Scroll.Position = UDim2.new(0, 16, 0, 60)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 2
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 180)
Scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local Layout = Instance.new("UIListLayout", Scroll)
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Main Generation Logic Remake (Without Auto Code)
local function LogProductSignal(id, typeName)
    if TrackedIDs[id] then return end
    TrackedIDs[id] = true

    local Card = Instance.new("Frame", Scroll)
    Card.Size = UDim2.new(1, -4, 0, 55)
    Card.BackgroundColor3 = Color3.fromRGB(18, 24, 30)
    Card.BackgroundTransparency = 0.4
    Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 10)
    
    local CardStroke = Instance.new("UIStroke", Card)
    CardStroke.Thickness = 1
    CardStroke.Color = Color3.fromRGB(0, 255, 180)
    CardStroke.Transparency = 0.85

    -- Scaled Informative Label Configuration
    local Info = Instance.new("TextLabel", Card)
    Info.Size = UDim2.new(0.48, 0, 1, 0)
    Info.Position = UDim2.new(0, 12, 0, 0)
    Info.Text = "<font color='#00FFD0'><b>" .. typeName .. "</b></font>\n<font color='#A0AAB5'>ID: " .. id .. "</font>"
    Info.RichText = true
    Info.TextColor3 = Color3.fromRGB(255, 255, 255)
    Info.Font = Enum.Font.GothamMedium
    Info.TextSize = 12
    Info.TextXAlignment = Enum.TextXAlignment.Left
    Info.BackgroundTransparency = 1

    -- Button Inline Box Structure Holder
    local BtnGroup = Instance.new("Frame", Card)
    BtnGroup.Size = UDim2.new(0.48, 0, 1, 0)
    BtnGroup.Position = UDim2.new(0.52, -12, 0, 0)
    BtnGroup.BackgroundTransparency = 1

    local BtnLayout = Instance.new("UIListLayout", BtnGroup)
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    BtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BtnLayout.Padding = UDim.new(0, 6)

    local function GenerateButton(title, color)
        local b = Instance.new("TextButton", BtnGroup)
        b.Size = UDim2.new(0, 46, 0, 32)
        b.BackgroundColor3 = color
        b.BackgroundTransparency = 0.85
        b.Text = title
        b.Font = Enum.Font.GothamBold
        b.TextColor3 = color
        b.TextSize = 11
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        
        local bStroke = Instance.new("UIStroke", b)
        bStroke.Thickness = 1
        bStroke.Color = color
        bStroke.Transparency = 0.6

        ApplyGlowHover(b, color)
        return b
    end

    local ScanBtn = GenerateButton("SCAN", Color3.fromRGB(0, 220, 255))
    local FireBtn = GenerateButton("FIRE", Color3.fromRGB(0, 255, 140))
    local DeleteBtn = GenerateButton("DEL", Color3.fromRGB(255, 75, 95))

    -- Interactions Function Execution Setup
    DeleteBtn.MouseButton1Click:Connect(function()
        TrackedIDs[id] = nil
        Card:Destroy()
    end)

    ScanBtn.MouseButton1Click:Connect(function()
        ScanBtn.Text = "..."
        local success, res = pcall(function() 
            return MarketplaceService:GetProductInfo(id, (typeName == "GAMEPASS" and Enum.InfoType.GamePass or Enum.InfoType.Product)) 
        end)
        if success and res then
            ScanBtn.Text = "OK"
            ScanBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
            ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ScanBtn.BackgroundTransparency = 0.2
        else
            ScanBtn.Text = "ERR" 
            ScanBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            ScanBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ScanBtn.BackgroundTransparency = 0.2
        end
    end)

    FireBtn.MouseButton1Click:Connect(function()
        FireBtn.Text = "DONE"
        FireBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FireBtn.TextColor3 = Color3.fromRGB(11, 14, 18)
        FireBtn.BackgroundTransparency = 0.1
        
        pcall(function()
            if typeName == "GAMEPASS" then 
                MarketplaceService:SignalPromptGamePassPurchaseFinished(LP, id, true)
            else 
                MarketplaceService:SignalPromptProductPurchaseFinished(LP.UserId, id, true) 
            end
        end)

        task.delay(1, function()
            FireBtn.Text = "FIRE"
            FireBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 140)
            FireBtn.TextColor3 = Color3.fromRGB(0, 255, 140)
            FireBtn.BackgroundTransparency = 0.85
        end)
    end)
end

-- Link System Hooks Connections
MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(p, id) LogProductSignal(id, "GAMEPASS") end)
MarketplaceService.PromptProductPurchaseFinished:Connect(function(p, id) LogProductSignal(id, "PRODUCT") end)
