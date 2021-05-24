--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : n0pe
--|* Date created      : 09.12.2019
--|**********************************************************************

Bank = inherit(Object)

addEvent("VL:SERVER:payIn", true)
addEvent("VL:SERVER:payOut", true)
addEvent("VL:SERVER:transfer", true)

function Bank:constructor()
    addEventHandler("VL:SERVER:payIn", root, bind(self.payIn, self))
    addEventHandler("VL:SERVER:payOut", root, bind(self.payOut, self))
    addEventHandler("VL:SERVER:transfer", root, bind(self.transfer, self))
end

function Bank:payIn(amount)
    if amount and amount > 0 then
        local amount = math.floor(tonumber(amount))
        if client:getData("money") >= amount then
            client:takeCash(amount, "Einzahlung")
            client:giveMoney(amount, "Einzahlung")
            client:sendNotification("BANK_PAYIN_SUCCESS", "success", amount)

            Logs:output("bank", "%s hat %d€ auf sein Bankkonto eingezahlt", client:getName(), amount)
        else
            client:sendNotification("BANK_PAYIN_ERROR", "error", amount - client:getData("money"))
        end
    else
        client:sendNotification("BANK_PAYIN_AMOUNT_ERROR", "error")
    end
end

function Bank:payOut(amount)
    if amount and amount > 0 then
        local amount = math.floor(tonumber(amount))
        if client:getData("bankmoney") >= amount then
            client:takeMoney(amount, "Auszahlung")
            client:giveCash(amount, "Auszahlung")
            client:sendNotification("BANK_PAYOUT_SUCCESS", "success", amount)
            client:setQuestStep(1)

            Logs:output("bank", "%s hat %d€ von seinem Bankkonto ausgezahlt", client:getName(), amount)
        else
            client:sendNotification("BANK_PAYOUT_ERROR", "error", amount - client:getData("bankmoney"))
        end
    else
        client:sendNotification("BANK_PAYOUT_AMOUNT_ERROR", "error")
    end
end

function Bank:transfer(targetName, amount, reason)
    if targetName and isElement(getPlayerFromName(targetName)) then
        if amount and amount > 0 then
            if reason and #reason > 0 then
                local target = getPlayerFromName(targetName)
                local amount = math.floor(amount)
                if client:getData("bankmoney") >= amount then
                    if client ~= target then
                        client:takeMoney(amount, "Überweisung an " .. target:getName())
                        target:giveMoney(amount, "Überweisung von " .. client:getName())

                        client:sendNotification("BANK_TRANSFER_SUCCESS", "info", target:getName(), amount, reason)
                        target:sendNotification("BANK_TRANSFER_SUCCESS_PLAYER", "info", client:getName(), amount, reason)

                        Logs:output("bank", "%s hat %s %d€ überwiesen", client:getName(), target:getName(), amount)
                    else
                        client:sendNotification("BANK_TRANSFER_PLAYER_ERROR", "error")
                    end
                end
            else
                client:sendNotification("BANK_TRANSFER_REASON_ERROR", "error")
            end
        else
            client:sendNotification("BANK_TRANSFER_AMOUNT_ERROR", "error")
        end
    else
        client:sendNotification("BANK_TRANSFER_TARGET_ERROR", "error")
    end
end