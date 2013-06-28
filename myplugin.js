// Handle Loading of appMobi Library
document.addEventListener("appMobi.device.ready",MyPluginRegister,false);

function MyPluginRegister()
{
	if( AppMobi.device.platform == "Android" )
		AppMobi.device.registerLibrary("com.myplugin.MyPluginModule");
	if( AppMobi.device.platform == "iOS" )
		AppMobi.device.registerLibrary("MyPluginModule");
}

function MyPluginLoaded()
{	
	while (MyPlugin._constructors.length > 0) {
		var constructor = MyPlugin._constructors.shift();
		try {
			constructor();
		} catch(e) {
			alert("Failed to run constructor: " + e.message);
		}
	}
    
	// all constructors run, now fire the ready event
	MyPlugin.available = true;
	var e = document.createEvent('Events');
	e.initEvent('myplugin.ready',true,true);
	document.dispatchEvent(e);
}

// Global name-prefixed object to store initialization info
if (typeof(MyPluginInfo) != 'object')
    MyPluginInfo = {};

/**
 * This provides a global namespace for accessing information
 */
MyPlugin = {
    queue: {
        ready: true,
        commands: [],
        timer: null
    },
    _constructors: []
};

/**
 * Add an initialization function to a queue that ensures our JavaScript 
 * object constructors will be run only once our module has been loaded
 */
MyPlugin.addConstructor = function(func) {
    var state = document.readyState;
    if ( ( state == 'loaded' || state == 'complete' ) && MyPluginInfo.ready != "undefined" )
	{
		func();
	}
    else
	{
        MyPlugin._constructors.push(func);
	}
};

// Begin Javascript definition of MyPlugin.Worker which bridges to MyPluginWorker
MyPlugin.Worker = function() 
{
}

MyPlugin.Worker.prototype.restorePurchasesWork = function()
{
	if( AppMobi.device.platform == "Android" )
		MyPluginWorker.restorePurchasesWork();
	if( AppMobi.device.platform == "iOS" )
		AppMobi.exec("MyPluginWorker.restorePurchasesWork");
}

MyPlugin.Worker.prototype.buyProductWork = function(productIdentifier)
{
	if( AppMobi.device.platform == "Android" )
		MyPluginWorker.buyProductWork(productIdentifier);
	if( AppMobi.device.platform == "iOS" )
		AppMobi.exec("MyPluginWorker.buyProductWork", productIdentifier);
}

MyPlugin.addConstructor(function() {
    if (typeof MyPlugin.worker == "undefined") MyPlugin.worker = new MyPlugin.Worker();
});

// Begin Javascript definition of MyPlugin.Setup which bridges to MyPluginSetup
MyPlugin.Setup = function() 
{
    this.ready = null;
    try 
	{
		this.ready = MyPluginInfo.ready;
    } 
	catch(e) 
	{
    }
}

MyPlugin.addConstructor(function() {
    if (typeof MyPlugin.setup == "undefined") MyPlugin.setup = new MyPlugin.Setup();
});
