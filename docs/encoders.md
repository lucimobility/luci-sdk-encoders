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

## Contribution guidelines ##
This project welcomes third-party code via pull requests.

You are welcome to propose and discuss enhancements using project issues.

Branching Policy: The latest tag on the main branch is considered stable. The main branch is the one where all contributions must be merged before being promoted to a tagged release. If you plan to propose a patch, please commit into its own feature branch.

All contributions must comply with the project's standards:

Every example / source file must refer to LICENSE Every example / source file must include correct copyright notice

Depending on your language used it is expected you follow one of two syling guides

Python use PEP8 Standard
C++ use clang formatting
Please familiarize yourself with the Apache License 2.0 before contributing.

When editing KiCad board files please include a summary of any components changed. Please note it is unlikely we will approve a merge of a board file change without the board having been physically tested with its changes.

### How to make a new feature PR ###
In order to get a new feature or change into the next official release please follow the steps listed below

- Fork the Project
- Create your Feature Branch (git checkout -b feature/AmazingFeature)
- Commit your Changes (git commit -m 'Add some AmazingFeature')
- Push to the Branch (git push origin feature/AmazingFeature)
- Open a Pull Request

### Guidelines for Pull Requests ###
How to get your contributions merged smoothly and quickly.

- Create small PRs that are narrowly focused on addressing a single concern. Create multiple PRs to address different concerns.

- For speculative changes, consider opening an issue and discussing it first.

- Provide a good PR description as a record of what change is being made and why it was made. Link to a GitHub issue if it exists.

- If you are adding a new file, make sure it has the copyright message template at the top as a comment. You can copy over the message from an existing file and update the year.

- Unless your PR is trivial, you should expect there will be reviewer comments that you'll need to address before merging. We expect you to be reasonably responsive to those comments, otherwise the PR will be closed after 2-3 weeks of inactivity.

- Maintain clean commit history and use meaningful commit messages. PRs with messy commit history are difficult to review and won't be merged. Use rebase -i to curate your commit history.

- Keep your PR up to date with upstream/main (if there are merge conflicts, we can't really merge your change).

- Depending on the aggressiveness of a change reviewers may ask that you include unit tests to make sure there is a proper level of code coverage.

- Exceptions to the rules can be made if there's a compelling reason for doing so.


## Supported Chairs ##
| Chair    |
| -------- |
| Quickie 300M  |
| Quickie 500M  |
| Permobil F3|



### DISCLAIMER ### 
These designs and files are made public for research and are NOT considered a final product or design. They are internal dev tools that LUCI uses and is willing to make public to help push advancements in the wheelchair space. As this is a public repo that hopefully benefits from third party design changes we take NO responsibility for any potential damage or malfunctions caused from these designs.