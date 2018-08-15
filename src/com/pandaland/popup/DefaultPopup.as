package com.pandaland.popup {
import flash.display.MovieClip;

public class DefaultPopup implements IPopup {

    public var pContent:MovieClip;

    public function DefaultPopup(_arg_1:MovieClip) {
        this.pContent = _arg_1;
    }

    public function init():void {
    }

    public function get content():MovieClip {
        return (this.pContent);
    }

    public function close():void {
        this.pContent.visible = false;
    }


}
}

