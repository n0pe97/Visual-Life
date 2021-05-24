--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date              : 30.11.2019
--|**********************************************************************

BankGUI = inherit(Object)

addEvent("VL:CLIENT:showBank", true)

local width, height = 700 * (screenWidth / 1920), 450 * (screenHeight / 1080)
local x, y = screenWidth / 2 - width / 2, screenHeight / 2 - height / 2

function BankGUI:constructor()
    addEventHandler("VL:CLIENT:showBank", root, bind(self.show, self))
end

function BankGUI:show()
    self:hide()

    self.m_Window = GUIWindow:new(x, y, width, height, loc("BANK_TITLE"), tocolor(0, 125, 0, 255), false, true, false)

    self.m_Home = GUIButton:new(0 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_HOME"), tocolor(15, 15, 15, 255), self.m_Window)
    self.m_Transaktion = GUIButton:new(175 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_TRANSAKTION"), tocolor(15, 15, 15, 255), self.m_Window)
    self.m_Transfer = GUIButton:new(350 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_TRANSFER"), tocolor(15, 15, 15, 255), self.m_Window)
    self.m_Statements = GUIButton:new(525 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_STATEMENTS"), tocolor(15, 15, 15, 255), self.m_Window)

    GUIInfo:new(35 * screenWidth / 1920, 140 * screenHeight / 1080, 315, 60, loc("BANK_BANKMONEY"), tocolor(0, 125, 0, 255), "", Settings.Color.White, self.m_Window)
    GUIInfo:new(35 * screenWidth / 1920, 240 * screenHeight / 1080, 315, 60, loc("BANK_MONEY"), tocolor(0, 125, 0, 255), "", Settings.Color.White, self.m_Window)
    GUIInfo:new(380 * screenWidth / 1920, 140 * screenHeight / 1080, 285, 270, loc("BANK_INFORMATION"), tocolor(0, 125, 0, 255), loc("BANK_HOME_TEXT"), Settings.Color.White, self.m_Window)

    GUIImage:new("res/Images/GUI/Bank/bankmoney.png", 50 * screenWidth / 1920, 155 * screenHeight / 1080, 28, 28, self.m_Window)
    GUIImage:new("res/Images/GUI/Bank/money.png", 50 * screenWidth / 1920, 255 * screenHeight / 1080, 28, 28, self.m_Window)

    GUILabel:new(35 * screenWidth / 1920, 157 * screenHeight / 1080, 300, 20, comma_value(loc("BANK_BANKCASH"):format(localPlayer:getData("bankmoney"))), Settings.Color.White, 1.6, self.m_Window, "right", "center")
    GUILabel:new(35 * screenWidth / 1920, 257 * screenHeight / 1080, 300, 20, comma_value(loc("BANK_BARCASH"):format(localPlayer:getData("money"))), Settings.Color.White, 1.6, self.m_Window, "right", "center")

    self.m_Home.onLeftClickDown = bind(self.show, self)
    self.m_Transaktion.onLeftClickDown = bind(self.showTransaktion, self)
    self.m_Transfer.onLeftClickDown = bind(self.showTransfer, self)
    self.m_Statements.onLeftClickDown = bind(self.showStatements, self)
end

function BankGUI:showTransaktion()
    self:hide()

    self.m_TransaktionWindow = GUIWindow:new(x, y, width, height, loc("BANK_TITLE"), tocolor(0, 125, 0, 255), false, true, false)

    self.m_Home = GUIButton:new(0 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_HOME"), tocolor(15, 15, 15, 255), self.m_TransaktionWindow)
    self.m_Transaktion = GUIButton:new(175 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_TRANSAKTION"), tocolor(15, 15, 15, 255), self.m_TransaktionWindow)
    self.m_Transfer = GUIButton:new(350 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_TRANSFER"), tocolor(15, 15, 15, 255), self.m_TransaktionWindow)
    self.m_Statements = GUIButton:new(525 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_STATEMENTS"), tocolor(15, 15, 15, 255), self.m_TransaktionWindow)
    self.m_PayIn = GUIButton:new(35 * screenWidth / 1920, 255 * screenHeight / 1080, 135 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_PAYIN"), tocolor(0, 125, 0, 255), self.m_TransaktionWindow)
    self.m_PayOut = GUIButton:new(200 * screenWidth / 1920, 255 * screenHeight / 1080, 135 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_PAYOUT"), tocolor(0, 125, 0, 255), self.m_TransaktionWindow)

    GUILabel:new(35 * screenWidth / 1920, 110 * screenHeight / 1080, 300, 30, loc("BANK_PAYIN_PAYOUT"), tocolor(0, 125, 0, 255), 1.3, self.m_TransaktionWindow)
    GUILabel:new(35 * screenWidth / 1920, 160 * screenHeight / 1080, 300, 30, loc("BANK_AMOUNT"), Settings.Color.White, 1.1, self.m_TransaktionWindow)

    self.m_Edit = GUIEdit:new(35 * screenWidth / 1920, 200 * screenHeight / 1080, 300, 40, self.m_TransaktionWindow)

    GUIInfo:new(380 * screenWidth / 1920, 140 * screenHeight / 1080, 285, 270, loc("BANK_INFORMATION"), tocolor(0, 125, 0, 255), loc("BANK_HOME_TEXT"), Settings.Color.White, self.m_TransaktionWindow)

    self.m_Home.onLeftClickDown = bind(self.show, self)
    self.m_Transaktion.onLeftClickDown = bind(self.showTransaktion, self)
    self.m_Transfer.onLeftClickDown = bind(self.showTransfer, self)
    self.m_Statements.onLeftClickDown = bind(self.showStatements, self)
    self.m_PayIn.onLeftClickDown = bind(self.payIn, self)
    self.m_PayOut.onLeftClickDown = bind(self.payOut, self)
end

function BankGUI:showTransfer()
    self:hide()

    self.m_TransferWindow = GUIWindow:new(x, y, width, height, loc("BANK_TITLE"), tocolor(0, 125, 0, 255), false, true, false)

    self.m_Home = GUIButton:new(0 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_HOME"), tocolor(15, 15, 15, 255), self.m_TransferWindow)
    self.m_Transaktion = GUIButton:new(175 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_TRANSAKTION"), tocolor(15, 15, 15, 255), self.m_TransferWindow)
    self.m_Transfer = GUIButton:new(350 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_TRANSFER"), tocolor(15, 15, 15, 255), self.m_TransferWindow)
    self.m_Statements = GUIButton:new(525 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_STATEMENTS"), tocolor(15, 15, 15, 255), self.m_TransferWindow)

    GUILabel:new(35 * screenWidth / 1920, 110 * screenHeight / 1080, 300, 30, loc("BANK_TRANSFER_TEXT"), tocolor(0, 125, 0, 255), 1.3, self.m_TransferWindow)

    GUILabel:new(35 * screenWidth / 1920, 140 * screenHeight / 1080, 300, 30, loc("BANK_TARGET_TEXT"), Settings.Color.White, 1.1, self.m_TransferWindow)
    self.m_TargetEdit = GUIEdit:new(35 * screenWidth / 1920, 170 * screenHeight / 1080, 300, 40, self.m_TransferWindow)

    GUILabel:new(35 * screenWidth / 1920, 220 * screenHeight / 1080, 300, 30, loc("BANK_AMOUNT"), Settings.Color.White, 1.1, self.m_TransferWindow)
    self.m_AmountEdit = GUIEdit:new(35 * screenWidth / 1920, 250 * screenHeight / 1080, 300, 40, self.m_TransferWindow)

    GUILabel:new(35 * screenWidth / 1920, 300 * screenHeight / 1080, 300, 30, loc("BANK_REASON_TEXT"), Settings.Color.White, 1.1, self.m_TransferWindow)
    self.m_ReasonEdit = GUIEdit:new(35 * screenWidth / 1920, 330 * screenHeight / 1080, 300, 40, self.m_TransferWindow)

    self.m_TransferButton = GUIButton:new(35 * screenWidth / 1920, 390 * screenHeight / 1080, 150, 40, loc("BANK_TRANSFER_BUTTON"), tocolor(0, 125, 0, 255), self.m_TransferWindow)

    GUIInfo:new(380 * screenWidth / 1920, 140 * screenHeight / 1080, 285, 270, loc("BANK_INFORMATION"), tocolor(0, 125, 0, 255), loc("BANK_HOME_TEXT"), Settings.Color.White, self.m_TransferWindow)

    self.m_Home.onLeftClickDown = bind(self.show, self)
    self.m_Transaktion.onLeftClickDown = bind(self.showTransaktion, self)
    self.m_Transfer.onLeftClickDown = bind(self.showTransfer, self)
    self.m_Statements.onLeftClickDown = bind(self.showStatements, self)
    self.m_TransferButton.onLeftClickDown = bind(self.transfer, self)
end

function BankGUI:showStatements()
    self:hide()

    self.m_StatementWindow = GUIWindow:new(x, y, width, height, loc("BANK_TITLE"), tocolor(0, 125, 0, 255), false, true, false)

    self.m_Home = GUIButton:new(0 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_HOME"), tocolor(15, 15, 15, 255), self.m_StatementWindow)
    self.m_Transaktion = GUIButton:new(175 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_TRANSAKTION"), tocolor(15, 15, 15, 255), self.m_StatementWindow)
    self.m_Transfer = GUIButton:new(350 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_TRANSFER"), tocolor(15, 15, 15, 255), self.m_StatementWindow)
    self.m_Statements = GUIButton:new(525 * screenWidth / 1920, 50 * screenHeight / 1080, 175 * screenWidth / 1920, 40 * screenHeight / 1080, loc("BANK_STATEMENTS"), tocolor(15, 15, 15, 255), self.m_StatementWindow)

    self.m_Grid = GUIGridlist:new(35 * screenWidth / 1920, 110 * screenHeight / 1080, width - 70, height - 140, tocolor(0, 125, 0, 255), { { "Datum", 200 }, { "Betrag", 150 }, { "Sonstiges", 300 } }, banksheet:get(), self.m_StatementWindow)

    self.m_Home.onLeftClickDown = bind(self.show, self)
    self.m_Transaktion.onLeftClickDown = bind(self.showTransaktion, self)
    self.m_Transfer.onLeftClickDown = bind(self.showTransfer, self)
    self.m_Statements.onLeftClickDown = bind(self.showStatements, self)
end

function BankGUI:payIn()
    triggerServerEvent("VL:SERVER:payIn", localPlayer, tonumber(self.m_Edit:getText()))
end

function BankGUI:payOut()
    triggerServerEvent("VL:SERVER:payOut", localPlayer, tonumber(self.m_Edit:getText()))
end

function BankGUI:transfer()
    triggerServerEvent("VL:SERVER:transfer", localPlayer, self.m_TargetEdit:getText(), tonumber(self.m_AmountEdit:getText()), self.m_ReasonEdit:getText())
end

function BankGUI:hide()
    if self.m_Window then self.m_Window:close() end
    if self.m_TransaktionWindow then self.m_TransaktionWindow:close() end
    if self.m_TransferWindow then self.m_TransferWindow:close() end
    if self.m_StatementWindow then self.m_StatementWindow:close() end
end