package openfl.display;

import haxe.Timer;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFormat;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end

#if openfl
import openfl.system.System;
#end

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

class FPS extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Float;

	@:noCompletion private var cacheCount:Int;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var times:Array<Float>;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(Paths.font("montserrat.ttf"), 12, color);
		autoSize = LEFT;
		multiline = true;
		text = "FPS: ";
		textColor = 0xFFFFFFFF;
 
		cacheCount = 0;
		currentTime = 0;
		times = [];

		#if flash
		addEventListener(Event.ENTER_FRAME, function(e)
		{
			var time = Lib.getTimer();
			__enterFrame(time);
		    
		});
		#end
	}
	
	/*override function update(elapsed:Float)
	{
	super.update(elapsed);
	}
	*/
	
	public static var currentColor = 0;    
	var skippedFrames = 0;
	var updateFPStime = 0;
    var updateFPSnum = 0;
    var ColorArray:Array<Int> = [
		0xFF9400D3,
		0xFF4B0082,
		0xFF0000FF,
		0xFF00FF00,
		0xFFFFFF00,
		0xFFFF7F00,
		0xFFFF0000
	                                
	    ];
	                             	                  	
	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
	
	//var elapsed = FlxG.elapsed;    		    		
		currentTime += deltaTime;
		times.push(currentTime);

		while (times[0] < currentTime - 1000)
		{
			times.shift();
		}
		
		
		if (ClientPrefs.rainbowFPS)
	    {
	        if (skippedFrames >= 6)
		    {
		    	if (currentColor >= ColorArray.length)
    				currentColor = 0;
    			textColor = ColorArray[currentColor];
    			currentColor++;
    			skippedFrames = 0;
    		}
    		else
    		{
    			skippedFrames++;	
    		}
		}
		else
		{
		textColor = 0xFFFFFFFF;		
		}
        
        updateFPStime += deltaTime;
        updateFPSnum += 1;
        if (updateFPSnum >= 10);
        {
        currentFPS = Math.ceil(currentFPS * 0.5 + 1 / (updateFPStime / updateFPSnum / 1000) * 0.5) ;
        updateFPStime = 0;
        updateFPSnum = 0;
        }

		var currentCount = times.length;
		//currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentFPS > ClientPrefs.framerate) currentFPS = ClientPrefs.framerate;

		//if (currentCount != cacheCount /*&& visible*/)
		//{
			text = "FPS: " + currentFPS + "/" + ClientPrefs.framerate + "  "  + Math.floor(1 / currentFPS * 10000 + 0.5) / 10 + "ms";
			var memoryMegas:Float = 0;
			
			#if openfl
			memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
			text += "\nMemory: " + memoryMegas + " MB";
            text += "\nPSYCH V2.5(DEBUG)\nCAM V2.5.0";
			#end
			
            var newmemoryMegas:Float = 0;
			// textColor = 0xFFFFFFFF;
			if (memoryMegas > 1000) // || currentFPS <= ClientPrefs.framerate / 2)
			{
			newmemoryMegas = Math.ceil( Math.abs( System.totalMemory ) / 10000000 / 1.024)/100;
				// textColor = 0xFFFFFFFF;
				text = "FPS: " + currentFPS + "/" + ClientPrefs.framerate + "  "  + Math.floor(1 / currentFPS * 10000 + 0.5) / 10 + "ms";
				text += "\nMemory: " + newmemoryMegas + " GB";
                text += "\nPSYCH V2.5(DEBUG)\nCAM V2.5.0";
			}

			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end

            text += '\ndeltaTime: ' + deltaTime + '\nFlxG.elapsed: ';

			text += "\n";
		//}

		cacheCount = currentCount;
	}
	
	

	
}
