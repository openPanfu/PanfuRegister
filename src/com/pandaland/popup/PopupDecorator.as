package com.pandaland.popup {
import flash.display.MovieClip;

public class PopupDecorator implements IPopup {

    protected var decoratedPopup:IPopup;

    public function PopupDecorator(_arg_1:IPopup) {
        this.decoratedPopup = _arg_1;
        this.init();
    }

    public function init():void {
    }

    public function get content():MovieClip {
        return (this.decoratedPopup.content);
    }

    public function close():void {
        this.decoratedPopup.close();
    }


}
}

