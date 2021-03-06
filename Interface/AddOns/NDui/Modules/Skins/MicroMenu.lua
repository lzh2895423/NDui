local _, ns = ...
local B, C, L, DB = unpack(ns)
local S = B:GetModule("Skins")

local _G = getfenv(0)
local tinsert, pairs, type = table.insert, pairs, type
local buttonList = {}

function S:MicroButton_SetupTexture(icon, texcoord, texture)
	local r, g, b = DB.r, DB.g, DB.b
	if not NDuiDB["Skins"]["ClassLine"] then r, g, b = 0, 0, 0 end

	if texture == "encounter" then
		icon:SetPoint("TOPLEFT", 2, -2)
		icon:SetPoint("BOTTOMRIGHT", -2, 3)
	else
		icon:SetAllPoints()
	end
	icon:SetTexture(DB.MicroTex..texture)
	icon:SetTexCoord(unpack(texcoord))
	icon:SetVertexColor(r, g, b)
end

function S:MicroButton_Create(parent, data)
	local texture, texcoord, method, tooltip = unpack(data)

	local bu = CreateFrame("Frame", nil, parent)
	tinsert(buttonList, bu)
	bu:SetSize(22, 22)

	local icon = bu:CreateTexture(nil, "ARTWORK")
	S:MicroButton_SetupTexture(icon, texcoord, texture)

	if type(method) == "string" then
		local button = _G[method]
		button:SetHitRectInsets(0, 0, 0, 0)
		button:SetParent(bu)
		button:ClearAllPoints(bu)
		button:SetAllPoints(bu)
		button.SetPoint = B.Dummy
		button:UnregisterAllEvents()
		button:SetNormalTexture(nil)
		button:SetPushedTexture(nil)
		button:SetDisabledTexture(nil)
		if tooltip then B.AddTooltip(button, "ANCHOR_RIGHT", tooltip) end

		local hl = button:GetHighlightTexture()
		S:MicroButton_SetupTexture(hl, texcoord, texture)
		if not NDuiDB["Skins"]["ClassLine"] then hl:SetVertexColor(1, 1, 1) end

		local flash = button.Flash
		S:MicroButton_SetupTexture(flash, texcoord, texture)
		if not NDuiDB["Skins"]["ClassLine"] then flash:SetVertexColor(1, 1, 1) end
	else
		bu:SetScript("OnMouseUp", method)
		B.AddTooltip(bu, "ANCHOR_RIGHT", tooltip)

		local hl = bu:CreateTexture(nil, "HIGHLIGHT")
		S:MicroButton_SetupTexture(hl, texcoord, texture)
		if not NDuiDB["Skins"]["ClassLine"] then hl:SetVertexColor(1, 1, 1) end
	end
end

function S:MicroMenu_Lines()
	if not NDuiDB["Skins"]["MenuLine"] then return end

	local cr, cg, cb = 0, 0, 0
	if NDuiDB["Skins"]["ClassLine"] then cr, cg, cb = DB.r, DB.g, DB.b end

	-- MICROMENU
	local mmbottomL = CreateFrame("Frame", nil, UIParent)
	mmbottomL:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 0, 3)
	B.CreateGF(mmbottomL, 210, C.mult, "Horizontal", cr, cg, cb, 0, .7)
	local mmbottomR = CreateFrame("Frame", nil, UIParent)
	mmbottomR:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 0, 3)
	B.CreateGF(mmbottomR, 210, C.mult, "Horizontal", cr, cg, cb, .7, 0)

	local mmtopL = CreateFrame("Frame", nil, UIParent)
	mmtopL:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOM", 0, 24)
	B.CreateGF(mmtopL, 230, C.mult, "Horizontal", cr, cg, cb, 0, .7)
	local mmtopR = CreateFrame("Frame", nil, UIParent)
	mmtopR:SetPoint("BOTTOMLEFT", UIParent, "BOTTOM", 0, 24)
	B.CreateGF(mmtopR, 230, C.mult, "Horizontal", cr, cg, cb, .7, 0)
end

function S:MicroMenu()
	if not NDuiDB["Skins"]["MicroMenu"] then return end
	if not NDuiDB["Actionbar"]["Enable"] then return end

	local menubar = CreateFrame("Frame", nil, UIParent)
	menubar:SetSize(323, 22)
	B.Mover(menubar, L["Menubar"], "Menubar", C.Skins.MicroMenuPos)
	S:MicroMenu_Lines()

	-- Generate Buttons
	local buttonInfo = {
		{"player", {51/256, 141/256, 86/256, 173/256}, "CharacterMicroButton"},
		{"spellbook", {83/256, 173/256, 86/256, 173/256}, "SpellbookMicroButton"},
		{"talents", {83/256, 173/256, 86/256, 173/256}, "TalentMicroButton"},
		{"achievements", {83/256, 173/256, 83/256, 173/256}, "AchievementMicroButton"},
		{"quests", {83/256, 173/256, 80/256, 167/256}, "QuestLogMicroButton"},
		{"guild", {83/256, 173/256, 80/256, 167/256}, "GuildMicroButton"},
		{"LFD", {83/256, 173/256, 83/256, 173/256}, "LFDMicroButton"},
		{"encounter", {83/256, 173/256, 83/256, 173/256}, "EJMicroButton"},
		{"pets", {83/256, 173/256, 83/256, 173/256}, "CollectionsMicroButton"},
		{"store", {83/256, 173/256, 83/256, 173/256}, "StoreMicroButton"},
		{"help", {83/256, 173/256, 80/256, 170/256}, "MainMenuMicroButton", MicroButtonTooltipText(MAINMENU_BUTTON, "TOGGLEGAMEMENU")},
		{"bags", {47/256, 137/256, 83/256, 173/256}, ToggleAllBags, MicroButtonTooltipText(BAGSLOT, "OPENALLBAGS")},
	}
	for _, info in pairs(buttonInfo) do
		S:MicroButton_Create(menubar, info)
	end

	-- Order Positions
	for i = 1, #buttonList do
		if i == 1 then
			buttonList[i]:SetPoint("LEFT")
		else
			buttonList[i]:SetPoint("LEFT", buttonList[i-1], "RIGHT", 5, 0)
		end
	end

	-- Default elements
	B.HideObject(MicroButtonPortrait)
	B.HideObject(GuildMicroButtonTabard)
	B.HideObject(MainMenuBarDownload)
	B.HideObject(HelpOpenWebTicketButton)
	B.HideObject(MainMenuBarPerformanceBar)
	MainMenuMicroButton:SetScript("OnUpdate", nil)

	CharacterMicroButtonAlert:EnableMouse(false)
	B.HideOption(CharacterMicroButtonAlert)
end