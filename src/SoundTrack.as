package {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.Timer;

public class SoundTrack extends EventDispatcher {

    public var type:int;
    public var trackPath:String;
    public var fadeOutAble:Boolean;
    public var fadeOutDuration:int;
    public var fadeOutPlayingTracks:Boolean;
    private var pSound:Sound;
    private var pSoundChannel:SoundChannel;
    private var pVolume:Number = 1;

    public function SoundTrack(_arg_1:int, _arg_2:String, _arg_3:int, _arg_4:Boolean, _arg_5:int) {
        this.type = _arg_1;
        this.trackPath = _arg_2;
        this.fadeOutPlayingTracks = Boolean(_arg_3);
        this.fadeOutAble = _arg_4;
        this.fadeOutDuration = _arg_5;
    }

    public function set sound(_arg_1:Sound):void {
        this.pSound = _arg_1;
    }

    public function get sound():Sound {
        return (this.pSound);
    }

    public function set soundChannel(_arg_1:SoundChannel):void {
        this.pSoundChannel = _arg_1;
    }

    public function get soundChannel():SoundChannel {
        return (this.pSoundChannel);
    }

    public function fadeout():void {
        var _local_1:Timer = new Timer((this.fadeOutDuration / 10), 10);
        _local_1.addEventListener(TimerEvent.TIMER, this.decreaseTimer);
        _local_1.addEventListener(TimerEvent.TIMER_COMPLETE, this.mute);
        _local_1.start();
    }

    private function decreaseTimer(_arg_1:TimerEvent):void {
        if (this.pVolume > 0) {
            this.pVolume = (this.pVolume - 0.1);
            this.pSoundChannel.soundTransform = new SoundTransform(this.pVolume);
            PanfuRegister.log(((("Volume for " + this.trackPath) + " : ") + this.pSoundChannel.soundTransform.volume));
        }
    }

    private function mute(_arg_1:TimerEvent):void {
        this.pVolume = 0;
        this.pSoundChannel.soundTransform = new SoundTransform(this.pVolume);
        PanfuRegister.log(((("(mute) Volume for " + this.trackPath) + " : ") + this.pSoundChannel.soundTransform.volume));
        var _local_2:Timer = (_arg_1.target as Timer);
        _local_2.removeEventListener(TimerEvent.TIMER, this.decreaseTimer);
        _local_2.removeEventListener(TimerEvent.TIMER_COMPLETE, this.mute);
        dispatchEvent(new Event(Event.COMPLETE));
    }


}
}

