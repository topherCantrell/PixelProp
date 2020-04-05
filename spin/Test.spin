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
    ' On Tim's board
    pinPIX5 = 4
    pinPIX6 = 5
    pinPIX7 = 6
    pinPIX8 = 7

    ' GPIO - pins P8 - P15
    pinGPIO8  = 8
    pinGPIO9  = 9
    pinGPIO10 = 10
    pinGPIO11 = 11
    pinGPIO12 = 12
    pinGPIO13 = 13
    pinGPIO14 = 14
    pinGPIO15 = 15

OBJ
    PST      : "Parallax Serial Terminal"      
    STRIP    : "NeoPixelStrip"    
    SD       : "SDCard"
    
VAR
    byte sectorBuffer[2048]
    byte buff[512]

    
pri dumpSector(address) | i,j,t
    t:=0
    repeat i from 0 to 31
      PST.hex(t,4)
      PST.char(" ")
      repeat j from 0 to 15
        PST.hex(byte[address],2)
        PST.char(" ")
        address += 1
        t+=1
      PST.char(13)
      ' TODO ASCII
      
PUB testSD | i

  PauseMSec(2000)   ' Give the user time to switch to terminal  
  PST.start(115200) ' Start the serial terminal
    
  i := SD.start(@buff, pinDO, pinSCLK, pinDI, pinCS)           

  PST.str(string("Return code: ")) 
  PST.hex(i,8)
  PST.char(13)

  SD.readFileSectors(@sectorBuffer,0,1)

  dumpSector(@sectorBuffer)

  repeat


PUB testHardware | i

  ' Go ahead and drive the pixel data lines low.
  
  dira[pinPIX1] := 1
  outa[pinPIX1] := 0
  dira[pinPIX2] := 1
  outa[pinPIX2] := 0
  dira[pinPIX3] := 1
  outa[pinPIX3] := 0
  dira[pinPIX4] := 1
  outa[pinPIX4] := 0
  '
  ' On Tim's board
  'dira[pinPIX5] := 1
  'outa[pinPIX5] := 0
  'dira[pinPIX6] := 1
  'outa[pinPIX6] := 0
  'dira[pinPIX7] := 1
  'outa[pinPIX7] := 0
  'dira[pinPIX8] := 1
  'outa[pinPIX8] := 0

  STRIP.init

  PauseMSec(2000)   ' Give the user time to switch to terminal
  
  PST.start(115200) ' Start the serial terminal

  ' ======================================================================
  ' Test the SD card hardware
  ' ======================================================================
  
  ' - Format a 2G SD card for FAT (the default)
  ' - Create a file on the disk that starts with the text "2018"
  ' - Put the card into the card slot on the board
  
  PST.str(string("Reading the SD card ...",13))

  i := SD.start(@sectorBuffer, pinDO, pinSCLK, pinDI, pinCS)           

  PST.str(string("Return code: ")) 
  PST.hex(i,8)
  PST.char(13)

  SD.readFileSectors(@sectorBuffer,0,1)
  repeat i from 0 to 512
    PST.hex(sectorBuffer[i],2)
    PST.char(32)

  PST.char(13)
  
  ' ======================================================================
  ' Test the GPIO pins
  ' ======================================================================

  ' Jummper the I/O pins together in pairs as follows:
  '   - P8  to P12
  '   - P9  to P13
  '   - P10 to P14
  '   - P11 to P15

  dira[8]  := 1
  dira[9]  := 1
  dira[10] := 1
  dira[11] := 1

  outa[8]  := 0
  outa[9]  := 0
  outa[10] := 0
  outa[11] := 0

  PST.str(string("Testing GPIO (passes silently)",13))
  
  if ina[12]<>0 or ina[13]<>0 or ina[14]<>0 or ina[15]<>0
    PST.str(string("## IO Failed at 1",13))
    
  outa[8]:= 1
  if ina[12]<>1 or ina[13]<>0 or ina[14]<>0 or ina[15]<>0
    PST.str(string("## IO Failed at 2",13))

  outa[8]:= 0
  outa[9]:= 1
  if ina[12]<>0 or ina[13]<>1 or ina[14]<>0 or ina[15]<>0
    PST.str(string("## IO Failed at 3",13))

  outa[9]:= 0
  outa[10]:= 1
  if ina[12]<>0 or ina[13]<>0 or ina[14]<>1 or ina[15]<>0
    PST.str(string("## IO Failed at 4",13))

  outa[10]:= 0
  outa[11]:= 1
  if ina[12]<>0 or ina[13]<>0 or ina[14]<>0 or ina[15]<>1
    PST.str(string("## IO Failed at 5",13))

  ' ======================================================================
  ' Test the NEO Pixels and terminal round-trip
  ' ======================================================================

  PST.str(string("Press a key to redraw the pixels.",13))
  PST.str(string("You should get back YourKey + 1",13))

  STRIP.draw(2, @colors1, @pixelPattern, pinPIX1, 256)
  STRIP.draw(2, @colors2, @pixelPattern, pinPIX2, 256)
  STRIP.draw(2, @colors3, @pixelPattern, pinPIX3, 256)
  STRIP.draw(2, @colors4, @pixelPattern, pinPIX4, 256) 

  repeat
  
    i := PST.charIn
    i := i + 1
    PST.char(i)
    
    ' Draw the pattern on each strand (different colors)
    STRIP.draw(2, @colors1, @pixelPattern, pinPIX1, 256)
    STRIP.draw(2, @colors2, @pixelPattern, pinPIX2, 256)
    STRIP.draw(2, @colors3, @pixelPattern, pinPIX3, 256)
    STRIP.draw(2, @colors4, @pixelPattern, pinPIX4, 256) 

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
    