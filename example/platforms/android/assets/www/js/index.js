/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
var app = {
    // Application Constructor
    initialize: function() {
        this.bindEvents();
    },
    // Bind Event Listeners
    //
    // Bind any events that are required on startup. Common events are:
    // 'load', 'deviceready', 'offline', and 'online'.
    bindEvents: function() {
        document.addEventListener('deviceready', this.onDeviceReady, false);
    },
    // deviceready Event Handler
    //
    // The scope of 'this' is the event. In order to call the 'receivedEvent'
    // function, we must explicitly call 'app.receivedEvent(...);'
    onDeviceReady: function() {
        app.receivedEvent('deviceready');
    },
    // Update DOM on a Received Event
    receivedEvent: function(id) {
        var parentElement = document.getElementById(id);
        var listeningElement = parentElement.querySelector('.listening');
        var receivedElement = parentElement.querySelector('.received');

        listeningElement.setAttribute('style', 'display:none;');
        receivedElement.setAttribute('style', 'display:block;');

        console.log('Received Event: ' + id);

        cordova.plugins.CordovaJWPlayer.setup({ autostart: true, onlyFullScreen : true }, function(result) {
            cordova.plugins.CordovaJWPlayer.onPlay(function success() {
                console.log("Playing Started");
            });
            cordova.plugins.CordovaJWPlayer.setPlaylist([
                {
                    title : "Kama Mackensie",
                    mediaid : "100",
                    sources : [
                        {
                            file : "http://content.bitsontherun.com/videos/3XnJSIm4-injeKYZS.mp4",
                            label: "180p Video 1 Streaming",
                            isDefault: true
                        },
                        {
                            file : "http://content.bitsontherun.com/videos/bkaovAYt-52qL9xLP.mp4",
                            label: "270p Video 1 Streaming"
                        },
                        {
                            file : "http://content.bitsontherun.com/videos/bkaovAYt-DZ7jSYgM.mp4",
                            label: "720p Video 1 Streaming"
                        }
                    ]
                },
                {
                    title : "Loren Cohen",
                    mediaid : "101",
                    sources : [ 
                        {
                            file : "https://video.hypermartialarts.com/vod/amlst:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ3b3d6YSIsImlhdCI6MTQ3ODAwMDAwMiwiZXhwIjoxNDc4MDQzMjMyLCJtZWRpYSI6ImFtYXpvbnMzL2h5cGVydmlkZW8vZW5jb2RlZC9wcm90cmFpbmluZy90eWxlci1tYWNrZW5zaS1rYW1hLXRyaWNrcy9obWF0XzAxX1R5bGVyXzAxX0JlaGluZF90aGVfQmFja19SZWxlYXNlLm1wNC5zbWlsIn0.uPzWPm2zy3P7ShzM0043b5J7-POe3u9Cp3nEQs4a0_8/playlist.m3u8",
                            label: "180p Video 2 Streaming",
                            isDefault: true
                        },
                        {  
                            file : "https://video.hypermartialarts.com/vod/amlst:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ3b3d6YSIsImlhdCI6MTQ3ODAwMDAwMiwiZXhwIjoxNDc4MDQzMjMyLCJtZWRpYSI6ImFtYXpvbnMzL2h5cGVydmlkZW8vZW5jb2RlZC9wcm90cmFpbmluZy90eWxlci1tYWNrZW5zaS1rYW1hLXRyaWNrcy9obWF0XzAxX1R5bGVyXzAxX0JlaGluZF90aGVfQmFja19SZWxlYXNlLm1wNC5zbWlsIn0.uPzWPm2zy3P7ShzM0043b5J7-POe3u9Cp3nEQs4a0_8/playlist.m3u8",
                            label: "270p Video 2 Streaming"
                        },
                        {  
                            file : "https://video.hypermartialarts.com/vod/amlst:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ3b3d6YSIsImlhdCI6MTQ3ODAwMDAwMiwiZXhwIjoxNDc4MDQzMjMyLCJtZWRpYSI6ImFtYXpvbnMzL2h5cGVydmlkZW8vZW5jb2RlZC9wcm90cmFpbmluZy90eWxlci1tYWNrZW5zaS1rYW1hLXRyaWNrcy9obWF0XzAxX1R5bGVyXzAxX0JlaGluZF90aGVfQmFja19SZWxlYXNlLm1wNC5zbWlsIn0.uPzWPm2zy3P7ShzM0043b5J7-POe3u9Cp3nEQs4a0_8/playlist.m3u8",
                            label: "720p Video 2 Streaming"
                        }
                    ]
                },
                {
                    title : "Sedder Joshep",
                    mediaid : "102",
                    sources : [ 
                        {
                            file : "https://video.hypermartialarts.com/vod/amlst:eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJ3b3d6YSIsImlhdCI6MTQ3ODAwMDAwMiwiZXhwIjoxNDc4MDQzMjMyLCJtZWRpYSI6ImFtYXpvbnMzL2h5cGVydmlkZW8vZW5jb2RlZC9wcm90cmFpbmluZy90eWxlci1tYWNrZW5zaS1rYW1hLXRyaWNrcy9obWF0XzE1X1R5bGVyXzA4X1JlbGVhc2VfQ29tYm8ubXA0LnNtaWwifQ.-u1LTqHsTHdlNuOTVqungMn5x86_LwXVSNpyHPAJ48c/playlist.m3u8",
                            label: "180p Video 3 Streaming",
                            isDefault: true
                        }
                    ]
                }], function(success) {

                }, function(err) {
                    console.log(err);
                });

        }, function(error) {
            console.log(error);
        })
    },
    playItem : function(index) {
        cordova.plugins.CordovaJWPlayer.play(index);
    }
};

app.initialize();