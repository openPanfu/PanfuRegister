package com.pandaland.popup {
import com.pandaland.manager.SnippetManager;

import flash.text.TextField;

public class BodyTextDecorator extends PopupDecorator {

    private var tfToScroll:TextField;

    public function BodyTextDecorator(_arg_1:IPopup, _arg_2:String) {
        super(_arg_1);
        this.tfToScroll = (_arg_1.content["txtDesc"] as TextField);
        SnippetManager.instance.setSnippet(this.tfToScroll, _arg_2);
    }

}
}

