-- Function to set the XP rate
local function SetXpRate(rate)
    -- Sends a chat message to mod-individual-xp to set the XP rate
    SendChatMessage(".xp set " .. rate, "SAY")
end

-- List of XP rates with corresponding functions
local xpRates = {
    { text = "Experience:", isTitle = true },
    { text = "x1 (Blizzlike)", func = function() SetXpRate(1) end },
    { text = "x3", func = function() SetXpRate(3) end },
    { text = "x5", func = function() SetXpRate(5) end },
    { text = "x7", func = function() SetXpRate(7) end },
    { text = "x12", func = function() SetXpRate(12) end },
    { text = "Custom", func = function() StaticPopup_Show("SET_XP_RATE") end }, -- Open custom XP rate dialog
}

-- Function to initialize the dropdown menu
local function InitializeMenu(self, level)
    if not level then return end
    for _, rate in pairs(xpRates) do
        local info = UIDropDownMenu_CreateInfo()
        info.text = rate.text
        info.func = rate.func
        info.isTitle = rate.isTitle
        UIDropDownMenu_AddButton(info, level)
    end
end

-- Create the dropdown menu frame
local xpBarMenu = CreateFrame("Frame", "SetXpBarMenu", UIParent, "UIDropDownMenuTemplate")
xpBarMenu.initialize = InitializeMenu

-- Enable mouse interaction with the XP bar
MainMenuExpBar:EnableMouse(true)
MainMenuExpBar:SetScript("OnMouseDown", function(self, button)
    if button == "RightButton" then
        EasyMenu(xpRates, xpBarMenu, "cursor", 3, -3, "MENU")
    end
end)

-- Custom XP Rate Popup Dialog
StaticPopupDialogs["SET_XP_RATE"] = {
    text = "Enter custom XP rate:",
    button1 = "Set Rate",
    button2 = "Cancel",
    hasEditBox = true, -- Dialog has an edit box for user input
    -- Function to execute when the "Set Rate" button is clicked
    OnAccept = function(self)
        local rate = self.editBox:GetText()
        SetXpRate(rate)
    end,
    timeout = 0,
    whileDead = true, -- Dialog persists even when other windows are open
    hideOnEscape = true, -- Dialog closes when the escape key is pressed
    preferredIndex = 3, -- Index to avoid taint from UIParent
}
