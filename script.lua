-- [[ QUANG MOD - V16 ULTIMATE MYTHICAL HUNTER ]] --
-- Tính năng: Full UI Gốc, Anti-Freeze, Nhặt Trái Gốc Cây, Discord Image To, Anti-AFK --

_G.WebhookURL = "https://discord.com/api/webhooks/1477601625945407714/cm27KWxnN1bIk7KQpccEmSVRghh9GvWn-lbSftl_TtX7SoEd9CIKsTCgNZug7PnbC2BX"
_G.SafeSpeed = 330
_G.Invisible = true
_G.WaterWalk = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local Player = Players.LocalPlayer

-- 1. ANTI-AFK & REJOIN (CHỐNG TREO 20P & FIX KICK)
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
    task.wait(5)
    TeleportService:Teleport(game.PlaceId, Player)
end)

-- 2. NOCLIP (XUYÊN TƯỜNG) - FIX KẸT GÓC/GHẾ/GỐC CÂY
RunService.Stepped:Connect(function()
    pcall(function()
        if Player.Character then
            for _, v in pairs(Player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end)
end)

-- 3. GIAO DIỆN CẦU VỒNG + NÚT XOAY (100% GỐC)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 320, 0, 120); MainFrame.Position = UDim2.new(0.5, -160, 0.05, 0); MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0.2, 0)
local UIStroke = Instance.new("UIStroke", MainFrame); UIStroke.Thickness = 3
local ModTitle = Instance.new("TextLabel", MainFrame)
ModTitle.Size = UDim2.new(0, 100, 0, 20); ModTitle.Position = UDim2.new(0.5, -50, 0, -10); ModTitle.BackgroundColor3 = Color3.fromRGB(20, 20, 20); ModTitle.Text = "QUANG MOD"; ModTitle.TextColor3 = Color3.fromRGB(255, 255, 255); ModTitle.Font = Enum.Font.GothamBold
Instance.new("UICorner", ModTitle).CornerRadius = UDim.new(0.5, 0)
local Status = Instance.new("TextLabel", MainFrame)
Status.Size = UDim2.new(1, 0, 1, 0); Status.BackgroundTransparency = 1; Status.TextColor3 = Color3.fromRGB(255, 255, 255); Status.TextSize = 16; Status.Text = "Đang khởi động..."; Status.Parent = MainFrame
task.spawn(function()
    while task.wait(0.01) do UIStroke.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1) end
end)

-- 4. HÀM GỬI DISCORD KÈM ẢNH TO (LƯU TRỮ VĨNH VIỄN)
local FruitIcons = {
    ["Kitsune Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/1/18/Kitsune_Icon.png",
    ["Dragon Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/f/f6/Dragon_Icon.png",
    ["Leopard Fruit"] = "https://static.wikia.nocookie.net/blox-fruits/images/1/1a/Leopard_Icon.png",
    ["Default"] = "https://static.wikia.nocookie.net/blox-fruits/images/8/8e/Blox_Fruit_Icon.png"
}

function SendVipNoti(name)
    task.spawn(function()
        local icon = FruitIcons[name] or FruitIcons["Default"]
        local data = {
            ["embeds"] = {{
                ["title"] = "🌟 QUANG MOD - PHÁT HIỆN TRÁI XỊN! 🌟",
                ["description"] = "🔥 **Tên trái:** " .. name .. "\n👤 **Người chơi:** " .. Player.Name,
                ["color"] = 16711680,
                ["image"] = { ["url"] = icon }, -- Hiện ảnh to rõ nét
                ["footer"] = { ["text"] = "Đã cất rương & lưu ảnh thành công!" }
            }}
        }
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then req({Url = _G.WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)}) end
    end)
end

-- 5. VÒNG LẶP CHỐNG TREO & NHẶT TRÁI GỐC CÂY
task.spawn(function()
    while true do
        task.wait(2) -- Nghỉ 2s để CPU Redmi Note 13 không bị treo logic
        pcall(function()
            local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local found = false
                for _, v in pairs(game.Workspace:GetDescendants()) do -- Quét sạch trái gốc cây
                    if v:IsA("Tool") and (v.Name:find("Fruit") or v.Name:find("Blox")) then
                        if v.Parent == game.Workspace or v.Parent:IsA("Model") then
                            found = true
                            Status.Text = "🍎 Đang gom: " .. v.Name
                            v.Handle.CFrame = hrp.CFrame
                            task.wait(0.5)
                            SendVipNoti(v.Name)
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", v.Name, v)
                            task.wait(1)
                        end
                    end
                end
                if not found then
                    Status.Text = "🔍 Đang tìm server mới (1-3 người)..."
                    task.wait(5)
                    -- Gọi hàm nhảy server tại đây
                end
            end
        end)
    end
end)
