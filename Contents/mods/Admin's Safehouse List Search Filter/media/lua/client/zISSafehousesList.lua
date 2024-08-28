local ISSafehousesList_initialise = ISSafehousesList.initialise

function ISSafehousesList:initialise()
    ISSafehousesList_initialise(self)
    self.searchField = ISTextEntryBox:new("", self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, getText("IGUI_AdminPanel_SeeSafehouses")) / 2), 40, 100, 10);
        self.searchField:initialise()
        self.searchField.tooltip = getText("ContextMenu_searchTip")
        self.searchField.onTextChange = function()
            local searchFilter = self.searchField:getInternalText()
            self:populateList(searchFilter)
        end
    self.searchField.backgroundColor = { r = 0, g = 0, b = 0, a = 1 }
    self:addChild(self.searchField)
    self.searchField:setVisible(true)
end

function ISSafehousesList:render()

    if self.searchField:isVisible() then
        local x
        local y
        x = 85
        y = 3
        self.searchField:drawTexture(getTexture("media/ui/searchicon.png"), x, y, 1, 1, 1, 1)
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






-- Function to calculate Jaccard similarity between two strings by Vorshim
-- function Vorshim.stringSimilarity(a, b)
--     -- Function to generate bigrams from a string
--     local function generateBigrams(str)
--         local bigrams = {}
--         for i = 1, #str - 1 do
--             local bigram = str:sub(i, i + 1)
--             bigrams[bigram] = (bigrams[bigram] or 0) + 1
--         end
--         return bigrams
--     end

--     -- Generate bigrams for both strings
--     local bigramsA = generateBigrams(a)
--     local bigramsB = generateBigrams(b)

--     -- Calculate intersection and union sizes
--     local intersection = 0
--     local union = 0

--     for bigram, countA in pairs(bigramsA) do
--         local countB = bigramsB[bigram] or 0
--         intersection = intersection + math.min(countA, countB)
--         union = union + math.max(countA, countB)
--     end

--     -- Add the remaining bigrams from B that are not in A to the union
--     for bigram, countB in pairs(bigramsB) do
--         if not bigramsA[bigram] then
--             union = union + countB
--         end
--     end

--     if union == 0 then
--         return 0
--     else
--         return intersection / union
--     end
-- end
