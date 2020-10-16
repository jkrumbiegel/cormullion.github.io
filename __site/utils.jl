using FranklinUtils, Franklin, Markdown

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
usage \\drawunicodechar{0x2a, 0x2020, 0x2021, 0xa7, 0xb6, 0x2225, 0x2042}

draw the unicode character from its numeric code

_assets/images/POSTNAME

"""
function lx_drawunicodechar(lxc, _)
    args, kwargs = lxargs(lxc)

    # args is Any[0x2a, 0x2020, 0x2021, 0xa7, 0xb6, 0x2225, 0x2042]

    s =  join(string.(args, base=16), "_")
    s =  replace(s, " " => "")

    dir = lowercase(locvar("title"))
    filename = "unicodechar-$(s).svg"
    pathname = "_assets/images/$(dir)/" * filename

    Drawing(600, 120, pathname)
    origin()
    fontface("JuliaMono-Regular")

    t = Tiler(600, 120, 1, length(args))
    fontsize(t.tileheight)
    for (pos, n) in t
        s = string(Char(args[n]))

        if 0x300 < args[n] < 0x3ff ||
           0x20D0 < args[n] < 0x20FF
            text(string(" ", s), pos, halign=:left, valign=:middle)
        else
            text(s, pos, halign=:center, valign=:middle)
        end
        @layer begin
            fontsize(10)
            sethue("skyblue")
            unicp = args[n]
            hs = string("\\u", lpad(string(unicp, base=16), 4 , "0"))
            text(hs, Point(pos.x, 10 + t.tileheight/2), halign=:center)
        end
    end
    finish()

    # might need to work round svg DOM bugs in browsers?
    tidiedfile = tidysvg(pathname)
    tidiedfile = replace(tidiedfile, "_assets" => "/assets")

    return "![]($(tidiedfile))"
end

"""

usage \\drawunicodestring{"x ∗+= y"}

draws all the Unicode characters

"""
function lx_drawunicodestring(lxc, _)
    args, kwargs = lxargs(lxc)

    # not sure why this needs escaping
    str = join(args)

    dir = lowercase(locvar("title"))

    hashed = hash(str)

    filename = "unicodestring-$(hashed).svg"
    pathname = "_assets/images/$(dir)/" * filename

    str = replace(str, "hash" => "#")
    fontface("JuliaMono-Regular")
    fsize = 200

    #get fontsize
    @draw begin
        fontsize(fsize)
        te = textextents(str)
        # width too big?
        while te[3] > 600
            fsize -= 5
            fontsize(fsize)
            te = textextents(str)
        end
        while te[4] > 100
            fsize -= 5
            fontsize(fsize)
            te = textextents(str)
        end
    end

    Drawing(600, 200, pathname)
    fontface("JuliaMono-Regular")
    origin()
    fontsize(fsize)
    text(str, O, halign=:center, valign=:middle)
    finish()

    # might need to work round svg DOM bugs in browsers?
    tidiedfile = tidysvg(pathname)
    tidiedfile = replace(tidiedfile, "_assets" => "/assets")
    rm(pathname)
    return "![image]($(tidiedfile))"
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
