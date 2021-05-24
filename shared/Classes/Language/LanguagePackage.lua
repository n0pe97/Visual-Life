--|**********************************************************************
--|* Project           : Visual Life Selfmade
--|* Author            : revelse
--|* Date              : 22.11.2019
--|**********************************************************************

LanguagePack = inherit(Object)

function LanguagePack:constructor(languageStrings)
    self.m_Strings = languageStrings
end

function LanguagePack:getString(key)
    return self.m_Strings[key]
end