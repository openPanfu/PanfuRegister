package {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.utils.Dictionary;
import flash.utils.Timer;

public class SoundManager {

    private static var pInst:SoundManager;
    public static const TYPE_FEMALE_VOICE:int = 1;
    public static const TYPE_SFX:int = 2;
    public static const TYPE_RESERVED:int = 4;
    public static const TYPE_RESERVED2:int = 8;

    private var muteTransform:SoundTransform;
    private var playTransform:SoundTransform;
    private var tFolders:Dictionary;
    private var pSoundChannels:Dictionary;
    private var pMute:Boolean = false;
    private var sounds:Array;
    private var pSoundtrack:SoundTrack = null;
    private var pLanguage:String = "DE";
    private var pSound:Sound = null;
    private var pWaitTimer:Timer;

    public function SoundManager(_arg_1:SingletonProtector) {
        this.muteTransform = new SoundTransform(0, 0);
        this.playTransform = new SoundTransform(1, 0);
        this.tFolders = new Dictionary();
        this.pSoundChannels = new Dictionary();
        this.sounds = new Array();
        this.pWaitTimer = new Timer(3000, 1);
        super();
        this.tFolders[TYPE_SFX] = "SFX";
    }

    public static function get inst():SoundManager {
        if (pInst == null) {
            pInst = new (SoundManager)(new SingletonProtector());
        }
        return (pInst);
    }


    public function init(_arg_1:String):void {
        this.pLanguage = _arg_1;
        this.tFolders[TYPE_FEMALE_VOICE] = ("REGISTR_SCR_MALE/" + this.pLanguage);
    }

    public function playSound(tType:int, tSoundFile:String, tDuration:int = 3, tWaitForOtherSound:Boolean = true):void {
        var tURLRequest:URLRequest;
        var tSound:Sound;
        if (tSoundFile == "") {
            return;
        }
        if (this.pMute) {
            return;
        }
        if (((!(tWaitForOtherSound)) || (((tWaitForOtherSound) && (!(this.pWaitTimer.running)))))) {
            tURLRequest = new URLRequest((((((("sound/" + this.tFolders[tType]) + "/") + this.pLanguage) + "/") + tSoundFile) + ".mp3"));
            try {
                tSound = new Sound(tURLRequest);
                tSound.play();
                if (tWaitForOtherSound) {
                    this.pWaitTimer.delay = (tDuration * 1000);
                    this.pWaitTimer.reset();
                    this.pWaitTimer.start();
                }
                this.pSound = tSound;
            } catch (e:Error) {
                PanfuRegister.log("File not found");
            }
        }
    }

    public function set mute(_arg_1:Boolean):void {
        this.pMute = _arg_1;
        if (this.pMute) {
            SoundMixer.soundTransform = this.muteTransform;
        } else {
            SoundMixer.soundTransform = this.playTransform;
        }
    }

    public function get mute():Boolean {
        return (this.pMute);
    }

    public function playTrack(_arg_1:int, _arg_2:String, _arg_3:int = 2147483647, _arg_4:Boolean = true, _arg_5:int = 1000):void {
        var _local_8:SoundTrack;
        var _local_9:Timer;
        if ((((_arg_1 & TYPE_FEMALE_VOICE)) && (!((this.pLanguage == "DE"))))) {
            return;
        }
        var _local_6:int;
        var _local_7:SoundTrack = new SoundTrack(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5);
        for each (_local_8 in this.sounds) {
            if (((((_local_8) && (_local_8.fadeOutAble))) && ((_local_8.type & _arg_3)))) {
                _local_8.fadeout();
            }
        }
        this.sounds.push(_local_7);
        this.pSoundtrack = _local_7;
        if (_local_6 != 0) {
            _local_9 = new Timer(_local_6, 1);
            _local_9.addEventListener(TimerEvent.TIMER_COMPLETE, this.onFadeoutFinished, false, 0, true);
            _local_9.start();
        } else {
            this.startPlaying(_local_7);
        }
    }

    private function fadeout(_arg_1:SoundTrack):void {
        _arg_1.fadeout();
        var _local_2:int = this.sounds.indexOf(_arg_1);
    }

    private function onFadeoutFinished(_arg_1:TimerEvent):void {
        this.startPlaying(this.pSoundtrack);
    }

    private function startPlaying(tSoundTrack:SoundTrack):void {
        var tSound:Sound;
        var tSoundChannel:SoundChannel;
        var tPath:String = (((("sound/" + this.tFolders[tSoundTrack.type]) + "/") + tSoundTrack.trackPath) + ".mp3");
        PanfuRegister.log(("Play " + tPath));
        var tURLRequest:URLRequest = new URLRequest(tPath);
        try {
            tSound = new Sound(tURLRequest);
            tSoundChannel = tSound.play();
            tSoundTrack.sound = tSound;
            tSoundTrack.soundChannel = tSoundChannel;
            this.pSoundChannels[tSoundTrack.soundChannel] = tSoundTrack;
            tSoundTrack.addEventListener(Event.COMPLETE, this.onSoundTrackComplete);
            tSoundTrack.soundChannel.addEventListener(Event.SOUND_COMPLETE, this.onSoundChannelTrackComplete);
            this.sounds.push(tSoundTrack);
        } catch (err:Error) {
            PanfuRegister.log("File not found");
        }
    }

    private function onSoundTrackComplete(_arg_1:Event):void {
        var _local_2:SoundTrack = (_arg_1.target as SoundTrack);
        var _local_3:int = this.sounds.indexOf(_local_2);
    }

    private function onSoundChannelTrackComplete(_arg_1:Event):void {
        var _local_2:SoundChannel = (_arg_1.target as SoundChannel);
        var _local_3:* = this.pSoundChannels[_local_2];
        var _local_4:int = this.sounds.indexOf(_local_3);
    }


}
}

class SingletonProtector {


}

