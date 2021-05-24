GUIInput = {}
GUIInput.ms_CurrentFocus        = nil
GUIInput.ms_InternalEdit        = guiCreateEdit(0, 0, 1, 1, "", false)
GUIInput.ms_PreviousInput       = ""
GUIInput.ms_SkipChangedEvent    = false
GUIInput.ms_OldCaretIndex       = 0
guiSetAlpha(GUIInput.ms_InternalEdit, 0)

function GUIInput.constructor()
    error("Cannot create a new GUIInput")
end

function GUIInput.destructor()
    guiSetInputEnabled(false)    
end

function GUIInput.setFocus(guiEdit, caret)
    -- Check if a focus input exists
    if GUIInput.ms_CurrentFocus and GUIInput.ms_CurrentFocus ~= guiEdit then
        local edit = GUIInput.ms_CurrentFocus
        edit:onInternalLooseFocus()
        if edit.onLooseFocus then edit:onLooseFocus() end
    end

    -- Rewrite
    GUIInput.ms_CurrentFocus = guiEdit
    GUIInput.ms_PreviousInput = guiGetText(GUIInput.ms_InternalEdit)

    -- Change focus
    if guiEdit then
        -- Create a small mutex
        GUIInput.ms_SkipChangedEvent = true

        guiBringToFront(GUIInput.ms_InternalEdit)
        GUIInput.ms_OldCaretIndex = guiEditGetCaretIndex(GUIInput.ms_InternalEdit)
        guiSetInputEnabled(true)
        guiSetText(GUIInput.ms_InternalEdit, guiEdit:getText())

        -- Unlock it
        GUIInput.ms_SkipChangedEvent = false

        -- Adapt caret index
        if caret then
            guiEditSetCaretIndex(GUIInput.ms_InternalEdit, tonumber(caret))
        else
            guiEditSetCaretIndex(GUIInput.ms_InternalEdit, utfLen(guiEdit:getText()))
        end

        -- Trigger element's events
        guiEdit:onInternalFocus()
        if guiEdit.onFocus then guiEdit:onFocus() end
    else
        guiSetInputEnabled(false)
    end
end

function GUIInput.checkFocus(guiElement)
    if GUIInput.ms_CurrentFocus ~= guiElement then
        GUIInput.setFocus()
    end
end

addEventHandler("onClientGUIChanged", GUIInput.ms_InternalEdit,
    function()
        -- Check changed mutex
        if GUIInput.ms_SkipChangedEvent then return end

        -- Obtain focused element
        local e = GUIInput.ms_CurrentFocus
        if e then
            local text = guiGetText(source)

            -- Check edit types
            if e:isNumeric() then
                if e:isIntOnly() then
                    if (text == "" or pregFind(text, '^[0-9]*$')) and utfLen(text) <= e.m_MaxLength and tonumber(text == "" and 0 or text) <= e.m_MaxValue then
						GUIInput.ms_PreviousInput = text
						e:setText(text)
					else
						guiSetText(source, GUIInput.ms_PreviousInput or "") -- Triggers onClientGUIChanged again
					end
                else
                    if (tonumber(text) or text == "") and utfLen(text) <= e.m_MaxLength and tonumber(text == "" and 0 or text) <= e.m_MaxValue then
						GUIInput.ms_PreviousInput = text
						e:setText(text)
					else
						guiSetText(source, GUIInput.ms_PreviousInput or "") -- Triggers onClientGUIChanged again
					end
                end
            else
                if utfLen(text) <= e.m_MaxLength then
					GUIInput.ms_PreviousInput = text
					e:setText(text)
				else
					guiSetText(source, GUIInput.ms_PreviousInput or "")
				end
            end

            -- Trigger element's events
            if e.onInternalEditInput then e:onInternalEditInput(guiEditGetCaretIndex(source)) end
            if e.onEditInput then e:onEditInput(guiEditGetCaretIndex(source)) end
        end
    end
)

addEventHandler("onClientPreRender", root,
    function()
        if GUIInput.ms_CurrentFocus then
            local caret = guiEditGetCaretIndex(GUIInput.ms_InternalEdit)
            if caret ~= GUIInput.ms_OldCaretIndex then
                GUIInput.ms_CurrentFocus:setCaretPosition(caret)
                GUIInput.ms_OldCaretIndex = caret
            end
        end
    end
)

local function getNextEditBox(baseElement, startElement)
    local children = baseElement:getChildren()
    local idx = table.find(children, startElement)

    -- Check all elements after the start element
    for i = idx + 1, #children, 1 do 
        if instanceof(children[i], GUIInput, true) then
            return children[i]
        end
    end

    -- Check all elements before the start element
    for i = 0, idx - 1, 1 do
        if instanceof(children[i], GUIInput, true) then
            return children[i]
        end
    end

    -- Default case
    return false
end

addEventHandler("onClientKey", root,
    function(button, state)
        if button == "tab" and state then
            local e = GUIInput.ms_CurrentFocus
            if e then
                local newEdit = getNextEditBox(e:getParent(), e)
                if newEdit then
                    GUIInput.setFocus(newEdit, 0)
                end
            end
        end
    end
)