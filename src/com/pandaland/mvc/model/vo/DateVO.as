package com.pandaland.mvc.model.vo {
import flash.net.registerClassAlias;

public class DateVO implements AmfValueObjectInterface {

    private var _date:Number;


    public static function register():void {
        registerClassAlias("com.pandaland.mvc.model.vo.DateVO", DateVO);
    }


    public function toString():String {
        return (((("[Instance of:  com.pandaland.mvc.model.vo.DateVO" + " // date: ") + this.date) + "]"));
    }

    public function get date():Number {
        return (this._date);
    }

    public function set date(_arg_1:Number):void {
        this._date = _arg_1;
    }


}
}

