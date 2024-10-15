function Inlines(inlines)
    local count_opening = 0
    local count_closing = 0
    local opening = true
    local delete
    if inlines == nil then return inlines end
    for n=1, #inlines do
        local r = ""
        local s = inlines[n].text

        if s ~= nil then
            if string.match(s, ',,') then
                for i=1, #s do
                    local char = string.sub(s, i, i)
                    if char == ","
                        and string.sub(s, i+1, i+1) == ","
                        and delete ~= i then
                        delete = i + 1
                        if opening == true then
                            r = r .. "<!--"
                            opening = false
                            count_opening = count_opening + 1
                        else
                            r = r .. "-->"
                            count_closing = count_closing + 1
                            opening = true
                        end
                    elseif delete == i then
                        delete = nil
                    else
                        r = r .. char
                    end
                    inlines[n] = pandoc.RawInline('html', r)
                end
            end
        end
    end
    if count_closing == count_opening then
        return inlines
    else
        return nil
    end
end
