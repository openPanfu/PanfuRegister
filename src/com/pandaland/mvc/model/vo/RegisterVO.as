package com.pandaland.mvc.model.vo {
import flash.net.registerClassAlias;

public class RegisterVO implements AmfValueObjectInterface {

    public static const CHAT_STANDARD:String = "1";
    public static const CHAT_SECURITY:String = "2";
    public static const BOY:String = "boy";
    public static const GIRL:String = "girl";

    private var _sex:String;
    private var _years:int;
    private var _birthday:DateVO;
    private var _name:String;
    private var _pw:String;
    private var _promotionCode:String;
    private var _playerInfoVO:PlayerInfoVO;
    private var _chatId:String;
    private var _pwParents:String;
    private var _emailParents:String;
    private var _refererId:int;
    private var _referrer:String;
    private var _newsletter:Boolean;
    private var _country:String;
    private var _itemIds:Array;
    private var _partnerId:String;
    private var _trackingCode:String;
    private var _doubleOptIn:Boolean;


    public static function register():void {
        registerClassAlias("com.pandaland.mvc.model.vo.RegisterVO", RegisterVO);
    }


    public function toString():String {
        return (((((((((((((((((((((((((((((("[Instance of:  com.pandaland.mvc.model.vo.RegisterVO" + "\n // sex: ") + this.sex) + "\n // years: ") + this.years) + "\n // birthday: ") + this.birthday) + "\n // name: ") + this.name) + "\n // pw: ") + this.pw) + "\n // newsletter: ") + this.wantsNewsletter) + "\n // promotionCode: ") + this.promotionCode) + "\n --------------------------------------") + "\n // playerInfoVO: ") + this.playerInfoVO.toString()) + "\n --------------------------------------") + "\n // chatId: ") + this.chatId) + "\n // pwParents: ") + this.pwParents) + "\n // emailParents: ") + this.emailParents) + "\n // refererId: ") + this.refererId) + "\n // referrer: ") + this.referrer) + "]"));
    }

    public function get doubleOptIn():Boolean {
        return (this._doubleOptIn);
    }

    public function get trackingCode():String {
        return (this._trackingCode);
    }

    public function get partnerId():String {
        return (this._partnerId);
    }

    public function get sex():String {
        return (this._sex);
    }

    public function get years():int {
        return (this._years);
    }

    public function get birthday():DateVO {
        return (this._birthday);
    }

    public function get name():String {
        return (this._name);
    }

    public function get pw():String {
        return (this._pw);
    }

    public function get promotionCode():String {
        return (this._promotionCode);
    }

    public function get playerInfoVO():PlayerInfoVO {
        return (this._playerInfoVO);
    }

    public function get chatId():String {
        return (this._chatId);
    }

    public function get pwParents():String {
        return (this._pwParents);
    }

    public function get emailParents():String {
        return (this._emailParents);
    }

    public function get refererId():int {
        return (this._refererId);
    }

    public function get referrer():String {
        return (this._referrer);
    }

    public function get country():String {
        return (this._country);
    }

    public function get itemIds():Array {
        return (this._itemIds);
    }

    public function set doubleOptIn(_arg_1:Boolean):void {
        this._doubleOptIn = _arg_1;
    }

    public function set partnerId(_arg_1:String):void {
        this._partnerId = _arg_1;
    }

    public function set trackingCode(_arg_1:String):void {
        this._trackingCode = _arg_1;
    }

    public function set itemIds(_arg_1:Array):void {
        this._itemIds = _arg_1;
    }

    public function set sex(_arg_1:String):void {
        this._sex = _arg_1;
    }

    public function set years(_arg_1:int):void {
        this._years = _arg_1;
    }

    public function set birthday(_arg_1:DateVO):void {
        this._birthday = _arg_1;
    }

    public function set name(_arg_1:String):void {
        this._name = _arg_1;
    }

    public function set pw(_arg_1:String):void {
        this._pw = _arg_1;
    }

    public function set promotionCode(_arg_1:String):void {
        this._promotionCode = _arg_1;
    }

    public function set playerInfoVO(_arg_1:PlayerInfoVO):void {
        this._playerInfoVO = _arg_1;
    }

    public function set chatId(_arg_1:String):void {
        this._chatId = _arg_1;
    }

    public function set pwParents(_arg_1:String):void {
        this._pwParents = _arg_1;
    }

    public function set country(_arg_1:String):void {
        this._country = _arg_1;
    }

    public function set emailParents(_arg_1:String):void {
        this._emailParents = _arg_1;
    }

    public function set refererId(_arg_1:int):void {
        this._refererId = _arg_1;
    }

    public function set referrer(_arg_1:String):void {
        this._referrer = _arg_1;
    }

    public function get wantsNewsletter():Boolean {
        return (this._newsletter);
    }

    public function set wantsNewsletter(_arg_1:Boolean):void {
        this._newsletter = _arg_1;
    }


}
}

