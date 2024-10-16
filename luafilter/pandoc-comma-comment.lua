local function remove_comma_comment(s, iscomment)
    local new = ""
    local prev = ''
    local cur = ''
    for i=1, #s do
        prev = cur
        cur = string.sub(s, i, i)
        if prev == ',' and cur == ',' then
            iscomment = not iscomment
        elseif cur ~= ',' and iscomment ~= true then
            new = new .. cur
        end
    end
    return new, iscomment
end

function Inlines(inlines)
    local iscomment = false
    local new = nil
    if inlines == nil then return inlines end
    for n=1, #inlines do
        local s = inlines[n].text
        if s ~= nil then
            new, iscomment = remove_comma_comment(s, iscomment)
            inlines[n].text = new
        end
    end
    return inlines
end
