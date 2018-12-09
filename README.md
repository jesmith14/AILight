# Project Palette

##### Creators: Jessie Smith, Landon Gerrits, Monica Ravichandran, Andrew Cofano, Kalyan Vejalla

* [Overview](#overview)
* [Information For Anyone Forking](#information-for-anyone-forking)
* [Hue Lights SDK Guide](#hue-lights-sdk-guide)
* [Contact Us!](#contact-us)

---
## [Overview](#overview)

This project originally began as an attempt to use the Phillips Hue SDK Lighting app to reflect weather patterns. As weather changed, the lighting would change. We then pivoted and decided to use the lights to suggest lighting schemes for a room. This project is an iOS application that allows a user to upload an image of their room, and then sets their Phillips Hue lightbulbs to the suggested room lighting complementary color schemes. We use a kmeans clustering algorithm that determines the most prominent colors in the room. Then, using these colors and weights, we feed the information into a trained neural net to produce suggested HSB (lighting) values for the Phillips Hue lightbulbs in the room. The user has the ability to manually modify the suggested HSB values and retrain the neural net so over time the neural net discovers and suggests user preferred values.

---
## [Information For Anyone Forking](#information-for-anyone-forking)

In order to run this repository, you will need to download many packages for swift and for python. The swift and python files work together through a Flask Server on the backend.
To get started, make sure you have the following:
- Mojave OS if you are on a Mac
- XCode to run the swift files
- Python 3.5 >
- Flask to run the backend
- numpy, pandas, pytorch, and pillow to get started on the python end (you will need to import many more modules and libraries than this, just check the top of the python files!)

To run the repo:
1. Open the ___ file in XCode and make sure everything builds
2. Open the terminal and cd into the AILight directory
3. run the following command : `python swift_to_flask.py`
4. Open a phone simulator in XCode
5. Upload an image.

From there, you can see the suggested lighting values. You can either accept them, change them manually, retrain the neural net with them, upload a new image, or exit the program.

---
## [Hue Lights SDK Guide](#hue-lights-sdk-guide)
##### The hue Apple SDK by Philips
(c) Copyright Philips 2012-2014
Introduction
---
The Hue SDK is a set of tools that are designed to make it easy to access the Hue system through the Hue Wi-Fi network connected bridge and control an associated set of connected lamps. The aim of the SDK is to enable you to create your own applications for the Hue system.
The tools are provided with documentation for the SDK and example code. They are designed to be flexible, whilst easing the use of the more complex components of the system.

Supported platforms
----------------
The hue Apple SDK provides an Objective C API to access the hue system and is available and supported on the following platforms:

* iOS platform SDK
 * Supported from iOS 5.0 and higher
* OS X platform SDK
 * Supported from OS X 10.7 and higher

Get Started
----------------
To get started programming with the hue Apple SDK there are 2 main approaches you can take:

###Integrate the SDK into an existing or new project
Depending on your choice of platform, use either    _HueSDK\_iOS.framework_ or the _HueSDK\_OSX.framework_ folder from this repository.

After downloading, drag the framework folder to your Xcode project and add ‘-ObjC’ to your linker flags under your project Build Settings.
Next download the files from the Lumberjack folder from this repository and add them to your project.

###Use our QuickStart app as your base
Our QuickStart app is a bare bones application with minimal code for connecting and authenticating to a bridge and updating a lightstate. A good starting point for creating your own app.  Depending on your choice of platform, use either the project available in the _QuickStart iOS_ or the  _QuickStart OS X_ folder from this repository.

###Acknowledgements
Please adhere to any third party licenses that are applicable on this SDK when building applications with our SDK or using the QuickStart applications as your base (see ACKNOWLEDGEMENTS file in this repository, for applicable licenses).

Swift Integration
----------------
To start using the hue Apple SDK in your Swift projects:

* Add a new file to your project, an Objective-C .m file.
* When asked about creating a bridge header file, say yes.
* Remove the unused .m file you just added.

* Add your Objective-C import statements to the created bridge header .h file, like for using the hue Apple SDK:
 * For iOS:
<pre>#import &lt;HueSDK\_iOS/HueSDK.h></pre>
 * For OS X:
<pre>#import &lt;HueSDK\_OSX/HueSDK.h></pre>

Once you’ve added the hue Apple SDK to your bridge header, you can start using the SDK in your Swift project.

SDK Guide
----------------
For general principles of the hue system and an overview of our SDK API with code examples please visit our [Apple API Guide](http://developers.meethue.com/documentation/apple-api-guide) on our developer portal. 

Repository Contents
----------------
* ApplicationDesignNotes
 * Contains documentation that is useful when designing a hue application. Currently contains documentation for doing color conversion.
* Documentation
 * Contains API documentation for each platform in docset and html format. 
* HueSDK_iOS.framework
 * Framework for the iOS platform
* HueSDK_OSX.framework
 * Framework for the OS X platform
* QuickStartApp_IOS
 * QuickStart application for the iOS platform
* QuickStartApp_OSX
 * QuickStart application for the OS X platform
* Lumberjack
 * Logging library that used by the HueSDK. Make sure you add the files in this folder to your project.

Help and Support
----------------
Stuck, need help or any suggestions on how to improve the hue Apple SDK? For now please raise an issue and one of your devs will reply shortly.

Disclaimer
----------------
Philips releases this SDK with friendly house rules. These friendly house rules are part of a legal framework; this to protect both the developers and hue. The friendly house rules cover e.g. the naming of Philips and of hue which can only be used as a reference (a true and honest statement) and not as a an brand or identity. Also covered is that the hue SDK and API can only be used for hue and for no other application or product. Very common sense friendly rules that are common practice amongst leading brands that have released their SDK’s.

Copyright (c) 2012- 2013, Philips Electronics N.V. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of Philips Electronics N.V. , nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOTLIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FORA PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER ORCONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, ORPROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OFLIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDINGNEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THISSOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

---
## [Contact Us!](#contact-us)

If you are interested in maintaining this code, taking over this project, continuing work, or have any questions about our repo feel free to reach out!

If you are a Cal Poly student during the 2018-2019 school year, email Landon at:
`landon.gerrits@me.com`

If you aren't a Cal Poly student or it is past the 2018-2019 school year, email Jessie at:
`jessiejsmith01@gmail.com`

Cheers!

