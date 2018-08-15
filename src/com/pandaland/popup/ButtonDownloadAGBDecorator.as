package com.pandaland.popup {
import com.pandaland.manager.SnippetManager;

import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.text.TextField;

public class ButtonDownloadAGBDecorator extends PopupDecorator {

    protected var pButton:MovieClip;
    protected var pCallback:Function;

    public function ButtonDownloadAGBDecorator(_arg_1:IPopup, _arg_2:String, _arg_3:String, _arg_4:Function) {
        super(_arg_1);
        this.pCallback = _arg_4;
        this.pButton = (_arg_1.content[_arg_2] as MovieClip);
        if (this.pButton) {
            this.pButton.buttonMode = true;
            this.pButton.mouseChildren = false;
            SnippetManager.instance.setSnippet((this.pButton["label"] as TextField), _arg_3);
            this.pButton.addEventListener(MouseEvent.CLICK, this.onClicked);
        }
    }

    protected function onClicked(_arg_1:MouseEvent):void {
        this.pCallback();
    }


}
}

