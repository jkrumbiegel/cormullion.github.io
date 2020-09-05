"""
make a list of blog posts for inclusion on home page
"""
function hfun_blogposts()
    list = readdir("pages")
    filter!(f -> endswith(f, ".md"), list)
    filter!(f -> !occursin("draft", f), list)
    sort!(list, rev=true)
    io = IOBuffer()
    @info " ... updating post list"
    write(io, "
")
    write(io, "<div class=\"postlist\">\n")
    write(io, "    <div class=grid>\n")
    for (k, i) in enumerate(list)
        title = open(joinpath("pages", i)) do f
            r = read(f, String)
            m = match(r"@def title = \"(.*?)\"", r)
            return string(first(m.captures))
        end
        @info " .... processing page $title"
        pagename = first(splitext(i))
        postdate = pagename[1:10]
        k = "     <p><a href=\"/pages/$(pagename)/\">$(title)</a> $(postdate) </p>"
        write(io, """ $k\n""")
    end
    write(io, "    </div>\n")
    write(io, "</div>\n")
    write(io, "
")
    return String(take!(io))
end

using Luxor, Dates

"""
usage {{ drawunicodechar 0x002A }}

draw the unicode character from its numeric code

I don't yet understand paths in franklin properly, so I've
hard coded them...
"""
function hfun_drawunicodechar(ca)
    @info pwd()
    filename = "unicodechar-$(join(ca, "")).svg"
    pathname = "_assets/images/asterisk/" * filename

    Drawing(600, 130, pathname)
    origin()
    fontface("JuliaMono-Regular")

    t = Tiler(600, 130, 1, length(ca))
    fontsize(t.tileheight)
    for (pos, n) in t
        s = string(Char(parse(Int, ca[n])))

        if 0x300 < parse(Int, ca[n]) < 0x3ff ||
           0x20D0 < parse(Int, ca[n]) < 0x20FF
            text(string(" ", s), pos, halign=:left, valign=:middle)
        else
            text(s, pos, halign=:center, valign=:middle)
        end
        @layer begin
            fontsize(10)
            sethue("skyblue")
            unicp = parse(Int, ca[n])
            hs = string("\\u", lpad(string(unicp, base=16), 4 , "0"))
            text(hs, Point(pos.x, 10 + t.tileheight/2), halign=:center)
        end
    end
    finish()
    # might need to work round svg DOM bugs in browsers?
    tidiedfile = tidysvg(pathname)
    tidiedfile = replace(tidiedfile, "_assets" => "/assets")
    io = IOBuffer()
    write(io, "<img src=\"$(tidiedfile)\" >")
    return String(take!(io))
end

function hfun_drawunicodestring(s)
        @info pwd()
    str = replace(join(s), "*" => "*")
    str = replace(str, "#" => "#")
    str = replace(str, "|" => "bar")
    filename = "unicode-string-$(join(str, "")).svg"
    pathname = "_assets/images/asterisk/" * filename

    Drawing(600, 130, pathname)
    origin()
    fontface("JuliaMono-Regular")

    fsize = 200
    fontsize(fsize)
    str = join(s, " ")

    te = textextents(str)
    # width too big?
    while te[3] > 400
        fsize -= 5
        fontsize(fsize)
        te = textextents(str)
    end

    text(str, O, halign=:center, valign=:middle)
    finish()

    tidiedfile = tidysvg(pathname)
    tidiedfile = replace(tidiedfile, "_assets" => "/assets")

    io = IOBuffer()
    write(io, "<img src=\"$(tidiedfile)\" >")
    return String(take!(io))
end

"""
    \\unicode{0x2400}

inserts unicode character from an integer (hex, decimal...)
"""
function lx_unicode(com, _) # the signature must look like this
    # leave this first line, it extracts the content of the brace
    content = Franklin.content(com.braces[1])
    return string(Char(parse(Int, content)))
end
