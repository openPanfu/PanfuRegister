package com.pandaland.popup {
import flash.display.MovieClip;
import flash.events.MouseEvent;

public class CloseButtonDecorator extends PopupDecorator {

    private var btnClose:MovieClip;

    public function CloseButtonDecorator(_arg_1:IPopup) {
        super(_arg_1);
        this.btnClose = (_arg_1.content["btnClose"] as MovieClip);
        this.btnClose.buttonMode = true;
        this.btnClose.mouseChildren = false;
        if (!this.btnClose.hasEventListener(MouseEvent.CLICK)) {
            this.btnClose.addEventListener(MouseEvent.CLICK, this.onClose);
        }
    }

    private function onClose(_arg_1:MouseEvent):void {
        super.decoratedPopup.close();
    }


}
}

