@def published = "2018-08-10 00:00:00 +0000"
@def title = "Guilloches"
@def authors = """Cormullion"""
@def hascode = true
@def rss = "Making guilloches patterns using the geometric lathe...  ![hypotrochoid](/assets/images/guilloches/julia-hypotrochoid.png)"
@def rss_pubdate = Date(2018, 08, 10)
@def rss_author = "cormullion"

This year's Julia conference is nearly over, and [JuliaCon 2018](http://juliacon.org/2018/) has been a great success. I wasn't able to attend in person, but there were numerous live video streams, and many tweeters kept everyone around the world up to date. There was even a [live-streamed github commit](https://www.youtube.com/watch?v=1jN5wKvN-Uk&t=749s&index=2&list=PLP8iPy9hna6Qsq5_-zrg0NTwqDSDYtfQB&frags=pl%2Cwn) of the 1.0 release! So thanks to you all and to the audio-visual folks for enabling us to attend in spirit.

I was fortunate enough to be allowed to contribute in a very small way. Avik asked me to help with making certificates to be presented to the winners of the [Julia Community Prizes](http://juliacon.org/2018/prize.html). These certificates were made with Julia (of course!); here's a slightly modified (unofficial, unsigned!) version of the certificate. I've added all the winner's names and their citations.

[![guilloches](/assets/images/guilloches/juliacon2018prizecertificate.png)]
(/images/guilloches/juliacon2018prizecertificate.pdf)

I tried to make a modern-looking certificate while still hinting at some of the traditional graphical techniques of elaborate ornamental linework. This is often known as *guilloches* or *guillochés*, and has been used for centuries, not only for decoration on watches and jewellery, but also on all kinds of printed matter as a way of dissuading hopeful copiers and forgers. They were often engraved onto metal plates using *geometric lathes*, which occasionally were known as *rose engine*s. There’s speculation that the name ‘guilloches’ comes from a Swiss or French craftsman called Guillot, but that’s probably not true.

(I don’t think forgeries are going to be an issue for this certificate!)

Before the 20th century, guilloches would have warned the less enterprising forger away from attempting unauthorized reproductions. With the advent of modern digital technologies, forging and anti-forging techniques have become much more sophisticated, but the ornamental swirls are still retained *skeuomorphically*, no longer fulfilling their original role but maintained for their visual interest and beauty.

~~~ <img src="/assets/images/guilloches/guilloches-background.png" /> ~~~

There are many possible approaches, sometimes based on hypotrochoids, but often using simpler parametric equations. Mathematically they can be very straightforward; here's a simple example (given suitable values for the `k` constants):

```julia
@svg begin
    setline(0.5)
    poly([
        Point(e^(-k₁ * t) * (r * cos(k₃ * t + 1)) +
              e^(-k₂ * t) * (r * cos(k₄ * t + 1)),
              e^(-k₁ * t) * (r * sin(k₅ * t + 2)) +
              e^(-k₂ * t) * (r * sin(k₆ * t + 1)))
        for t in 0:0.05:500], :stroke)
end
```

~~~ <img src="/assets/images/guilloches/simple.png" /> ~~~

If you change the parameters slowly, they have the peculiar ability to look like they're rotating in 3D space:

~~~ <img src="/assets/images/guilloches/animated-guilloches.gif" /> ~~~

In a way, these guilloches curves were like visual cryptography. If the artist kept the values of the constants secret, and only the resulting curves were seen, others will be unable to reproduce exactly the same curves even if they had access to the same machinery. Of course, today you could probably analyse the curves well enough to find out the original constants, but it must have deterred the more mathematically-challenged forgers back in the day.

Guillochéd bank notes are often very beautiful. They can be found on the internet, despite the general reluctance to reproduce currency.

~~~<a title="Godot13 / Smithsonian Institution [Public domain], via Wikimedia Commons" href="https://commons.wikimedia.org/wiki/File:SWI-11b-Confederation_Schweizerische_Nationalbank-5_Franken_(1914).jpg" target="_blank"><img width="512" alt="SWI-11b-Confederation Schweizerische Nationalbank-5 Franken (1914)"  src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/SWI-11b-Confederation_Schweizerische_Nationalbank-5_Franken_%281914%29.jpg/512px-SWI-11b-Confederation_Schweizerische_Nationalbank-5_Franken_%281914%29.jpg"></a>~~~

Some of these patterns could be hypotrochoids. I added a `hypotrochoid()` function ages ago, but it's usually gathering dust: perhaps it would have been useful for this project.

~~~<img src="/assets/images/guilloches/julia-hypotrochoid.png" />~~~

```julia
@svg begin
   background("ivory")
   translate(-200, -200)
   scale(1.2)
   julialogo(action=:clip)
   setline(0.2)
   for i in 1:30
      @layer begin
          randomhue()
          translate(rand(-250:250), rand(-250:250))
          hypotrochoid(250, 181, 153, :stroke)
      end
   end
   clipreset()
end 500 500 "/tmp/s.svg"
```

The patterns also remind me of the results made by the Harmonograph, a old 19th century device, probably made of brass and mahogany, with two or more pendulums that trace out the interactions of the simple harmonic motions as the pendulums lose velocity. These devices became popular during the 19th century, and gentlemen and ladies would attend soirées and ‘conversaziones’, watching with delight as the images were slowly revealed. My SVG original image takes only a few seconds to generate, and a bit longer to open in a web browser: I like the quality of the SVG output, but the 70 MB files are a bit bulky.

Anti-forging techniques have progressed a lot since the heyday of the guilloches, and I expect that there's a lot more going on in the field than reaches the public internet, for obvious reasons. [This old (1999) brochure](https://www.snb.ch/en/mmr/reference/series8_brochure/source/series8_brochure.en.pdf) from the Swiss National Bank has a quick introduction to some of them, including the Kinegram, Optically Variable Ink, ultraviolet, intaglio, and watermarked digits, but—the less they tell you, the better the security.

All of which doesn't—I hope—detract from the achievements of the winners of this year's Julia Community prize. Congratulations!

[2018-08-10]

![cormullion signing off](http://steampiano.net/cormullionknot.gif?guilloches)
