-- SAGAPUNG
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/ZurraOfficial/Fly/main/SAGAPUNG.lua"))()

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ASSETS = {
    logo = "rbxassetid://1352543873",
    minimize = "rbxassetid://2406617031",
    close = "rbxassetid://5054663650",
    settings = "rbxassetid://1204397029",
    info = "rbxassetid://3523243755",
}

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
    pcall(function() ScreenGui.Parent = gethui() parented = true end)
end
if not parented then
    pcall(function() ScreenGui.Parent = CoreGui parented = true end)
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

local function makeImage(parent, assetId, size, pos)
    return new("ImageLabel", {
        Size = size,
        Position = pos,
        BackgroundTransparency = 1,
        Image = assetId,
        Parent = parent,
    })
end

local Main = new("Frame", {
    Size = UDim2.new(0, 520, 0, 460),
    Position = UDim2.new(0.5, -260, 0.5, -230),
    BackgroundColor3 = Colors.BG,
    BorderSizePixel = 0,
    Active = true,
    Draggable = true,
    Parent = ScreenGui,
})
corner(12, Main)
stroke(Colors.Border, 1, Main)

local Header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Colors.Header,
    BorderSizePixel = 0,
    Parent = Main,
})
corner(12, Header)
new("Frame", {
    Size = UDim2.new(1, 0, 0, 12),
    Position = UDim2.new(0, 0, 1, -12),
    BackgroundColor3 = Colors.Header,
    BorderSizePixel = 0,
    Parent = Header,
})

local logo = makeImage(Header, ASSETS.logo, UDim2.new(0, 24, 0, 24), UDim2.new(0, 14, 0.5, -12))

local title = new("TextLabel", {
    Size = UDim2.new(1, -120, 1, 0),
    Position = UDim2.new(0, 46, 0, 0),
    BackgroundTransparency = 1,
    Text = "SAGAPUNG",
    TextColor3 = Colors.Text,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Header,
})

local minimizeBtn = new("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -66, 0.5, -14),
    BackgroundColor3 = Colors.Card,
    BorderSizePixel = 0,
    Text = "",
    Parent = Header,
})
corner(6, minimizeBtn)
makeImage(minimizeBtn, ASSETS.minimize, UDim2.new(0, 14, 0, 14), UDim2.new(0.5, -7, 0.5, -7))

local closeBtn = new("TextButton", {
    Size = UDim2.new(0, 28, 0, 28),
    Position = UDim2.new(1, -34, 0.5, -14),
    BackgroundColor3 = Colors.Card,
    BorderSizePixel = 0,
    Text = "",
    Parent = Header,
})
corner(6, closeBtn)
makeImage(closeBtn, ASSETS.close, UDim2.new(0, 12, 0, 12), UDim2.new(0.5, -6, 0.5, -6))

local Body = new("ScrollingFrame", {
    Size = UDim2.new(1, -20, 1, -60),
    Position = UDim2.new(0, 10, 0, 52),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Colors.Border,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    Parent = Main,
})
new("UIListLayout", {
    Padding = UDim.new(0, 12),
    SortOrder = Enum.SortOrder.LayoutOrder,
    Parent = Body,
})

