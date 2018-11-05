CON
  _clkmode        = xtal1 + pll16x
  _xinfreq        = 5_000_000

CON
 
    pinD1   = 15
    pinD2   = 14
    pinD3   = 13
    pinD4   = 12

OBJ    
    STRIP    : "NeoPixelStrip"    
    'PST      : "Parallax Serial Terminal"
  
pub Main
                          
  ' Go ahead and drive the pixel data lines low.
  dira[pinD1] := 1
  outa[pinD1] := 0

  dira[pinD2] := 1
  outa[pinD2] := 0

  dira[pinD3] := 1                                                                 
  outa[pinD3] := 0

  dira[pinD4] := 1
  outa[pinD4] := 0

  STRIP.init

  PauseMSec(1000)    

  repeat
    STRIP.draw(2, @colors1, @PIXELTEST,  pinD1, 256)
    STRIP.draw(2, @colors2, @PIXELTEST,  pinD2, 256)
    STRIP.draw(2, @colors3, @PIXELTEST,  pinD3, 256)
    STRIP.draw(2, @colors4, @PIXELTEST,  pinD4, 256)
    PauseMSec(1000)

PRI PauseMSec(Duration)
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)

dat
PIXELTEST   
    byte 1,2,1,1,1,1,1,1,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4,4,4,4,4,4,4,3,4    
   
DAT

colors1
         '   GG RR BB
    long $00_00_00_00  ' 0
    long $00_00_00_05  ' 1
    long $00_00_05_00  ' 2
    long $00_05_00_00  ' 3
    long $00_05_05_05  ' 4

colors2
         '   GG RR BB
    long $00_00_00_00  ' 0
    long $00_00_00_05  ' 1
    long $00_00_05_00  ' 2
    long $00_05_00_00  ' 3
    long $00_05_05_05  ' 4

colors3
         '   GG RR BB
    long $00_00_00_00  ' 0
    long $00_00_00_05  ' 1
    long $00_00_05_00  ' 2
    long $00_05_00_00  ' 3
    long $00_05_05_05  ' 4

colors4
         '   GG RR BB
    long $00_00_00_00  ' 0
    long $00_00_00_05  ' 1
    long $00_00_05_00  ' 2
    long $00_05_00_00  ' 3
    long $00_05_05_05  ' 4

