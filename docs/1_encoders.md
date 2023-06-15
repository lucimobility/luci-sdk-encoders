# Encoders #
Design files and documentation for power wheelchair encoders compatible with the LUCI sensor system.
[GitHub repo](https://github.com/lucimobility/luci-sdk-encoders)

![Shield](images/Shiled.png)

## What is this repository for? ##
This repo is for the public release of an encoder system for power wheelchairs that is compatible with the [LUCI](https://luci.com/) system and [LUCI SDK](https://lucimobility.github.io/luci-ros2-sdk-docs/).

## Features ##
1. Provide main drive wheel position
2. Provide caster angle position

## How do I get set up? ##

### SDK Install ###
If you are a researcher with access to an installed LUCI unit you will want to follow the getting started instructions in the [SDK](https://lucimobility.github.io/luci-ros2-sdk-docs/How-To/Getting-Started/docker) in order to get the LUCI data streams exposed. 

### Encoder Setup ###
We have designed the printed parts to support the following encoder [AS5600 boards](https://www.amazon.com/gp/product/B094F8H591/ref=ppx_yo_dt_b_search_asin_title?ie=UTF8&psc=1).

Once you are successfully reading data from LUCI through our SDK you are ready to set up the encoder system.
This can be broken down into a few basic steps.

1. Find the correct sheet metal designs for your specific chair
<b>Note: Not all chair models are currently supported. If your chair model is not available please consider editing our designs and pushing them up here as a pull request. We actively encourage new model support.</b>
2. Follow the mounting guide to install your specific sheet metal.
3. Install the diamagnetic magnets on all the casters and main drive wheels that you would like to track. Hot glue works best for this.
4. Install encoders into the 3D printed parts
5. Mount the 3D printed parts onto casters and sheet metal
6. Mount the shield onto an arduino uno running the provided firmware. <b>NOTE: The current shield will short on the arduino board if its leads are not covered in electrical tape!</b>
7. Open the USB link hub on the back of your LUCI unit and plug in the arduino uno
8. Power cycle the chair/ LUCI unit

Once plugged in LUCI should automatically start streaming encoder data through the luci_grpc_node in the SDK. 

## Supported Chairs ##
| Chair    |  Link |
| -------- |-----|
| Quickie 300M  | https://github.com/lucimobility/luci-sdk-encoders/tree/main/Hardware/Quickie_300M|
| Quickie 500M  |https://github.com/lucimobility/luci-sdk-encoders/tree/main/Hardware/Quickie_500M|
| Permobil F3   |https://github.com/lucimobility/luci-sdk-encoders/tree/main/Hardware/Permobil_F3|
| Permobil M3   |https://github.com/lucimobility/luci-sdk-encoders/tree/main/Hardware/Permobil_M3|



### DISCLAIMER ### 
These designs and files are made public for research and are NOT considered a final product or design. They are internal dev tools that LUCI uses and is willing to make public to help push advancements in the wheelchair space. As this is a public repo that hopefully benefits from third party design changes we take NO responsibility for any potential damage or malfunctions caused from these designs.