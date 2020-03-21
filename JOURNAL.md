# 3/21/2020

I got the parts and populated the last 4 boards I had made long ago.

No smoke this time! I think the microsd connector was shorting out vias underneath it? Maybe. Maybe it was the flux/alcohol I used last time.

One of the boards has an error in the general I/O check. I believe it is the 4th pin of the connectors. One of them.

None of the boards pass the SD test. I'm not sure if it is software or hardware or card format.

The pixels light, but refresh with randomness. I'm not sure if it is software or hardware.

Things to try next time:

  - Test this code on the know Oreo board to see if the problem is hardware or software
  - Try testing with just one pixel line refreshing
  - Use the SD-card sniffer board to make sure the I/O lines are correct
  - Wire the pixels and SD up on the old propeller demo board (removes my board from the equation)
  