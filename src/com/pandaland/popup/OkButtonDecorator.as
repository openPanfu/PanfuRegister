package com.pandaland.popup {
import com.pandaland.manager.SnippetManager;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

public class OkButtonDecorator extends PopupDecorator {

    private var _okButton:MovieClip;
    private var _callback:Function;

    public function OkButtonDecorator(_arg_1:IPopup, _arg_2:String, _arg_3:String, _arg_4:Function) {
        super(_arg_1);
        this._callback = _arg_4;
        this._okButton = (_arg_1.content[_arg_2] as MovieClip);
        if (this._okButton) {
            this._okButton.buttonMode = true;
            this._okButton.mouseChildren = false;
            SnippetManager.instance.setSnippet((this._okButton["label"] as TextField), _arg_3);
            this._okButton.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
            this._okButton.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
            this._okButton.addEventListener(MouseEvent.CLICK, this.onClicked);
        }
    }

    private function onMouseOver(_arg_1:MouseEvent):void {
        this._okButton.gotoAndStop(2);
    }

    private function onMouseOut(_arg_1:MouseEvent):void {
        this._okButton.gotoAndStop(1);
    }

    private function onClicked(_arg_1:MouseEvent):void {
        super.decoratedPopup.close();
        this._callback();
    }


}
}

