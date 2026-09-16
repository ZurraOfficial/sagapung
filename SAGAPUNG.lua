-- SAGAPUNG
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/ZurraOfficial/Fly/main/SAGAPUNG.lua"))()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

for _, obj in pairs(CoreGui:GetChildren()) do
    if obj.Name == "SagapungUI" then obj:Destroy() end
end
for _, obj in pairs(PlayerGui:GetChildren()) do
    if obj.Name == "SagapungUI" then obj:Destroy() end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SagapungUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999

local parented = false
if gethui then
    pcall(function()
        ScreenGui.Parent = gethui()
        parented = true
    end)
end
if not parented then
    pcall(function()
        ScreenGui.Parent = CoreGui
        parented = true
    end)
end
if not parented then
    ScreenGui.Parent = PlayerGui
end

local Colors = {
    BG = Color3.fromRGB(15, 15, 18),
    Header = Color3.fromRGB(22, 22, 26),
    Card = Color3.fromRGB(28, 28, 33),
    Border = Color3.fromRGB(45, 45, 52),
    Text = Color3.fromRGB(235, 235, 240),
    Muted = Color3.fromRGB(150, 150, 160),
    Accent = Color3.fromRGB(90, 180, 255),
    Success = Color3.fromRGB(80, 210, 120),
    Danger = Color3.fromRGB(230, 80, 80),
}

local function new(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do
        pcall(function() o[k] = v end)
    end
    return o
end

local function corner(r, p)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function stroke(color, thick, p)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thick or 1
    s.Parent = p
    return s
end

-- ============================================
-- MAIN WINDOW
-- ============================================
local Main = new("Frame", {
    Size = UDim2.new(0, 500, 0, 400),
    Position = UDim2.new(0.5, -250, 0.5, -200),
    BackgroundColor3 = Colors.BG,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = ScreenGui,
})
corner(12, Main)
stroke(Colors.Border, 1, Main)

-- Header
local Header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Colors.Header,
    BorderSizePixel = 0,
    Parent = Main,
})
corner(12, Header)
new("Frame", { Size = UDim2.new(1, 0, 0, 12), Position = UDim2.new(0, 0, 1, -12), BackgroundColor3 = Colors.Header, BorderSizePixel = 0, Parent = Header })

local title = new("TextLabel", {
    Size = UDim2.new(1, -60, 1, 0),
    Position = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text = "SAGAPUNG",
    TextColor3 = Colors.Text,
    TextSize = 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header,
})

local versionTag = new("TextLabel", {
    Size = UDim2.new(0, 100, 1, 0),
    Position = UDim2.new(1, -60, 0, 0),
    BackgroundTransparency = 1,
    Text = "v1.0",
    TextColor3 = Colors.Muted,
    TextSize = 11,
    Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = Header,
})

-- Scroll body
local Body = new("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -60),
    Position = UDim2.new(0, 10, 0, 52),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Colors.Border,
    CanvasSize = UDim2.new(0, 0, 0, 900),
    Parent = Main,
})
new("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Body,
})

-- ============================================
-- HELPER: CARD
-- ============================================
local function makeCard(titleText, height, order)
    local card = new("Frame", {
        Size = UDim2.new(1, -6, 0, height),
        BackgroundColor3 = Colors.Card,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = Body,
    })
    corner(10, card)
    stroke(Colors.Border, 1, card)
    new("TextLabel", {
        Size = UDim2.new(1, -24, 0, 20),
        Position = UDim2.new(0, 14, 0, 12),
        BackgroundTransparency = 1,
        Text = titleText,
        TextColor3 = Colors.Text,
        TextSize = 13,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = card,
    })
    return card
end

