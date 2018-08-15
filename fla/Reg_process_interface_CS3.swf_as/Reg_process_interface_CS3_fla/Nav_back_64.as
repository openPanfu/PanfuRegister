package Reg_process_interface_CS3_fla 
{
    import flash.display.*;
    import flash.text.*;
    
    public dynamic class Nav_back_64 extends flash.display.MovieClip
    {
        public function Nav_back_64()
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
            stop();
            return;
        }

        public var label:flash.text.TextField;
    }
}
