--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : revelse
--|* Date              : 22.11.2019
--|**********************************************************************

Localization = inherit(Singleton)

function Localization:constructor()
    self.m_IsServer = type(triggerClientEvent) == "function"

    self.m_Language = {}
    self.m_LanguagePack = {}

    self:loadLanguagePackages()
end

function Localization:loadLanguagePackages()
    self:addLanguagePack("DE", Localization.German)
    self:addLanguagePack("EN", Localization.English)
end

function Localization:isClientSide()
    return not self.m_IsServer
end

function Localization:addLanguagePack(name, strings)
    self.m_LanguagePack[name] = strings
end

function Localization:getLanguage(string, player)
    local language
    if self:isClientSide() then
        language = getElementData(localPlayer, "language") or config:get("language")
    else
        language = getElementData(player, "language")
    end
    if self.m_LanguagePack[language] and self.m_LanguagePack[language][string] then
        return self.m_LanguagePack[language][string]
    elseif self.m_LanguagePack["EN"] and self.m_LanguagePack["EN"][string] then
        return self.m_LanguagePack["EN"][string]
    else
        return string
    end
end

function loc(string, player)
    return Localization:getSingleton():getLanguage(string, player)
end

function Localization:destructor()
end