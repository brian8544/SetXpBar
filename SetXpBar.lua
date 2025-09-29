-- Function to set the XP rate
local function SetXpRate(rate)
    -- Sends a chat message to mod-individual-xp to set the XP rate
    SendChatMessage(".xp set " .. rate, "SAY")
end

-- Dropdown menu setup
local function InitializeMenu()
    local info

    info = {}
    info.text = "Experience:"
    info.isTitle = 1
    info.notCheckable = 1
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "x1 (Blizzlike)"
    info.func = function() SetXpRate(1) end
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "x3"
    info.func = function() SetXpRate(3) end
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "x5"
    info.func = function() SetXpRate(5) end
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "x7"
    info.func = function() SetXpRate(7) end
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "x12"
    info.func = function() SetXpRate(12) end
    UIDropDownMenu_AddButton(info)

    info = {}
    info.text = "Custom"
    info.func = function() StaticPopup_Show("SET_XP_RATE") end
    UIDropDownMenu_AddButton(info)
end

-- Create the dropdown menu frame
local xpBarMenu = CreateFrame("Frame", "SetXpBarMenu", UIParent, "UIDropDownMenuTemplate")
UIDropDownMenu_Initialize(xpBarMenu, InitializeMenu)

-- Enable mouse interaction with the XP bar
MainMenuExpBar:EnableMouse(true)
MainMenuExpBar:SetScript("OnMouseDown", function()
    if arg1 == "RightButton" then
        ToggleDropDownMenu(1, nil, xpBarMenu, "cursor", 0, 0)
    end
end)

-- Custom XP Rate Popup Dialog
StaticPopupDialogs["SET_XP_RATE"] = {
    text = "Enter custom XP rate:",
    button1 = "Set Rate",
    button2 = "Cancel",
    hasEditBox = 1,
    maxLetters = 10,

    OnAccept = function()
        local editBox = getglobal(this:GetParent():GetName().."EditBox")
        local rate = editBox:GetText()
        if rate and rate ~= "" then
            SetXpRate(rate)
        end
    end,

    OnShow = function()
        getglobal(this:GetName().."EditBox"):SetFocus()
    end,

    EditBoxOnEnterPressed = function()
        local parent = this:GetParent()
        local rate = this:GetText()
        if rate and rate ~= "" then
            SetXpRate(rate)
        end
        parent:Hide()
    end,

    EditBoxOnEscapePressed = function()
        this:GetParent():Hide()
    end,

    timeout = 0,
    whileDead = 1,
    hideOnEscape = 1,
    exclusive = 1,
}
