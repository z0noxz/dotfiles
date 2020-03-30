function string.htmlescape(str)
    local str = string.gsub(str, "<", "&lt;")
    str = string.gsub(str, ">", "&gt;")
    str = string.gsub(str, "&", "&amp;")
    str = string.gsub(str, "\"", "&quot;")
    str = string.gsub(str, "'", "&apos;")
    return str
end

function string.shellescape(str)
    return "'"..string.gsub(str, "'", "'\"'\"'").."'"
end

function string.starts(str,start)
    return string.sub(str, 1, string.len(start)) == start
end

function os.capture(cmd, raw)
    local f = assert(io.popen(cmd, 'r'))
    local s = assert(f:read('*a'))
    f:close()
    if raw then return s end
    s = string.gsub(s, '^%s+', '')
    s = string.gsub(s, '%s+$', '')
    s = string.gsub(s, '[\n\r]+', ' ')
    return s
end

function notify_current_track()
    local data = mp.get_property_native("metadata")
    local state = "playing"
    local artist = ""
    local title = ""
    local media_title = ""
    local body = ""
    local command = ""

    if not data then
        return
    end

    if mp.get_property_native("pause") then
        state = "paused"
    end

    function get_metadata(data, keys)
        for _,v in pairs(keys) do
            if data[v] and string.len(data[v]) > 0 then
                return data[v]
            end
        end
        return ""
    end

    artist = get_metadata(data, {"artist", "ARTIST"})
    title = get_metadata(data, {"title", "TITLE", "icy-title"})
    media_title = mp.get_property_native("media-title")

    -- soundcloud user and title
    if string.starts(mp.get_property_native("path"), "https://api.soundcloud.com/tracks/") then
        body = string.shellescape(("%s: %s"):format(
            state,
            os.capture(("sscw-track %s"):format(
                string.shellescape(mp.get_property_native("filename"))
            ))
        ))
    -- filename only
    elseif title ~= "" then
        -- title only
        if artist == "" then
            body = string.shellescape(("%s: %s"):format(
                state,
                string.htmlescape(title)
            ))
        -- artist and title
        else
            body = string.shellescape(("%s: %s - %s"):format(
                state,
                string.htmlescape(artist),
                string.htmlescape(title)
            ))
        end
    -- media_title fallback
    elseif media_title ~= "" then
        body = string.shellescape(("%s: %s"):format(
            state,
	    media_title
        ))
    -- filename fallback
    else
        body = string.shellescape(("%s: %s"):format(
            state,
            mp.get_property_native("filename")
        ))
    end

	os.execute(("printf %s > /tmp/ztatus.fifo"):format(body))
end

function notify_metadata_updated(name, value)
    notify_current_track()
end

function notify_pause_change(name, value)
    notify_current_track()
end


mp.register_event("file-loaded", notify_current_track)
mp.observe_property("metadata", nil, notify_metadata_updated)
mp.observe_property("pause", "bool", notify_pause_change)