local function makeCard(titleText, height, order, iconAsset)
    local card = new("Frame", {
        Size = UDim2.new(1, -6, 0, height),
        BackgroundColor3 = Colors.Card,
        BorderSizePixel = 0,
        LayoutOrder = order,
        Parent = Body,
    })
    corner(10, card)
    stroke(Colors.Border, 1, card)

    if iconAsset then
        makeImage(card, iconAsset, UDim2.new(0, 16, 0, 16), UDim2.new(0, 14, 0, 14))
    end

    new("TextLabel", {
        Size = UDim2.new(1, -60, 0, 20),
        Position = UDim2.new(0, 38, 0, 12),
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
        Size = UDim2.new(1, -28, 0, 34),
        Position = UDim2.new(0, 14, 0, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(1, -70, 1, 0),
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
    return btn
end

local function makeSlider(parent, y, label, minVal, maxVal, defaultVal, callback)
    local row = new("Frame", {
        Size = UDim2.new(1, -28, 0, 60),
        Position = UDim2.new(0, 14, 0, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    local lbl = new("TextLabel", {
        Size = UDim2.new(1, -80, 0, 20),
        BackgroundTransparency = 1,
        Text = label,
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
        Text = tostring(defaultVal),
        TextColor3 = Colors.Accent,
        TextSize = 12,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = row,
    })
    local bar = new("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = UDim2.new(0, 0, 0, 38),
        BackgroundColor3 = Colors.Border,
        BorderSizePixel = 0,
        Parent = row,
    })
    corner(3, bar)
    local frac = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
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
        local val = math.floor(minVal + (maxVal - minVal) * pos)
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
    return fill, dot, valLbl
end

local function makeInput(parent, y, label, defaultVal, callback)
    local row = new("Frame", {
        Size = UDim2.new(1, -28, 0, 34),
        Position = UDim2.new(0, 14, 0, y),
        BackgroundTransparency = 1,
        Parent = parent,
    })
    new("TextLabel", {
        Size = UDim2.new(0, 110, 1, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = Colors.Text,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = row,
    })
    local box = new("TextBox", {
        Size = UDim2.new(1, -120, 0, 30),
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

-- FLY ENGINE (Infinite Yield)
FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1

function sFLY(vfly)
    local plr = Players.LocalPlayer
    local char = plr.Character or plr.CharacterAdded:Wait()
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        repeat wait() until char:FindFirstChildOfClass("Humanoid")
        humanoid = char:FindFirstChildOfClass("Humanoid")
    end
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
    local T = humanoid.RootPart
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0
    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.CFrame = T.CFrame
        BV.Velocity = Vector3.new(0, 0, 0)
        BV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        spawn(function()
            repeat wait()
                local camera = workspace.CurrentCamera
                if not vfly and humanoid then humanoid.PlatformStand = true end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.Velocity = ((camera.CFrame.LookVector * (lCONTROL.F + lCONTROL.B)) + ((camera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p)) * SPEED
                else
                    BV.Velocity = Vector3.new(0, 0, 0)
                end
                BG.CFrame = camera.CFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if humanoid then humanoid.PlatformStand = false end
        end)
    end
    flyKeyDown = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = -(vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = -(vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif input.KeyCode == Enum.KeyCode.E and QEfly then CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed) * 2
        elseif input.KeyCode == Enum.KeyCode.Q and QEfly then CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed) * 2
        end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)
    flyKeyUp = UserInputService.InputEnded:Connect(function(input, processed)
        if processed then return end
        if input.KeyCode == Enum.KeyCode.W then CONTROL.F = 0
        elseif input.KeyCode == Enum.KeyCode.S then CONTROL.B = 0
        elseif input.KeyCode == Enum.KeyCode.A then CONTROL.L = 0
        elseif input.KeyCode == Enum.KeyCode.D then CONTROL.R = 0
        elseif input.KeyCode == Enum.KeyCode.E then CONTROL.Q = 0
        elseif input.KeyCode == Enum.KeyCode.Q then CONTROL.E = 0
        end
    end)
    FLY()
end

function NOFLY()
    FLYING = false
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
    if Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local flyCard = makeCard("FLY", 210, 1, ASSETS.settings)
makeToggle(flyCard, 42, "Enable Fly", function(state)
    if state then
        NOFLY()
        wait(0.05)
        sFLY()
    else
        NOFLY()
    end
end)
makeSlider(flyCard, 84, "Fly Speed", 1, 10000, 50, function(v)
    iyflyspeed = v
    vehicleflyspeed = v
end)
makeInput(flyCard, 156, "Set Speed:", 50, function(txt)
    local n = tonumber(txt)
    if n and n >= 1 and n <= 10000 then
        iyflyspeed = n
        vehicleflyspeed = n
    end
end)

local wsCard = makeCard("WALKSPEED", 158, 2, ASSETS.settings)
local currentWS = 16
makeToggle(wsCard, 42, "Enable WalkSpeed", function(state)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = state and currentWS or 16
        end
    end
end)
makeSlider(wsCard, 84, "WalkSpeed", 1, 500, 16, function(v)
    currentWS = v
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= 16 then hum.WalkSpeed = v end
    end
end)
makeInput(wsCard, 156, "Set Value:", 16, function(txt)
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

local jumpCard = makeCard("JUMP POWER", 200, 3, ASSETS.settings)
local currentJP = 50
makeToggle(jumpCard, 42, "Enable Jump Power", function(state)
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = state
            hum.JumpPower = state and currentJP or 50
        end
    end
end)
makeSlider(jumpCard, 84, "Jump Power", 1, 500, 50, function(v)
    currentJP = v
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.UseJumpPower then hum.JumpPower = v end
    end
end)
makeInput(jumpCard, 156, "Set Value:", 50, function(txt)
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

local infJumpConn
makeToggle(jumpCard, 190, "Infinite Jump", function(state)
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
end)

local espCard = makeCard("ESP PLAYER", 60, 4, ASSETS.info)
local ESPenabled = false
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
    if ESPFolder then
        local bb = ESPFolder:FindFirstChild(plr.Name)
        if bb then bb:Destroy() end
    end
end)

makeToggle(espCard, 42, "Enable Player ESP", function(state)
    ESPenabled = state
    refreshESP()
end)

LocalPlayer.CharacterAdded:Connect(function()
    if FLYING then
        wait(0.5)
        if FLYING then sFLY() end
    end
end)

wait()
Body.CanvasSize = UDim2.new(0, 0, 0, Body.UIListLayout.AbsoluteContentSize.Y + 20)
Body.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Body.CanvasSize = UDim2.new(0, 0, 0, Body.UIListLayout.AbsoluteContentSize.Y + 20)
end)

local floatingIcon = nil
local savedPos = UDim2.new(0, 20, 0.5, -24)
local isMinimized = false

local function restore()
    if not isMinimized then return end
    isMinimized = false
    Main.Visible = true
    tweenMain(UDim2.new(0, 520, 0, 460), UDim2.new(0.5, -260, 0.5, -230))
    if floatingIcon then
        floatingIcon:Destroy()
        floatingIcon = nil
    end
end

function tweenMain(size, pos)
    local t = TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = size, Position = pos})
    t:Play()
end

local function minimize()
    if isMinimized then return end
    isMinimized = true

    if floatingIcon then floatingIcon:Destroy() end

    floatingIcon = new("TextButton", {
        Size = UDim2.new(0, 52, 0, 52),
        Position = savedPos,
        BackgroundColor3 = Colors.Card,
        BorderSizePixel = 0,
        Text = "",
        ZIndex = 200,
        Parent = ScreenGui,
    })
    corner(26, floatingIcon)
    stroke(Colors.Border, 1, floatingIcon)
    local glow = Instance.new("UIStroke")
    glow.Color = Colors.Accent
    glow.Thickness = 1.5
    glow.Transparency = 0.6
    glow.Parent = floatingIcon

    makeImage(floatingIcon, ASSETS.logo, UDim2.new(0, 30, 0, 30), UDim2.new(0.5, -15, 0.5, -15))

    local fDrag = false
    local fStart, fPos
    local dragHappened = false

    floatingIcon.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            fDrag = true
            dragHappened = false
            fStart = input.Position
            fPos = floatingIcon.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    fDrag = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if fDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - fStart
            if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
                dragHappened = true
            end
            floatingIcon.Position = UDim2.new(fPos.X.Scale, fPos.X.Offset + delta.X, fPos.Y.Scale, fPos.Y.Offset + delta.Y)
            savedPos = floatingIcon.Position
        end
    end)

    floatingIcon.MouseButton1Click:Connect(function()
        if dragHappened then return end
        savedPos = floatingIcon.Position
        restore()
    end)

    Main.Visible = false
end

local function closeUI()
    if FLYING then NOFLY() end
    ScreenGui:Destroy()
end

minimizeBtn.MouseButton1Click:Connect(minimize)
closeBtn.MouseButton1Click:Connect(closeUI)

print("[SAGAPUNG] Loaded successfully")
