:set -XOverloadedStrings
:set prompt ""

import Sound.Tidal.Context

import System.IO (hSetEncoding, stdout, utf8)
hSetEncoding stdout utf8

-- total latency = oLatency + cFrameTimespan
tidal <- startTidal (superdirtTarget {oLatency = 0.1, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cVerbose = True, cFrameTimespan = 1/20})

:{
let only = (hush >>)
    p = streamReplace tidal
    hush = streamHush tidal
    panic = do hush
               once $ sound "superpanic"
    list = streamList tidal
    mute = streamMute tidal
    unmute = streamUnmute tidal
    unmuteAll = streamUnmuteAll tidal
    unsoloAll = streamUnsoloAll tidal
    solo = streamSolo tidal
    unsolo = streamUnsolo tidal
    once = streamOnce tidal
    first = streamFirst tidal
    asap = once
    nudgeAll = streamNudgeAll tidal
    all = streamAll tidal
    resetCycles = streamResetCycles tidal
    setcps = asap . cps
    getcps = streamGetcps tidal
    getnow = streamGetnow tidal
    xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
    xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
    histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
    wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
    waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
    jump i = transition tidal True (Sound.Tidal.Transition.jump) i
    jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
    jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
    jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
    mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
    interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
    interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
    clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
    clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
    anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
    anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
    forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
    d1 = p 1 . (|< orbit 0)
    d2 = p 2 . (|< orbit 1)
    d3 = p 3 . (|< orbit 2)
    d4 = p 4 . (|< orbit 3)
    d5 = p 5 . (|< orbit 4)
    d6 = p 6 . (|< orbit 5)
    d7 = p 7 . (|< orbit 6)
    d8 = p 8 . (|< orbit 7)
    d9 = p 9 . (|< orbit 8)
    d10 = p 10 . (|< orbit 9)
    d11 = p 11 . (|< orbit 10)
    d12 = p 12 . (|< orbit 11)
    d13 = p 13
    d14 = p 14
    d15 = p 15
    d16 = p 16
:}

:{
let getState = streamGet tidal
    setI = streamSetI tidal
    setF = streamSetF tidal
    setS = streamSetS tidal
    setR = streamSetR tidal
    setB = streamSetB tidal
:}


:{
let
    plygato num amt = plyWith num (|* legato amt)
    plydown num amt = plyWith num (|* gain amt)
    plydowndown num amt = (plydown num amt) . (plydown num amt)
    invnote n = 0 - n
    invnote' axis n = 2 * axis - n
    roundy p =  (fromIntegral . round) <$> p
    stepr n r1 r2 f = segment n $ range r1 r2 $ f
    stepr' n r1 r2 f = roundy $ stepr n r1 r2 f
    arposc sc n upper wave = scale sc (stepr' n 0 upper wave)
    rslice x y = slice x (segment y $ irand x)
    truRand x = x <~ rand
    justEcho = stut' 2 0.125 (id) -- works great with sometimes!
    echo = stut' 2 0.125 ((# speed 0.9) . (# room 0.4) . (# gain 0.8) . (# delay 0.1))
    rumble = stut' 8 0.0625 ((# room 0.4) . (# gain 0.8) . (# speed 1.2) . (# delay 0.1))
    party = stut' 16 0.0625 ((# pan (truRand 24145))
                                 . (# gain (range 0.8 1.5 sine+(truRand 9796)))
                                 . (# vowel "<a o>")
                                 . (# room 0.1))
    shift x = (x <~)
    deco = off 0.015625 (# squiz 4)
    m1= d1 silence
    m2 = d2 silence
    m3 = d3 silence
    m4 = d4 silence
    m5 = d5 silence
    m6 = d6 silence
    m7 = d7 silence
    m8 = d8 silence
    m9 = d9 silence
    m10 = d10 silence
    swingy = swingBy 0.0156125 8
    swingy' = swingBy 0.0156125 4
    swingy'' = swingBy 0.0156125 2
    accident = rarely (shift 0.03125)
    nudge' = begin (truRand 2141)
    hop = within (0.375, 0.8125) (slow 2 . stutWith 16 (-1/64) (|* gain 0.9))
    hip = within (0.125, 0.5625) (stutWith 2 (-1/64) (|* gain 1.9))

:}


:set prompt "tidal> "
:set prompt-cont ""
