package com.huatuo.cordova;

import android.util.Log;

import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.IDCardResult;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

class JsonUtils {

    static Map<String, String> fromJson(JSONObject jsonObject) throws JSONException {
        Map<String, String> map = new HashMap<String, String>();

        Iterator<String> keysItr = jsonObject.keys();
        while (keysItr.hasNext()) {
            String key = keysItr.next();
            String value = jsonObject.getString(key);
            map.put(key, value);
        }
        return map;
    }

    static JSONObject toJson(Map<String, String> map) {
        Iterator<String> iterator = map.keySet().iterator();

        JSONObject jsonObject = new JSONObject();
        while (iterator.hasNext()) {
            String key = iterator.next();

            try {
                jsonObject.put(key, map.get(key));
            } catch (JSONException e) {
                Log.wtf("RequestManager", "Failed to put value for " + key + " into JSONObject.", e);
            }
        }
        return jsonObject;
    }

    static JSONObject toJson(final IDCardResult idCardResult) {
        if (idCardResult == null) {
            return null;
        }

        final JSONObject result = new JSONObject();
        final JSONObject data = new JSONObject();
        try {
            result.put("code", 0);
            if (idCardResult.getIdCardSide().equals("front")) {
                data.put("direction", idCardResult.getDirection());
                data.put("wordsResultNumber", idCardResult.getWordsResultNumber());
                data.put("address", idCardResult.getAddress());
                data.put("idNumber", idCardResult.getIdNumber());
                data.put("birthday", idCardResult.getBirthday());
                data.put("name", idCardResult.getName());
                data.put("gender", idCardResult.getGender());
                data.put("ethnic", idCardResult.getEthnic());
                data.put("riskType", idCardResult.getRiskType());
                data.put("imageStatus", idCardResult.getImageStatus());
            } else if (idCardResult.getIdCardSide().equals("back")) {
                data.put("signDate", idCardResult.getSignDate());
                data.put("expiryDate", idCardResult.getExpiryDate());
                data.put("issueAuthority", idCardResult.getIssueAuthority());
            }
            result.put("message", "OK");
            result.put("data", data);
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return result;
    }

    static JSONObject toJson(final OCRError ocrError) {
        if (ocrError == null) {
            return null;
        }

        final JSONObject result = new JSONObject();
        try {
            result.put("code", ocrError.getErrorCode());
            result.put("message", ocrError.getMessage());
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return result;
    }


}
