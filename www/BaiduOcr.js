/**
 * cordova is available under the MIT License (2008).
 * See http://opensource.org/licenses/alphabetical for full text.
 *
 * Copyright (c) Matt Kane 2010
 * Copyright (c) 2011, IBM Corporation
 * Copyright (c) 2012-2017, Adobe Systems
 */


var exec = cordova.require("cordova/exec");


var BaiduOcr = {
    /**
     * 初始化ocr
     * @param successCallback
     * @param errorCallback
     */
    init: function (successCallback, errorCallback) {


        if (errorCallback == null) {
            errorCallback = function () {
            };
        }

        if (typeof errorCallback !== "function") {
            console.log("BaiduOcr.init failure: failure parameter not a function");
            return;
        }

        if (typeof successCallback !== "function") {
            console.log("BaiduOcr.init failure: success callback parameter must be a function");
            return;
        }

        exec(successCallback, errorCallback, 'BaiduOcr', 'init');
    },
    /**
     * 扫描身份证
     * @param successCallback
     * @param errorCallback
     * @param params 其中的contentType取值： IDCardFront(正面),IDCardBack(反面)
     */
    scanId: function (successCallback, errorCallback, params) {

        if (errorCallback == null) {
            errorCallback = function () {
            };
        }

        if (typeof errorCallback !== "function") {
            console.log("BaiduOcr.scanId failure: failure parameter not a function");
            return;
        }

        if (typeof successCallback !== "function") {
            console.log("BaiduOcr.scanId failure: success callback parameter must be a function");
            return;
        }

        exec(successCallback, errorCallback, 'BaiduOcr', 'scanId', [params]);
    },
    /**
     * 销毁
     * @param successCallback
     * @param errorCallback
     */
    destroy: function (successCallback, errorCallback) {
        if (errorCallback == null) {
            errorCallback = function () {
            };
        }

        if (typeof errorCallback !== "function") {
            console.log("BaiduOcr.destroy failure: failure parameter not a function");
            return;
        }

        if (typeof successCallback !== "function") {
            console.log("BaiduOcr.destroy failure: success callback parameter must be a function");
            return;
        }

        exec(successCallback, errorCallback, 'BaiduOcr', 'destroy');
    }
};


//-------------------------------------------------------------------
/*BaiduOcr.prototype.encode = function (type, data, successCallback, errorCallback, options) {
    if (errorCallback == null) {
        errorCallback = function () {
        };
    }

    if (typeof errorCallback != "function") {
        console.log("BarcodeScanner.encode failure: failure parameter not a function");
        return;
    }

    if (typeof successCallback != "function") {
        console.log("BarcodeScanner.encode failure: success callback parameter must be a function");
        return;
    }

    exec(successCallback, errorCallback, 'BarcodeScanner', 'encode', [
        {"type": type, "data": data, "options": options}
    ]);
};*/

module.exports = BaiduOcr;
