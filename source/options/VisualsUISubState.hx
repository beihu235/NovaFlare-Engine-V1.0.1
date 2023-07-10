package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import haxe.Json;
import haxe.format.JsonParser;
import Controls;

using StringTools;

typedef NoteSkinData =
{
	Skin1:string,
	Skin2:string,
	Skin3:string,
	Skin4:string,
	Skin5:string,
	Skin6:string,
	Skin7:string,
	Skin8:string,
	Skin9:string,
	Skin10:string

}

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals and UI';
		rpcTitle = 'Visuals & UI Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Note Splashes',
			"If unchecked, hitting \"Sick!\" notes won't show particles.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);
		
		var option:Option = new Option('Note Skin',
			"Choose Note Skin",
			'NoteSkin',
			'string',
			'original',
			['original', 'Skin1', 'Skin2', 'Skin3', 'Skin4', 'Skin5', 'Skin6', 'Skin7', 'Skin8', 'Skin9', 'Skin10']);
			option.onChange = onChangeNoteSkin;
			//option.showNoteSkin = true;
		addOption(option);
		

		var option:Option = new Option('Hide HUD',
			'If checked, hides most HUD elements.',
			'hideHud',
			'bool',
			false);
		addOption(option);
		
		var option:Option = new Option('Time Bar:',
			"What should the Time Bar display?",
			'timeBarType',
			'string',
			'Time Left',
			['Time Left', 'Time Elapsed', 'Song Name', 'Disabled']);
		addOption(option);

		var option:Option = new Option('Flashing Lights',
			"Uncheck this if you're sensitive to flashing lights!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Camera Zooms',
			"If unchecked, the camera won't zoom in on a beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Score Text Zoom on Hit',
			"If unchecked, disables the Score text zooming\neverytime you hit a note.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Health Bar Transparency',
			'How much transparent should the health bar and icons be.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);
		
		var option:Option = new Option('FPS Counter',
			'If unchecked, hides FPS Counter.',
			'showFPS',
			'bool',
			true);
		addOption(option);
		option.onChange = onChangeFPSCounter;
		
		var option:Option = new Option('FPS Rainbow',
			'If unchecked, FPS not change color',
			'rainbowFPS',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Pause Screen Song:',
			"What song do you prefer for the Pause Screen?",
			'pauseMusic',
			'string',
			'Tea Time',
			['None', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;
		
		#if CHECK_FOR_UPDATES
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);
		#end

		var option:Option = new Option('Combo Stacking',
			"If unchecked, Ratings and Combo won't stack, saving on System Memory and making them easier to read",
			'comboStacking',
			'bool',
			true);
		addOption(option);

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'None')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('freakyMenu'));
		super.destroy();
	}

	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	
	var NoteSkin:NoteSkinData;
	function onChangeNoteSkin()
	{
		NoteSkin = Json.parse(Paths.getTextFromFile('images/NoteSkin/SkinData.json'));
		if (ClientPrefs.NoteSkin == 'original') FlxG.save.data.ChangeSkin = false;
		else {
		     FlxG.save.data.ChangeSkin = true;
		     if (ClientPrefs.NoteSkin == 'Skin1') FlxG.save.data.NoteSkinName = NoteSkinData.Skin1;
		     if (ClientPrefs.NoteSkin == 'Skin2') FlxG.save.data.NoteSkinName = NoteSkinData.Skin2;
		     if (ClientPrefs.NoteSkin == 'Skin3') FlxG.save.data.NoteSkinName = NoteSkinData.Skin3;
		     if (ClientPrefs.NoteSkin == 'Skin4') FlxG.save.data.NoteSkinName = NoteSkinData.Skin4;
		     if (ClientPrefs.NoteSkin == 'Skin5') FlxG.save.data.NoteSkinName = NoteSkinData.Skin5;
		     if (ClientPrefs.NoteSkin == 'Skin6') FlxG.save.data.NoteSkinName = NoteSkinData.Skin6;
		     if (ClientPrefs.NoteSkin == 'Skin7') FlxG.save.data.NoteSkinName = NoteSkinData.Skin7;
		     if (ClientPrefs.NoteSkin == 'Skin8') FlxG.save.data.NoteSkinName = NoteSkinData.Skin8;
		     if (ClientPrefs.NoteSkin == 'Skin9') FlxG.save.data.NoteSkinName = NoteSkinData.Skin9;
		     if (ClientPrefs.NoteSkin == 'Skin10') FlxG.save.data.NoteSkinName = NoteSkinData.Skin10;     
		}
	}
}











