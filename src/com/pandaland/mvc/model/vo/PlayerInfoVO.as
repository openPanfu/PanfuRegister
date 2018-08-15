package com.pandaland.mvc.model.vo {
import flash.net.registerClassAlias;

public class PlayerInfoVO implements AmfValueObjectInterface {

    private var pID:int;
    private var pName:String;
    private var pAge:int;
    private var pSex:String;
    private var pBirthday:DateVO;
    private var pCoins:int;
    private var pMood:int;
    private var pChatId:String;
    private var pIsPremium:Boolean;
    private var pIsGuest:Boolean;
    private var pCurrentGameServer:int;
    private var pSocialLevel:int;
    private var pSocialScore:int;
    private var pLastLogin:Number;
    private var pSignupDate:Number;
    private var pDaysOnPanfu:int;
    private var pHelperStatus:Boolean;
    private var pLastSeenACGlobal:int;
    private var pIsSheriff:int;
    private var pIsTourFinished:Boolean;
    private var pState:String;
    private var pMembershipStatus:int;
    private var pActiveInventory:Array;
    private var pInactiveInventory:Array;
    public var buddies:Array;
    public var blocked:Array;
    private var pBollies:Array;
    private var pMusicCollection:Array;
    private var pPokoPets:Array;
    private var pPokoPetsWithNoHealth:Array;


    public static function register():void {
        registerClassAlias("com.pandaland.mvc.model.vo.PlayerInfoVO", PlayerInfoVO);
    }


    public function toString():String {
        return (((((((((((((((((((((((((((((((((((((((((((((((((((((((("[Instance of:  com.pandaland.mvc.model.vo.PlayerInfoVO" + "\n // id: ") + this.id) + "\n // name: ") + this.name) + "\n // age: ") + this.age) + "\n // sex: ") + this.sex) + "\n // birtday: ") + this.birthday) + "\n // chatId: ") + this.chatId) + "\n // coins: ") + this.coins) + "\n // isPremium: ") + this.isPremium) + "\n // isGuest: ") + this.isGuest) + "\n // currentGameServer: ") + this.currentGameServer) + "\n // socialLevel: ") + this.socialLevel) + "\n // socialScore: ") + this.socialScore) + "\n // lastLogin: ") + this.lastLogin) + "\n // daysOnPanfu: ") + this.daysOnPanfu) + "\n // helperStatus: ") + this.pHelperStatus) + "\n // buddies: ") + this.buddies) + "\n // active: ") + this.activeInventory) + "\n // inactive: ") + this.inactiveInventory) + "\n // bollies: ") + this.bollies) + "\n // musicCollection: ") + this.pMusicCollection) + "\n // lastSeenACGlobal: ") + this.pLastSeenACGlobal) + "\n // mood: ") + this.mood) + "\n // isSheriff: ") + this.isSheriff) + "\n // isTourFinished: ") + this.isTourFinished) + "\n // membershipStatus: ") + this.membershipStatus) + "\n // pokopets: ") + this.pokoPets) + "\n // pokopetsWithNoHealth: ") + this.pokoPetsWithNoHealth) + "]"));
    }

    public function removeBuddy(_arg_1:int):Boolean {
        var _local_2:int;
        if (this.buddies != null) {
            _local_2 = 0;
            while (_local_2 < this.buddies.length) {
                if (this.buddies[_local_2].playerId == _arg_1) {
                    this.buddies.splice(_local_2, 1);
                    return (true);
                }
                _local_2++;
            }
        }
        return (false);
    }

    public function get bollies():Array {
        if (this.pBollies == null) {
            this.pBollies = [];
        }
        return (this.pBollies);
    }

    public function set bollies(_arg_1:Array):void {
        this.pBollies = _arg_1;
    }

    public function get inactiveInventory():Array {
        if (!this.pInactiveInventory) {
            this.pInactiveInventory = [];
        }
        return (this.pInactiveInventory);
    }

    public function set inactiveInventory(_arg_1:Array):void {
        this.pInactiveInventory = _arg_1;
    }

    public function get activeInventory():Array {
        if (!this.pActiveInventory) {
            this.pActiveInventory = [];
        }
        return (this.pActiveInventory);
    }

    public function set activeInventory(_arg_1:Array):void {
        this.pActiveInventory = _arg_1;
    }

    public function get id():int {
        return (this.pID);
    }

    public function get name():String {
        return (this.pName);
    }

    public function get age():int {
        return (this.pAge);
    }

    public function get sex():String {
        return (this.pSex);
    }

    public function get birthday():DateVO {
        return (this.pBirthday);
    }

    public function get coins():int {
        return (this.pCoins);
    }

    public function get mood():int {
        return (this.pMood);
    }

    public function get chatId():String {
        return (this.pChatId);
    }

    public function get isPremium():Boolean {
        return (this.pIsPremium);
    }

    public function get isGuest():Boolean {
        return (this.pIsGuest);
    }

    public function get currentGameServer():int {
        return (this.pCurrentGameServer);
    }

    public function get socialLevel():int {
        return (this.pSocialLevel);
    }

    public function get socialScore():int {
        return (this.pSocialScore);
    }

    public function get lastLogin():Number {
        return (this.pLastLogin);
    }

    public function get signupDate():Number {
        return (this.pSignupDate);
    }

    public function get membershipStatus():int {
        return (this.pMembershipStatus);
    }

    public function get musicCollection():Array {
        if (!this.pMusicCollection) {
            this.pMusicCollection = [];
        }
        return (this.pMusicCollection);
    }

    public function get pokoPets():Array {
        if (!this.pPokoPets) {
            this.pPokoPets = [];
        }
        return (this.pPokoPets);
    }

    public function get daysOnPanfu():int {
        return (this.pDaysOnPanfu);
    }

    public function get helperStatus():Boolean {
        return (this.pHelperStatus);
    }

    public function get lastSeenACGlobal():int {
        return (this.pLastSeenACGlobal);
    }

    public function get isSheriff():int {
        if ((((this.pIsSheriff == 1)) || ((this.pIsSheriff == 2)))) {
            return (1);
        }
        return (0);
    }

    public function get isTourFinished():Boolean {
        return (this.pIsTourFinished);
    }

    public function get pokoPetsWithNoHealth():Array {
        return (this.pPokoPetsWithNoHealth);
    }

    public function set isTourFinished(_arg_1:Boolean):void {
        this.pIsTourFinished = _arg_1;
    }

    public function set isSheriff(_arg_1:int):void {
        this.pIsSheriff = _arg_1;
    }

    public function set id(_arg_1:int):void {
        this.pID = _arg_1;
    }

    public function set name(_arg_1:String):void {
        this.pName = _arg_1;
    }

    public function set age(_arg_1:int):void {
        this.pAge = _arg_1;
    }

    public function set sex(_arg_1:String):void {
        this.pSex = _arg_1;
    }

    public function set birthday(_arg_1:DateVO):void {
        this.pBirthday = _arg_1;
    }

    public function set coins(_arg_1:int):void {
        this.pCoins = _arg_1;
    }

    public function set mood(_arg_1:int):void {
        this.pMood = _arg_1;
    }

    public function set chatId(_arg_1:String):void {
        this.pChatId = _arg_1;
    }

    public function set isPremium(_arg_1:Boolean):void {
        this.pIsPremium = _arg_1;
    }

    public function set isGuest(_arg_1:Boolean):void {
        this.pIsGuest = _arg_1;
    }

    public function set currentGameServer(_arg_1:int):void {
        this.pCurrentGameServer = _arg_1;
    }

    public function set socialLevel(_arg_1:int):void {
        this.pSocialLevel = _arg_1;
    }

    public function set socialScore(_arg_1:int):void {
        this.pSocialScore = _arg_1;
    }

    public function set lastLogin(_arg_1:Number):void {
        this.pLastLogin = _arg_1;
    }

    public function set signupDate(_arg_1:Number):void {
        this.pSignupDate = _arg_1;
    }

    public function set membershipStatus(_arg_1:int):void {
        this.pMembershipStatus = _arg_1;
    }

    public function set musicCollection(_arg_1:Array):void {
        this.pMusicCollection = _arg_1;
    }

    public function set pokoPetsWithNoHealth(_arg_1:Array):void {
        this.pPokoPetsWithNoHealth = _arg_1;
    }

    public function set daysOnPanfu(_arg_1:int):void {
        this.pDaysOnPanfu = _arg_1;
    }

    public function set helperStatus(_arg_1:Boolean):void {
        this.pHelperStatus = _arg_1;
    }

    public function set lastSeenACGlobal(_arg_1:int):void {
        this.pLastSeenACGlobal = _arg_1;
    }

    public function get state():String {
        return (this.pState);
    }

    public function set state(_arg_1:String):void {
        this.pState = _arg_1;
    }


}
}