local function makeToggle(parent, y, text, callback)
    local row = new("Frame", {
        Size = UDim2.new(1, -24, 0, 32),
        Position = UDim2.new(0, 12, 0, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(1, -60, 1, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Colors.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local btn = new("TextButton", {
        Size = UDim2.new(0, 44, 0, 22),
        Position = UDim2.new(1, -44, 0.5, -11),
        BackgroundColor3 = Colors.Border,
        BorderSizePixel = 0,
        Text = "",
        Parent = row,
    })
    corner(11, btn)
    local dot = new("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0, 3, 0.5, -8),
        BackgroundColor3 = Colors.Muted,
        BorderSizePixel = 0,
        Parent = btn,
    })
    corner(8, dot)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if state then
            btn.BackgroundColor3 = Colors.Accent
            dot.Position = UDim2.new(1, -19, 0.5, -8)
            dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            btn.BackgroundColor3 = Colors.Border
            dot.Position = UDim2.new(0, 3, 0.5, -8)
            dot.BackgroundColor3 = Colors.Muted
        end
        if callback then callback(state) end
    end)
    return btn, dot
end

local function makeInput(parent, y, label, defaultVal, callback)
    local row = new("Frame", {
        Size = UDim2.new(1, -24, 0, 36),
        Position = UDim2.new(0, 12, 0, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Colors.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local box = new("TextBox", {
        Size = UDim2.new(1, -110, 0, 30),
        Position = UDim2.new(0, 110, 0.5, -15),
        BackgroundColor3 = Colors.BG,
        BorderSizePixel = 0,
        Text = tostring(defaultVal),
        TextColor3 = Colors.Text,
        PlaceholderColor3 = Colors.Muted,
        TextSize = 12,
        Font = Enum.Font.Code,
        ClearTextOnFocus = false,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = row,
    })
    corner(6, box)
    stroke(Colors.Border, 1, box)
    box.FocusLost:Connect(function()
        if callback then callback(box.Text) end
    end)
    return box
end

local function makeSlider(parent, y, label, min, max, default, callback)
    local row = new("Frame", {
        Size = UDim2.new(1, -24, 0, 56),
        Position = UDim2.new(0, 12, 0, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    local lbl = new("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        BackgroundTransparency = 1,
        Text = label .. ": " .. tostring(default),
        TextColor3 = Colors.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local valLbl = new("TextLabel", {
        Size = UDim2.new(0, 80, 0, 20),
        Position = UDim2.new(1, -80, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default),
        TextColor3 = Colors.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row,
    })
    local bar = new("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 36),
        BackgroundColor3 = Colors.Border,
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(3, bar)
    local frac = (default - min) / (max - min)
    local fill = new("Frame", {
        Size = UDim2.new(frac, 0, 1, 0),
        BackgroundColor3 = Colors.Accent,
        BorderSizePixel = 0,
        Parent = bar,
    })
    corner(3, fill)
    local dot = new("Frame", {
        Size = UDim2.new(0, 14, 0, 14),
        Position = UDim2.new(frac, -7, 0.5, -7),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Parent = bar,
    })
    corner(7, dot)
    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        dot.Position = UDim2.new(pos, -7, 0.5, -7)
        valLbl.Text = tostring(val)
        if callback then callback(val) end
    end
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    return fill, dot, valLbl, lbl
end

-- ============================================
-- FLY ENGINE
-- ============================================
local FLYING = false
local flySpeed = 50
local flyBV, flyBG, flyKeyDown, flyKeyUp

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    if flyBV then flyBV:Destroy() end
    if flyBG then flyBG:Destroy() end
    if flyKeyDown then flyKeyDown:Disconnect() end
    if flyKeyUp then flyKeyUp:Disconnect() end

    FLYING = true
    local BG = Instance.new("BodyGyro")
    local BV = Instance.new("BodyVelocity")
    BG.P = 9e4
    BG.Parent = root
    BV.Parent = root
    BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BG.CFrame = root.CFrame
    BV.Velocity = Vector3.new(0, 0, 0)
    BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBV = BV
    flyBG = BG

    local CONTROL = { F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0 }

    flyKeyDown = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 1
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -1
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -1
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 1
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 1
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = -1
        elseif input.KeyCode == Enum.KeyCode.Space then CONTROL.Q = 1
        elseif input.KeyCode == Enum.KeyCode.LeftControl then CONTROL.E = -1
        end
    end)

    flyKeyUp = UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0
        elseif input.KeyCode == Enum.KeyCode.Space then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.LeftControl then CONTROL.E = 0
        end
    end)

    spawn(function()
        while FLYING and root and root.Parent do
            local cam = workspace.CurrentCamera
            local dir = Vector3.new()
            dir = dir + cam.CFrame.LookVector * (CONTROL.F + CONTROL.B)
            dir = dir + cam.CFrame.RightVector * (CONTROL.R + CONTROL.L)
            dir = dir + Vector3.new(0, 1, 0) * (CONTROL.Q + CONTROL.E)
            if dir.Magnitude > 0 then
                BV.Velocity = dir.Unit * flySpeed
            else
                BV.Velocity = Vector3.new(0, 0, 0)
            end
            BG.CFrame = cam.CFrame
            hum.PlatformStand = true
            wait()
        end
        if BG then BG:Destroy() end
        if BV then BV:Destroy() end
        if hum then hum.PlatformStand = false end
    end)
end

local function stopFly()
    FLYING = false
    if flyKeyDown then flyKeyDown:Disconnect() flyKeyDown = nil end
    if flyKeyUp then flyKeyUp:Disconnect() flyKeyUp = nil end
    if flyBV then flyBV:Destroy() flyBV = nil end
    if flyBG then flyBG:Destroy() flyBG = nil end
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = false end
    end
end

-- ============================================
-- INFINITE JUMP
-- ============================================
local infJumpConn
local function setInfJump(state)
    if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
    if state then
        infJumpConn = UserInputService.JumpRequest:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
end

-- ============================================
-- ESP
-- ============================================
local ESPFolder
local function clearESP()
    if ESPFolder then ESPFolder:Destroy() end
    ESPFolder = Instance.new("Folder")
    ESPFolder.Name = "SagapungESP"
    ESPFolder.Parent = ScreenGui
end
clearESP()

local function addESP(plr)
    if plr == LocalPlayer then return end
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head")
    if not head then return end
    if ESPFolder:FindFirstChild(plr.Name) then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = plr.Name
    bb.Adornee = head
    bb.Size = UDim2.new(0, 200, 0, 60)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = ESPFolder

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 0.5, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plr.Name
    nameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextSize = 14
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.Parent = bb

    local distLbl = Instance.new("TextLabel")
    distLbl.Size = UDim2.new(1, 0, 0.5, 0)
    distLbl.Position = UDim2.new(0, 0, 0.5, 0)
    distLbl.BackgroundTransparency = 1
    distLbl.TextColor3 = Color3.fromRGB(90, 180, 255)
    distLbl.TextStrokeTransparency = 0
    distLbl.TextSize = 12
    distLbl.Font = Enum.Font.Gotham
    distLbl.Parent = bb

    spawn(function()
        while bb and bb.Parent and ESPenabled do
            if plr.Character and plr.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local d = math.floor((LocalPlayer.Character.HumanoidRootPart.Position - plr.Character.Head.Position).Magnitude)
                distLbl.Text = d .. " studs"
            else
                break
            end
            wait(0.2)
        end
    end)
end

ESPenabled = false
local function refreshESP()
    clearESP()
    if not ESPenabled then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        addESP(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if ESPenabled then
        plr.CharacterAdded:Connect(function()
            wait(0.5)
            if ESPenabled then addESP(plr) end
        end)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    local bb = ESPFolder:FindFirstChild(plr.Name)
    if bb then bb:Destroy() end
end)

-- ============================================
-- BUILD UI CARDS
-- ============================================
-- CARD 1: FLY
local flyCard = makeCard("✈  FLY", 150, 1)
makeToggle(flyCard, 44, "Enable Fly", function(state)
    if state then startFly() else stopFly() end
end)
makeSlider(flyCard, 82, "Fly Speed", 1, 10000, 50, function(v)
    flySpeed = v
end)
local flyBox = makeInput(flyCard, 142, "Set Speed:", 50, function(txt)
    local n = tonumber(txt)
    if n and n >= 1 and n <= 10000 then
        flySpeed = n
    end
end)

-- CARD 2: WALKSPEED
local wsCard = makeCard("🏃  WALKSPEED", 150, 2)
local currentWS = 16
makeToggle(wsCard, 44, "Enable", function(state)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = state and currentWS or 16
        end
    end
end)
makeSlider(wsCard, 82, "Walk Speed", 1, 500, 16, function(v)
    currentWS = v
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= 16 then hum.WalkSpeed = v end
    end
end)
makeInput(wsCard, 142, "Set Value:", 16, function(txt)
    local n = tonumber(txt)
    if n and n >= 1 and n <= 500 then
        currentWS = n
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = n end
        end
    end
end)

-- CARD 3: JUMP
local jumpCard = makeCard("⬆  JUMP", 190, 3)
local currentJP = 50
makeToggle(jumpCard, 44, "Enable Jump Power", function(state)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = state
            hum.JumpPower = state and currentJP or 50
        end
    end
end)
makeSlider(jumpCard, 82, "Jump Power", 1, 500, 50, function(v)
    currentJP = v
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.UseJumpPower then hum.JumpPower = v end
    end
end)
makeInput(jumpCard, 142, "Set Value:", 50, function(txt)
    local n = tonumber(txt)
    if n and n >= 1 and n <= 500 then
        currentJP = n
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = n
            end
        end
    end
end)
makeToggle(jumpCard, 178, "Infinite Jump", function(state)
    setInfJump(state)
end)

-- CARD 4: ESP
local espCard = makeCard("👁  ESP", 56, 4)
makeToggle(espCard, 44, "Enable Player ESP", function(state)
    ESPenabled = state
    refreshESP()
end)

-- Update canvas
wait()
Body.CanvasSize = UDim2.new(0, 0, 0, Body.UIListLayout.AbsoluteContentSize.Y + 20)
Body.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Body.CanvasSize = UDim2.new(0, 0, 0, Body.UIListLayout.AbsoluteContentSize.Y + 20)
end)

-- Cleanup on respawn
LocalPlayer.CharacterAdded:Connect(function()
    if FLYING then
        wait(0.5)
        if FLYING then startFly() end
    end
end)

print("[SAGAPUNG] Loaded")
