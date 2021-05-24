GUICursor = inherit(Singleton)

function GUICursor:constructor()
    setCursorAlpha(255)

    bindKey("m", "down", function() showCursor(not isCursorShowing()) end)
end

function GUICursor:destructor()
    setCursorAlpha(255)
end