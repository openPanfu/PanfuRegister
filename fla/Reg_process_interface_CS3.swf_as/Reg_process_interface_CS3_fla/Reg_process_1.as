package Reg_process_interface_CS3_fla 
{
    import adobe.utils.*;
    import flash.accessibility.*;
    import flash.display.*;
    import flash.errors.*;
    import flash.events.*;
    import flash.external.*;
    import flash.filters.*;
    import flash.geom.*;
    import flash.media.*;
    import flash.net.*;
    import flash.printing.*;
    import flash.profiler.*;
    import flash.sampler.*;
    import flash.system.*;
    import flash.text.*;
    import flash.ui.*;
    import flash.utils.*;
    import flash.xml.*;
    
    public dynamic class Reg_process_1 extends flash.display.MovieClip
    {
        public function Reg_process_1()
        {
            super();
            addFrameScript(0, frame1, 1, frame2, 3, frame4, 12, frame13, 13, frame14, 23, frame24, 24, frame25, 32, frame33, 33, frame34, 47, frame48, 48, frame49, 54, frame55, 62, frame63);
            return;
        }

        function frame1():*
        {
            btnNext.visible = false;
            btnBack.visible = false;
            popup.visible = false;
            btnMute.visible = false;
            return;
        }

        function frame2():*
        {
            dispatchEvent(new flash.events.Event("switchedFrames"));
            stop();
            return;
        }

        function frame4():*
        {
            dispatchEvent(new flash.events.Event("switchedFrames"));
            stop();
            return;
        }

        function frame13():*
        {
            ContainerMc.bubble.visible = false;
            return;
        }

        function frame14():*
        {
            dispatchEvent(new flash.events.Event("switchedFrames"));
            stop();
            return;
        }

        function frame24():*
        {
            ContainerMc.bubble.visible = false;
            return;
        }

        function frame25():*
        {
            dispatchEvent(new flash.events.Event("switchedFrames"));
            stop();
            return;
        }

        function frame33():*
        {
            ContainerMc.bubble.visible = false;
            ContainerMc.btnPlayNow.gotoAndStop(1);
            popupHelp.visible = false;
            agbPopup.visible = false;
            return;
        }

        function frame34():*
        {
            dispatchEvent(new flash.events.Event("switchedFrames"));
            stop();
            return;
        }

        function frame48():*
        {
            ContainerMc.visible = true;
            return;
        }

        function frame49():*
        {
            dispatchEvent(new flash.events.Event("switchedFrames"));
            stop();
            return;
        }

        function frame55():*
        {
            dispatchEvent(new flash.events.Event("switchedFrames"));
            return;
        }

        function frame63():*
        {
            stop();
            return;
        }

        public var popupHelp:flash.display.MovieClip;

        public var btnMute:flash.display.MovieClip;

        public var selectMaleWood:flash.display.MovieClip;

        public var title1:flash.text.TextField;

        public var title2:flash.text.TextField;

        public var btnNext:flash.display.MovieClip;

        public var selectMaleAvatar:flash.display.MovieClip;

        public var ContainerMc:flash.display.MovieClip;

        public var avatar:flash.display.MovieClip;

        public var agbPopup:flash.display.MovieClip;

        public var pandaname:flash.text.TextField;

        public var catalog:flash.display.MovieClip;

        public var popup:flash.display.MovieClip;

        public var allClothes:flash.display.MovieClip;

        public var selectFemaleAvatar:flash.display.MovieClip;

        public var btnBack:flash.display.MovieClip;

        public var mcSteps:flash.display.MovieClip;

        public var selectFemaleWood:flash.display.MovieClip;
    }
}
