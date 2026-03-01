-- [[ QUANG MOD - KẾT HỢP VIP & ANTI-STUCK ]] --
_G.WebhookURL = "https://discord.com/api/webhooks/1477601625945407714/cm27KWxnN1bIk7KQpccEmSVRghh9GvWn-lbSftl_TtX7SoEd9CIKsTCgNZug7PnbC2BX"
_G.SafeSpeed = 330
_G.Invisible = true
_G.WaterWalk = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- 1. CHỌN TEAM (Pirates)
pcall(function()
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("SetTeam", "Pirates")
end)

-- 2. HÀM XUYÊN TƯỜNG (NOCLIP) - CHỐNG KẸT GÓC TƯỜNG/GHẾ
RunService.Stepped:Connect(function()
    if Player.Character then
        for _, v in pairs(Player.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- 3. TÀNG HÌNH & ĐI TRÊN NƯỚC
local function ApplyVipEffects()
    pcall(function()
        local char = Player.Character or Player.CharacterAdded:Wait()
        if _G.Invisible then
            for _, v in pairs(char:GetDescendants()) do
                if (v:IsA("BasePart") or v:IsA("Decal")) and v.Name ~= "HumanoidRootPart" then
                    v.Transparency = 1
                end
            end
        end
        if _G.WaterWalk then
            if not char:FindFirstChild("WaterPlatform") then
                local p = Instance.new("Part", char)
                p.Name = "WaterPlatform"
                p.Size = Vector3.new(10, 1, 10)
                p.Transparency = 1
                p.Anchored = true
                p.CanCollide = true
                spawn(function()
                    while p.Parent do
                        p.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -3.5, 0)
                        task.wait()
                    end
                end)
            end
        end
    end)
end
spawn(ApplyVipEffects)
Player.CharacterAdded:Connect(ApplyVipEffects)

-- 4. GIAO DIỆN CẦU VỒNG (QUANG MOD)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 120)
MainFrame.Position = UDim2.new(0.5, -160, 0.05, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.2, 0)

local ModTitle = Instance.new("TextLabel", MainFrame)
ModTitle.Size = UDim2.new(0, 100, 0, 20)
ModTitle.Position = UDim2.new(0.5, -50, 0, -10)
ModTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ModTitle.Text = "QUANG MOD"
ModTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
ModTitle.Font = Enum.Font.GothamBold
Instance.new("UICorner", ModTitle).CornerRadius = UDim.new(0.5, 0)

local UIStroke = Instance.new("UIStroke", MainFrame)
UIStroke.Thickness = 3
spawn(function()
    while task.wait(0.01) do 
        UIStroke.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
    end
end)

local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 1, 0)
Status.BackgroundTransparency = 1
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.Text = "Đang quét server..."
Status.Parent = MainFrame

-- 5. DANH SÁCH ẢNH TRÁI (TỪ VIDEO 41 TRÁI)
local FruitImages = {
    ["Kitsune Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/1/18/Kitsune_Icon.png",
    ["Dragon Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/f/f6/Dragon_Icon.png",
    ["Leopard Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/1/1a/Leopard_Icon.png",
    ["Dough Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/a/a5/Dough_Icon.png",
    ["T-Rex Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/5/53/T-Rex_Icon.png",
    ["Portal Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/f/fe/Portal_Icon.png",
    ["Default"] = "https://static.wikia.nocookie.net/blox-fruits/images/8/8e/Blox_Fruit_Icon.png"
}

-- 6. HÀM GỬI THÔNG BÁO DISCORD
function SendDiscordNotification(name)
    local icon = FruitImages[name] or FruitImages["Default"]
    local data = {
        ["embeds"] = {{
            ["title"] = "🍎 ĐÃ NHẶT ĐƯỢC TRÁI!",
            ["description"] = "✨ **Trái:** " .. name .. "\n👤 **User:** " .. Player.Name,
            ["color"] = 16711680,
            ["thumbnail"] = { ["url"] = icon },
            ["footer"] = { ["text"] = "QUANG MOD | Redmi Note 13" }
        }}
    }
    local request = (syn and syn.request) or (http and http.request) or http_request or request
    if request then
        request({
            Url = _G.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(data)
        })
    end
end

-- 7. HÀM CẤT TRÁI & NHẢY SERVER
function ServerHop()
    Status.Text = "🛡️ Đang nhảy server (1-3 người)..."
    pcall(function()
        local Api = "https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
        local servers = HttpService:JSONDecode(game:HttpGet(Api)).data
        for _, s in pairs(servers) do
            if s.playing >= 1 and s.playing <= 3 and s.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, Player)
            end
        end
    end)
end

-- 8. VÒNG LẶP GOM TRÁI (BRING FRUIT)
function BringAndStore()
    local hrp = Player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local found = false
    for _, v in pairs(game.Workspace:GetChildren()) do
        if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Blox")) then
            found = true
            Status.Text = "🍎 Đang gom: " .. v.Name
            v.Handle.CFrame = hrp.CFrame -- Kéo trái về phía mình
            task.wait(0.5)
            SendDiscordNotification(v.Name)
            local originalName = v:GetAttribute("OriginalName") or v.Name
            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", originalName, v)
            task.wait(1)
        end
    end
    return found
end

-- 9. VÒNG LẶP CHÍNH
spawn(function()
    while true do
        -- Kiểm tra Admin
        for _, p in pairs(Players:GetPlayers()) do
            if p:GetRankInGroup(2830050) > 0 then ServerHop() end
        end

        local foundFruit = BringAndStore()
        if not foundFruit then
            task.wait(5)
            ServerHop()
        end
        task.wait(2)
    end
end)
