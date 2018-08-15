package Reg_process_interface_CS3_fla 
{
    import flash.display.*;
    import flash.text.*;
    
    public dynamic class ChooseGirl_3 extends flash.display.MovieClip
    {
        public function ChooseGirl_3()
        {
            super();
            addFrameScript(0, frame1, 1, frame2);
            return;
        }

        function frame1():*
        {
            stop();
            return;
        }

        function frame2():*
        {
            gotoAndPlay(2);
            return;
        }

        public var label:flash.text.TextField;
    }
}
