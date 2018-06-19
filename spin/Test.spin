CON
  _clkmode        = xtal1 + pll16x
  _xinfreq        = 5_000_000

CON

    ' Micro SD Card (simple hardware mode, card must be <2G)
    pinDO   = 27
    pinSCLK = 26
    pinDI   = 25
    pinCS   = 24

    ' 5V output pins
    pinPIX1 = 0
    pinPIX2 = 1
    pinPIX3 = 2
    pinPIX4 = 3

    ' GPIO - pins P8 -P15     

OBJ
    PST      : "Parallax Serial Terminal"      
    STRIP    : "NeoPixelStrip"    
    SD       : "SDCard"
    
VAR

    byte sectorBuffer[2048]

PUB testAll

  PauseMSec(2000)

  PST.start(115200)

  testPixels  

PUB testSD | i

  ' - Format a 2G SD card for FAT (the default)
  ' - Create a file on the disk that starts with the text "2018"
  ' - Put the card into the card slot on the board  
  
  i := SD.start(@sectorBuffer, pinDO, pinSCLK, pinDI, pinCS)

  PST.hex(i,8)
  PST.char(13)

  SD.readFileSectors(@sectorBuffer,0,1)
  repeat i from 0 to 15
    PST.hex(sectorBuffer[i],2)
    PST.char(32)

  PST.char(13)

PUB testPixels

  ' Go ahead and drive the pixel data lines low.
  dira[pinPIX1] := 1
  outa[pinPIX1] := 0
  dira[pinPIX2] := 1
  outa[pinPIX2] := 0
  dira[pinPIX3] := 1
  outa[pinPIX3] := 0
  dira[pinPIX4] := 1
  outa[pinPIX4] := 0

  STRIP.init


  repeat
    PauseMSec(1000)
     
    ' Draw the pattern on each strand (different colors)
    STRIP.draw(2, @colors1, @pixelPattern, pinPIX1, 256)
    STRIP.draw(2, @colors2, @pixelPattern, pinPIX2, 256)
    STRIP.draw(2, @colors3, @pixelPattern, pinPIX3, 256)
    STRIP.draw(2, @colors4, @pixelPattern, pinPIX4, 256) 

PUB testSerial | c     

  PST.str(string("Serial output",13))

  repeat
    c := PST.charIn
    c := c + 1
    PST.char(c)  

PUB testGPIO | p

  ' Blink a GPIO pin high and low (5 seconds each)
  ' Try all of them you want -- pins 8 through 15 ccw around the
  ' corner of the board.

  p := 15
  
  dira[p] := 1
  
  repeat
    outa[p] := 1
    PauseMSec(5000)
    outa[p] := 0
    PauseMSec(5000)
      
PRI PauseMSec(Duration)
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)

DAT

colors1
    long $00_00_00_00
    long $00_05_05_05

colors2
    long $00_00_00_00
    long $00_00_05_05

colors3               
    long $00_00_00_00
    long $00_05_05_00

colors4
    long $00_00_00_00
    long $00_05_00_05       

pixelPattern
    byte 1,1,0,1,1,0,1,0
    byte 0,1,0,0,1,0,1,0    
    byte 0,0,0,0,0,0,0,0
    byte 1,0,0,0,0,0,0,0
    byte 0,1,0,0,0,0,0,0
    byte 0,0,1,0,0,0,0,0
    byte 0,0,0,1,0,0,0,0
    byte 0,0,0,0,1,0,0,0
    byte 0,0,0,0,0,1,0,0
    byte 0,0,0,0,0,0,1,0
    byte 0,0,0,0,0,0,0,1
    byte 0,0,0,0,0,0,1,0
    byte 0,0,0,0,0,1,0,0
    byte 0,0,0,0,1,0,0,0
    byte 0,0,0,1,0,0,0,0
    byte 0,0,1,0,0,0,0,0 
    byte 0,1,0,0,0,0,0,0
    byte 1,0,0,0,0,0,0,0
    byte 0,1,0,0,0,0,0,0
    byte 0,0,1,0,0,0,0,0
    byte 0,0,0,1,0,0,0,0
    byte 0,0,0,0,1,0,0,0
    byte 0,0,0,0,0,1,0,0
    byte 0,0,0,0,0,0,1,0
    byte 0,0,0,0,0,0,0,1
    byte 0,0,0,0,0,0,1,0
    byte 0,0,0,0,0,1,0,0
    byte 0,0,0,0,1,0,0,0
    byte 0,0,0,1,0,0,0,0
    byte 0,0,1,0,0,0,0,0
    byte 0,1,0,0,0,0,0,0
    byte 1,1,0,0,0,1,0,1
    