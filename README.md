html5mstorekitplugin
====================

StoreKit Plugin for Intel's HTML5M platform.

This plugin has been created to handle the process of paying an in-App purchase and restoring previous in-App purchases
for an Application.

The plugin is based on Intel's sample plugin and most of the StoreKit integration code is taken from an article by 
Ray Wenderlich: http://www.raywenderlich.com/21081/introduction-to-in-app-purchases-in-ios-6-tutorial (Thanks!)

I see a lot of room for improvement to this plugin which I hope the community can help.

Here are some of the things that can definitely be improved:
* Code refactoring (Starting by changing the MyPlugin 'namespace' to something more meaningful)
* My newbiness with Objective-C (I'm pretty sure that code can be organized in a different way and made more efficient)

It would also be extremely awesome if someone could come up with a similar thing for Android.

Customizing
===========

The only thing I think you need to customize in this plugin code to make it work with your in-App purchases is
under the MyPlugin/InAppPurchase.m file:

the productIdentifiers NSSet variable needs to have the list of purchases that you will allow. Make sure to remove the
@"SamplePurchaseIdA", @"SamplePurchaseIDB" for a list of you in-App purchase(s).

Take a look at the index.html on how to include the myplugin.js file, how to trigger the buy and restore processes
and finally how to capture the events. The index.html file is by no means part of the plugin, but you will need to 
include some of its code in your index.html file.

Now, here are some hints on how to make this work on your iOS project. Remember to read carefully the Intel docs 
about building plugins for the iOS platform.

1. Make sure that you have XCode installed on your Mac (yes, you'll need a Mac)
2. Open the .xproj file, select choose the "MyPlugin" target and select your device
3. Make sure that for the MyPlugin target, you are linking with the StoreKit.framework
4. Product -> Clean and Product -> Build your project.
5. Under the Products folder of your project, you will find the libMyPlugin.a file. Right-Click -> Show in Finder
6. You will see the libMyPlugin.a and an include/MyPlugin folder with the following files:
  * IAPHelper.h
  * InAppPurchase.h
  * myplugin.js
  * MyPluginCommand.h
  * MyPluginModule.h
  * MyPluginSetup.h
  * MyPluginWorker.h
  
You need to place the libMyPlugin.a and all these files (forget that they are under the include/MyPlugin directory) all in the same level (move them to a different folder if you want) and zip them.
*NOTE: I'm not entirely sure about this, but I think that adding only the MyPluginModule.h header file instead of all the header files will do. Didn't have time to try it though.
*THIS IS IMPORTANT: Do not zip the folder these files are in, just zip the files so they are in the root of your zip file.

7. In the plugin section of the build process when building your app, add this zip file. The class name of the plugin is MyPluginModule (I guess for the description you can just write anything, but I used the same than the class name)
8. Build your app, and enjoy!

If you want to contribute, you're most welcome to do so. If you have any questions, feel free to ask!
