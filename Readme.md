# What

(2024-09/2024-12)

Lua interface for sending data to RGB stripe.

![Image](Images/Stripe.png)


## Components

RGB stripe is connected to Arduino. Arduino is connected to USB.
USB can be accessed as "file" `/dev/ttyUSB0` or something like that.

On Arduino is [firmware][Firmware] (written by me in C++).
It has *text interface*.

So you can always connect to device via serial interface (try
Serial Monitor from Arduino IDE or Arduino CLI). `115200 baud`.
Password.. no password, just connect and type `?`.


## Lua interface

We're implementing subset of supported commands.

* [Interface][Interface]
* `SetPixel(Index, Color)` sets pixel in device memory
* `SetPixels(Index, Colors)` sets pixels in device memory
* `Display()` displays device memory on LED stripe
* `Reset()` resets device memory (makes pixels black)


## Examples

We're providing test/usage examples:

* [1_SetPixel][SetPixel] -- set specific pixels
* [2_SetPixels][SetPixels] -- set whole stripe to image line
* [3_Scrolling_image][Scroll] -- demo of "smooth" scrolling


## Requirements

Hardware
  * Ws2812B (aka **Neopixel**) LED stripe
  * ATmega328/P (aka **Arduino Uno**)
  * Standalone 5V power supply is recommended

Firmware
  * [That repo][Firmware] (Server interface)
    * `avrdude`
    * `arduino-cli`

Software
  * Linux (for `/dev/ttyUSB0`)
  * Lua 5.3+
  * This repo (Client interface)


## See also

* [Server part][Firmware]
* [My other repositories][contents]

[Interface]: StripeWriter/Interface.lua
[SetPixel]: Demos/1_SetPixel/SetPixel.lua
[SetPixels]: Demos/2_SetPixels/SetPixels.lua
[Scroll]: Demos/3_Scrolling_image/ScrollPpm.lua

[Firmware]: https://github.com/martin-eden/Embedded-me_RgbStripeConsole

[contents]: https://github.com/martin-eden/contents
