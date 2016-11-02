cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
    {
        "file": "plugins/cordova-jwplayer/www/CordovaJWPlayer.js",
        "id": "cordova-jwplayer.CordovaJWPlayer",
        "clobbers": [
            "cordova.plugins.CordovaJWPlayer"
        ]
    }
];
module.exports.metadata = 
// TOP OF METADATA
{
    "cordova-plugin-whitelist": "1.3.0",
    "cordova-jwplayer": "0.0.1"
};
// BOTTOM OF METADATA
});