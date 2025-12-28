local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local UI_BORDER_SPACING = 10
local BUTTON_HGT = FONT_HGT_SMALL + 6

local ISSafehousesList_initialise = ISSafehousesList.initialise
local ISSafehousesList_render = ISSafehousesList.render

function ISSafehousesList:initialise()
    ISSafehousesList_initialise(self)

    -- Posiziona il searchField tra titolo e lista
    local searchY = UI_BORDER_SPACING*2 + FONT_HGT_MEDIUM + 5
    local searchWidth = 150
    self.searchField = ISTextEntryBox:new("", self.width/2 - searchWidth/2, searchY, searchWidth, BUTTON_HGT)
    self.searchField:initialise()
    self.searchField:instantiate()
    self.searchField.tooltip = getText("ContextMenu_searchTip")
    self.searchField.onTextChange = function()
        local searchFilter = self.searchField:getInternalText()
        self:populateList(searchFilter)
    end
    self.searchField.backgroundColor = { r = 0, g = 0, b = 0, a = 1 }
    self:addChild(self.searchField)

    -- Sposta la lista più in basso per fare spazio al searchField
    local extraSpace = BUTTON_HGT + UI_BORDER_SPACING
    self.datas:setY(self.datas:getY() + extraSpace)
    self.datas:setHeight(self.datas:getHeight() - extraSpace)
end

function ISSafehousesList:render()
    if ISSafehousesList_render then
        ISSafehousesList_render(self)
    end

    if self.searchField and self.searchField:isVisible() then
        -- Disegna icona a sinistra del campo di ricerca
        local iconX = self.searchField:getX() - 20
        local iconY = self.searchField:getY() + 2
        self:drawTexture(getTexture("media/ui/searchicon.png"), iconX, iconY, 1, 1, 1, 1)
    end
end



function ISSafehousesList:populateList(searchFilter)
    self.datas:clear()
    local matchingSafehouses = {}
    local nonMatchingSafehouses = {}
    
    -- Converti il filtro di ricerca in minuscolo per una comparazione case-insensitive
    local searchFilterLower = string.lower(searchFilter or "")

    for i = 0, SafeHouse.getSafehouseList():size() - 1 do
        local safe = SafeHouse.getSafehouseList():get(i)
        local ownerName = string.lower(safe:getOwner())

        -- Controlla se il nome del proprietario contiene la stringa di ricerca
        local match = string.find(ownerName, searchFilterLower)
        if match then
            table.insert(matchingSafehouses, safe)
        else
            table.insert(nonMatchingSafehouses, safe)
        end
    end

    -- Concatenare le safehouse ordinate con quelle non corrispondenti
    local sortedSafehouses = matchingSafehouses
    for _, safe in ipairs(nonMatchingSafehouses) do
        table.insert(sortedSafehouses, safe)
    end

    -- Aggiunge le safehouse ordinate alla lista
    for _, safe in ipairs(sortedSafehouses) do
        self.datas:addItem(safe:getTitle(), safe)
    end
end
