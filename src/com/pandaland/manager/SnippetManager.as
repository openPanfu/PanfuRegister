package com.pandaland.manager {
import flash.text.TextField;

public class SnippetManager {

    private static var inst:SnippetManager;

    private var dictionary:XML;


    public static function get instance():SnippetManager {
        if (inst == null) {
            inst = new SnippetManager();
        }
        return (inst);
    }


    public function init(_arg_1:String):void {
        this.dictionary = new XML(_arg_1);
    }

    public function setSnippet(_arg_1:TextField, _arg_2:String, _arg_3:Object = null, _arg_4:Boolean = false):void {
        var _local_5:XMLList = this.dictionary[_arg_2];
        var _local_6:* = _arg_2;
        if (((_local_5) && (_local_5[0]))) {
            _local_6 = _local_5[0].toString();
        }
        if (_arg_4) {
            _arg_1.htmlText = "<b>";
            _arg_1.htmlText = (_arg_1.htmlText + _local_6);
            _arg_1.htmlText = (_arg_1.htmlText + "</b>");
        } else {
            _arg_1.htmlText = _local_6;
        }
    }

    public function appendSnippet(_arg_1:TextField, _arg_2:String):void {
        var _local_3:XMLList = this.dictionary[_arg_2];
        var _local_4:* = _arg_2;
        if (((_local_3) && (_local_3[0]))) {
            _local_4 = _local_3[0].toString();
        }
        _arg_1.htmlText = (_arg_1.htmlText + _local_4);
    }


}
}

